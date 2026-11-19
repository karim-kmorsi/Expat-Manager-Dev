import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';

const failureFixtureKey = 78;
final fixtureDay = DateTime.utc(2026, 10, 6);
final laterDay = DateTime.utc(2026, 10, 7);

enum FinancialWrite {
  salary,
  transfer,
  expense,
  remittanceDebit,
  remittanceReceipt,
  correction,
  reconciliation,
}

Future<LedgerDatabase> openFailureFixture(String path) => LedgerDatabase.open(
  File(path),
  Uint8List.fromList(List.filled(32, failureFixtureKey)),
);

Future<int> financialWrite(
  Ledger ledger,
  FinancialWrite write,
  Map<String, int> ids,
) {
  final key = 'interruption-${write.name}';
  final bank = ids['bank']!;
  final remittance = ids['remittance']!;
  final expense = (
    accountId: bank,
    minor: 1000,
    date: laterDay,
    period: ExpensePeriod.individual,
    category: ExpenseCategory.other,
    note: 'Synthetic test purchase',
  );
  return switch (write) {
    FinancialWrite.salary => ledger.recordSalary(
      operationId: key,
      accountId: bank,
      minor: 200000,
      receivedOn: fixtureDay,
      reference: 'Synthetic payroll reference',
    ),
    FinancialWrite.transfer => ledger.transfer(
      operationId: key,
      from: bank,
      to: ids['wallet']!,
      minor: 30000,
      effectiveAt: laterDay,
    ),
    FinancialWrite.expense => ledger.recordExpense(
      operationId: key,
      input: expense,
    ),
    FinancialWrite.remittanceDebit ||
    FinancialWrite.remittanceReceipt => ledger.recordRemittanceEvent(
      remittanceId: remittance,
      operationId: key,
      kind: write == FinancialWrite.remittanceDebit
          ? RemittanceEventKind.debit
          : RemittanceEventKind.receipt,
      minor: 5000,
      sourceMinor: write == FinancialWrite.remittanceReceipt ? 10000 : null,
      evidence: 'Synthetic ${write.name} reference',
      effectiveAt: laterDay,
    ),
    FinancialWrite.correction => ledger.correctExpense(
      entryId: ids['expense']!,
      input: expense,
      reversalOperationId: 'interruption-reversal',
      replacementOperationId: key,
    ),
    FinancialWrite.reconciliation => ledger.confirmAccountBalance(
      accountId: bank,
      operationId: key,
      priorMinor: 100000,
      countedMinor: 98000,
      effectiveAt: laterDay,
    ),
  };
}

// Run in a separate Dart process so the parent can kill the real SQLite writer
// without allowing Drift to roll back or close its connection gracefully.
Future<void> main(List<String> args) async {
  final db = await openFailureFixture(args[0]);
  final write = FinancialWrite.values.byName(args[1]);
  final ids = Map<String, int>.from(jsonDecode(args[2]) as Map);
  Future<void> stageWrite() async {
    await financialWrite(Ledger(db), write, ids);
  }

  Future<void> waitForKill() async {
    stdout.writeln('FINANCIAL_WRITE_READY');
    await stdout.flush();
    await stdin.drain<void>();
    throw StateError('Writer did not receive SIGKILL');
  }

  if (args[3] == 'committed') {
    await stageWrite();
    await waitForKill();
  } else {
    await db.transaction(() async {
      await stageWrite();
      await waitForKill();
    });
  }
}
