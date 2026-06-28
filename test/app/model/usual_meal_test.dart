import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualMeal, () {
    test('round-trips through json', () {
      const usualMeal = UsualMeal(
        id: 'usual-1',
        name: 'Oatmeal',
        photoPath: '/tmp/oat.png',
        nutrition: Nutrition(calories: 300),
      );

      final decoded = UsualMeal.fromJson(usualMeal.toJson());

      expect(decoded, equals(usualMeal));
    });

    test('parses optional fields as null when absent', () {
      final usualMeal = UsualMeal.fromJson(<String, dynamic>{
        'id': 'usual-2',
        'name': 'Apple',
      });

      expect(usualMeal.nutrition, equals(const Nutrition()));
      expect(usualMeal.photoPath, isNull);
    });

    test('round-trips with components', () {
      const usualMeal = UsualMeal(
        id: 'usual-3',
        name: 'Chicken & rice bowl',
        nutrition: Nutrition(calories: 293),
        components: [
          MealComponent(
            name: 'Chicken, 1 oz',
            nutrition: Nutrition(calories: 22, protein: 5),
            quantity: 4,
            usualFoodId: 'food-1',
          ),
          MealComponent(
            name: 'Rice, cup',
            nutrition: Nutrition(calories: 205, carbs: 45),
          ),
        ],
      );

      final decoded = UsualMeal.fromJson(usualMeal.toJson());

      expect(decoded, equals(usualMeal));
    });

    test('defaults components to empty for legacy json without the key', () {
      final usualMeal = UsualMeal.fromJson(<String, dynamic>{
        'id': 'usual-4',
        'name': 'Oatmeal',
        'nutrition': {'calories': 300},
      });

      expect(usualMeal.components, isEmpty);
    });
  });
}
