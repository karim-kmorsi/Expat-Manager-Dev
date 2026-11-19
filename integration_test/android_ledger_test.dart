import 'dart:io';

import 'package:expat_manager/data/android_storage.dart';
import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/main.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Android Keystore, encrypted reopen and Arabic ledger navigation',
    (tester) async {
      final date = DateTime.utc(2026, 1, 2);
      final prefix = 'test-${DateTime.now().microsecondsSinceEpoch}';
      final first = await openAndroidLedger();
      final ledger = Ledger(first);
      final bank = await ledger.createAccount(
        name: 'حساب اختبار البنك',
        currency: 'USD',
        kind: AccountKind.bank,
      );
      final cash = await ledger.createAccount(
        name: 'حساب اختبار النقد',
        currency: 'USD',
        kind: AccountKind.cash,
      );
      final npr = await ledger.createAccount(
        name: 'حساب اختبار NPR',
        currency: 'NPR',
        kind: AccountKind.bank,
      );
      final egp = await ledger.createAccount(
        name: 'حساب اختبار EGP',
        currency: 'EGP',
        kind: AccountKind.bank,
      );
      for (final (account, minor) in [
        (bank, 200000),
        (npr, 12345),
        (egp, -800),
      ]) {
        await ledger.recordOpening(
          operationId: '$prefix-$account',
          accountId: account,
          minor: minor,
          effectiveAt: date,
        );
      }
      await ledger.transfer(
        operationId: '$prefix-transfer',
        from: bank,
        to: cash,
        minor: 30000,
        effectiveAt: date,
      );
      expect(await ledger.netExpenses('USD'), BigInt.zero);
      await first.close();

      const storage = MethodChannel('com.karimkmorsi.expat_manager/storage');
      final config = (await storage.invokeMapMethod<String, Object>(
        'openLedger',
      ))!;
      final file = File(config['path']! as String);
      expect(
        await file.openRead(0, 16).first,
        isNot('SQLite format 3\u0000'.codeUnits),
      );
      final key = Uint8List.fromList(config['key']! as Uint8List);
      key[0] ^= 1;
      await expectLater(
        LedgerDatabase.open(file, key),
        throwsA(isA<StorageLocked>()),
      );

      final reopened = await openAndroidLedger();
      addTearDown(reopened.close);
      final restored = Ledger(reopened);
      expect(await restored.balance(bank), (openingKnown: true, minor: 170000));
      expect(await restored.balance(cash), (openingKnown: false, minor: 30000));
      expect(await restored.balance(npr), (openingKnown: true, minor: 12345));
      expect(await restored.balance(egp), (openingKnown: true, minor: -800));

      await tester.pumpWidget(ExpatManager(ledger: Future.value(restored)));
      await tester.pumpAndSettle();
      final label = find.text('الحسابات');
      expect(Directionality.of(tester.element(label)), TextDirection.rtl);
      expect(find.text('حساب اختبار البنك'), findsWidgets);
      await tester.tap(find.text('إضافة حساب'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'حساب اختبار الواجهة');
      await tester.tap(find.text('حفظ'));
      await tester.pumpAndSettle();
      expect(find.text('حساب اختبار الواجهة'), findsWidgets);
      expect(find.text('حدث خطأ أثناء الحفظ.'), findsNothing);
      await tester.tap(find.text('القيود'));
      await tester.pumpAndSettle();
      expect(find.text('رصيد افتتاحي'), findsWidgets);
    },
  );
}
