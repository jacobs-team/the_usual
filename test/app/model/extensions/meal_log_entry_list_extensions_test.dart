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

  group('orderedQuickPicks', () {
    UsualMeal usual(String id, String name) => UsualMeal(id: id, name: name);

    MealLogEntry logEntry({
      required String id,
      required DateTime loggedAt,
      required MealOfTheDay mealOfTheDay,
      String? name,
      String? usualMealId,
    }) {
      return MealLogEntry(
        id: id,
        loggedAt: loggedAt,
        mealOfTheDay: mealOfTheDay,
        name: name ?? id,
        usualMealId: usualMealId,
      );
    }

    final usuals = <MealOfTheDay, List<UsualMeal>>{
      MealOfTheDay.breakfast: [
        usual('eggs', 'Eggs'),
        usual('oatmeal', 'Oatmeal'),
        usual('coffee', 'Coffee'),
      ],
      MealOfTheDay.dinner: [usual('pizza', 'Pizza')],
    };

    final day = DateTime(2026, 6, 16);

    test("orders the meal's own usuals: most recent, then by frequency", () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 15),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'eggs',
        ),
        logEntry(
          id: '2',
          loggedAt: DateTime(2026, 6, 10),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
        logEntry(
          id: '3',
          loggedAt: DateTime(2026, 6, 11),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
        logEntry(
          id: '4',
          loggedAt: DateTime(2026, 6, 12),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.map((usualMeal) => usualMeal.id).toList(),
        equals(['eggs', 'oatmeal', 'coffee']),
      );
    });

    test('excludes usuals that belong to other meals', () {
      final picks = <MealLogEntry>[].orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.any((usualMeal) => usualMeal.id == 'pizza'),
        isFalse,
      );
      expect(
        picks.map((usualMeal) => usualMeal.id).toList(),
        equals(['eggs', 'oatmeal', 'coffee']),
      );
    });

    test('drops a usual already logged today for this meal by id', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'Renamed Eggs',
          usualMealId: 'eggs',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(picks.any((usualMeal) => usualMeal.id == 'eggs'), isFalse);
    });

    test('drops a usual already logged today for this meal by name', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'oatmeal',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(picks.any((usualMeal) => usualMeal.id == 'oatmeal'), isFalse);
    });
  });

  group('usualsFromOtherMeals', () {
    UsualMeal usual(String id, String name) => UsualMeal(id: id, name: name);

    MealLogEntry logEntry({
      required String id,
      required DateTime loggedAt,
      required MealOfTheDay mealOfTheDay,
      String? name,
      String? usualMealId,
    }) {
      return MealLogEntry(
        id: id,
        loggedAt: loggedAt,
        mealOfTheDay: mealOfTheDay,
        name: name ?? id,
        usualMealId: usualMealId,
      );
    }

    final usuals = <MealOfTheDay, List<UsualMeal>>{
      MealOfTheDay.breakfast: [
        usual('eggs', 'Eggs'),
        usual('coffee', 'Coffee'),
      ],
      MealOfTheDay.lunch: [
        usual('salad', 'Salad'),
        usual('sandwich', 'Sandwich'),
      ],
      MealOfTheDay.dinner: [usual('pizza', 'Pizza')],
    };

    final day = DateTime(2026, 6, 16);

    test(
      'groups other meals, excludes the current meal, keeps library order',
      () {
        final grouped = <MealLogEntry>[].usualsFromOtherMeals(
          mealOfTheDay: MealOfTheDay.breakfast,
          usuals: usuals,
          day: day,
        );

        expect(grouped.containsKey(MealOfTheDay.breakfast), isFalse);
        expect(
          grouped[MealOfTheDay.lunch]!
              .map((usualMeal) => usualMeal.id)
              .toList(),
          equals(['salad', 'sandwich']),
        );
        expect(
          grouped[MealOfTheDay.dinner]!
              .map((usualMeal) => usualMeal.id)
              .toList(),
          equals(['pizza']),
        );
      },
    );

    test(
      'drops usuals logged today for the current meal and omits emptied meals',
      () {
        final entries = [
          logEntry(
            id: '1',
            loggedAt: DateTime(2026, 6, 16, 8),
            mealOfTheDay: MealOfTheDay.breakfast,
            name: 'Pizza',
            usualMealId: 'pizza',
          ),
        ];

        final grouped = entries.usualsFromOtherMeals(
          mealOfTheDay: MealOfTheDay.breakfast,
          usuals: usuals,
          day: day,
        );

        expect(grouped.containsKey(MealOfTheDay.dinner), isFalse);
        expect(
          grouped[MealOfTheDay.lunch]!
              .map((usualMeal) => usualMeal.id)
              .toList(),
          equals(['salad', 'sandwich']),
        );
      },
    );
  });
}
