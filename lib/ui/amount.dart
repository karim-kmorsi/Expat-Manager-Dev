import '../finance/model.dart';
import 'digits.dart';

int? parseMinor(String input, int scale) {
  final normalized = latinAmount(input.trim());
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

String formatMinor(int minor, int scale) =>
    formatUnits(BigInt.from(minor), scale);

String formatUnits(BigInt minor, int scale) {
  final digits = minor.abs().toString().padLeft(scale + 1, '0');
  final sign = minor.isNegative ? '-' : '';
  if (scale == 0) return '$sign$digits';
  final point = digits.length - scale;
  return '$sign${digits.substring(0, point)}.${digits.substring(point)}';
}
