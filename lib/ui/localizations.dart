import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import 'digits.dart';

class LatinArabicLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const LatinArabicLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'ar';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    await initializeDateFormatting('ar');
    return _LatinArabicMaterial();
  }

  @override
  bool shouldReload(LatinArabicLocalizationsDelegate old) => false;
}

DateFormat _latin(DateFormat format) => format..useNativeDigits = false;

class _LatinArabicMaterial extends MaterialLocalizationAr {
  _LatinArabicMaterial()
    : super(
        fullYearFormat: _latin(DateFormat.y('ar')),
        compactDateFormat: _latin(DateFormat('d/M/y', 'ar')),
        shortDateFormat: _latin(DateFormat.yMMMd('ar')),
        mediumDateFormat: _latin(DateFormat.MMMEd('ar')),
        longDateFormat: _latin(DateFormat.yMMMMEEEEd('ar')),
        yearMonthFormat: _latin(DateFormat.yMMMM('ar')),
        shortMonthDayFormat: _latin(DateFormat.MMMd('ar')),
        decimalFormat: NumberFormat.decimalPattern('en'),
        twoDigitZeroPaddedFormat: NumberFormat('00', 'en'),
      );

  @override
  DateTime? parseCompactDate(String? inputString) => super.parseCompactDate(
    inputString == null
        ? null
        : latinDigits(inputString)
              .replaceAll(RegExp('[\u061c\u200e\u200f]'), '')
              .trim(),
  );

  @override
  String get dateHelpText => 'يوم/شهر/سنة';
}
