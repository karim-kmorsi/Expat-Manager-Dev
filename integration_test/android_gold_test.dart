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
    'Arabic gold register and confirmed sale survive encrypted reopen',
    (tester) async {
      var db = await openAndroidLedger();
      addTearDown(() => db.close());
      var ledger = Ledger(db);
      final marker = 'T015 TEST ${DateTime.now().microsecondsSinceEpoch}';
      final owner = 'مالك $marker';
      final initialEntries = (await ledger.entries()).length;
      final account = await ledger.createAccount(
        name: marker,
        currency: 'EGP',
        kind: AccountKind.bank,
      );

      Future<void> openRegister() async {
        await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
        await tester.pumpAndSettle();
        await tester.tap(find.text('الذهب الفعلي'));
        await tester.pumpAndSettle();
        final title = find.text('الذهب الفعلي في مصر');
        expect(title, findsOneWidget);
        expect(Directionality.of(tester.element(title)), TextDirection.rtl);
      }

      Future<void> field(String label, String text) async {
        final input = find.widgetWithText(TextFormField, label);
        await tester.ensureVisible(input);
        await tester.enterText(input, text);
        await tester.pumpAndSettle();
      }

      Future<void> button(Finder target) async {
        await tester.ensureVisible(target);
        await tester.tap(target);
        await tester.pumpAndSettle();
      }

      await openRegister();
      await button(find.widgetWithText(FilledButton, 'إضافة قطعة'));
      await field('اسم القطعة أو وصفها', marker);
      await field('الوزن بالجرام', '١٠٫٢٥');
      await field('العيار', '٢٢٫٥');
      await field('المالك الفعلي', owner);
      await field('الحائز', 'حائز تجريبي');
      await button(find.widgetWithText(FilledButton, 'حفظ'));

      await button(find.text(marker));
      expect(find.textContaining('10.25 جرام · عيار 22.5'), findsOneWidget);
      expect(find.text('تكلفة الشراء غير معروفة'), findsOneWidget);
      await button(find.widgetWithText(TextButton, 'نقل الحيازة'));
      await field('الحائز الجديد', 'حائز تجريبي ثانٍ');
      await button(find.widgetWithText(FilledButton, 'حفظ'));
      expect(find.text('الحائز حائز تجريبي ثانٍ'), findsOneWidget);

      await button(find.widgetWithText(TextButton, 'تسجيل البيع'));
      await button(find.widgetWithText(FilledButton, 'حفظ'));
      expect(find.text('لم يؤكّد استلام الثمن'), findsOneWidget);
      expect(await ledger.entries(), hasLength(initialEntries));
      await button(find.widgetWithText(FilledButton, 'تأكيد استلام الثمن'));
      await button(find.text('حساب الاستلام'));
      await button(find.text('$marker · EGP').last);
      await field('المبلغ المستلم · EGP', '٥٠٠');
      await button(find.widgetWithText(FilledButton, 'تأكيد'));
      expect(find.text('500.00 EGP'), findsOneWidget);
      expect((await ledger.balance(account)).minor, 50000);
      expect(await ledger.entries(), hasLength(initialEntries + 1));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      db = await openAndroidLedger();
      ledger = Ledger(db);
      final other = '$marker other';
      await ledger.addGold(
        operationId: other,
        details: GoldDetails(
          label: other,
          kind: GoldKind.coin,
          weightMg: 2000,
          karatHundredths: 2100,
          owner: 'مالك آخر',
        ),
        custodian: 'حائز آخر',
      );
      await openRegister();
      expect(find.text(other), findsOneWidget);
      await button(find.text('تصفية القطع'));
      await button(
        find.widgetWithText(DropdownButtonFormField<String?>, 'المالك'),
      );
      await button(find.text(owner).last);
      expect(find.text(other), findsNothing);
      await button(find.text(marker));
      expect(find.text('500.00 EGP'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'تأكيد استلام الثمن'),
        findsNothing,
      );
      final sold = (await ledger.goldInventory()).singleWhere(
        (row) => row.piece.label == marker,
      );
      expect(sold.sale, isNotNull);
      expect(sold.piece.custodian, 'حائز تجريبي ثانٍ');
      expect(await ledger.entries(), hasLength(initialEntries + 1));
    },
  );
}
