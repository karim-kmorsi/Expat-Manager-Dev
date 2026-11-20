import 'dart:async';

import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/main.dart';
import 'package:expat_manager/ui/date_picker.dart';
import 'package:expat_manager/ui/digits.dart';
import 'package:expat_manager/ui/localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test(
    'normalizes both Arabic digit sets and preserves selection and IME input',
    () {
      final formatter = amountInputFormatters.single;
      const input = TextEditingValue(
        text: '−١۲3٫٤۵',
        selection: TextSelection.collapsed(offset: 3),
      );
      final normalized = formatter.formatEditUpdate(
        TextEditingValue.empty,
        input,
      );
      expect(normalized.text, '-123.45');
      expect(normalized.selection, input.selection);

      final composing = input.copyWith(
        composing: const TextRange(start: 1, end: 4),
      );
      expect(
        formatter.formatEditUpdate(TextEditingValue.empty, composing),
        composing,
      );
      expect(latinDigits('مرجع ١۲3'), 'مرجع 123');
    },
  );

  testWidgets(
    'normal app keeps RTL and Arabic strings with Latin date digits',
    (tester) async {
      await tester.pumpWidget(ExpatManager(ledger: Completer<Ledger>().future));
      await tester.pump();
      final context = tester.element(find.byType(CircularProgressIndicator));
      expect(Directionality.of(context), TextDirection.rtl);
      expect(Localizations.localeOf(context), const Locale('ar'));
      final strings = MaterialLocalizations.of(context);
      final date = DateTime(2026, 11, 20);
      expect(strings.formatCompactDate(date), '20/11/2026');
      expect(
        strings.formatFullDate(date),
        allOf(contains('نوفمبر'), contains('2026')),
      );
      expect(strings.formatMonthYear(date), contains('2026'));
      expect(strings.formatDecimal(12345), '12,345');
      expect(strings.parseCompactDate('٢٠/۱۱/2026'), date);
      expect(strings.parseCompactDate('٣١/١١/٢٠٢٦'), isNull);
    },
  );

  testWidgets('saved dark appearance keeps RTL and legible surface colors', (
    tester,
  ) async {
    await tester.pumpWidget(
      ExpatManager(
        ledger: Completer<Ledger>().future,
        initialAppearance: Future.value(ThemeMode.dark),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    final context = tester.element(find.byType(CircularProgressIndicator));
    final theme = Theme.of(context);
    expect(theme.brightness, Brightness.dark);
    expect(Directionality.of(context), TextDirection.rtl);
    final foreground = theme.colorScheme.onSurface.computeLuminance();
    final background = theme.scaffoldBackgroundColor.computeLuminance();
    expect((foreground + .05) / (background + .05), greaterThan(4.5));
  });

  testWidgets(
    'calendar shows Latin days and manual entry normalizes pasted dates',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      DateTime? result;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            LatinArabicLocalizationsDelegate(),
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async => result = await showAppDatePicker(
                  context: context,
                  initialDate: DateTime(2026, 11, 20),
                  firstDate: DateTime(2026, 11, 1),
                  lastDate: DateTime(2026, 11, 30),
                ),
                child: const Text('فتح التقويم'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final strings = MaterialLocalizations.of(
        tester.element(find.text('فتح التقويم')),
      );
      await tester.tap(find.text('فتح التقويم'));
      await tester.pumpAndSettle();
      expect(find.text('23'), findsOneWidget);
      expect(find.text('٢٣'), findsNothing);
      await tester.tap(find.text('23'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip(strings.inputDateModeButtonLabel));
      await tester.pumpAndSettle();
      final field = find.byType(TextFormField);
      String currentText() => tester
          .widget<EditableText>(find.byType(EditableText))
          .controller
          .text;
      expect(currentText(), '23/11/2026');
      await tester.enterText(field, '١/١٢/٢٠٢٦');
      expect(currentText(), '1/12/2026');
      await tester.tap(find.text(strings.okButtonLabel));
      await tester.pumpAndSettle();
      expect(find.text(strings.dateOutOfRangeLabel), findsOneWidget);
      await tester.enterText(field, '٢۴/۱١/2026');
      expect(currentText(), '24/11/2026');
      await tester.tap(find.byTooltip(strings.calendarModeButtonLabel));
      await tester.pumpAndSettle();
      expect(
        find.text(strings.formatFullDate(DateTime(2026, 11, 24))),
        findsOneWidget,
      );
      await tester.tap(find.text(strings.okButtonLabel));
      await tester.pumpAndSettle();
      expect(result, DateTime(2026, 11, 24));
    },
  );
}
