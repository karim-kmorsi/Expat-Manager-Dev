import 'package:expat_manager/data/android_storage.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:expat_manager/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Arabic leave entry works offline and survives encrypted reopen', (
    tester,
  ) async {
    var db = await openAndroidLedger();
    addTearDown(() => db.close());
    var ledger = Ledger(db);
    final now = DateTime.now();
    final today = leaveDay(now);
    final account = await ledger.createAccount(
      name: 'T013 synthetic bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 't013-${now.microsecondsSinceEpoch}',
      accountId: account,
      minor: 4242,
      effectiveAt: now,
    );

    final partial = await ledger.personalLeave.save(
      kind: LeaveKind.casual,
      status: LeaveStatus.approved,
      period: LeavePeriod(today + 2, today + 4),
      occasion: 'تجربة إلغاء جزئي',
    );

    Future<void> openLeave() async {
      await tester.pumpWidget(ExpatManager(ledger: Future.value(ledger)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('الإجازات'));
      await tester.pumpAndSettle();
      final heading = find.text('السجل');
      expect(heading, findsOneWidget);
      expect(Directionality.of(tester.element(heading)), TextDirection.rtl);
    }

    await openLeave();
    await tester.tap(find.text('تخطيط إجازة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('عرض الاقتراحات'));
    await tester.pumpAndSettle();
    final suggestion = find.widgetWithIcon(ListTile, Icons.add);
    expect(suggestion, findsOneWidget);
    await tester.ensureVisible(suggestion);
    await tester.tap(suggestion);
    await tester.pumpAndSettle();
    expect(find.text('إضافة إجازة'), findsWidgets);

    await tester.tap(find.text('مطلوبة'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('معتمدة').last);
    await tester.pumpAndSettle();
    final occasion = find.byType(TextFormField);
    await tester.ensureVisible(occasion);
    await tester.enterText(occasion, 'تجربة إجازة محلية');
    await tester.tap(find.text('حفظ'));
    await tester.pumpAndSettle();
    final entries = (await ledger.personalLeave.overview()).entries;
    final saved = entries.singleWhere(
      (entry) => entry.occasion == 'تجربة إجازة محلية',
    );
    expect(saved.startDay, today);
    expect(saved.endDay, today);
    expect(saved.status, LeaveStatus.approved);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    await db.close();
    db = await openAndroidLedger();
    ledger = Ledger(db);
    await openLeave();
    final reopened = await ledger.personalLeave.overview();
    expect(
      reopened.entries.singleWhere((entry) => entry.id == saved.id).status,
      LeaveStatus.approved,
    );
    expect(reopened.balance(now.year, LeaveKind.annual).reserved, 1);
    expect((await ledger.balance(account)).minor, 4242);
    await tester.scrollUntilVisible(
      find.textContaining('تجربة إجازة محلية'),
      150,
    );
    expect(find.textContaining('تجربة إجازة محلية'), findsOneWidget);

    final partialLabel = find.textContaining('تجربة إلغاء جزئي');
    await tester.scrollUntilVisible(partialLabel, 120);
    final tile = find
        .ancestor(of: partialLabel, matching: find.byType(ListTile))
        .first;
    await tester.tap(
      find.descendant(of: tile, matching: find.byTooltip('خيارات الإجازة')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('إلغاء الإجازة').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('استخدمت جزءًا من الإجازة'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ويعود 2 يوم'), findsOneWidget);
    await tester.tap(find.text('تأكيد الإلغاء'));
    await tester.pumpAndSettle();
    final afterCancel = await ledger.personalLeave.overview();
    final used = afterCancel.entries.singleWhere(
      (entry) => entry.id == partial,
    );
    expect(used.status, LeaveStatus.used);
    expect(used.endDay, today + 2);
    expect(
      afterCancel
          .balance(dateOfLeaveDay(today + 2).year, LeaveKind.casual)
          .used,
      1,
    );

    final planner = find.text('تخطيط إجازة');
    await tester.scrollUntilVisible(planner, -120);
    await tester.tap(planner);
    await tester.pumpAndSettle();
    await tester.tap(find.text('تاريخ محدد'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('فترة مستقبلية').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('فترة بعد ثلاثة أشهر'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('عرض الاقتراحات'));
    await tester.pumpAndSettle();
    expect(find.textContaining('يُخصم 1 يوم'), findsWidgets);
    expect(find.textContaining('راحة متصلة'), findsWidgets);
    final futureOption = find.widgetWithIcon(ListTile, Icons.add).first;
    await tester.ensureVisible(futureOption);
    await tester.tap(futureOption);
    await tester.pumpAndSettle();
    final beginning = find.textContaining('البداية');
    final expectedMonth = DateTime(now.year, now.month + 3);
    final localizations = MaterialLocalizations.of(tester.element(beginning));
    final latestDay = DateTime(
      expectedMonth.year,
      expectedMonth.month + 1,
      0,
    ).day;
    final expectedStart = DateTime(
      expectedMonth.year,
      expectedMonth.month,
      now.day.clamp(1, latestDay),
    );
    final labels = [
      for (var offset = 0; offset <= 30; offset++)
        'البداية ${localizations.formatCompactDate(DateTime(expectedStart.year, expectedStart.month, expectedStart.day + offset))}',
    ];
    expect(labels, contains(tester.widget<Text>(beginning).data));
  });
}
