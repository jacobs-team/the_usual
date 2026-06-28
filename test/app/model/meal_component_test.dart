import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealComponent, () {
    test('round-trips through json', () {
      const mealComponent = MealComponent(
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5, fat: 1),
        quantity: 4,
        usualFoodId: 'food-1',
      );

      final decoded = MealComponent.fromJson(mealComponent.toJson());

      expect(decoded, equals(mealComponent));
    });

    test('defaults quantity to 1, nutrition to empty, link to null', () {
      final mealComponent = MealComponent.fromJson(<String, dynamic>{
        'name': 'Rice',
      });

      expect(mealComponent.quantity, equals(1));
      expect(mealComponent.nutrition, equals(const Nutrition()));
      expect(mealComponent.usualFoodId, isNull);
    });

    test('scaledNutrition multiplies per-unit nutrition by quantity', () {
      const mealComponent = MealComponent(
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5),
        quantity: 4,
      );

      // `Nutrition.operator *` leaves unset values null (fat/carbs here), so the
      // expectation only sets the values that were present per unit.
      expect(
        mealComponent.scaledNutrition,
        equals(const Nutrition(calories: 88, protein: 20)),
      );
    });

    test('scaledNutrition supports fractional quantities', () {
      const mealComponent = MealComponent(
        name: 'Quesadilla',
        nutrition: Nutrition(calories: 300),
        quantity: 1.5,
      );

      expect(mealComponent.scaledNutrition.calories, equals(450));
    });
  });
}
