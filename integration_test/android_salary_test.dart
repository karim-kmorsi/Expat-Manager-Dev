import 'package:expat_manager/data/android_storage.dart';
import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Arabic payroll UI, execution link and encrypted reopen on Android',
    (tester) async {
      final db = await openAndroidLedger();
      var isFirstOpen = true;
      addTearDown(() async {
        if (isFirstOpen) await db.close();
      });
      final ledger = Ledger(db);
      final run = DateTime.now().microsecondsSinceEpoch;
      final name = 'حساب راتب اختباري $run';
      final bank = await ledger.createAccount(
        name: name,
        currency: 'USD',
        kind: AccountKind.bank,
      );
      final cash = await ledger.createAccount(
        name: 'نقد اختباري',
        currency: 'USD',
        kind: AccountKind.cash,
      );

      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الرواتب'));
      await tester.pumpAndSettle();
      expect(
        Directionality.of(tester.element(find.text('الرواتب'))),
        TextDirection.rtl,
      );
      await tester.tap(find.text('تسجيل راتب'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButton<LedgerAccount>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('$name · USD').last);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, '2000');
      await tester.enterText(find.byType(TextFormField).last, 'Fixture-$run');
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();

      final salary = (await ledger.salaries()).singleWhere(
        (row) => row.accountId == bank,
      );
      expect(salary.minor, 200000);
      expect((await ledger.balance(bank)).minor, 200000);
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      await tester.tap(find.text('إنشاء خطة توزيع'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('إضافة بند'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).first,
        'بند نقد اختباري',
      );
      await tester.enterText(find.byType(TextFormField).last, '300');
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      final item = (await ledger.salaryPlan(salary.id)).allocations.single.id;

      for (final (label, minor) in [
        ('أسرة', 50000),
        ('ادخار', 40000),
        ('معيشة', 60000),
      ]) {
        await ledger.addSalaryAllocation(salary.id, label, minor);
      }
      final first = await ledger.transfer(
        operationId: 'fixture-$run-a',
        from: bank,
        to: cash,
        minor: 10000,
        effectiveAt: DateTime.now(),
      );
      final second = await ledger.transfer(
        operationId: 'fixture-$run-b',
        from: bank,
        to: cash,
        minor: 20000,
        effectiveAt: DateTime.now(),
      );
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text(name));
      await tester.pumpAndSettle();
      expect(find.text('200.00 USD'), findsOneWidget);

      final linkButton = find.text('ربط دفعة').first;
      await tester.ensureVisible(linkButton);
      await tester.tap(linkButton);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), '200');
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      expect(
        (await ledger.salaryPlan(salary.id)).allocations.first.executed,
        20000,
      );
      final linked = find.text('القيد $second · منفّذ');
      await tester.ensureVisible(linked);
      await tester.tap(linked);
      await tester.pumpAndSettle();
      expect(find.text('تفاصيل القيد'), findsOneWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      await ledger.linkSalaryExecution(
        allocationId: item,
        entryId: first,
        minor: 10000,
      );
      await ledger.confirmSalaryMovement(second, 'دليل اختباري');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      isFirstOpen = false;
      final reopened = await openAndroidLedger();
      addTearDown(reopened.close);
      final persisted = Ledger(reopened);
      final plan = await persisted.salaryPlan(salary.id);
      expect(
        (plan.planned, plan.unallocated, plan.executed, plan.confirmed),
        (180000, 20000, 30000, 20000),
      );
      expect(plan.allocations.first.remaining, 0);
      expect((await persisted.balance(bank)).minor, 170000);
      expect((await persisted.balance(cash)).minor, 30000);
    },
  );
}
