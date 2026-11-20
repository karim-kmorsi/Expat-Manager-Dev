import 'package:flutter/services.dart';

final _nativeDigits = RegExp('[٠-٩۰-۹]');

String latinDigits(String text) =>
    text.replaceAllMapped(_nativeDigits, (match) {
      final code = match[0]!.codeUnitAt(0);
      return (code - (code >= 0x06f0 ? 0x06f0 : 0x0660)).toString();
    });

String latinAmount(String text) =>
    latinDigits(text).replaceAll('٫', '.').replaceAll('−', '-');

const numberInputFormatters = <TextInputFormatter>[_LatinInputFormatter()];
const amountInputFormatters = <TextInputFormatter>[
  _LatinInputFormatter(amount: true),
];

class _LatinInputFormatter extends TextInputFormatter {
  const _LatinInputFormatter({this.amount = false});

  final bool amount;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Only rewrite committed IME text. Each replacement has the same length,
    // so the user's selection and cursor offset are preserved.
    if (!newValue.composing.isCollapsed) return newValue;
    final text = amount
        ? latinAmount(newValue.text)
        : latinDigits(newValue.text);
    return text == newValue.text ? newValue : newValue.copyWith(text: text);
  }
}
