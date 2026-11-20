part of 'ledger.dart';

enum TicketStatus { upcoming, due, received, used, expired }

typedef DashainReceipt = ({int accountId, int minor, int day});
typedef DashainView = ({
  DashainPlan plan,
  DashainReceipt? receipt,
  int expectedMinor,
  int expectedDay,
});

typedef TravelProgress = ({
  int target,
  int pledged,
  int saved,
  int remaining,
  int? monthly,
});

typedef TravelView = ({
  TravelGoal goal,
  List<TravelContribution> contributions,
  TravelProgress progress,
});

const _travelGoalId = 1;
const _ticketPolicyVersion = 1;

LeavePeriod annualTicketCycle(
  int year, {
  int policyVersion = _ticketPolicyVersion,
}) => switch (policyVersion) {
  1 => LeavePeriod(
    leaveDay(DateTime.utc(year)),
    leaveDay(DateTime.utc(year, 12, 31)),
  ),
  _ => throw StateError('Unsupported ticket policy'),
};

bool _supportedDay(int day) =>
    day >= leaveDay(firstLeaveDate) && day <= leaveDay(lastLeaveDate);

bool _validYear(int year) =>
    year >= firstLeaveDate.year && year <= lastLeaveDate.year;

void _requireEntitlement(bool valid) {
  if (!valid) throw const LedgerException(LedgerIssue.invalidInput);
}

TicketStatus ticketStatus(AnnualTicket? ticket, int year, DateTime today) {
  if (ticket?.usedDay != null) return TicketStatus.used;
  if (ticket?.receivedDay != null) return TicketStatus.received;
  final cycle = annualTicketCycle(
    year,
    policyVersion: ticket?.policyVersion ?? _ticketPolicyVersion,
  );
  final day = leaveDay(today);
  if (day < cycle.startDay) return TicketStatus.upcoming;
  return day > cycle.endDay ? TicketStatus.expired : TicketStatus.due;
}

extension PersonalEntitlements on Ledger {
  Future<DashainPlan?> _dashain(int year) => (_db.select(
    _db.dashainPlans,
  )..where((row) => row.year.equals(year))).getSingleOrNull();

  Future<DashainReceipt> _dashainReceipt(int id) async {
    final entry = await (_db.select(
      _db.journalEntries,
    )..where((row) => row.id.equals(id))).getSingle();
    final credit = (await _postingsFor(id)).singleWhere((row) => row.minor > 0);
    return (
      accountId: credit.accountId,
      minor: credit.minor,
      day: leaveDay(
        DateTime.fromMicrosecondsSinceEpoch(entry.effectiveMicros, isUtc: true),
      ),
    );
  }

  Future<DashainView?> dashain(int year) => _db.transaction(() async {
    final plan = await _dashain(year);
    if (plan == null) return null;
    return (
      plan: plan,
      receipt: plan.receiptId == null
          ? null
          : await _dashainReceipt(plan.receiptId!),
      expectedMinor: checkedMinor(
        BigInt.from(plan.salaryMinor) + BigInt.from(plan.allowancesMinor),
      ),
      expectedDay: plan.festivalDay - 15,
    );
  });

  Future<void> saveDashainPlan({
    required int year,
    required int festivalDay,
    required String currency,
    required int salaryMinor,
    required int allowancesMinor,
  }) => _db.transaction(() async {
    _requireEntitlement(
      _validYear(year) &&
          _supportedDay(festivalDay) &&
          dateOfLeaveDay(festivalDay).year == year &&
          salaryMinor > 0 &&
          allowancesMinor >= 0,
    );
    checkedMinor(BigInt.from(salaryMinor) + BigInt.from(allowancesMinor));
    _requireEntitlement(
      await (_db.select(
            _db.currencies,
          )..where((row) => row.code.equals(currency))).getSingleOrNull() !=
          null,
    );
    final values = DashainPlansCompanion.insert(
      year: Value(year),
      festivalDay: festivalDay,
      currency: currency,
      salaryMinor: salaryMinor,
      allowancesMinor: allowancesMinor,
    );
    if (await _dashain(year) == null) {
      await _db.into(_db.dashainPlans).insert(values);
    } else {
      await (_db.update(
        _db.dashainPlans,
      )..where((row) => row.year.equals(year))).write(values);
    }
  });

