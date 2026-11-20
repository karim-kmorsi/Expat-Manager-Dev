import 'package:drift/drift.dart';

import '../data/database.dart';
import 'model.dart';

LeavePeriod entryPeriod(LeaveEntry entry) =>
    LeavePeriod(entry.startDay, entry.endDay);

class LeaveOverview {
  LeaveOverview(this.entries, this.rules, this.holidays);

  final List<LeaveEntry> entries;
  final List<LeaveRule> rules;
  final List<LeaveHoliday> holidays;
  late final calendar = LeaveCalendar(holidays.map((holiday) => holiday.day));

  LeaveRule ruleFor(int year) {
    final firstDay = leaveDay(DateTime.utc(year));
    return rules.lastWhere((rule) => rule.effectiveDay <= firstDay);
  }

  LeaveBalance balance(int year, LeaveKind kind, {int? excludeId}) {
    final rule = ruleFor(year);
    final entitlement = switch (kind) {
      LeaveKind.annual => rule.annualDays,
      LeaveKind.casual => rule.casualDays,
      LeaveKind.sick => rule.sickDays,
    };
    var used = 0;
    var reserved = 0;
    for (final entry in entries) {
      if (entry.id == excludeId ||
          entry.kind != kind ||
          !entry.status.reservesDays) {
        continue;
      }
      final period = entryPeriod(entry);
      if (period.chargeYear != year) continue;
      if (entry.status == LeaveStatus.used) {
        used += period.days;
      } else {
        reserved += period.days;
      }
    }
    return (
      entitlement: entitlement,
      used: used,
      reserved: reserved,
      remaining: entitlement - used - reserved,
    );
  }

  bool overlapsReserved(LeavePeriod period, {int? excludeId}) => entries.any(
    (entry) =>
        entry.id != excludeId &&
        entry.status.reservesDays &&
        period.overlaps(entryPeriod(entry)),
  );

  bool hasActivePeriod(LeaveKind kind, LeavePeriod period, {int? excludeId}) =>
      entries.any(
        (entry) =>
            entry.id != excludeId &&
            entry.status != LeaveStatus.cancelled &&
            entry.kind == kind &&
            entry.startDay == period.startDay &&
            entry.endDay == period.endDay,
      );

  /// An exact plan starts on [firstDay]. A window must contain the entire
  /// leave. An occasion must fall inside the continuous break. Prefer more time off.
  List<LeavePeriod> suggest({
    required LeaveKind kind,
    required LeavePlanningMode mode,
    required int firstDay,
    required int lastDay,
    required int days,
  }) {
    if (days < 1 || days > 366 || !_supported(LeavePeriod(firstDay, lastDay))) {
      throw const LeaveException(LeaveIssue.dates);
    }
    final occasion = mode == LeavePlanningMode.occasion
        ? LeavePeriod(firstDay, firstDay)
        : null;
    final occasionBreak = occasion != null && !calendar.isWorkDay(firstDay)
        ? calendar.continuousBreak(occasion)
        : null;
    final firstStart = switch (mode) {
      LeavePlanningMode.occasion =>
        (occasionBreak?.startDay ?? firstDay + 1) - days,
      _ => firstDay,
    };
    final lastStart = switch (mode) {
      LeavePlanningMode.window => lastDay - days + 1,
      LeavePlanningMode.occasion =>
        occasionBreak == null ? firstDay : occasionBreak.endDay + 1,
      LeavePlanningMode.exact => firstDay,
    };
    final suggestions = <({LeavePeriod period, int timeOff})>[];
    final remainingByYear = <int, int>{};
    for (var start = firstStart; start <= lastStart; start++) {
      final period = LeavePeriod(start, start + days - 1);
      if (!_supported(period)) continue;
      final remaining = remainingByYear.putIfAbsent(
        period.chargeYear,
        () => balance(period.chargeYear, kind).remaining,
      );
      if (days <= remaining &&
          !overlapsReserved(period) &&
          !hasActivePeriod(kind, period)) {
        final continuous = calendar.continuousBreak(period);
        if (occasion == null || continuous.overlaps(occasion)) {
          suggestions.add((period: period, timeOff: continuous.days));
        }
      }
    }
    suggestions.sort((a, b) {
      final byTimeOff = b.timeOff.compareTo(a.timeOff);
      return byTimeOff == 0
          ? a.period.startDay.compareTo(b.period.startDay)
          : byTimeOff;
    });
    return [for (final suggestion in suggestions.take(5)) suggestion.period];
  }
}

