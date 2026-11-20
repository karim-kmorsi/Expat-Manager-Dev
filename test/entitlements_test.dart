import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:expat_manager/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'support/legacy_schema.dart';

int day(int year, int month, int date) =>
    leaveDay(DateTime.utc(year, month, date));

Matcher ledgerIssue(LedgerIssue issue) => throwsA(
  isA<LedgerException>().having((error) => error.issue, 'issue', issue),
);

void main() {
  late Directory temp;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;
  const byte = 0x47;
  final hexKey = List.filled(32, '47').join();

  Future<void> open() async {
    db = await LedgerDatabase.open(
      file,
      Uint8List.fromList(List.filled(32, byte)),
    );
    ledger = Ledger(db);
  }

  Future<int> bank([String currency = 'USD']) => ledger.createAccount(
    name: 'Test $currency',
    currency: currency,
    kind: AccountKind.bank,
  );

  Future<void> plan(int year, int festival) => ledger.saveDashainPlan(
    year: year,
    festivalDay: festival,
    currency: 'USD',
    salaryMinor: 180000,
    allowancesMinor: 25000,
  );

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('expat-t014-');
    file = File('${temp.path}/ledger.sqlite');
    await open();
  });
  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  test(
    'annual Dashain dates derive payment date and gross salary without posting',
    () async {
      await plan(2024, day(2024, 10, 12));
      await plan(2025, day(2025, 10, 2));
      final first = (await ledger.dashain(2024))!;
      expect(first.expectedDay, day(2024, 9, 27));
      expect(first.expectedMinor, 205000);
      expect(first.receipt, isNull);
      expect((await ledger.dashain(2025))!.expectedDay, day(2025, 9, 17));
      await plan(2025, day(2025, 10, 3));
      expect((await ledger.dashain(2025))!.expectedDay, day(2025, 9, 18));
      expect(await ledger.entries(), isEmpty);
    },
  );

  test('same confirmation is idempotent after restart and rejects different stale input', () async {
    final account = await bank('NPR');
    await plan(2024, day(2024, 10, 12));
    final receipt = (accountId: account, minor: 204550, day: day(2024, 9, 25));
    Future<void> confirm() => ledger.confirmDashain(
      year: 2024,
      expectedRevision: 0,
      receipt: receipt,
    );
    await Future.wait([confirm(), confirm()]);
    await db.close();
    await open();
    await confirm();
    await expectLater(
      ledger.confirmDashain(
        year: 2024,
        expectedRevision: 0,
        receipt: (accountId: account, minor: 100, day: receipt.day),
      ),
      ledgerIssue(LedgerIssue.duplicateConflict),
    );
    expect((await ledger.dashain(2024))!.receipt, receipt);
    expect((await ledger.entries()).single.kind, JournalKind.dashainBonus);
    expect((await ledger.balance(account)).minor, receipt.minor);
    expect(await ledger.netExpenses('NPR'), BigInt.zero);
  });

  test(
    'correction and undo link reversals and retain one net receipt',
    () async {
      final account = await bank();
      await plan(2024, day(2024, 10, 12));
      final old = (accountId: account, minor: 200, day: day(2024, 9, 25));
      final updated = (accountId: account, minor: 180, day: day(2024, 9, 26));
      await ledger.confirmDashain(
        year: 2024,
        expectedRevision: 0,
        receipt: old,
      );
      final original = (await ledger.dashain(2024))!.plan.receiptId!;
      await expectLater(
        ledger.reverse(
          operationId: 'generic-reverse',
          entryId: original,
          effectiveAt: DateTime.utc(2024, 9, 25),
          reason: 'Test',
        ),
        ledgerIssue(LedgerIssue.reversalNotAllowed),
      );
      await expectLater(
        ledger.confirmDashain(
          year: 2024,
          expectedRevision: 1,
          reason: 'Test',
          receipt: (accountId: account, minor: 0, day: updated.day),
        ),
        ledgerIssue(LedgerIssue.invalidInput),
      );
      expect((await ledger.entries()).length, 1);
      Future<void> correct() => ledger.confirmDashain(
        year: 2024,
        expectedRevision: 1,
        receipt: updated,
        reason: 'Test correction',
      );
      await correct();
      await correct();
      final view = (await ledger.dashain(2024))!;
      expect(view.receipt, updated);
      expect(
        (await ledger.entries())
            .singleWhere((row) => row.id == view.plan.receiptId)
            .correctionOf,
        original,
      );
      expect(
        (await ledger.entries())
            .singleWhere((row) => row.reversalOf == original)
            .effectiveMicros,
        dateOfLeaveDay(old.day).microsecondsSinceEpoch,
      );
      expect((await ledger.balance(account)).minor, 180);
      await ledger.confirmDashain(
        year: 2024,
        expectedRevision: 2,
        receipt: null,
        reason: 'Test withdrawal',
      );
      expect((await ledger.balance(account)).minor, 0);
      expect((await ledger.dashain(2024))!.receipt, isNull);
      expect(await ledger.entries(), hasLength(4));
      await expectLater(
        ledger.confirmDashain(year: 2024, expectedRevision: 0, receipt: old),
        ledgerIssue(LedgerIssue.duplicateConflict),
      );
    },
  );

  test('a reconciled bonus cannot be reversed or changed', () async {
    final account = await bank();
    await plan(2024, day(2024, 10, 12));
    final receipt = (accountId: account, minor: 200, day: day(2024, 9, 25));
    await ledger.confirmDashain(
      year: 2024,
      expectedRevision: 0,
      receipt: receipt,
    );
    await ledger.confirmAccountBalance(
      accountId: account,
      operationId: 'statement',
      priorMinor: 200,
      countedMinor: 200,
      effectiveAt: DateTime.utc(2024, 9, 30),
    );
    await expectLater(
      ledger.confirmDashain(
        year: 2024,
        expectedRevision: 1,
        receipt: null,
        reason: 'Test',
      ),
      ledgerIssue(LedgerIssue.reconciledPeriod),
    );
    expect((await ledger.dashain(2024))!.receipt, receipt);
    expect(await ledger.entries(), hasLength(2));
  });

  testWidgets(
    'Arabic benefits screen confirms an actual bonus from a chosen account',
    (tester) async {
      final year = DateTime.now().year;
      final account = await bank();
      await plan(year, day(year, 10, 12));
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('الاستحقاقات والادخار'));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.text('مكافأة الدساي'))),
        TextDirection.rtl,
      );
      expect(find.text('المتوقع 2050.00 USD'), findsOneWidget);
      await tester.tap(find.text('تأكيد الاستلام'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('حساب الاستلام'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test USD · USD').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '١٢٣٫٤٥');
      await tester.tap(find.text('تأكيد'));
      await tester.pumpAndSettle();
      expect(find.text('تم الاستلام'), findsOneWidget);
      expect(find.text('123.45 USD'), findsOneWidget);
      expect((await ledger.balance(account)).minor, 12345);
      await tester.tap(find.byTooltip('رجوع'));
      await tester.pumpAndSettle();
      expect(find.text('123.45 USD'), findsOneWidget);
      await tester.tap(find.text('القيود'));
      await tester.pumpAndSettle();
      expect(find.text('مكافأة الدساي'), findsOneWidget);
    },
  );

  test(
    'ticket is non-cash and separate by year with optional leave and usage',
    () async {
      expect(ticketStatus(null, 2024, DateTime(2024, 1, 1)), TicketStatus.due);
      expect(ticketStatus(null, 2024, DateTime(2025)), TicketStatus.expired);
      final leave = await ledger.personalLeave.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.approved,
        period: LeavePeriod(day(2024, 10, 11), day(2024, 10, 16)),
      );
      final received = day(2024, 9, 28);
      await ledger.saveTicket(
        year: 2024,
        expected: null,
        receivedDay: received,
      );
      await ledger.saveTicket(
        year: 2024,
        expected: null,
        receivedDay: received,
      );
      await expectLater(
        ledger.saveTicket(
          year: 2024,
          expected: null,
          receivedDay: day(2024, 9, 29),
        ),
        ledgerIssue(LedgerIssue.duplicateConflict),
      );
      final ticket = (await ledger.ticket(2024))!;
      expect(
        ticketStatus(ticket, 2024, DateTime(2024, 9, 28)),
        TicketStatus.received,
      );
      expect(ticket.usedDay, isNull);
      await expectLater(
        ledger.saveTicket(
          year: 2024,
          expected: ticket,
          receivedDay: received,
          usedDay: day(2025, 1, 1),
        ),
        ledgerIssue(LedgerIssue.invalidInput),
      );
      await ledger.saveTicket(
        year: 2024,
        expected: ticket,
        receivedDay: received,
        usedDay: day(2024, 10, 11),
        leaveId: leave,
      );
      await db.close();
      await open();
      final used = (await ledger.ticket(2024))!;
      expect(ticketStatus(used, 2024, DateTime(2025)), TicketStatus.used);
      expect(used.leaveId, leave);
      expect(used.receivedDay, received);
      expect(used.usedDay, day(2024, 10, 11));
      expect(await ledger.ticket(2025), isNull);
      await ledger.saveTicket(
        year: 2024,
        expected: used,
        receivedDay: received,
      );
      expect((await ledger.ticket(2024))!.usedDay, isNull);
      expect(await ledger.entries(), isEmpty);
    },
  );

  test('contributions and goal changes recalculate savings without posting or double counting', () async {
    final source = await bank();
    final destination = await bank();
    final foreign = await bank('EGP');
    final date = day(2024, 10, 1);
    await ledger.recordOpening(
      operationId: 'start',
      accountId: source,
      minor: 1000,
      effectiveAt: dateOfLeaveDay(date),
    );
    await ledger.saveTravelGoal(
      currency: 'USD',
      targetDay: day(2024, 12, 1),
      tripMinor: 1100,
      airfareMinor: 100,
    );
    Future<void> contribute(
      String key,
      int account,
      int amount, {
      TravelContribution? expected,
    }) => ledger.contributeToTravel(
      operationId: key,
      accountId: account,
      day: date,
      minor: amount,
      expected: expected,
    );
    Future<TravelProgress> progress() async =>
        (await ledger.travelSavings(today: DateTime(2024, 10, 1)))!.progress;
    await contribute('one', source, 600);
    await contribute('one', source, 600);
    await expectLater(
      contribute('wrong currency', foreign, 10),
      ledgerIssue(LedgerIssue.currencyMismatch),
    );
    await expectLater(
      contribute('too much', source, 401),
      ledgerIssue(LedgerIssue.invalidInput),
    );
    expect(await progress(), (
      target: 1200,
      pledged: 600,
      saved: 600,
      remaining: 600,
      monthly: 200,
    ));
    final existing = (await ledger.travelSavings())!.contributions.single;
    await contribute('one', source, 500, expected: existing);
    expect((await progress()).monthly, 234);
    await ledger.saveTravelGoal(
      currency: 'USD',
      targetDay: day(2024, 11, 10),
      tripMinor: 1000,
      airfareMinor: 0,
    );
    expect((await progress()).monthly, 250);
    await ledger.transfer(
      operationId: 'move',
      from: source,
      to: destination,
      minor: 900,
      effectiveAt: dateOfLeaveDay(date),
    );
    expect((await progress()).saved, 100);
    await contribute('two', destination, 900);
    expect((await progress()).saved, 1000);
    expect(await ledger.entries(), hasLength(2));
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    expect((await ledger.travelSavings())!.progress.remaining, 0);
  });

  test(
    'encrypted v6 migration keeps finance and leave and creates a v6 backup',
    () async {
      final account = await bank();
      await ledger.recordOpening(
        operationId: 'prior',
        accountId: account,
        minor: 1280,
        effectiveAt: DateTime.utc(2024, 10),
      );
      final leave = await ledger.personalLeave.save(
        kind: LeaveKind.sick,
        status: LeaveStatus.approved,
        period: LeavePeriod(day(2024, 10, 4), day(2024, 10, 5)),
      );
      await db.close();
      final raw = sqlite.sqlite3.open(file.path);
      try {
        unlockDatabase(raw, hexKey);
        dropEntitlementSchema(raw);
        raw.execute('PRAGMA user_version = 6');
      } finally {
        raw.close();
      }
      await open();
      expect(db.schemaVersion, 7);
      expect((await ledger.balance(account)).minor, 1280);
      expect((await ledger.personalLeave.overview()).entries.single.id, leave);
      await plan(2024, day(2024, 10, 12));
      expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
      expect(
        (await db.customSelect('PRAGMA integrity_check').getSingle())
            .data
            .values
            .single,
        'ok',
      );
      final backup = sqlite.sqlite3.open(
        '${file.path}.v6.backup',
        mode: sqlite.OpenMode.readOnly,
      );
      try {
        unlockDatabase(backup, hexKey);
        expect(backup.select('PRAGMA user_version').single.values.single, 6);
        expect(
          backup
              .select('SELECT count(*) FROM leave_entries')
              .single
              .values
              .single,
          1,
        );
        expect(
          backup
              .select('SELECT count(*) FROM journal_entries')
              .single
              .values
              .single,
          1,
        );
      } finally {
        backup.close();
      }
    },
  );
}
