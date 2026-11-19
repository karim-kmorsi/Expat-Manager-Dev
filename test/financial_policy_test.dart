import 'dart:io';

import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/financial_interruption_worker.dart' show openFailureFixture;

void main() {
  final day = DateTime.utc(2026, 11, 1);
  final statement = DateTime.utc(2026, 11, 10);
  final next = DateTime.utc(2026, 11, 11);

  Matcher rejected(LedgerIssue issue) => throwsA(
    isA<LedgerException>().having((error) => error.issue, 'issue', issue),
  );

  test('protects matched accounts on both sides of an expense or transfer correction', () async {
    final folder = await Directory.systemTemp.createTemp('t011-policy-');
    final db = await openFailureFixture('${folder.path}/ledger.sqlite');
    addTearDown(() async {
      await db.close();
      await folder.delete(recursive: true);
    });
    final ledger = Ledger(db);
    Future<int> bank(String name) => ledger.createAccount(
      name: name,
      currency: 'USD',
      kind: AccountKind.bank,
    );
    final matched = await bank('Matched fixture');
    final unmatched = await bank('Unmatched fixture');
    final cash = await ledger.setupUsdCash();
    final withdrawal = await ledger.withdrawUsdCash(
      operationId: 'withdrawal',
      bankId: matched,
      minor: 10000,
      effectiveAt: day,
    );
    ExpenseInput expense(int account, int minor, DateTime at) => (
      accountId: account,
      minor: minor,
      date: at,
      period: ExpensePeriod.individual,
      category: null,
      note: null,
    );
    final old = await ledger.recordExpense(
      operationId: 'closed-expense',
      input: expense(matched, 3000, day),
    );
    final other = await ledger.recordExpense(
      operationId: 'old-other-expense',
      input: expense(unmatched, 4000, day),
    );
    final reconciliation = await ledger.confirmAccountBalance(
      accountId: matched,
      operationId: 'statement',
      priorMinor: -13000,
      countedMinor: -13500,
      effectiveAt: statement,
    );
    final recorded = await ledger.entries();
    final allowed = rejected(LedgerIssue.reconciledPeriod);
    await expectLater(
      ledger.cancelExpense(
        entryId: old,
        operationId: 'cancel',
        effectiveAt: next,
      ),
      allowed,
    );
    await expectLater(
      ledger.correctExpense(
        entryId: old,
        input: expense(unmatched, 3100, next),
        reversalOperationId: 'old-reverse',
        replacementOperationId: 'old-replace',
      ),
      allowed,
    );
    // The origin is open, but the replacement would backdate the adjustment
    // into a different account that was already reconciled.
    await expectLater(
      ledger.correctExpense(
        entryId: other,
        input: expense(matched, 4600, day),
        reversalOperationId: 'other-reverse',
        replacementOperationId: 'other-replace',
      ),
      allowed,
    );
    await expectLater(
      ledger.correctUsdCashAmount(
        entryId: withdrawal,
        minor: 9500,
        reversalOperationId: 'withdrawal-reverse',
        replacementOperationId: 'withdrawal-replace',
      ),
      allowed,
    );
    await expectLater(
      ledger.reverse(
        entryId: reconciliation,
        operationId: 'reverse-statement',
        effectiveAt: next,
        reason: 'Synthetic reversal',
      ),
      rejected(LedgerIssue.reversalNotAllowed),
    );
    expect(await ledger.entries(), recorded);
    expect((await ledger.balance(matched)).minor, -13500);
    expect((await ledger.balance(unmatched)).minor, -4000);
    expect((await ledger.balance(cash)).minor, 10000);
    expect(await ledger.netExpenses('USD'), BigInt.from(7000));

    final after = await ledger.recordExpense(
      operationId: 'open-expense',
      input: expense(matched, 1000, next),
    );
    Future<int> correctAfter() => ledger.correctExpense(
      entryId: after,
      input: expense(matched, 1500, next),
      reversalOperationId: 'open-reverse',
      replacementOperationId: 'open-replace',
    );
    final replacement = await correctAfter();
    expect((await ledger.balance(matched)).minor, -15000);
    await ledger.confirmAccountBalance(
      accountId: matched,
      operationId: 'newer-statement',
      priorMinor: -15000,
      countedMinor: -15000,
      effectiveAt: next,
    );
    expect(await correctAfter(), replacement);
    expect((await ledger.balance(matched)).minor, -15000);
  });
}
