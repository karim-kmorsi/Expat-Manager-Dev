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
    'Arabic remittance UI records partial arrival and refund offline',
    (tester) async {
      var db = await openAndroidLedger();
      addTearDown(() async => db.close());
      var ledger = Ledger(db);
      final now = DateUtils.dateOnly(DateTime.now());
      final key = DateTime.now().microsecondsSinceEpoch;
      final origin = 'مصدر اصطناعي $key';
      final destination = 'وجهة اصطناعية $key';
      final bank = await ledger.createAccount(
        name: origin,
        currency: 'NPR',
        kind: AccountKind.bank,
      );
      final egypt = await ledger.createAccount(
        name: destination,
        currency: 'EGP',
        kind: AccountKind.bank,
      );
      await ledger.recordOpening(
        operationId: 'remittance-integration-opening-$key',
        accountId: bank,
        minor: 100000,
        effectiveAt: now,
      );
      final priorExpenses = await ledger.netExpenses('EGP');

      Future<void> tap(Finder finder) async {
        await tester.ensureVisible(finder.first);
        await tester.tap(finder.first);
        await tester.pumpAndSettle();
      }

      Future<void> text(String label) => tap(find.text(label));

      Future<void> input(String title, String value) =>
          tester.enterText(find.widgetWithText(TextField, title), value);

      Future<void> chooseAccount(
        int index,
        String name,
        String currency,
      ) async {
        await tap(find.byType(DropdownButton<LedgerAccount>).at(index));
        final option = find.text('$name · $currency').last;
        await tester.scrollUntilVisible(
          option,
          130,
          scrollable: find.byType(Scrollable).last,
        );
        await tap(option);
      }

      Future<void> record(
        String action,
        String currency,
        String amount,
        String evidence, {
        String? source,
      }) async {
        await text(action);
        await input('المبلغ الفعلي · $currency', amount);
        if (source != null) {
          await input('حصة الخصم المثبتة · NPR، اختياري', source);
        }
        await input('مرجع الإثبات', evidence);
        await tap(find.widgetWithText(FilledButton, 'حفظ'));
        expect(find.byType(AlertDialog), findsNothing);
      }

      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await text('الحوالات');
      expect(
        Directionality.of(tester.element(find.text('الحوالات إلى مصر'))),
        TextDirection.rtl,
      );
      await text('تخطيط حوالة');
      await chooseAccount(0, origin, 'NPR');
      await chooseAccount(1, destination, 'EGP');
      await text('أؤكد أن المصدر في نيبال والوجهة في مصر');
      await text('حفظ الخطة');
      expect(find.text('مخططة').hitTestable(), findsOneWidget);
      expect((await ledger.balance(bank)).minor, 100000);

      await record('تسجيل الخصم المرسل', 'NPR', '500', 'خصم $key');
      expect(
        find.text('مرسلة · بانتظار الاستلام').hitTestable(),
        findsOneWidget,
      );
      await record('تسجيل الاستلام', 'EGP', '125', 'وصول $key', source: '300');
      expect(find.text('معلّقة · قيد التسوية').hitTestable(), findsOneWidget);
      expect((await ledger.balance(bank)).minor, 50000);
      expect((await ledger.balance(egypt)).minor, 12500);
      expect(await ledger.netExpenses('EGP'), priorExpenses);

      await text('إلغاء التعليمات');
      await text('تأكيد الإلغاء');
      expect(find.text('طُلب الإلغاء. الخصم ما زال مسجّلًا.'), findsOneWidget);
      await record('تسجيل الاسترداد', 'NPR', '200', 'استرداد $key');
      expect(find.text('مستلمة').hitTestable(), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await db.close();
      db = await openAndroidLedger();
      ledger = Ledger(db);
      final item = (await ledger.remittances()).singleWhere(
        (view) => view.source.id == bank,
      );
      expect(item.status, RemittanceStatus.received);
      expect(item.activity, hasLength(3));
      expect(item.outstanding, 0);
      expect(item.received, 12500);
      expect((await ledger.balance(bank)).minor, 70000);
      expect((await ledger.balance(egypt)).minor, 12500);
    },
  );
}
