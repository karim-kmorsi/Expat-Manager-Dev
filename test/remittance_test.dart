import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

void main() {
  final sent = DateTime(2026, 11, 1);
  final later = DateTime(2026, 11, 3);
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;
  late int nepal;
  late int egypt;
  late int sameCurrency;

  Future<LedgerDatabase> open([int value = 86]) =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, value)));

  setUp(() async {
    final folder = await Directory.systemTemp.createTemp('remittances-');
    file = File('${folder.path}/ledger.sqlite');
    db = await open();
    ledger = Ledger(db);
    nepal = await ledger.createAccount(
      name: 'Synthetic Nepal bank',
      currency: 'NPR',
      kind: AccountKind.bank,
    );
    egypt = await ledger.createAccount(
      name: 'Synthetic Egypt bank',
      currency: 'EGP',
      kind: AccountKind.bank,
    );
    sameCurrency = await ledger.createAccount(
      name: 'Synthetic Egyptian NPR account',
      currency: 'NPR',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 'test-opening',
      accountId: nepal,
      minor: 100000,
      effectiveAt: sent,
    );
  });

  tearDown(() async {
    await db.close();
    await file.parent.delete(recursive: true);
  });

  Future<int> plan(
    String key, {
    bool same = false,
    RemittanceDestination type = RemittanceDestination.personal,
  }) => ledger.planRemittance(
    operationId: key,
    sourceAccountId: nepal,
    destination: type,
    destinationAccountId: type == RemittanceDestination.personal
        ? (same ? sameCurrency : egypt)
        : null,
    destinationCurrency: same ? 'NPR' : 'EGP',
    beneficiary: type == RemittanceDestination.personal
        ? null
        : 'Synthetic recipient',
  );

  Future<int> movement(
    int id,
    String key,
    RemittanceEventKind kind,
    int amount, {
    String? evidence,
    int? fee,
    int? source,
    int? receipt,
    DateTime? date,
  }) => ledger.recordRemittanceEvent(
    remittanceId: id,
    operationId: key,
    kind: kind,
    minor: amount,
    evidence: evidence ?? key,
    effectiveAt: date ?? sent,
    feeMinor: fee,
    sourceMinor: source,
    receiptEntryId: receipt,
  );

  Matcher rejected(RemittanceIssue issue) => throwsA(
    isA<RemittanceException>().having((error) => error.issue, 'issue', issue),
  );

  Future<void> verifyBalance() async {
    for (final entry in await ledger.entries()) {
      final totals = <String, BigInt>{};
      for (final line in (await ledger.salaryMovement(entry.id)).lines) {
        totals.update(
          line.currency,
          (sum) => sum + BigInt.from(line.minor),
          ifAbsent: () => BigInt.from(line.minor),
        );
      }
      expect(
        totals.values.every((sum) => sum == BigInt.zero),
        isTrue,
        reason: 'Entry ${entry.id}: $totals',
      );
    }
  }

  test('one debit, partial foreign receipt, delayed proof and two purposes survive reopen', () async {
    final id = await plan('own');
    expect(await plan('own'), id);
    expect((await ledger.remittance(id)).status, RemittanceStatus.planned);
    expect((await ledger.balance(nepal)).minor, 100000);

    final debit = await movement(
      id,
      'bank reference 11',
      RemittanceEventKind.debit,
      30000,
      fee: 1000,
    );
    expect((await ledger.remittance(id)).status, RemittanceStatus.sent);
    expect((await ledger.balance(nepal)).minor, 70000);
    expect((await ledger.balance(egypt)).minor, 0);
    expect(await ledger.netExpenses('NPR'), BigInt.from(1000));
    expect(
      await movement(
        id,
        'bank reference 11',
        RemittanceEventKind.debit,
        30000,
        fee: 1000,
      ),
      debit,
    );
    await ledger.updateRemittanceStatus(id, cancel: false);

    await db.close();
    db = await open();
    ledger = Ledger(db);
    expect((await ledger.remittance(id)).status, RemittanceStatus.pending);
    final receipt = await movement(
      id,
      'receipt one',
      RemittanceEventKind.receipt,
      3500,
      date: later,
    );
    var view = await ledger.remittance(id);
    expect(view.outstanding, 29000);
    expect(view.needsSourceProof(view.active.last), isTrue);
    expect((await ledger.balance(egypt)).minor, 3500);
    await movement(
      id,
      'receipt two',
      RemittanceEventKind.receipt,
      5400,
      source: 18000,
      date: later,
    );
    expect((await ledger.remittance(id)).outstanding, 11000);
    await expectLater(
      movement(
        id,
        'bad proof',
        RemittanceEventKind.sourceProof,
        12000,
        receipt: receipt,
        date: later,
      ),
      rejected(RemittanceIssue.sourceLimit),
    );
    await movement(
      id,
      'settlement statement',
      RemittanceEventKind.sourceProof,
      11000,
      receipt: receipt,
      date: later,
    );
    expect(
      await movement(
        id,
        'receipt one',
        RemittanceEventKind.receipt,
        3500,
        date: later,
      ),
      receipt,
    );
    await ledger.addRemittancePurpose(
      id,
      'family',
      'Family earmark',
      4500,
      family: true,
    );
    await ledger.addRemittancePurpose(id, 'other', 'Own costs', 4000);
    await expectLater(
      ledger.addRemittancePurpose(id, 'too much', 'Over', 401),
      rejected(RemittanceIssue.purposeLimit),
    );
    view = await ledger.remittance(id);
    expect(view.status, RemittanceStatus.received);
    expect(view.unallocated, 400);
    expect((await ledger.balance(nepal)).minor, 70000);
    expect((await ledger.balance(egypt)).minor, 8900);
    expect(await ledger.netExpenses('EGP'), BigInt.zero);
    expect(
      (await ledger.entries()).where(
        (e) => e.kind == JournalKind.remittanceDebit,
      ),
      hasLength(1),
    );
    await verifyBalance();

    await db.close();
    expect(
      await file.openRead(0, 16).first,
      isNot('SQLite format 3\u0000'.codeUnits),
    );
    await expectLater(open(87), throwsA(isA<StorageLocked>()));
    db = await open();
    ledger = Ledger(db);
    expect((await ledger.remittance(id)).purposes, hasLength(2));
    expect((await ledger.remittance(id)).status, RemittanceStatus.received);
  });

  test('pre-debit cancellation and post-debit partial refund retain unexplained balance', () async {
    final cancelled = await plan('cancel early');
    await ledger.updateRemittanceStatus(cancelled, cancel: true);
    expect(
      (await ledger.remittance(cancelled)).status,
      RemittanceStatus.cancelled,
    );
    expect(await ledger.entries(), hasLength(1));
    await movement(
      cancelled,
      'observed late debit',
      RemittanceEventKind.debit,
      200,
    );
    expect(
      (await ledger.remittance(cancelled)).status,
      RemittanceStatus.pending,
    );
    await movement(
      cancelled,
      'late debit returned',
      RemittanceEventKind.refund,
      200,
    );
    expect(
      (await ledger.remittance(cancelled)).status,
      RemittanceStatus.refunded,
    );

    final id = await plan('sent then returned', same: true);
    await movement(id, 'dated debit', RemittanceEventKind.debit, 60000);
    await ledger.updateRemittanceStatus(id, cancel: true);
    expect((await ledger.balance(nepal)).minor, 40000);
    final refund = await movement(
      id,
      'actual refund',
      RemittanceEventKind.refund,
      20000,
      date: later,
    );
    final view = await ledger.remittance(id);
    expect(view.status, RemittanceStatus.pending);
    expect(view.outstanding, 40000);
    expect(view.debit!.event.feeMinor, isNull);
    expect(
      view.active.last.movement.entry.effectiveMicros,
      later.microsecondsSinceEpoch,
    );
    expect((await ledger.balance(nepal)).minor, 60000);
    expect(
      await movement(
        id,
        'actual refund',
        RemittanceEventKind.refund,
        20000,
        date: later,
      ),
      refund,
    );
    await expectLater(
      movement(
        id,
        'extra refund',
        RemittanceEventKind.refund,
        40001,
        date: later,
      ),
      rejected(RemittanceIssue.sourceLimit),
    );
    await movement(
      id,
      'rest returned',
      RemittanceEventKind.refund,
      40000,
      date: later,
    );
    expect((await ledger.remittance(id)).status, RemittanceStatus.refunded);
    expect((await ledger.balance(nepal)).minor, 100000);
    expect(await ledger.netExpenses('NPR'), BigInt.zero);
    await verifyBalance();
  });

  test('duplicate references across drafts, raced debits, bad values, and key conflicts', () async {
    final first = await plan('first', same: true);
    final second = await plan('second', same: true);
    final replies = await Future.wait([
      movement(
        first,
        'bank-1',
        RemittanceEventKind.debit,
        1500,
        evidence: 'Bank ID 123',
      ),
      movement(
        first,
        'bank-1',
        RemittanceEventKind.debit,
        1500,
        evidence: 'Bank ID 123',
      ),
    ]);
    expect(replies[0], replies[1]);
    await expectLater(
      movement(
        second,
        'bank-2',
        RemittanceEventKind.debit,
        1500,
        evidence: 'bank id 123',
      ),
      rejected(RemittanceIssue.duplicateEvidence),
    );
    await movement(second, 'bank-2', RemittanceEventKind.debit, 1500);
    await expectLater(
      movement(first, 'zero', RemittanceEventKind.receipt, 0),
      rejected(RemittanceIssue.invalidInput),
    );
    await expectLater(
      movement(first, 'negative', RemittanceEventKind.receipt, -3),
      rejected(RemittanceIssue.invalidInput),
    );
    await expectLater(
      movement(
        first,
        'early',
        RemittanceEventKind.receipt,
        400,
        date: sent.subtract(const Duration(days: 1)),
      ),
      rejected(RemittanceIssue.invalidStatus),
    );
    await movement(
      first,
      'r1',
      RemittanceEventKind.receipt,
      500,
      evidence: 'receipt ref',
    );
    await expectLater(
      movement(
        second,
        'r2',
        RemittanceEventKind.receipt,
        500,
        evidence: 'RECEIPT REF',
      ),
      rejected(RemittanceIssue.duplicateEvidence),
    );
    await expectLater(
      movement(
        first,
        'r1',
        RemittanceEventKind.receipt,
        501,
        evidence: 'receipt ref',
      ),
      throwsA(
        isA<LedgerException>().having(
          (error) => error.issue,
          'issue',
          LedgerIssue.duplicateConflict,
        ),
      ),
    );
    await movement(first, 'r3', RemittanceEventKind.receipt, 1000);
    expect((await ledger.remittance(first)).status, RemittanceStatus.received);
    expect((await ledger.balance(sameCurrency)).minor, 1500);
    await verifyBalance();
  });

  test(
    'family receipt and later existing family expense are counted once each',
    () async {
      final direct = await plan(
        'direct to family',
        type: RemittanceDestination.family,
      );
      await movement(direct, 'direct debit', RemittanceEventKind.debit, 2500);
      expect(await ledger.netExpenses('EGP'), BigInt.zero);
      await movement(
        direct,
        'family received',
        RemittanceEventKind.receipt,
        1000,
        source: 2500,
      );
      expect(await ledger.netExpenses('EGP'), BigInt.from(1000));

      final own = await plan('own with family purpose');
      await movement(own, 'personal debit', RemittanceEventKind.debit, 3000);
      final receipt = await movement(
        own,
        'own receipt',
        RemittanceEventKind.receipt,
        2000,
        source: 3000,
      );
      await ledger.addRemittancePurpose(
        own,
        'support',
        'Support',
        1000,
        family: true,
      );
      await ledger.addRemittancePurpose(
        own,
        'support2',
        'Support second',
        1000,
        family: true,
      );
      expect(await ledger.netExpenses('EGP'), BigInt.from(1000));
      final expense = await ledger.recordExpense(
        operationId: 'family expense',
        input: (
          accountId: egypt,
          minor: 600,
          date: later,
          period: ExpensePeriod.individual,
          category: null,
          note: 'Synthetic payout',
        ),
      );
      expect(
        (await ledger.remittanceFamilyCandidates(own, 'support')).single.id,
        expense,
      );
      await ledger.linkRemittanceFamilyPayment(own, 'support', expense);
      await ledger.linkRemittanceFamilyPayment(own, 'support', expense);
      await expectLater(
        ledger.linkRemittanceFamilyPayment(own, 'support2', expense),
        rejected(RemittanceIssue.duplicateEvidence),
      );
      expect(
        (await ledger.remittance(own)).familyPayments['support']!.single.id,
        expense,
      );
      expect(await ledger.netExpenses('EGP'), BigInt.from(1600));
      expect((await ledger.balance(egypt)).minor, 1400);
      await expectLater(
        ledger.reverseRemittanceEvent(
          entryId: receipt,
          operationId: 'protected receipt',
          reason: 'linked payout',
          effectiveAt: later,
        ),
        rejected(RemittanceIssue.protectedCorrection),
      );
      await verifyBalance();
    },
  );

  test('salary execution links principal only and keeps the old link after a refund', () async {
    final salary = await ledger.recordSalary(
      operationId: 'salary',
      accountId: nepal,
      minor: 50000,
      receivedOn: sent,
    );
    await ledger.createSalaryPlan(salary);
    final a = await ledger.addSalaryAllocation(salary, 'Egypt first', 30000);
    final b = await ledger.addSalaryAllocation(salary, 'Egypt second', 10000);
    final id = await plan('salary remittance');
    final debit = await movement(
      id,
      'scheduled debit',
      RemittanceEventKind.debit,
      30000,
      fee: 2000,
    );
    expect((await ledger.salaryCandidates(a)).single.available, 28000);
    await ledger.linkSalaryExecution(
      allocationId: a,
      entryId: debit,
      minor: 26000,
    );
    await ledger.linkSalaryExecution(
      allocationId: a,
      entryId: debit,
      minor: 26000,
    );
    expect((await ledger.salaryCandidates(b)).single.available, 2000);
    final before = await ledger.balance(nepal);
    await expectLater(
      ledger.linkSalaryExecution(allocationId: b, entryId: debit, minor: 2001),
      throwsA(
        isA<SalaryException>().having(
          (e) => e.issue,
          'issue',
          SalaryIssue.movementLimit,
        ),
      ),
    );
    await expectLater(
      ledger.reverseRemittanceEvent(
        entryId: debit,
        operationId: 'no reverse',
        reason: 'linked already',
        effectiveAt: later,
      ),
      rejected(RemittanceIssue.protectedCorrection),
    );
    await ledger.confirmSalaryMovement(debit, 'Account statement');
    expect((await ledger.salaryPlan(salary)).confirmed, 26000);
    expect((await ledger.remittance(id)).status, RemittanceStatus.sent);
    expect(await ledger.balance(nepal), before);
    await movement(
      id,
      'refund part',
      RemittanceEventKind.refund,
      4000,
      date: later,
    );
    expect(await ledger.salaryCandidates(b), isEmpty);
    expect((await ledger.salaryPlan(salary)).executed, 26000);
    expect((await ledger.balance(nepal)).minor, before.minor + 4000);
    await verifyBalance();
  });

  test('correction preserves history, rolls back invalid replacement, blocks after matching', () async {
    final id = await plan('correction', same: true);
    final debit = await movement(
      id,
      'source debit',
      RemittanceEventKind.debit,
      2000,
    );
    final original = await movement(
      id,
      'correctable receipt',
      RemittanceEventKind.receipt,
      500,
    );
    await ledger.addRemittancePurpose(
      id,
      'already split',
      'Synthetic purpose',
      490,
    );
    Future<int> correct(int amount) => ledger.correctRemittanceEvent(
      entryId: original,
      operationId: 'replacement',
      reason: 'Bank clarified amount',
      effectiveAt: later,
      minor: amount,
      evidence: 'correctable receipt',
    );
    await expectLater(correct(480), rejected(RemittanceIssue.purposeLimit));
    await expectLater(correct(2500), rejected(RemittanceIssue.sourceLimit));
    expect((await ledger.salaryMovement(original)).reversed, isFalse);
    expect((await ledger.balance(sameCurrency)).minor, 500);
    final replacement = await correct(600);
    expect(await correct(600), replacement);
    expect((await ledger.salaryMovement(original)).reversed, isTrue);
    expect(
      (await ledger.salaryMovement(replacement)).entry.correctionOf,
      original,
    );
    expect((await ledger.balance(sameCurrency)).minor, 600);
    expect((await ledger.remittance(id)).outstanding, 1400);
    await ledger.confirmAccountBalance(
      accountId: sameCurrency,
      operationId: 'matched',
      priorMinor: 600,
      countedMinor: 600,
      effectiveAt: later,
    );
    await expectLater(
      ledger.reverseRemittanceEvent(
        entryId: replacement,
        operationId: 'reconciled',
        reason: 'date unresolved',
        effectiveAt: later,
      ),
      rejected(RemittanceIssue.protectedCorrection),
    );
    await expectLater(
      ledger.reverse(
        entryId: debit,
        operationId: 'generic reverse',
        reason: 'no bypass',
        effectiveAt: later,
      ),
      throwsA(isA<LedgerException>()),
    );
    await verifyBalance();
  });

  test(
    'encrypted v4 migration keeps balances and creates a verified backup',
    () async {
      await db.close();
      final key = List.filled(32, '56').join();
      final raw = sqlite.sqlite3.open(file.path);
      try {
        unlockDatabase(raw, key);
        for (final table in [
          'remittance_family_payments',
          'remittance_purposes',
          'remittance_events',
          'remittances',
        ]) {
          raw.execute('DROP TABLE $table');
        }
        raw.execute(
          "DELETE FROM ledger_accounts WHERE kind IN ('remittanceTransit', 'remittanceExchange')",
        );
        raw.execute('PRAGMA user_version = 4');
      } finally {
        raw.close();
      }
      db = await open();
      ledger = Ledger(db);
      expect((await ledger.balance(nepal)).minor, 100000);
      final backup = sqlite.sqlite3.open(
        '${file.path}.v4.backup',
        mode: sqlite.OpenMode.readOnly,
      );
      try {
        expect(
          () => backup.select('SELECT * FROM sqlite_schema'),
          throwsA(isA<sqlite.SqliteException>()),
        );
        unlockDatabase(backup, key);
        expect(backup.select('PRAGMA user_version').single.values.single, 4);
        expect(
          backup.select('PRAGMA integrity_check').single.values.single,
          'ok',
        );
      } finally {
        backup.close();
      }
      final id = await plan('after migration');
      await movement(id, 'new transfer', RemittanceEventKind.debit, 1000);
      expect((await ledger.balance(nepal)).minor, 99000);
    },
  );
}