bool _supported(LeavePeriod period) =>
    period.startDay >= leaveDay(firstLeaveDate) &&
    period.endDay <= leaveDay(lastLeaveDate) &&
    period.days > 0;

class LeaveBook {
  LeaveBook(this._db);
  final LedgerDatabase _db;

  Future<LeaveOverview> overview() => _db.transaction(_read);

  Future<LeaveOverview> _read() async => LeaveOverview(
    await (_db.select(_db.leaveEntries)..orderBy([
          (row) => OrderingTerm.desc(row.startDay),
          (row) => OrderingTerm.desc(row.id),
        ]))
        .get(),
    await (_db.select(
      _db.leaveRules,
    )..orderBy([(row) => OrderingTerm.asc(row.effectiveDay)])).get(),
    await (_db.select(
      _db.leaveHolidays,
    )..orderBy([(row) => OrderingTerm.asc(row.day)])).get(),
  );

  Future<int> save({
    int? id,
    required LeaveKind kind,
    required LeaveStatus status,
    required LeavePeriod period,
    String occasion = '',
    MedicalReport medicalReport = MedicalReport.unspecified,
  }) => _db.transaction(() async {
    if (!_supported(period) ||
        status == LeaveStatus.cancelled ||
        occasion.trim().length > 120) {
      throw const LeaveException(LeaveIssue.dates);
    }
    final existing = id == null ? null : await _entry(id);
    if (existing?.status == LeaveStatus.cancelled) {
      throw const LeaveException(LeaveIssue.missing);
    }
    if (existing?.status == LeaveStatus.used &&
        (status != LeaveStatus.used ||
            existing!.kind != kind ||
            existing.startDay != period.startDay ||
            existing.endDay != period.endDay)) {
      throw const LeaveException(LeaveIssue.used);
    }
    final data = await _read();
    if (data.hasActivePeriod(kind, period, excludeId: id)) {
      throw const LeaveException(LeaveIssue.duplicate);
    }
    if (status.reservesDays && data.overlapsReserved(period, excludeId: id)) {
      throw const LeaveException(LeaveIssue.overlap);
    }
    // Requested entries can describe alternatives. Only approved and used
    // entries reserve days, and an edit replaces its existing reservation.
    if (period.days >
        data.balance(period.chargeYear, kind, excludeId: id).remaining) {
      throw const LeaveException(LeaveIssue.balance);
    }
    final values = LeaveEntriesCompanion.insert(
      kind: kind,
      status: status,
      startDay: period.startDay,
      endDay: period.endDay,
      occasion: occasion.trim(),
      medicalReport: kind == LeaveKind.sick
          ? medicalReport
          : MedicalReport.unspecified,
    );
    if (id == null) return _db.into(_db.leaveEntries).insert(values);
    await (_db.update(
      _db.leaveEntries,
    )..where((row) => row.id.equals(id))).write(values);
    return id;
  });

