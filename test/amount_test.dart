import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/ui/amount.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('converts decimal and Arabic digits into exact signed minor units', () {
    expect(parseMinor(' ١٢٣٫٤٥ ', 2), 12345);
    expect(parseMinor('−۱۲٫۷۰', 2), -1270);
    expect(parseMinor('0', 2), 0);
    expect(parseMinor('92233720368547758.07', 2), maxMinor);
    expect(formatMinor(minMinor, 2), '-92233720368547758.07');
    expect(parseMinor('-92233720368547758.08', 2), isNull);
    expect(parseMinor('92233720368547758.08', 2), isNull);
    expect(parseMinor('1.001', 2), isNull);
    expect(parseMinor('1e4', 2), isNull);
  });
}
