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
    'Arabic expense entry, overlap review, reversal and balance check persist',
    (tester) async {
      final db = await openAndroidLedger();
      var firstOpen = true;
      addTearDown(() async {
        if (firstOpen) await db.close();
      });
      final ledger = Ledger(db);
      final now = DateTime.now();
      final unique = now.microsecondsSinceEpoch;
      final name = 'بنك مصروفات اختباري $unique';
      final bank = await ledger.createAccount(
        name: name,
        currency: 'NPR',
        kind: AccountKind.bank,
      );
      await ledger.recordOpening(
        operationId: 'expense-test-$unique',
        accountId: bank,
        minor: 100000,
        effectiveAt: now,
      );
      final before = await ledger.netExpenses('NPR');

      Future<void> tap(Finder item) async {
        await tester.ensureVisible(item.first);
        await tester.tap(item.first);
        await tester.pumpAndSettle();
      }

      Future<void> text(String label) => tap(find.text(label));

      Future<void> selectBank() async {
        await tap(find.byType(DropdownButton<ExpenseAccount>));
        await tap(find.text('$name · NPR · بنك').last);
      }

      Future<void> record(String amount, {bool grouped = false}) async {
        await text('تسجيل مصروف');
        await selectBank();
        await tester.enterText(find.byType(TextFormField).first, amount);
        if (grouped) {
          await tap(find.byType(DropdownButton<ExpensePeriod>));
          await text('إجمالي يوم');
        }
        await text('حفظ');
      }

      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await text('المصروفات');
      expect(
        Directionality.of(tester.element(find.text('المصروفات'))),
        TextDirection.rtl,
      );
      await record('100');
      expect((await ledger.balance(bank)).minor, 90000);
      expect(find.text('غير مصنّف · فردي'), findsWidgets);

      await record('100');
      expect((await ledger.balance(bank)).minor, 90000);
      expect(find.text('مصروف مشابه مسجّل'), findsOneWidget);
      await text('حفظ كمصروف آخر');
      expect((await ledger.balance(bank)).minor, 80000);

      await record('700', grouped: true);
      expect(
        find.textContaining('هناك مصروف مسجّل في فترة متداخلة'),
        findsOneWidget,
      );
      expect((await ledger.balance(bank)).minor, 80000);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      await tap(find.byTooltip('خيارات المصروف'));
      await text('إلغاء المصروف');
      await text('إلغاء المصروف');
      expect((await ledger.balance(bank)).minor, 90000);

      await text('مطابقة الرصيد');
      await selectBank();
      await tester.enterText(find.byType(TextFormField).first, '750');
      await text('مراجعة المطابقة');
      expect((await ledger.balance(bank)).minor, 90000);
      final confirm = find.byType(AlertDialog);
      expect(
        find.descendant(of: confirm, matching: find.text('900.00 NPR')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: confirm, matching: find.text('750.00 NPR')),
        findsOneWidget,
      );
      await tap(find.widgetWithText(FilledButton, 'تأكيد المطابقة'));
      expect(confirm, findsNothing);
      final observed = await ledger.balance(bank);
      final visible = tester
          .widgetList<Text>(find.byType(Text))
          .map((item) => item.data)
          .join(' | ');
      expect(observed.minor, 75000, reason: visible);
      expect(await ledger.netExpenses('NPR'), before + BigInt.from(10000));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      firstOpen = false;
      final reopened = await openAndroidLedger();
      addTearDown(reopened.close);
      final persisted = Ledger(reopened);
      expect((await persisted.balance(bank)).minor, 75000);
      final records = (await persisted.recentExpenses()).where(
        (entry) => entry.input.accountId == bank,
      );
      expect(records, hasLength(2));
      expect(records.where((entry) => entry.reversed), hasLength(1));
      expect(await persisted.netExpenses('NPR'), before + BigInt.from(10000));
    },
  );
}
