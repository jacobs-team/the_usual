import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('MealComponentListFormatting.componentsTotal', () {
    test('is empty for an empty list', () {
      expect(<MealComponent>[].componentsTotal, equals(const Nutrition()));
      expect(<MealComponent>[].componentsTotal.isEmpty, isTrue);
    });

    test('sums each component scaled by its quantity', () {
      const components = [
        MealComponent(
          name: 'Chicken, 1 oz',
          nutrition: Nutrition(calories: 22, protein: 5),
          quantity: 4,
        ),
        MealComponent(
          name: 'Rice, cup',
          nutrition: Nutrition(calories: 205, carbs: 45),
        ),
      ];

      final total = components.componentsTotal;

      expect(total.calories, equals(293));
      expect(total.protein, equals(20));
      expect(total.carbs, equals(45));
    });
  });
}
