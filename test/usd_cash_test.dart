import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final january = DateTime.utc(2026, 1, 5);
  final february = DateTime.utc(2026, 2, 1);
  late Directory directory;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;
  late int wallet;
  late int bank;

  Future<LedgerDatabase> open([int byte = 19]) =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, byte)));

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('expat-usd-cash-');
    file = File('${directory.path}/ledger.sqlite');
    db = await open();
    ledger = Ledger(db);
    wallet = await ledger.setupUsdCash();
    bank = await ledger.createAccount(
      name: 'Synthetic bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
  });

  tearDown(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  Future<int> openCash(int minor) => ledger.recordOpening(
    operationId: 'cash-opening',
    accountId: wallet,
    minor: minor,
    effectiveAt: january,
  );

  Future<int> withdraw(String id, int minor, [DateTime? at]) =>
      ledger.withdrawUsdCash(
        operationId: id,
        bankId: bank,
        minor: minor,
        effectiveAt: at ?? january,
      );

  Future<int> income(String id, int minor) => ledger.receiveExternalUsdCash(
    operationId: id,
    minor: minor,
    effectiveAt: january,
  );

  Future<int> spend(String id, int minor, {String? note}) => ledger.useUsdCash(
    operationId: id,
    minor: minor,
    effectiveAt: january,
    note: note,
  );

  Matcher issue(CashIssue issue) => throwsA(
    isA<CashException>().having((error) => error.issue, 'issue', issue),
  );

  test('1000 + 500 - 100 + 500 across two months uses one ledger', () async {
    await openCash(100000);
    await ledger.recordOpening(
      operationId: 'bank-opening',
      accountId: bank,
      minor: 200000,
      effectiveAt: january,
    );
    await withdraw('jan', 50000);
    expect((await ledger.balance(wallet)).minor, 150000);
    expect((await ledger.balance(bank)).minor, 150000);
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    await spend('use', 10000);
    expect((await ledger.balance(wallet)).minor, 140000);
    expect(await ledger.netExpenses('USD'), BigInt.from(10000));
    await withdraw('feb', 50000, february);
    expect((await ledger.balance(wallet)).minor, 190000);
    expect((await ledger.balance(bank)).minor, 100000);
    final jan = await ledger.usdCashOverview(january);
    final feb = await ledger.usdCashOverview(february);
    expect(jan.withdrawnMinor, BigInt.from(50000));
    expect(feb.withdrawnMinor, BigInt.from(50000));
    expect(feb.withdrawalLimitMinor, 50000);
    expect(feb.movements.first.kind, CashMovementKind.bankWithdrawal);
    final expense = feb.movements.singleWhere(
      (entry) => entry.kind == CashMovementKind.expense,
    );
    expect(expense.note, isNull);
    expect(await ledger.entries(), hasLength(5));
  });

  test('setting and income are distinct from withdrawals, including legacy transfers', () async {
    await withdraw('new withdrawal', 50000);
    await ledger.transfer(
      operationId: 'existing transfer path',
      from: bank,
      to: wallet,
      minor: 5000,
      effectiveAt: DateTime.utc(2026, 1, 31, 23, 59, 59),
    );
    final receipt = await income('external', 50000);
    final jan = await ledger.usdCashOverview(january);
    expect(jan.withdrawnMinor > BigInt.from(jan.withdrawalLimitMinor), isTrue);
    expect(jan.withdrawnMinor, BigInt.from(55000));
    expect(
      jan.movements.singleWhere((entry) => entry.entryId == receipt).kind,
      CashMovementKind.externalIncome,
    );
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    await ledger.setUsdWithdrawalLimit(60000);
    final updated = await ledger.usdCashOverview(january);
    expect(
      updated.withdrawnMinor > BigInt.from(updated.withdrawalLimitMinor),
      isFalse,
    );
    expect(usdMonthlySavingsGoalMinor, 50000);
    await withdraw('next month', 1000, february);
    expect(
      (await ledger.usdCashOverview(february)).withdrawnMinor,
      BigInt.from(1000),
    );
  });

  test('singleton and retry keep every amount recorded exactly once', () async {
    expect(await ledger.setupUsdCash(), wallet);
    await expectLater(
      ledger.createAccount(
        name: 'Duplicate wallet',
        currency: 'USD',
        kind: AccountKind.cash,
      ),
      issue(CashIssue.duplicateCashAccount),
    );
    await ledger.createAccount(
      name: 'NPR cash',
      currency: 'NPR',
      kind: AccountKind.cash,
    );
    final ids = await Future.wait([
      withdraw('one debit', 50000),
      withdraw('one debit', 50000),
    ]);
    expect(ids.first, ids.last);
    await expectLater(
      withdraw('one debit', 50001),
      throwsA(
        isA<LedgerException>().having(
          (error) => error.issue,
          'issue',
          LedgerIssue.duplicateConflict,
        ),
      ),
    );
    expect(
      await income('one receipt', 10000),
      await income('one receipt', 10000),
    );
    expect(
      await spend('uses all recorded cash', 60000),
      await spend('uses all recorded cash', 60000),
    );
    await expectLater(spend('another', 1), issue(CashIssue.insufficientCash));
    await expectLater(spend('zero', 0), issue(CashIssue.invalidAmount));
    await expectLater(income('negative', -2), issue(CashIssue.invalidAmount));
    expect((await ledger.balance(wallet)).minor, 0);
    expect((await ledger.balance(bank)).minor, -50000);
    expect(await ledger.entries(), hasLength(3));
  });

  test('correction reverses and replaces, preserves the original date and updates totals', () async {
    await openCash(100000);
    final oldWithdrawal = await withdraw('old withdrawal', 50000);
    final oldExpense = await spend(
      'old expense',
      10000,
      note: 'Synthetic purpose',
    );
    Future<int> correct(int id, int minor) => ledger.correctUsdCashAmount(
      reversalOperationId: 'reverse-$id',
      replacementOperationId: 'replace-$id',
      entryId: id,
      minor: minor,
    );
    final fixed = await correct(oldExpense, 8000);
    expect(await correct(oldExpense, 8000), fixed);
    await correct(oldWithdrawal, 55000);
    expect(await ledger.netExpenses('USD'), BigInt.from(8000));
    expect((await ledger.balance(bank)).minor, -55000);
    final jan = await ledger.usdCashOverview(january);
    expect(jan.minor, 147000);
    expect(jan.withdrawnMinor, BigInt.from(55000));
    expect(
      jan.movements
          .singleWhere((entry) => entry.entryId == oldExpense)
          .reversed,
      isTrue,
    );
    expect(
      jan.movements.singleWhere((entry) => entry.entryId == fixed).correctionOf,
      oldExpense,
    );
    expect(
      jan.movements.where((entry) => entry.kind == CashMovementKind.reversal),
      hasLength(2),
    );
    expect(
      (await ledger.usdCashOverview(february)).withdrawnMinor,
      BigInt.zero,
    );
  });

  test('confirmed settlement records the difference and rejects stale previews and late openings', () async {
    expect((await ledger.usdCashOverview(january)).balanceKnown, isFalse);
    Future<int> settle(String id, int before, int counted) =>
        ledger.confirmUsdCashBalance(
          operationId: id,
          priorMinor: before,
          countedMinor: counted,
          effectiveAt: january,
        );
    await expectLater(
      settle('wrong preview', 1, 500),
      issue(CashIssue.staleBalance),
    );
    final confirmed = await settle('count cash', 0, 90000);
    expect(await settle('count cash', 0, 90000), confirmed);
    await expectLater(openCash(20000), issue(CashIssue.openingAfterSettlement));
    await settle('short count', 90000, 85000);
    await settle('matches count', 85000, 85000);
    final view = await ledger.usdCashOverview(january);
    expect(view.minor, 85000);
    expect(view.balanceKnown, isTrue);
    expect(view.canRecordOpening, isFalse);
    expect(view.movements.map((entry) => entry.minor), [0, -5000, 90000]);
    expect(view.movements.last.priorMinor, 0);
    expect(view.movements.last.countedMinor, 90000);
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    expect(view.withdrawnMinor, BigInt.zero);
  });

  test('a failed adjustment record rolls back its balancing entry', () async {
    await db.customStatement(
      "CREATE TRIGGER reject_count BEFORE INSERT ON cash_reconciliations "
      "BEGIN SELECT RAISE(ABORT, 'fixture rejection'); END",
    );
    Future<int> save() => ledger.confirmUsdCashBalance(
      operationId: 'count',
      priorMinor: 0,
      countedMinor: 1000,
      effectiveAt: january,
    );
    await expectLater(save(), throwsA(isA<SqliteException>()));
    expect(await ledger.entries(), isEmpty);
    expect((await ledger.balance(wallet)).minor, 0);
    await db.customStatement('DROP TRIGGER reject_count');
    await save();
    expect((await ledger.balance(wallet)).minor, 1000);
  });

  test(
    'cash, threshold, settlement and history survive encrypted reopen',
    () async {
      await openCash(100000);
      await withdraw('bank withdrawal', 55000);
      await spend('cash purchase', 5000);
      await ledger.setUsdWithdrawalLimit(75000);
      await ledger.confirmUsdCashBalance(
        operationId: 'count',
        priorMinor: 150000,
        countedMinor: 148000,
        effectiveAt: january,
      );
      await db.close();
      await expectLater(open(20), throwsA(isA<StorageLocked>()));
      db = await open();
      ledger = Ledger(db);
      final view = await ledger.usdCashOverview(january);
      expect((view.minor, view.withdrawalLimitMinor), (148000, 75000));
      expect(view.withdrawnMinor, BigInt.from(55000));
      expect(view.movements, hasLength(4));
      expect(
        await file.openRead(0, 16).first,
        isNot('SQLite format 3\u0000'.codeUnits),
      );
    },
  );

  test('a v2 ledger with multiple USD cash accounts retains all data and requires wallet choice', () async {
    await openCash(20000);
    final receipt = await ledger.recordSalary(
      operationId: 'old salary',
      accountId: bank,
      minor: 200000,
      receivedOn: january,
    );
    await ledger.createSalaryPlan(receipt);
    await ledger.addSalaryAllocation(receipt, 'Old salary plan', 50000);
    await db.close();
    final key = List.filled(32, '13').join();
    final raw = sqlite3.open(file.path);
    try {
      unlockDatabase(raw, key);
      raw.execute('DROP TABLE remittance_family_payments');
      raw.execute('DROP TABLE remittance_purposes');
      raw.execute('DROP TABLE remittance_events');
      raw.execute('DROP TABLE remittances');
      raw.execute(
        "DELETE FROM ledger_accounts WHERE kind IN ('remittanceTransit', 'remittanceExchange')",
      );
      raw.execute('DROP TABLE expense_details');
      raw.execute('DROP TABLE cash_reconciliations');
      raw.execute('DROP TABLE cash_settings');
      raw.execute("DELETE FROM ledger_accounts WHERE kind = 'cashAdjustment'");
      raw.execute(
        "INSERT INTO ledger_accounts (name, currency, kind) VALUES ('Other older wallet', 'USD', 'cash')",
      );
      raw.execute('PRAGMA user_version = 2');
    } finally {
      raw.close();
    }
    db = await open();
    ledger = Ledger(db);
    final before = await ledger.usdCashOverview(january);
    expect(before.cashAccounts, hasLength(2));
    expect(before.account, isNull);
    await expectLater(
      withdraw('unselected', 1000),
      issue(CashIssue.walletRequired),
    );
    await ledger.setupUsdCash(existingAccountId: wallet);
    expect((await ledger.usdCashOverview(january)).minor, 20000);
    expect((await ledger.salaryPlan(receipt)).unallocated, 150000);
    final other = before.cashAccounts.singleWhere(
      (account) => account.id != wallet,
    );
    await expectLater(
      ledger.setupUsdCash(existingAccountId: other.id),
      issue(CashIssue.walletAlreadySelected),
    );
    expect(File('${file.path}.v2.backup').existsSync(), isTrue);
  });
}