  /// Replaces the active receipt with a linked correction, or reverses it when
  /// [receipt] is null. Forecast edits never post to the ledger.
  Future<void> confirmDashain({
    required int year,
    required int expectedRevision,
    required DashainReceipt? receipt,
    String? reason,
  }) => _db.transaction(() async {
    final plan = await _dashain(year);
    if (plan == null) throw const LedgerException(LedgerIssue.invalidInput);
    final activeId = plan.receiptId;
    final active = activeId == null ? null : await _dashainReceipt(activeId);
    if (plan.revision == expectedRevision + 1 && active == receipt) return;
    if (plan.revision != expectedRevision) {
      throw const LedgerException(LedgerIssue.duplicateConflict);
    }
    if (active == receipt) return;

    final prefix = 't014-dashain:$year:$expectedRevision';
    String? explanation;
    if (activeId != null) {
      explanation = _reason(reason ?? '');
      // Reverse on the original receipt day. The existing reconciliation
      // gate still applies to that date and to the proposed replacement.
      final original = await (_db.select(
        _db.journalEntries,
      )..where((row) => row.id.equals(activeId))).getSingle();
      await _reverse(
        '$prefix:reverse',
        original,
        dateOfLeaveDay(active!.day),
        explanation,
      );
    }
    int? replacement;
    if (receipt != null) {
      _requireEntitlement(
        receipt.minor > 0 &&
            _supportedDay(receipt.day) &&
            receipt.day <= leaveDay(DateTime.now()),
      );
      final account = await _personalAccount(receipt.accountId);
      final offset = await _offset(account.currency, AccountKind.income);
      replacement = await _persist(
        '$prefix:receipt',
        JournalKind.dashainBonus,
        dateOfLeaveDay(receipt.day),
        [
          (accountId: account.id, minor: receipt.minor),
          (accountId: offset.id, minor: -receipt.minor),
        ],
        correctionOf: activeId,
        reason: explanation,
      );
    }
    await (_db.update(
      _db.dashainPlans,
    )..where((row) => row.year.equals(year))).write(
      DashainPlansCompanion(
        receiptId: Value(replacement),
        revision: Value(expectedRevision + 1),
      ),
    );
  });

  Future<AnnualTicket?> ticket(int year) => (_db.select(
    _db.annualTickets,
  )..where((row) => row.year.equals(year))).getSingleOrNull();

  /// One record per cycle. Editing dates corrects the existing entitlement.
  Future<void> saveTicket({
    required int year,
    required AnnualTicket? expected,
    int? receivedDay,
    int? usedDay,
    int? leaveId,
  }) => _db.transaction(() async {
    _requireEntitlement(_validYear(year));
    final today = leaveDay(DateTime.now());
    final existing = await ticket(year);
    final version = existing?.policyVersion ?? _ticketPolicyVersion;
    final cycle = annualTicketCycle(year, policyVersion: version);
    bool inCycle(int day) =>
        day >= cycle.startDay && day <= cycle.endDay && day <= today;
    _requireEntitlement(
      receivedDay == null
          ? usedDay == null && leaveId == null
          : inCycle(receivedDay) &&
                (usedDay == null ||
                    (inCycle(usedDay) && usedDay >= receivedDay)),
    );
    if (leaveId != null && expected?.leaveId != leaveId) {
      final leave = await (_db.select(
        _db.leaveEntries,
      )..where((row) => row.id.equals(leaveId))).getSingleOrNull();
      _requireEntitlement(
        leave != null && leave.status != LeaveStatus.cancelled,
      );
    }
    final values = AnnualTicket(
      year: year,
      policyVersion: version,
      receivedDay: receivedDay,
      usedDay: usedDay,
      leaveId: leaveId,
    );
    if (existing == values) return;
    if (existing != expected) {
      throw const LedgerException(LedgerIssue.duplicateConflict);
    }
    await _db
        .into(_db.annualTickets)
        .insertOnConflictUpdate(values.toCompanion(false));
  });

  Future<TravelGoal?> _travelGoal() => (_db.select(
    _db.travelGoals,
  )..where((row) => row.id.equals(_travelGoalId))).getSingleOrNull();

  Future<List<TravelContribution>> _travelContributions() =>
      (_db.select(_db.travelContributions)
            ..where((row) => row.goalId.equals(_travelGoalId))
            ..orderBy([
              (row) => OrderingTerm.desc(row.day),
              (row) => OrderingTerm.asc(row.operationId),
            ]))
          .get();

