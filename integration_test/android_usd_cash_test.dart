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
    'RTL cash controls, warning, confirmed settlement and encrypted reopen',
    (tester) async {
      final db = await openAndroidLedger();
      var firstOpen = true;
      addTearDown(() async {
        if (firstOpen) await db.close();
      });
      final ledger = Ledger(db);
      final now = DateTime.now();
      final fixture = 'cash-fixture-${now.microsecondsSinceEpoch}';
      final existing = await ledger.usdCashOverview(now);
      final wallet = await ledger.setupUsdCash(
        existingAccountId:
            existing.account?.id ?? existing.cashAccounts.firstOrNull?.id,
      );
      final start = await ledger.usdCashOverview(now);
      if (start.canRecordOpening) {
        await ledger.recordOpening(
          operationId: '$fixture-opening',
          accountId: wallet,
          minor: 100000 - start.minor,
          effectiveAt: now,
        );
      } else {
        await ledger.confirmUsdCashBalance(
          operationId: '$fixture-initial-count',
          priorMinor: start.minor,
          countedMinor: 100000,
          effectiveAt: now,
        );
      }
      final name = 'بنك نقد اختباري ${now.microsecondsSinceEpoch}';
      final bank = await ledger.createAccount(
        name: name,
        currency: 'USD',
        kind: AccountKind.bank,
      );
      await ledger.recordOpening(
        operationId: '$fixture-bank-opening',
        accountId: bank,
        minor: 250000,
        effectiveAt: now,
      );
      final expensesBefore = await ledger.netExpenses('USD');
      final priorWithdrawn = (await ledger.usdCashOverview(now)).withdrawnMinor;
      await ledger.setUsdWithdrawalLimit(priorWithdrawn.toInt() + 50000);

      Future<void> tap(String label) async {
        final item = find.text(label).first;
        await tester.ensureVisible(item);
        await tester.tap(item);
        await tester.pumpAndSettle();
      }

      Future<void> enter(String amount) async {
        await tester.enterText(find.byType(TextFormField).first, amount);
      }

      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await tap('النقد');
      expect(
        Directionality.of(tester.element(find.text('النقد'))),
        TextDirection.rtl,
      );
      final balanceRow = find
          .ancestor(of: find.text('الرصيد النقدي'), matching: find.byType(Row))
          .first;
      expect(
        find.descendant(of: balanceRow, matching: find.text('1000.00 USD')),
        findsOneWidget,
      );
      expect(find.text('هدف الادخار الشخصي الشهري (اختياري)'), findsOneWidget);

      Future<void> addBankCash(String amount) async {
        await tap('إضافة نقد');
        await tester.tap(find.byType(DropdownButton<int>));
        await tester.pumpAndSettle();
        final option = find.text('سحب من البنك · $name').last;
        await tester.ensureVisible(option);
        await tester.tap(option);
        await tester.pumpAndSettle();
        await enter(amount);
        await tap('حفظ');
      }

      await addBankCash('500');
      expect((await ledger.balance(wallet)).minor, 150000);
      expect((await ledger.balance(bank)).minor, 200000);
      expect(await ledger.netExpenses('USD'), expensesBefore);
      const warning = 'تحذير: تجاوزت السحوبات البنكية حد هذا الشهر.';
      expect(find.text(warning), findsNothing);

      await tap('استخدام نقد');
      await enter('100');
      await tap('حفظ');
      expect((await ledger.balance(wallet)).minor, 140000);
      expect(
        await ledger.netExpenses('USD'),
        expensesBefore + BigInt.from(10000),
      );

      await addBankCash('50');
      expect(find.text(warning), findsOneWidget);
      await tap('تسوية الرصيد');
      await enter('1440');
      await tap('مراجعة التسوية');
      expect((await ledger.balance(wallet)).minor, 145000);
      await tap('تأكيد التسوية');
      expect((await ledger.balance(wallet)).minor, 144000);
      expect(
        await ledger.netExpenses('USD'),
        expensesBefore + BigInt.from(10000),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      firstOpen = false;
      final reopened = await openAndroidLedger();
      addTearDown(reopened.close);
      final result = await Ledger(reopened).usdCashOverview(now);
      expect(result.minor, 144000);
      expect(result.withdrawnMinor, priorWithdrawn + BigInt.from(55000));
      expect(result.balanceKnown, isTrue);
      expect(result.movements.first.countedMinor, 144000);
    },
  );
}
