import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('WeightUnitConversion', () {
    test('is a no-op when units match', () {
      expect(WeightUnit.lb.convertFrom(150, WeightUnit.lb), equals(150));
      expect(WeightUnit.kg.convertFrom(70, WeightUnit.kg), equals(70));
    });

    test('converts lb to kg and back within tolerance', () {
      expect(
        WeightUnit.kg.convertFrom(220.462, WeightUnit.lb),
        closeTo(100, 0.01),
      );
      expect(
        WeightUnit.lb.convertFrom(100, WeightUnit.kg),
        closeTo(220.462, 0.01),
      );
    });
  });
}