  // The caller explicitly identifies the last day actually used. An approved
  // date in the past is not evidence that any of its days were used.
  Future<void> cancel(int id, {int? usedThrough}) => _db.transaction(() async {
    final entry = await _entry(id);
    if (entry.status == LeaveStatus.cancelled && usedThrough == null) return;
    if (entry.status == LeaveStatus.used) {
      if (usedThrough == entry.endDay) return;
      throw const LeaveException(LeaveIssue.used);
    }
    final row = _db.update(_db.leaveEntries)..where((row) => row.id.equals(id));
    if (usedThrough == null) {
      await row.write(
        const LeaveEntriesCompanion(status: Value(LeaveStatus.cancelled)),
      );
      return;
    }
    if (entry.status != LeaveStatus.approved ||
        usedThrough < entry.startDay ||
        usedThrough >= entry.endDay) {
      throw const LeaveException(LeaveIssue.dates);
    }
    final used = LeavePeriod(entry.startDay, usedThrough);
    if ((await _read()).hasActivePeriod(entry.kind, used, excludeId: id)) {
      throw const LeaveException(LeaveIssue.duplicate);
    }
    await row.write(
      LeaveEntriesCompanion(
        status: const Value(LeaveStatus.used),
        endDay: Value(usedThrough),
      ),
    );
    await _db
        .into(_db.leaveEntries)
        .insert(
          LeaveEntriesCompanion.insert(
            kind: entry.kind,
            status: LeaveStatus.cancelled,
            startDay: usedThrough + 1,
            endDay: entry.endDay,
            occasion: entry.occasion,
            medicalReport: MedicalReport.unspecified,
          ),
        );
  });

  Future<LeaveEntry> _entry(int id) async {
    final entry = await (_db.select(
      _db.leaveEntries,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (entry == null) throw const LeaveException(LeaveIssue.missing);
    return entry;
  }

  Future<void> saveHoliday({
    int? oldDay,
    required int day,
    required String name,
  }) => _db.transaction(() async {
    final label = name.trim();
    if (!_supported(LeavePeriod(day, day)) ||
        label.isEmpty ||
        label.length > 120) {
      throw const LeaveException(LeaveIssue.holiday);
    }
    final byDay = _db.select(_db.leaveHolidays)
      ..where((row) => row.day.equals(day));
    if (oldDay != day && await byDay.getSingleOrNull() != null) {
      throw const LeaveException(LeaveIssue.holiday);
    }
    if (oldDay != null) {
      final updated =
          await (_db.update(
            _db.leaveHolidays,
          )..where((row) => row.day.equals(oldDay))).write(
            LeaveHolidaysCompanion(day: Value(day), name: Value(label)),
          );
      if (updated == 0) throw const LeaveException(LeaveIssue.missing);
    } else {
      await _db
          .into(_db.leaveHolidays)
          .insert(LeaveHoliday(day: day, name: label));
    }
  });

  Future<void> deleteHoliday(int day) async {
    await (_db.delete(
      _db.leaveHolidays,
    )..where((row) => row.day.equals(day))).go();
  }

  Future<void> addRule({
    required int year,
    required int annual,
    required int casual,
    required int sick,
  }) => _db.transaction(() async {
    final effectiveDay = leaveDay(DateTime.utc(year));
    if (year <= DateTime.now().year ||
        year > lastLeaveDate.year ||
        [annual, casual, sick].any((days) => days < 0 || days > 366)) {
      throw const LeaveException(LeaveIssue.policy);
    }
    final data = await _read();
    if (data.rules.any((rule) => rule.effectiveDay == effectiveDay)) {
      throw const LeaveException(LeaveIssue.policy);
    }
    final newRule = LeaveRule(
      effectiveDay: effectiveDay,
      annualDays: annual,
      casualDays: casual,
      sickDays: sick,
    );
    final rules = [...data.rules, newRule]
      ..sort((a, b) => a.effectiveDay.compareTo(b.effectiveDay));
    final updated = LeaveOverview(data.entries, rules, data.holidays);
    final affectedYears = {
      for (final entry in data.entries)
        if (entry.status.reservesDays) entryPeriod(entry).chargeYear,
    };
    for (final chargeYear in affectedYears) {
      if (LeaveKind.values.any(
        (kind) => updated.balance(chargeYear, kind).remaining < 0,
      )) {
        throw const LeaveException(LeaveIssue.balance);
      }
    }
    await _db.into(_db.leaveRules).insert(newRule);
  });
}
