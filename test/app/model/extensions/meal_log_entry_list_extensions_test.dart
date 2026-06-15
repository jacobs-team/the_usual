import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  MealLogEntry entry({
    required String id,
    required DateTime loggedAt,
    MealOfTheDay mealOfTheDay = MealOfTheDay.breakfast,
    int? calories,
  }) {
    return MealLogEntry(
      id: id,
      loggedAt: loggedAt,
      mealOfTheDay: mealOfTheDay,
      name: id,
      nutrition: Nutrition(calories: calories),
    );
  }

  group('MealLogEntryListFormatting', () {
    group('totalNutrition', () {
      test('sums known calories and ignores entries without them', () {
        final entries = [
          entry(id: 'a', loggedAt: DateTime(2026, 6, 14), calories: 200),
          entry(id: 'b', loggedAt: DateTime(2026, 6, 14), calories: 300),
          entry(id: 'c', loggedAt: DateTime(2026, 6, 14)),
        ];

        expect(entries.totalNutrition.calories, equals(500));
      });

      test('leaves calories unset for an empty list', () {
        expect(<MealLogEntry>[].totalNutrition.calories, isNull);
      });
    });

    group('breakdownOn', () {
      test('groups the given day by meal and sums its calories', () {
        final day = DateTime(2026, 6, 14);
        final entries = [
          entry(
            id: 'breakfast',
            loggedAt: DateTime(2026, 6, 14, 8),
            calories: 350,
          ),
          entry(
            id: 'lunch',
            loggedAt: DateTime(2026, 6, 14, 13),
            mealOfTheDay: MealOfTheDay.lunch,
            calories: 500,
          ),
          entry(
            id: 'lunch-no-cals',
            loggedAt: DateTime(2026, 6, 14, 14),
            mealOfTheDay: MealOfTheDay.lunch,
          ),
          entry(
            id: 'other-day',
            loggedAt: DateTime(2026, 6, 13, 8),
            calories: 999,
          ),
        ];

        final breakdown = entries.breakdownOn(day);

        expect(breakdown.nutrition.calories, equals(850));
        expect(
          breakdown.entriesByMeal[MealOfTheDay.breakfast],
          hasLength(1),
        );
        expect(breakdown.entriesByMeal[MealOfTheDay.lunch], hasLength(2));
        expect(
          breakdown.entriesByMeal.containsKey(MealOfTheDay.dinner),
          isFalse,
        );
      });

      test('returns empty breakdown when nothing was logged that day', () {
        final entries = [
          entry(id: 'a', loggedAt: DateTime(2026, 6, 10), calories: 100),
        ];

        final breakdown = entries.breakdownOn(DateTime(2026, 6, 14));

        expect(breakdown.nutrition.calories, isNull);
        expect(breakdown.entriesByMeal, isEmpty);
      });
    });
  });
}
