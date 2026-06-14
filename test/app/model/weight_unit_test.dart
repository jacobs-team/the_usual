import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WeightUnit, () {
    test('has lb and kg values', () {
      expect(WeightUnit.values, equals([WeightUnit.lb, WeightUnit.kg]));
    });
  });
}
