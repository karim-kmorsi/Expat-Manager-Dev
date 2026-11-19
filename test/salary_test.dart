import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final date = DateTime.utc(2026, 1, 2);
  late Directory directory;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;
  late int bank;
  late int cash;

  Future<LedgerDatabase> open() =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, 17)));

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('expat-salary-');
    file = File('${directory.path}/ledger.sqlite');
    db = await open();
    ledger = Ledger(db);
    bank = await ledger.createAccount(
      name: 'Synthetic payroll',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    cash = await ledger.createAccount(
      name: 'Synthetic cash',
      currency: 'USD',
      kind: AccountKind.cash,
    );
  });

  tearDown(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  Future<int> salary({
    String key = 'salary',
    int? account,
    int minor = 200000,
    String? reference,
    DateTime? received,
  }) => ledger.recordSalary(
    operationId: key,
    accountId: account ?? bank,
    minor: minor,
    receivedOn: received ?? date,
    reference: reference,
  );

  Future<int> plan() async {
    final id = await salary();
    await ledger.createSalaryPlan(id);
    return id;
  }

  Future<int> movement(String key, int minor, {int? source}) => ledger.transfer(
    operationId: key,
    from: source ?? bank,
    to: cash,
    minor: minor,
    effectiveAt: date,
  );

  Future<void> link(int allocation, int entry, int minor) =>
      ledger.linkSalaryExecution(
        allocationId: allocation,
        entryId: entry,
        minor: minor,
      );

  Matcher issue(SalaryIssue value) => throwsA(
    isA<SalaryException>().having((error) => error.issue, 'issue', value),
  );

  test('credits salary once and saving a plan leaves 200 USD unallocated without changing balances', () async {
    final ids = await Future.wait([salary(), salary()]);
    expect(ids.first, ids.last);
    await expectLater(
      salary(key: 'different request'),
      issue(SalaryIssue.duplicateReceipt),
    );
    final id = ids.first;
    await ledger.createSalaryPlan(id);
    await ledger.createSalaryPlan(id);
    for (final (label, minor) in [
      ('Family', 50000),
      ('Savings', 40000),
      ('Cash', 30000),
      ('Living', 60000),
    ]) {
      await ledger.addSalaryAllocation(id, label, minor);
    }
    final result = await ledger.salaryPlan(id);
    expect(result.planned, 180000);
    expect(result.unallocated, 20000);
    expect(result.executed, 0);
    expect(result.confirmed, 0);
    expect(
      salaryProgress(result.planned, result.executed, result.confirmed),
      SalaryProgress.planned,
    );
    expect((await ledger.balance(bank)).minor, 200000);
    expect(await ledger.entries(), hasLength(1));
    expect((await ledger.entries()).single.kind, JournalKind.salary);
    expect((await ledger.salaryMovement(id)).lines.map((line) => line.minor), [
      -200000,
      200000,
    ]);
    expect((await ledger.balance(cash)).minor, 0);
  });

  test('deduplicates reliable account references and validates bank and positive salary', () async {
    final id = await salary(reference: ' Synthetic A ');
    expect(await salary(reference: 'Synthetic A'), id);
    await expectLater(
      salary(key: 'different', reference: 'Synthetic A', minor: 210000),
      issue(SalaryIssue.duplicateReceipt),
    );
    await salary(key: 'two payrolls', reference: 'Synthetic B');
    await expectLater(
      salary(key: 'ambiguous'),
      issue(SalaryIssue.duplicateReceipt),
    );
    await expectLater(
      salary(key: 'zero', minor: 0),
      issue(SalaryIssue.invalidInput),
    );
    await expectLater(
      salary(key: 'negative', minor: -1),
      issue(SalaryIssue.invalidInput),
    );
    await expectLater(
      salary(key: 'cash deposit', account: cash),
      issue(SalaryIssue.bankAccountRequired),
    );
    expect(await ledger.salaries(), hasLength(2));
    expect((await ledger.balance(bank)).minor, 400000);
  });

  test('draft edits and deletes preserve budget; overflow and concurrent oversubscription fail', () async {
    final id = await plan();
    final item = await ledger.addSalaryAllocation(id, 'Draft', 40000);
    await ledger.updateSalaryAllocation(item, 'Revised', 50000);
    expect((await ledger.salaryPlan(id)).allocations.single.label, 'Revised');
    await expectLater(
      ledger.updateSalaryAllocation(item, 'Too large', 200001),
      issue(SalaryIssue.planLimit),
    );
    await expectLater(
      ledger.addSalaryAllocation(id, 'Too large', maxMinor),
      issue(SalaryIssue.planLimit),
    );
    await expectLater(
      ledger.addSalaryAllocation(id, 'Zero', 0),
      issue(SalaryIssue.invalidInput),
    );
    await expectLater(
      ledger.addSalaryAllocation(id, '', 100),
      issue(SalaryIssue.invalidInput),
    );
    await ledger.deleteSalaryAllocation(item);
    expect((await ledger.salaryPlan(id)).unallocated, 200000);
    final writes = await Future.wait([
      for (final label in ['Concurrent A', 'Concurrent B'])
        ledger
            .addSalaryAllocation(id, label, 120000)
            .then<Object>((id) => id, onError: (Object error) => error),
    ]);
    expect(writes.whereType<int>(), hasLength(1));
    expect(
      writes.whereType<SalaryException>().single.issue,
      SalaryIssue.planLimit,
    );
    expect((await ledger.salaryPlan(id)).unallocated, 80000);
  });

  test(
    'links two existing installments and derives executed and confirmed states',
    () async {
      final id = await plan();
      final item = await ledger.addSalaryAllocation(id, 'Cash', 30000);
      final first = await movement('payment one', 10000);
      final second = await movement('payment two', 20000);
      expect(await ledger.salaryCandidates(item), hasLength(2));
      final before = await ledger.entries();
      final balanceBefore = await ledger.balance(bank);
      await Future.wait([link(item, first, 10000), link(item, first, 10000)]);
      var status = (await ledger.salaryPlan(id)).allocations.single;
      expect(
        (status.executed, status.confirmed, status.remaining),
        (10000, 0, 20000),
      );
      expect(
        salaryProgress(status.planned, status.executed, status.confirmed),
        SalaryProgress.partial,
      );
      await expectLater(
        link(item, first, 1),
        issue(SalaryIssue.duplicateExecution),
      );
      await expectLater(
        ledger.updateSalaryAllocation(item, 'Edited', 30000),
        issue(SalaryIssue.allocationLocked),
      );
      await expectLater(
        ledger.deleteSalaryAllocation(item),
        issue(SalaryIssue.allocationLocked),
      );
      await expectLater(
        ledger.confirmSalaryMovement(second, 'Unlinked statement'),
        issue(SalaryIssue.unlinkedMovement),
      );
      await ledger.confirmSalaryMovement(first, 'Synthetic statement A');
      await ledger.confirmSalaryMovement(first, 'Synthetic statement A');
      await expectLater(
        ledger.confirmSalaryMovement(first, 'Changed'),
        issue(SalaryIssue.alreadyConfirmed),
      );
      await expectLater(
        link(item, second, 20001),
        issue(SalaryIssue.allocationLimit),
      );
      await link(item, second, 20000);
      status = (await ledger.salaryPlan(id)).allocations.single;
      expect(
        (status.executed, status.confirmed, status.remaining),
        (30000, 10000, 0),
      );
      expect(
        salaryProgress(status.planned, status.executed, status.confirmed),
        SalaryProgress.executed,
      );
      await ledger.confirmSalaryMovement(second, 'Synthetic statement B');
      status = (await ledger.salaryPlan(id)).allocations.single;
      expect(
        salaryProgress(status.planned, status.executed, status.confirmed),
        SalaryProgress.confirmed,
      );
      expect(await ledger.entries(), before);
      expect(await ledger.balance(bank), balanceBefore);
      expect(await ledger.netExpenses('USD'), BigInt.zero);
    },
  );

  test('caps reuse across plans and rejects movements with the wrong source or kind', () async {
    final id = await plan();
    final secondSalary = await salary(
      key: 'another month',
      received: DateTime.utc(2026, 2, 2),
    );
    await ledger.createSalaryPlan(secondSalary);
    final first = await ledger.addSalaryAllocation(id, 'First', 30000);
    final second = await ledger.addSalaryAllocation(
      secondSalary,
      'Second',
      30000,
    );
    final entry = await movement('shared debit', 30000);
    await link(first, entry, 20000);
    await expectLater(
      link(second, entry, 10001),
      issue(SalaryIssue.movementLimit),
    );
    final choices = await ledger.salaryCandidates(second);
    expect(choices.single.available, 10000);
    await link(second, entry, 10000);
    expect(await ledger.salaryCandidates(second), isEmpty);
    await expectLater(
      link(second, id, 1),
      issue(SalaryIssue.ineligibleMovement),
    );
    final bank2 = await ledger.createAccount(
      name: 'Another bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    final wrong = await movement('wrong debit', 100, source: bank2);
    await expectLater(
      link(second, wrong, 1),
      issue(SalaryIssue.ineligibleMovement),
    );
    await expectLater(link(second, wrong, -1), issue(SalaryIssue.invalidInput));
  });

  test('retains reversal history, frees executed plan capacity and blocks reversed entries', () async {
    final id = await plan();
    final item = await ledger.addSalaryAllocation(id, 'Cash', 30000);
    final another = await ledger.addSalaryAllocation(id, 'Another', 10000);
    final payment = await movement('payment', 10000);
    await link(item, payment, 10000);
    await ledger.confirmSalaryMovement(payment, 'Synthetic statement');
    await ledger.reverse(
      operationId: 'reverse payment',
      entryId: payment,
      effectiveAt: date,
      reason: 'Fixture',
    );
    final allocation = (await ledger.salaryPlan(id)).allocations.first;
    expect(
      (allocation.executed, allocation.confirmed, allocation.remaining),
      (0, 0, 30000),
    );
    expect(allocation.executions.single.reversed, isTrue);
    expect(allocation.executions.single.evidence, 'Synthetic statement');
    await expectLater(
      link(another, payment, 1),
      issue(SalaryIssue.reversedMovement),
    );
    await expectLater(
      ledger.deleteSalaryAllocation(item),
      issue(SalaryIssue.allocationLocked),
    );
    await ledger.reverse(
      operationId: 'reverse salary',
      entryId: id,
      effectiveAt: date,
      reason: 'Fixture',
    );
    expect((await ledger.salaryPlan(id)).salary.reversed, isTrue);
    await expectLater(
      ledger.addSalaryAllocation(id, 'Blocked', 1),
      issue(SalaryIssue.reversedSalary),
    );
  });

  test(
    'a failed salary receipt write rolls back the deposit and allows retry',
    () async {
      await db.customStatement(
        "CREATE TRIGGER reject_test_salary BEFORE INSERT ON salary_receipts "
        "BEGIN SELECT RAISE(ABORT, 'injected failure'); END",
      );
      await expectLater(salary(), throwsA(isA<SqliteException>()));
      expect((await ledger.balance(bank)).minor, 0);
      expect(await ledger.entries(), isEmpty);
      expect(await ledger.salaries(), isEmpty);
      await db.customStatement('DROP TRIGGER reject_test_salary');
      await salary();
      expect((await ledger.balance(bank)).minor, 200000);
      expect(await ledger.entries(), hasLength(1));
    },
  );

  test('salary, plan, links and confirmation persist after reopening the encrypted file', () async {
    final id = await plan();
    final item = await ledger.addSalaryAllocation(id, 'Saving', 40000);
    final entry = await movement('actual savings movement', 5000);
    await link(item, entry, 5000);
    await ledger.confirmSalaryMovement(entry, 'Synthetic receipt');
    await db.close();
    db = await open();
    ledger = Ledger(db);
    final result = await ledger.salaryPlan(id);
    expect(result.unallocated, 160000);
    expect((result.executed, result.confirmed), (5000, 5000));
    expect(result.allocations.single.remaining, 35000);
    expect((await ledger.balance(bank)).minor, 195000);
    expect(await ledger.entries(), hasLength(2));
  });

  test('migrates the encrypted v1 ledger and keeps a verified encrypted recovery copy', () async {
    await ledger.recordOpening(
      operationId: 'v1-open',
      accountId: bank,
      minor: 12345,
      effectiveAt: date,
    );
    await db.close();
    final key = List.filled(32, '11').join();
    final old = sqlite3.open(file.path);
    try {
      unlockDatabase(old, key);
      for (final table in [
        'remittance_family_payments',
        'remittance_purposes',
        'remittance_events',
        'remittances',
        'expense_details',
        'cash_reconciliations',
        'cash_settings',
        'movement_confirmations',
        'salary_executions',
        'salary_allocations',
        'salary_plans',
        'salary_receipts',
      ]) {
        old.execute('DROP TABLE $table');
      }
      old.execute(
        "DELETE FROM ledger_accounts WHERE kind IN ('remittanceTransit', 'remittanceExchange')",
      );
      old.execute("DELETE FROM ledger_accounts WHERE kind = 'cashAdjustment'");
      old.execute('PRAGMA user_version = 1');
    } finally {
      old.close();
    }

    db = await open();
    ledger = Ledger(db);
    expect((await ledger.balance(bank)).minor, 12345);
    expect(await ledger.salaries(), isEmpty);
    final snapshot = File('${file.path}.v1.backup');
    expect(snapshot.existsSync(), isTrue);
    expect(
      await snapshot.openRead(0, 16).first,
      isNot('SQLite format 3\u0000'.codeUnits),
    );
    final oldCopy = sqlite3.open(snapshot.path, mode: OpenMode.readOnly);
    try {
      unlockDatabase(oldCopy, key);
      expect(oldCopy.select('PRAGMA user_version').single.values.single, 1);
      expect(
        oldCopy
            .select(
              "SELECT count(*) FROM journal_entries WHERE operation_id = 'v1-open'",
            )
            .single
            .values
            .single,
        1,
      );
    } finally {
      oldCopy.close();
    }
    await salary();
    expect((await ledger.balance(bank)).minor, 212345);
  });
}