  Future<void> saveTravelGoal({
    required String currency,
    required int targetDay,
    required int tripMinor,
    required int airfareMinor,
  }) => _db.transaction(() async {
    _requireEntitlement(
      _supportedDay(targetDay) &&
          tripMinor >= 0 &&
          airfareMinor >= 0 &&
          (tripMinor > 0 || airfareMinor > 0),
    );
    checkedMinor(BigInt.from(tripMinor) + BigInt.from(airfareMinor));
    _requireEntitlement(
      await (_db.select(
            _db.currencies,
          )..where((row) => row.code.equals(currency))).getSingleOrNull() !=
          null,
    );
    final existing = await _travelGoal();
    if (existing != null &&
        existing.currency != currency &&
        (await _travelContributions()).isNotEmpty) {
      throw const LedgerException(LedgerIssue.currencyMismatch);
    }
    await _db
        .into(_db.travelGoals)
        .insertOnConflictUpdate(
          TravelGoal(
            id: _travelGoalId,
            currency: currency,
            targetDay: targetDay,
            tripMinor: tripMinor,
            airfareMinor: airfareMinor,
          ),
        );
  });

  Future<void> contributeToTravel({
    required String operationId,
    required int accountId,
    required int day,
    required int minor,
    TravelContribution? expected,
  }) => _db.transaction(() async {
    _requireEntitlement(
      operationId.trim().isNotEmpty &&
          operationId.length <= 200 &&
          minor > 0 &&
          _supportedDay(day) &&
          day <= leaveDay(DateTime.now()),
    );
    final goal = await _travelGoal();
    _requireEntitlement(goal != null);
    final all = await _travelContributions();
    final existing = all
        .where((row) => row.operationId == operationId)
        .firstOrNull;
    final inputs = all.where((row) => row.operationId != operationId);
    final contribution = TravelContribution(
      operationId: operationId,
      goalId: _travelGoalId,
      accountId: accountId,
      day: day,
      minor: minor,
    );
    if (existing == contribution) return;
    if (existing != expected) {
      throw const LedgerException(LedgerIssue.duplicateConflict);
    }
    final account = await _personalAccount(accountId);
    if (account.currency != goal!.currency) {
      throw const LedgerException(LedgerIssue.currencyMismatch);
    }
    final funds = await _total(accountId);
    final alreadySetAside = inputs
        .where((row) => row.accountId == accountId)
        .fold(BigInt.zero, (sum, row) => sum + BigInt.from(row.minor));
    _requireEntitlement(alreadySetAside + BigInt.from(minor) <= funds);
    checkedMinor(
      inputs.fold(
        BigInt.from(minor),
        (sum, row) => sum + BigInt.from(row.minor),
      ),
    );
    await _db
        .into(_db.travelContributions)
        .insertOnConflictUpdate(contribution);
  });

  Future<TravelView?> travelSavings({DateTime? today}) =>
      _db.transaction(() async {
        final goal = await _travelGoal();
        if (goal == null) return null;
        final contributions = await _travelContributions();
        final byAccount = <int, int>{};
        for (final row in contributions) {
          byAccount.update(
            row.accountId,
            (value) => value + row.minor,
            ifAbsent: () => row.minor,
          );
        }
        var saved = 0;
        var pledged = 0;
        for (final item in byAccount.entries) {
          pledged += item.value;
          final funds = await _total(item.key);
          if (funds.sign > 0) {
            saved += funds >= BigInt.from(item.value)
                ? item.value
                : funds.toInt();
          }
        }
        final target = goal.tripMinor + goal.airfareMinor;
        final remaining = target > saved ? target - saved : 0;
        final current = today ?? DateTime.now();
        final due = dateOfLeaveDay(goal.targetDay);
        final months =
            (due.year - current.year) * 12 + due.month - current.month + 1;
        final monthly = remaining == 0
            ? 0
            : goal.targetDay < leaveDay(current)
            ? null
            : ((BigInt.from(remaining) + BigInt.from(months - 1)) ~/
                      BigInt.from(months))
                  .toInt();
        return (
          goal: goal,
          contributions: contributions,
          progress: (
            target: target,
            pledged: pledged,
            saved: saved,
            remaining: remaining,
            monthly: monthly,
          ),
        );
      });
}
