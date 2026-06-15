import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(MealLogEntry, () {
    final loggedAt = DateTime(2026, 6, 14, 8, 30);

    test('round-trips through json', () {
      final mealLogEntry = MealLogEntry(
        id: 'meal-1',
        loggedAt: loggedAt,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
        nutrition: const Nutrition(
          calories: 350,
          protein: 18,
          fat: 14,
          carbs: 30,
        ),
        usualMealId: 'usual-1',
        photoPath: '/tmp/photo.png',
      );

      final decoded = MealLogEntry.fromJson(mealLogEntry.toJson());

      expect(decoded, equals(mealLogEntry));
    });

    test('parses optional fields as null when absent', () {
      final mealLogEntry = MealLogEntry.fromJson(<String, dynamic>{
        'id': 'meal-2',
        'loggedAt': loggedAt.toIso8601String(),
        'mealOfTheDay': 'lunch',
        'name': 'Sandwich',
      });

      expect(mealLogEntry.nutrition, equals(const Nutrition()));
      expect(mealLogEntry.usualMealId, isNull);
      expect(mealLogEntry.photoPath, isNull);
      expect(mealLogEntry.mealOfTheDay, equals(MealOfTheDay.lunch));
    });
  });
}
