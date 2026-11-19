import '../finance/model.dart';

int? parseMinor(String input, int scale) {
  const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
  const easternDigits = '۰۱۲۳۴۵۶۷۸۹';
  final normalized = input
      .trim()
      .replaceAllMapped(RegExp('[٠-٩۰-۹]'), (match) {
        final digit = match[0]!;
        final index = arabicDigits.indexOf(digit);
        return (index < 0 ? easternDigits.indexOf(digit) : index).toString();
      })
      .replaceAll('٫', '.')
      .replaceAll('−', '-');
  final match = RegExp(r'^(-?)([0-9]+)(?:\.([0-9]+))?$').firstMatch(normalized);
  if (match == null || normalized.length > 32) return null;
  final fraction = match[3] ?? '';
  if (fraction.length > scale) return null;
  final amount = BigInt.parse(
    '${match[1]}${match[2]}${fraction.padRight(scale, '0')}',
  );
  if (amount < BigInt.from(minMinor) || amount > BigInt.from(maxMinor)) {
    return null;
  }
  return amount.toInt();
}

String formatMinor(int minor, int scale) {
  final digits = BigInt.from(minor).abs().toString().padLeft(scale + 1, '0');
  final sign = minor < 0 ? '-' : '';
  if (scale == 0) return '$sign$digits';
  final point = digits.length - scale;
  return '$sign${digits.substring(0, point)}.${digits.substring(point)}';
}
