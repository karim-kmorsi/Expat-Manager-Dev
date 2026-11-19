import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  final first = DateTime(2026, 2, 2, 10);
  late Directory folder;
  late File file;
  late LedgerDatabase db;
  late Ledger ledger;
  late int cash;
  late int bank;
  late int usd;

  Future<LedgerDatabase> open([int key = 28]) =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, key)));

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('expat-expenses-');
    file = File('${folder.path}/ledger.sqlite');
    db = await open();
    ledger = Ledger(db);
    cash = await ledger.createAccount(
      name: 'Synthetic NPR cash',
      currency: 'NPR',
      kind: AccountKind.cash,
    );
    bank = await ledger.createAccount(
      name: 'Synthetic NPR bank',
      currency: 'NPR',
      kind: AccountKind.bank,
    );
    usd = await ledger.setupUsdCash();
    await ledger.recordOpening(
      operationId: 'usd-start',
      accountId: usd,
      minor: 100000,
      effectiveAt: first,
    );
  });

  tearDown(() async {
    await db.close();
    await folder.delete(recursive: true);
  });

  ExpenseInput input(
    int account,
    int amount, {
    ExpensePeriod period = ExpensePeriod.individual,
    DateTime? date,
    ExpenseCategory? category,
    String? note,
  }) => (
    accountId: account,
    minor: amount,
    date: date ?? first,
    period: period,
    category: category,
    note: note,
  );

  Future<int> save(
    String id,
    ExpenseInput form, [
    Set<int> acknowledged = const {},
  ]) => ledger.recordExpense(
    operationId: id,
    input: form,
    acknowledged: acknowledged,
  );

  Matcher overlap(bool known, Set<int> ids) => throwsA(
    isA<ExpenseOverlap>()
        .having((error) => error.known, 'known', known)
        .having((error) => error.entryIds, 'matching entries', ids),
  );

  test('posts individual and grouped expenses in the selected currency and account', () async {
    final payment = input(
      cash,
      1250,
      category: ExpenseCategory.food,
      note: '  Fixture lunch  ',
    );
    final individual = await save('individual', payment);
    final day = await save(
      'day',
      input(bank, 4200, period: ExpensePeriod.day, date: DateTime(2026, 2, 3)),
    );
    final week = await save(
      'week',
      input(bank, 6500, period: ExpensePeriod.week, date: DateTime(2026, 2, 4)),
    );
    expect((await ledger.balance(cash)).minor, -1250);
    expect((await ledger.balance(bank)).minor, -10700);
    expect(await ledger.netExpenses('NPR'), BigInt.from(11950));
    expect(await ledger.netExpenses('USD'), BigInt.zero);
    final items = await ledger.recentExpenses();
    expect(items.map((item) => item.id), [week, day, individual]);
    expect(items.last.input.category, ExpenseCategory.food);
    expect(items.last.input.note, 'Fixture lunch');
    expect(items.first.input.period, ExpensePeriod.week);
    expect(items.every((item) => item.currency == 'NPR'), isTrue);
    await ledger.transfer(
      operationId: 'internal',
      from: bank,
      to: cash,
      minor: 80,
      effectiveAt: first,
    );
    expect(await ledger.recentExpenses(), hasLength(3));
    expect(await ledger.netExpenses('NPR'), BigInt.from(11950));
  });

  test(
    'blocks whole-period intersections on the same account in either direction',
    () async {
      final week = await save(
        'week',
        input(cash, 8000, period: ExpensePeriod.week),
      );
      final sixth = DateTime(2026, 2, 8, 23);
      await expectLater(
        save('included', input(cash, 12, date: sixth), {week}),
        overlap(true, {week}),
      );
      await expectLater(
        save(
          'overlapping week',
          input(cash, 999, date: sixth, period: ExpensePeriod.week),
        ),
        overlap(true, {week}),
      );
      await save('next day', input(cash, 10, date: DateTime(2026, 2, 9)));
      await ledger.cancelExpense(
        entryId: week,
        operationId: 'cancel-week',
        effectiveAt: sixth,
      );
      final individual = await save(
        'now separated',
        input(cash, 20, date: sixth),
      );
      await expectLater(
        save(
          'overlaps individual',
          input(cash, 80, date: sixth, period: ExpensePeriod.day),
        ),
        overlap(true, {individual}),
      );
      expect((await ledger.balance(cash)).minor, -30);
    },
  );

  test(
    'warnings are explicit and acknowledge only the reviewed entries',
    () async {
      final a = await save('one', input(bank, 500));
      await expectLater(
        save('distinct', input(bank, 500)),
        overlap(false, {a}),
      );
      final b = await save('distinct', input(bank, 500), {a});
      await expectLater(
        save('third', input(cash, 500), {a}),
        overlap(false, {b}),
      );
      await expectLater(
        save(
          'group different account',
          input(cash, 2340, period: ExpensePeriod.day),
        ),
        overlap(false, {a, b}),
      );
      await save(
        'group different account',
        input(cash, 2340, period: ExpensePeriod.day),
        {a, b},
      );
      await save('usd unrelated', input(usd, 500));
      expect(await ledger.recentExpenses(), hasLength(4));
    },
  );

  test(
    'T-010 and T-012 share one cash expense and one overlap guard',
    () async {
      final id = await ledger.useUsdCash(
        operationId: 'one ticket',
        minor: 100,
        effectiveAt: first,
      );
      expect(await save('one ticket', input(usd, 100)), id);
      await expectLater(
        save('different request', input(usd, 100)),
        overlap(false, {id}),
      );
      await expectLater(
        save('whole day', input(usd, 300, period: ExpensePeriod.day), {id}),
        overlap(true, {id}),
      );
      final next = DateTime(2026, 2, 3);
      final day = await save(
        'day',
        input(usd, 300, period: ExpensePeriod.day, date: next),
      );
      await expectLater(
        ledger.useUsdCash(
          operationId: 'already in total',
          minor: 12,
          effectiveAt: next,
        ),
        overlap(true, {day}),
      );
      expect((await ledger.balance(usd)).minor, 99600);
      expect(await ledger.netExpenses('USD'), BigInt.from(400));
      await ledger.correctUsdCashAmount(
        reversalOperationId: 'reverse day',
        replacementOperationId: 'correct day',
        entryId: day,
        minor: 200,
      );
      final items = await ledger.recentExpenses();
      expect(
        items.singleWhere((row) => row.correctionOf == day).input.period,
        ExpensePeriod.day,
      );
      expect((await ledger.balance(usd)).minor, 99700);
    },
  );

  test(
    'retries one posting and corrects or cancels without removing originals',
    () async {
      final form = input(bank, 300);
      final ids = await Future.wait([
        save('one operation', form),
        save('one operation', form),
      ]);
      expect(ids.first, ids.last);
      await expectLater(
        save('one operation', input(bank, 300, category: ExpenseCategory.food)),
        throwsA(
          isA<LedgerException>().having(
            (error) => error.issue,
            'issue',
            LedgerIssue.duplicateConflict,
          ),
        ),
      );
      Future<int> correct(ExpenseInput replacement) => ledger.correctExpense(
        entryId: ids.first,
        input: replacement,
        reversalOperationId: 'reverse',
        replacementOperationId: 'replacement',
      );
      await expectLater(
        correct(input(usd, 250)),
        throwsA(
          isA<LedgerException>().having(
            (error) => error.issue,
            'issue',
            LedgerIssue.currencyMismatch,
          ),
        ),
      );
      final replacement = await correct(
        input(cash, 250, category: ExpenseCategory.bills),
      );
      expect(
        await correct(input(cash, 250, category: ExpenseCategory.bills)),
        replacement,
      );
      expect((await ledger.balance(bank)).minor, 0);
      expect((await ledger.balance(cash)).minor, -250);
      expect(await ledger.netExpenses('NPR'), BigInt.from(250));
      expect(
        (await ledger.recentExpenses())
            .singleWhere((item) => item.id == ids.first)
            .reversed,
        isTrue,
      );
      await ledger.cancelExpense(
        entryId: replacement,
        operationId: 'cancel',
        effectiveAt: first,
      );
      await ledger.cancelExpense(
        entryId: replacement,
        operationId: 'cancel',
        effectiveAt: first,
      );
      expect((await ledger.balance(cash)).minor, 0);
      expect(await ledger.netExpenses('NPR'), BigInt.zero);
      expect(await ledger.recentExpenses(), hasLength(2));
    },
  );

  test(
    'reconciles real cash and bank balances without creating an expense',
    () async {
      await save('recorded', input(bank, 250));
      await expectLater(
        ledger.confirmAccountBalance(
          accountId: bank,
          operationId: 'stale',
          priorMinor: 0,
          countedMinor: -400,
          effectiveAt: first,
        ),
        throwsA(
          isA<CashException>().having(
            (error) => error.issue,
            'issue',
            CashIssue.staleBalance,
          ),
        ),
      );
      final adjustment = await ledger.confirmAccountBalance(
        accountId: bank,
        operationId: 'bank observed',
        priorMinor: -250,
        countedMinor: -400,
        effectiveAt: first,
      );
      expect(
        await ledger.confirmAccountBalance(
          accountId: bank,
          operationId: 'bank observed',
          priorMinor: -250,
          countedMinor: -400,
          effectiveAt: first,
        ),
        adjustment,
      );
      await ledger.confirmAccountBalance(
        accountId: cash,
        operationId: 'cash count',
        priorMinor: 0,
        countedMinor: 2000,
        effectiveAt: first,
      );
      expect((await ledger.balance(bank)).minor, -400);
      expect((await ledger.balance(cash)).minor, 2000);
      expect(
        (await ledger.expenseAccounts())
            .where((row) => row.account.id == bank || row.account.id == cash)
            .every((row) => row.balanceKnown),
        isTrue,
      );
      expect(await ledger.netExpenses('NPR'), BigInt.from(250));
      expect(await ledger.recentExpenses(), hasLength(1));
    },
  );

  test('a posted bank expense is eligible for salary execution without a second debit', () async {
    final salary = await ledger.recordSalary(
      operationId: 'pay',
      accountId: bank,
      minor: 10000,
      receivedOn: first,
    );
    await ledger.createSalaryPlan(salary);
    final line = await ledger.addSalaryAllocation(
      salary,
      'Synthetic living costs',
      500,
    );
    final payment = await save('actual payment', input(bank, 300));
    expect(
      (await ledger.salaryCandidates(line)).single.movement.entry.id,
      payment,
    );
    await ledger.linkSalaryExecution(
      allocationId: line,
      entryId: payment,
      minor: 300,
    );
    expect((await ledger.salaryPlan(salary)).executed, 300);
    expect((await ledger.balance(bank)).minor, 9700);
    await ledger.cancelExpense(
      entryId: payment,
      operationId: 'void payment',
      effectiveAt: first,
    );
    final plan = await ledger.salaryPlan(salary);
    expect(plan.executed, 0);
    expect(plan.allocations.single.executions.single.reversed, isTrue);
    expect((await ledger.balance(bank)).minor, 10000);
  });

  test('failed expense metadata and failed grouped correction roll back every posting', () async {
    final original = await save('existing', input(bank, 100));
    final group = await save(
      'group',
      input(cash, 1000, period: ExpensePeriod.day, date: DateTime(2026, 2, 3)),
    );
    await expectLater(
      ledger.correctExpense(
        entryId: original,
        input: input(cash, 23, date: DateTime(2026, 2, 3)),
        reversalOperationId: 'r',
        replacementOperationId: 'p',
      ),
      overlap(true, {group}),
    );
    expect((await ledger.balance(bank)).minor, -100);
    expect(
      (await ledger.recentExpenses())
          .singleWhere((row) => row.id == original)
          .reversed,
      isFalse,
    );
    await db.customStatement(
      "CREATE TRIGGER reject_expense BEFORE INSERT ON expense_details "
      "BEGIN SELECT RAISE(ABORT, 'fixture'); END",
    );
    await expectLater(
      save('failed', input(bank, 2)),
      throwsA(isA<SqliteException>()),
    );
    expect((await ledger.balance(bank)).minor, -100);
    expect(await ledger.netExpenses('NPR'), BigInt.from(1100));
  });

  test(
    'migrates v3 cash expenses and adjustments and reopens an encrypted ledger',
    () async {
      final cashExpense = await ledger.useUsdCash(
        operationId: 'legacy cash use',
        minor: 700,
        effectiveAt: first,
      );
      await ledger.confirmUsdCashBalance(
        operationId: 'legacy cash count',
        priorMinor: 99300,
        countedMinor: 99000,
        effectiveAt: first,
      );
      await db.close();

      final key = List.filled(32, '1c').join();
      final raw = sqlite3.open(file.path);
      try {
        unlockDatabase(raw, key);
        raw.execute('DROP TABLE expense_details');
        raw.execute(
          "DELETE FROM ledger_accounts WHERE kind = 'cashAdjustment' AND currency <> 'USD'",
        );
        raw.execute('PRAGMA user_version = 3');
      } finally {
        raw.close();
      }

      await expectLater(open(29), throwsA(isA<StorageLocked>()));
      db = await open();
      ledger = Ledger(db);
      expect((await ledger.recentExpenses()).single.id, cashExpense);
      expect((await ledger.usdCashOverview(first)).minor, 99000);
      expect(File('${file.path}.v3.backup').existsSync(), isTrue);
      expect(
        await file.openRead(0, 16).first,
        isNot('SQLite format 3\u0000'.codeUnits),
      );
      await ledger.confirmAccountBalance(
        accountId: bank,
        operationId: 'new count',
        priorMinor: 0,
        countedMinor: -900,
        effectiveAt: first,
      );
      await db.close();
      db = await open();
      ledger = Ledger(db);
      expect((await ledger.balance(bank)).minor, -900);
      expect(await ledger.netExpenses('NPR'), BigInt.zero);
      expect((await ledger.recentExpenses()).single.id, cashExpense);
    },
  );
}
