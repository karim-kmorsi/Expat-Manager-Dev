import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/leave/leave_book.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'support/legacy_schema.dart';

int day(int year, int month, int date) =>
    leaveDay(DateTime.utc(year, month, date));

LeavePeriod period(int year, int month, int start, int end) =>
    LeavePeriod(day(year, month, start), day(year, month, end));

Matcher issue(LeaveIssue value) => throwsA(
  isA<LeaveException>().having((error) => error.issue, 'issue', value),
);

void main() {
  late Directory temp;
  late File file;
  late LedgerDatabase db;
  late LeaveBook book;
  const keyByte = 42;
  final hexKey = List.filled(32, '2a').join();

  Future<void> open() async {
    db = await LedgerDatabase.open(
      file,
      Uint8List.fromList(List.filled(32, keyByte)),
    );
    book = LeaveBook(db);
  }

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('expat-leave-test-');
    file = File('${temp.path}/ledger.sqlite');
    await open();
  });
  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  test('counts inclusive civil days for every type and skips days off only on return', () async {
    await book.saveHoliday(day: day(2026, 12, 25), name: 'عطلة داخل الفترة');
    await book.saveHoliday(day: day(2026, 12, 27), name: 'عطلة بعد الفترة');
    for (final (index, kind) in LeaveKind.values.indexed) {
      final leave = period(2026, 12, 24 - 7 * index, 25 - 7 * index);
      await book.save(kind: kind, status: LeaveStatus.used, period: leave);
      final data = await book.overview();
      final balance = data.balance(2026, kind);
      expect(leave.days, 2);
      expect(period(2026, 12, 24, 24).days, 1);
      expect(balance.entitlement, [30, 13, 15][index]);
      expect(balance.used, 2);
      expect(
        data.calendar.returnDay(leave),
        day(2026, 12, index == 0 ? 28 : 27 - 7 * index),
      );
    }
    final leave = period(2026, 12, 24, 25);
    await book.saveHoliday(
      oldDay: day(2026, 12, 27),
      day: day(2026, 12, 28),
      name: 'تاريخ جديد',
    );
    expect(
      (await book.overview()).calendar.returnDay(leave),
      day(2026, 12, 27),
    );
    await book.deleteHoliday(day(2026, 12, 28));
    expect((await book.overview()).holidays.single.name, 'عطلة داخل الفترة');
  });

  test('charges the whole crossing to the start year and rejects insufficient balance', () async {
    final crossing = LeavePeriod(day(2026, 12, 29), day(2027, 1, 5));
    final first = await book.save(
      kind: LeaveKind.annual,
      status: LeaveStatus.approved,
      period: period(2026, 7, 1, 23),
    );
    await expectLater(
      book.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.approved,
        period: crossing,
      ),
      issue(LeaveIssue.balance),
    );
    await book.save(
      id: first,
      kind: LeaveKind.annual,
      status: LeaveStatus.used,
      period: period(2026, 7, 1, 22),
    );
    await book.save(
      kind: LeaveKind.annual,
      status: LeaveStatus.approved,
      period: crossing,
    );
    final data = await book.overview();
    expect(data.balance(2026, LeaveKind.annual), (
      entitlement: 30,
      used: 22,
      reserved: 8,
      remaining: 0,
    ));
    expect(data.balance(2027, LeaveKind.annual).remaining, 30);
    await expectLater(
      book.save(
        kind: LeaveKind.casual,
        status: LeaveStatus.approved,
        period: period(2027, 1, 5, 5),
      ),
      issue(LeaveIssue.overlap),
    );
  });

  test(
    'requested is free and full cancellation releases an unused reservation',
    () async {
      final leave = period(2026, 11, 1, 13);
      final id = await book.save(
        kind: LeaveKind.casual,
        status: LeaveStatus.requested,
        period: leave,
      );
      expect(
        (await book.overview()).balance(2026, LeaveKind.casual).remaining,
        13,
      );
      await book.save(
        id: id,
        kind: LeaveKind.casual,
        status: LeaveStatus.approved,
        period: leave,
      );
      expect(
        (await book.overview()).balance(2026, LeaveKind.casual).reserved,
        13,
      );
      await book.cancel(id);
      await book.cancel(id);
      expect(
        (await book.overview()).entries.single.status,
        LeaveStatus.cancelled,
      );
      expect(
        (await book.overview()).balance(2026, LeaveKind.casual).remaining,
        13,
      );
    },
  );

  test(
    'partial cancellation keeps the actual charge in its start year',
    () async {
      final start = day(2026, 12, 29);
      final end = day(2027, 1, 5);
      final usedThrough = day(2027, 1, 2);
      final id = await book.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.approved,
        period: LeavePeriod(start, end),
      );

      await expectLater(
        book.cancel(id, usedThrough: end),
        issue(LeaveIssue.dates),
      );
      await book.cancel(id, usedThrough: usedThrough);
      await book.cancel(id, usedThrough: usedThrough);
      await expectLater(book.cancel(id), issue(LeaveIssue.used));
      await expectLater(
        book.save(
          id: id,
          kind: LeaveKind.annual,
          status: LeaveStatus.requested,
          period: LeavePeriod(start, usedThrough),
        ),
        issue(LeaveIssue.used),
      );
      await expectLater(
        book.save(
          id: id,
          kind: LeaveKind.annual,
          status: LeaveStatus.used,
          period: LeavePeriod(start, usedThrough - 1),
        ),
        issue(LeaveIssue.used),
      );
      await expectLater(
        book.save(
          id: id,
          kind: LeaveKind.casual,
          status: LeaveStatus.used,
          period: LeavePeriod(start, usedThrough),
        ),
        issue(LeaveIssue.used),
      );
      await book.save(
        id: id,
        kind: LeaveKind.annual,
        status: LeaveStatus.used,
        period: LeavePeriod(start, usedThrough),
        occasion: 'بيانات فقط',
      );
      await db.close();
      await open();
      final data = await book.overview();
      expect(data.entries, hasLength(2));
      expect(
        data.entries.singleWhere((entry) => entry.id == id).occasion,
        'بيانات فقط',
      );
      final cancelled = data.entries.singleWhere(
        (entry) => entry.status == LeaveStatus.cancelled,
      );
      expect((cancelled.startDay, cancelled.endDay), (usedThrough + 1, end));
      expect(data.balance(2026, LeaveKind.annual), (
        entitlement: 30,
        used: 5,
        reserved: 0,
        remaining: 25,
      ));
      expect(data.balance(2027, LeaveKind.annual).remaining, 30);
    },
  );

  test(
    'rejects duplicate active entries even during concurrent requested saves',
    () async {
      final dates = period(2026, 11, 3, 5);
      Future<int?> request() async {
        try {
          return await book.save(
            kind: LeaveKind.casual,
            status: LeaveStatus.requested,
            period: dates,
          );
        } on LeaveException catch (error) {
          expect(error.issue, LeaveIssue.duplicate);
          return null;
        }
      }

      final id = (await Future.wait([request(), request()]))
          .whereType<int>()
          .single;
      await expectLater(
        book.save(
          kind: LeaveKind.casual,
          status: LeaveStatus.approved,
          period: dates,
        ),
        issue(LeaveIssue.duplicate),
      );
      await book.cancel(id);
      expect(await request(), isNotNull);
      expect(
        (await book.overview()).entries.where(
          (entry) => entry.status != LeaveStatus.cancelled,
        ),
        hasLength(1),
      );
    },
  );

  test(
    'partial cancellation cannot duplicate another active request',
    () async {
      final usedPrefix = period(2026, 8, 1, 2);
      final request = await book.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.requested,
        period: usedPrefix,
      );
      final approved = await book.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.approved,
        period: period(2026, 8, 1, 4),
      );
      await expectLater(
        book.cancel(approved, usedThrough: usedPrefix.endDay),
        issue(LeaveIssue.duplicate),
      );
      expect(
        (await book.overview()).balance(2026, LeaveKind.annual).reserved,
        4,
      );
      await book.cancel(request);
      await book.cancel(approved, usedThrough: usedPrefix.endDay);
      expect((await book.overview()).balance(2026, LeaveKind.annual).used, 2);
    },
  );

  test('concurrent reservations cannot overspend a balance', () async {
    Future<bool> reserve(LeavePeriod days) async {
      try {
        await book.save(
          kind: LeaveKind.casual,
          status: LeaveStatus.approved,
          period: days,
        );
        return true;
      } on LeaveException catch (error) {
        expect(error.issue, LeaveIssue.balance);
        return false;
      }
    }

    final results = await Future.wait([
      reserve(period(2026, 7, 1, 7)),
      reserve(period(2026, 8, 1, 7)),
    ]);
    expect(results.where((saved) => saved), hasLength(1));
    expect(
      (await book.overview()).balance(2026, LeaveKind.casual).remaining,
      6,
    );
  });

  test(
    'suggests exact, window and occasion periods with available days',
    () async {
      await book.saveHoliday(day: day(2026, 12, 27), name: 'عطلة');
      await book.save(
        kind: LeaveKind.sick,
        status: LeaveStatus.used,
        period: period(2026, 12, 23, 23),
      );
      final data = await book.overview();
      final anchor = day(2026, 12, 24);
      List<LeavePeriod> suggest(
        LeavePlanningMode mode,
        int first,
        int last,
        int days,
      ) => data.suggest(
        kind: LeaveKind.annual,
        mode: mode,
        firstDay: first,
        lastDay: last,
        days: days,
      );
      expect(
        suggest(LeavePlanningMode.exact, anchor, anchor, 2).single.startDay,
        anchor,
      );
      final window = suggest(
        LeavePlanningMode.window,
        anchor - 1,
        anchor + 7,
        1,
      );
      expect(window.first.startDay, anchor);
      expect(
        window.every(
          (candidate) =>
              candidate.startDay >= anchor && candidate.endDay <= anchor + 7,
        ),
        isTrue,
      );
      final occasion = suggest(
        LeavePlanningMode.occasion,
        anchor + 1,
        anchor + 1,
        2,
      );
      expect(occasion, isNotEmpty);
      expect(
        occasion.every(
          (candidate) => data.calendar
              .continuousBreak(candidate)
              .overlaps(LeavePeriod(anchor + 1, anchor + 1)),
        ),
        isTrue,
      );
      expect(suggest(LeavePlanningMode.exact, anchor, anchor, 31), isEmpty);
    },
  );

  test(
    'planning around a holiday can include it without charging it',
    () async {
      final holiday = day(
        2027,
        2,
        7,
      ); // Sunday, following the weekly rest days.
      await book.saveHoliday(day: holiday, name: 'مناسبة');
      final data = await book.overview();
      final plan = data
          .suggest(
            kind: LeaveKind.annual,
            mode: LeavePlanningMode.occasion,
            firstDay: holiday,
            lastDay: holiday,
            days: 1,
          )
          .first;
      expect(plan.startDay, holiday - 3);
      expect(plan.days, 1);
      expect(data.calendar.continuousBreak(plan).days, 4);
      expect(data.calendar.returnDay(plan), holiday + 1);
    },
  );

  test('preserves rules and reports on reopen and rejects retroactive or overbooking changes', () async {
    final year = DateTime.now().year + 1;
    await book.save(
      kind: LeaveKind.sick,
      status: LeaveStatus.approved,
      period: period(year, 2, 1, 8),
      medicalReport: MedicalReport.recorded,
      occasion: 'موعد شخصي',
    );
    await expectLater(
      book.addRule(year: year, annual: 30, casual: 13, sick: 7),
      issue(LeaveIssue.balance),
    );
    await expectLater(
      book.addRule(year: year - 1, annual: 30, casual: 13, sick: 15),
      issue(LeaveIssue.policy),
    );
    await book.addRule(year: year, annual: 31, casual: 13, sick: 14);
    await book.saveHoliday(day: day(year, 2, 9), name: 'عطلة محلية');
    await db.close();
    await open();
    final data = await book.overview();
    expect(data.rules, hasLength(2));
    expect(data.ruleFor(year).effectiveDay, day(year, 1, 1));
    expect(data.balance(year - 1, LeaveKind.annual).entitlement, 30);
    expect(data.balance(year, LeaveKind.annual).entitlement, 31);
    expect(data.balance(year, LeaveKind.sick).remaining, 6);
    expect(data.entries.single.medicalReport, MedicalReport.recorded);
    expect(data.entries.single.occasion, 'موعد شخصي');
    expect(data.holidays.single.name, 'عطلة محلية');
  });

  test('migrates encrypted v5 financial data and retains a verified v5 recovery copy', () async {
    final ledger = Ledger(db);
    final account = await ledger.createAccount(
      name: 'Synthetic bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 'v5-opening',
      accountId: account,
      minor: 12345,
      effectiveAt: DateTime.utc(2026),
    );
    await db.close();

    Map<String, List<Map<String, Object?>>> financialRows(
      sqlite.Database raw,
    ) => {
      for (final row in raw.select(
        """SELECT name FROM sqlite_schema
           WHERE type = 'table' AND name NOT LIKE 'sqlite_%' AND name NOT LIKE 'leave_%'
             AND name NOT IN ('dashain_plans', 'annual_tickets', 'travel_goals', 'travel_contributions')""",
      ))
        row['name'] as String: [
          for (final item in raw.select(
            'SELECT * FROM "${row['name']}" ORDER BY rowid',
          ))
            Map<String, Object?>.from(item),
        ],
    };

    final old = sqlite.sqlite3.open(file.path);
    late final Map<String, List<Map<String, Object?>>> original;
    try {
      unlockDatabase(old, hexKey);
      dropLeaveSchema(old);
      old.execute('PRAGMA user_version = 5');
      original = financialRows(old);
    } finally {
      old.close();
    }
    await open();
    expect(
      (await db.customSelect('PRAGMA user_version').getSingle())
          .data
          .values
          .single,
      db.schemaVersion,
    );
    expect((await Ledger(db).balance(account)).minor, 12345);
    await book.save(
      kind: LeaveKind.annual,
      status: LeaveStatus.approved,
      period: period(2026, 12, 24, 25),
    );
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    expect(
      (await db.customSelect('PRAGMA integrity_check').getSingle())
          .data
          .values
          .single,
      'ok',
    );

    for (final (path, version) in [
      (file.path, db.schemaVersion),
      ('${file.path}.v5.backup', 5),
    ]) {
      final copy = sqlite.sqlite3.open(path, mode: sqlite.OpenMode.readOnly);
      try {
        unlockDatabase(copy, hexKey);
        expect(
          copy.select('PRAGMA user_version').single.values.single,
          version,
        );
        expect(financialRows(copy), original);
      } finally {
        copy.close();
      }
    }
  });
}
