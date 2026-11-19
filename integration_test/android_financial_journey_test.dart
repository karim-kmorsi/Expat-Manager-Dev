import 'package:expat_manager/data/android_storage.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'offline salary-to-reconciliation journey survives encrypted reopen',
    (tester) async {
      var db = await openAndroidLedger();
      addTearDown(() async => db.close());
      var ledger = Ledger(db);
      final unique = DateTime.now().microsecondsSinceEpoch;
      String key(String name) => 't011-$unique-$name';
      String canary(String name) => 'T011PRIVATE_${name}_$unique';
      final date = DateTime.utc(2026, 10, 5);
      final second = DateTime.utc(2026, 10, 6);
      final third = DateTime.utc(2026, 10, 8);
      final fourth = DateTime.utc(2026, 10, 9);
      final fifth = DateTime.utc(2026, 10, 10);
      final bank = await ledger.createAccount(
        name: canary('USD_ACCOUNT'),
        currency: 'USD',
        kind: AccountKind.bank,
      );
      final living = await ledger.createAccount(
        name: canary('NPR_ACCOUNT'),
        currency: 'NPR',
        kind: AccountKind.bank,
      );
      final egypt = await ledger.createAccount(
        name: canary('EGP_ACCOUNT'),
        currency: 'EGP',
        kind: AccountKind.bank,
      );
      final cash = await ledger.setupUsdCash();
      final initialCash = (await ledger.balance(cash)).minor;
      final expensesBefore = {
        for (final currency in ['USD', 'NPR', 'EGP'])
          currency: await ledger.netExpenses(currency),
      };

      Future<void> reopen() async {
        await db.close();
        db = await openAndroidLedger();
        ledger = Ledger(db);
      }

      Future<void> expectBalances(
        int source,
        int walletDelta,
        int npr,
        int egp,
      ) async {
        expect((await ledger.balance(bank)).minor, source);
        expect((await ledger.balance(cash)).minor, initialCash + walletDelta);
        expect((await ledger.balance(living)).minor, npr);
        expect((await ledger.balance(egypt)).minor, egp);
      }

      Future<void> expectExpenses(int usd, int npr, int egp) async {
        for (final (currency, amount) in [
          ('USD', usd),
          ('NPR', npr),
          ('EGP', egp),
        ]) {
          expect(
            await ledger.netExpenses(currency),
            expensesBefore[currency]! + BigInt.from(amount),
          );
        }
      }

      await ledger.recordOpening(
        operationId: key('opening-NPR'),
        accountId: living,
        minor: 100000,
        effectiveAt: date,
      );
      Future<int> salary([String name = 'salary']) => ledger.recordSalary(
        operationId: key(name),
        accountId: bank,
        minor: 200000,
        receivedOn: date,
        reference: canary('SALARY_REF'),
      );
      final pay = await salary();
      expect(await salary(), pay);
      await expectLater(
        salary('duplicate'),
        throwsA(
          isA<SalaryException>().having(
            (error) => error.issue,
            'issue',
            SalaryIssue.duplicateReceipt,
          ),
        ),
      );
      await ledger.createSalaryPlan(pay);
      final familyPlan = await ledger.addSalaryAllocation(
        pay,
        'دعم الأسرة',
        50000,
      );
      final personalPlan = await ledger.addSalaryAllocation(
        pay,
        'حساب مصر',
        40000,
      );
      final cashPlan = await ledger.addSalaryAllocation(pay, 'سحب نقدي', 30000);
      await ledger.addSalaryAllocation(pay, 'المعيشة في نيبال', 60000);
      expect((await ledger.salaryPlan(pay)).unallocated, 20000);
      expect((await ledger.salaryPlan(pay)).executed, 0);
      await expectBalances(200000, 0, 100000, 0);
      await expectExpenses(0, 0, 0);

      Future<int> withdraw() => ledger.withdrawUsdCash(
        operationId: key('withdraw'),
        bankId: bank,
        minor: 30000,
        effectiveAt: second,
      );
      final withdrawal = await withdraw();
      expect(await withdraw(), withdrawal);
      await ledger.linkSalaryExecution(
        allocationId: cashPlan,
        entryId: withdrawal,
        minor: 30000,
      );
      await ledger.confirmSalaryMovement(
        withdrawal,
        canary('CASH_CONFIRMATION'),
      );
      await expectBalances(170000, 30000, 100000, 0);
      await expectExpenses(0, 0, 0);

      Future<int> cashExpense() => ledger.useUsdCash(
        operationId: key('cash-purchase'),
        minor: 4000,
        effectiveAt: second,
        note: canary('CASH_NOTE'),
      );
      final cashPurchase = await cashExpense();
      expect(await cashExpense(), cashPurchase);
      final cashInput = (
        accountId: cash,
        minor: 4000,
        date: second,
        period: ExpensePeriod.individual,
        category: null,
        note: canary('CASH_NOTE'),
      );
      // The same purchase submitted through the other cash entry point.
      expect(
        await ledger.recordExpense(
          operationId: key('cash-purchase'),
          input: cashInput,
        ),
        cashPurchase,
      );
      await expectExpenses(4000, 0, 0);

      final singleInput = (
        accountId: living,
        minor: 10000,
        date: second,
        period: ExpensePeriod.individual,
        category: ExpenseCategory.food,
        note: canary('BANK_NOTE'),
      );
      final single = await ledger.recordExpense(
        operationId: key('single'),
        input: singleInput,
      );
      final dailyInput = (
        accountId: living,
        minor: 13000,
        date: third,
        period: ExpensePeriod.day,
        category: null,
        note: canary('GROUPED_NOTE'),
      );
      final daily = await ledger.recordExpense(
        operationId: key('daily'),
        input: dailyInput,
      );
      expect(
        await ledger.recordExpense(
          operationId: key('daily'),
          input: dailyInput,
        ),
        daily,
      );
      await expectBalances(170000, 26000, 77000, 0);
      await expectExpenses(4000, 23000, 0);

      final own = await ledger.planRemittance(
        operationId: key('personal-remittance'),
        sourceAccountId: bank,
        destinationAccountId: egypt,
        destinationCurrency: 'EGP',
        destination: RemittanceDestination.personal,
      );
      expect((await ledger.remittance(own)).status, RemittanceStatus.planned);
      await expectBalances(170000, 26000, 77000, 0);
      Future<int> movement(
        int id,
        RemittanceEventKind kind,
        String name,
        int minor, {
        int? source,
        DateTime? on,
        String? evidence,
        int? receipt,
      }) => ledger.recordRemittanceEvent(
        remittanceId: id,
        operationId: key(name),
        kind: kind,
        minor: minor,
        evidence: evidence ?? canary(name),
        effectiveAt: on ?? third,
        sourceMinor: source,
        receiptEntryId: receipt,
      );
      final debit = await movement(
        own,
        RemittanceEventKind.debit,
        'debit',
        40000,
      );
      await ledger.linkSalaryExecution(
        allocationId: personalPlan,
        entryId: debit,
        minor: 40000,
      );
      await ledger.updateRemittanceStatus(own, cancel: false);
      await reopen();
      expect((await ledger.remittance(own)).status, RemittanceStatus.pending);
      expect((await ledger.remittance(own)).outstanding, 40000);
      expect((await ledger.remittance(own)).debit!.event.feeMinor, isNull);
      expect(
        await movement(own, RemittanceEventKind.debit, 'debit', 40000),
        debit,
      );
      await expectBalances(130000, 26000, 77000, 0);
      await expectExpenses(4000, 23000, 0);
      await expectLater(
        movement(
          own,
          RemittanceEventKind.receipt,
          'empty-evidence',
          200000,
          evidence: ' ',
        ),
        throwsA(isA<RemittanceException>()),
      );
      final partial = await movement(
        own,
        RemittanceEventKind.receipt,
        'received-part',
        200000,
        on: fourth,
      );
      final pending = await ledger.remittance(own);
      expect(pending.needsSourceProof(pending.active.last), isTrue);
      expect(pending.status, RemittanceStatus.pending);
      expect(pending.outstanding, 40000);
      expect(pending.received, 200000);
      await movement(
        own,
        RemittanceEventKind.receipt,
        'received-final',
        400000,
        source: 25000,
        on: fifth,
      );
      expect((await ledger.remittance(own)).status, RemittanceStatus.pending);
      await movement(
        own,
        RemittanceEventKind.sourceProof,
        'source-proof',
        15000,
        receipt: partial,
        on: fifth,
      );
      await ledger.addRemittancePurpose(
        own,
        key('earmark-support'),
        'مخصّص دعم',
        100000,
        family: true,
      );
      await ledger.addRemittancePurpose(
        own,
        key('earmark-savings'),
        'مخصّص ادخار',
        400000,
      );
      expect((await ledger.remittance(own)).unallocated, 100000);
      await expectExpenses(4000, 23000, 0);

      final direct = await ledger.planRemittance(
        operationId: key('family-remittance'),
        sourceAccountId: bank,
        destinationCurrency: 'EGP',
        beneficiary: canary('BENEFICIARY'),
        destination: RemittanceDestination.family,
      );
      final familyDebit = await movement(
        direct,
        RemittanceEventKind.debit,
        'family-debit',
        50000,
      );
      await ledger.linkSalaryExecution(
        allocationId: familyPlan,
        entryId: familyDebit,
        minor: 50000,
      );
      await expectExpenses(4000, 23000, 0);
      await movement(
        direct,
        RemittanceEventKind.receipt,
        'family-received',
        750000,
        source: 50000,
        on: fourth,
      );

      Future<int> correct() => ledger.correctExpense(
        entryId: single,
        input: (
          accountId: living,
          minor: 8000,
          date: second,
          period: ExpensePeriod.individual,
          category: ExpenseCategory.food,
          note: canary('CORRECTED_NOTE'),
        ),
        reversalOperationId: key('reverse'),
        replacementOperationId: key('replacement'),
      );
      final replacement = await correct();
      expect(await correct(), replacement);
      expect((await ledger.salaryMovement(single)).reversed, isTrue);
      expect(
        (await ledger.salaryMovement(replacement)).entry.correctionOf,
        single,
      );
      await expectBalances(80000, 26000, 79000, 600000);
      await expectExpenses(4000, 21000, 750000);

      Future<int> reconcile() => ledger.confirmAccountBalance(
        accountId: living,
        operationId: key('difference'),
        priorMinor: 79000,
        countedMinor: 78500,
        effectiveAt: fifth,
      );
      final adjustment = await reconcile();
      expect(await reconcile(), adjustment);
      final adjustmentLines = (await ledger.salaryMovement(adjustment)).lines;
      expect(
        adjustmentLines.map((line) => line.kind),
        unorderedEquals([AccountKind.bank, AccountKind.cashAdjustment]),
      );
      expect((await ledger.balance(egypt)).openingKnown, isFalse);
      await ledger.confirmAccountBalance(
        accountId: egypt,
        operationId: key('first-EGP-count'),
        priorMinor: 600000,
        countedMinor: 600000,
        effectiveAt: fifth,
      );
      expect(
        (await ledger.expenseAccounts())
            .singleWhere((row) => row.account.id == egypt)
            .balanceKnown,
        isTrue,
      );

      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      final home = find.text('Expat Manager');
      expect(home, findsOneWidget);
      expect(Directionality.of(tester.element(home)), TextDirection.rtl);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();

      await reopen();
      await expectBalances(80000, 26000, 78500, 600000);
      await expectExpenses(4000, 21000, 750000);
      final plan = await ledger.salaryPlan(pay);
      expect(
        (plan.planned, plan.executed, plan.confirmed, plan.unallocated),
        (180000, 120000, 30000, 20000),
      );
      expect((await ledger.remittance(own)).status, RemittanceStatus.received);
      expect(
        (await ledger.remittance(direct)).status,
        RemittanceStatus.received,
      );
      expect(
        await movement(
          own,
          RemittanceEventKind.receipt,
          'received-part',
          200000,
          on: fourth,
        ),
        partial,
      );
      final entries = (await ledger.entries()).where(
        (entry) => entry.operationId.startsWith('t011-$unique-'),
      );
      expect(
        entries.where((entry) => entry.kind == JournalKind.salary),
        hasLength(1),
      );
      expect(
        entries.where((entry) => entry.kind == JournalKind.internalTransfer),
        hasLength(1),
      );
      expect(
        entries.where((entry) => entry.kind == JournalKind.remittanceDebit),
        hasLength(2),
      );
      for (final entry in entries) {
        final byCurrency = <String, BigInt>{};
        for (final line in (await ledger.salaryMovement(entry.id)).lines) {
          byCurrency.update(
            line.currency,
            (sum) => sum + BigInt.from(line.minor),
            ifAbsent: () => BigInt.from(line.minor),
          );
        }
        expect(
          byCurrency.values,
          everyElement(BigInt.zero),
          reason: 'Entry ${entry.id}',
        );
      }
    },
  );
}
