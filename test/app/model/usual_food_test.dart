import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualFood, () {
    test('round-trips through json', () {
      const usualFood = UsualFood(
        id: 'food-1',
        name: 'Chicken, 1 oz',
        nutrition: Nutrition(calories: 22, protein: 5, fat: 1),
      );

      final decoded = UsualFood.fromJson(usualFood.toJson());

      expect(decoded, equals(usualFood));
    });

    test('defaults nutrition to empty when absent', () {
      final usualFood = UsualFood.fromJson(<String, dynamic>{
        'id': 'food-2',
        'name': 'Black coffee',
      });

      expect(usualFood.nutrition, equals(const Nutrition()));
    });
  });
}
