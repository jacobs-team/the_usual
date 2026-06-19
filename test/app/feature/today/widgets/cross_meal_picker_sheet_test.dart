import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(OtherMealUsualsSheet, () {
    late DailyLogBloc dailyLogBloc;

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      registerFallbackValue(
        const DailyLogEvent.mealLogged(MealOfTheDay.breakfast, 'x'),
      );
    });

    Future<void> pumpSheet(
      WidgetTester tester,
      Map<MealOfTheDay, List<UsualMeal>> usualsByMeal, {
      List<DateTime>? logDays,
      TimeOfDay? dayStart,
    }) {
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        OtherMealUsualsSheet(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualsByMeal: usualsByMeal,
          logDays: logDays,
          dayStart: dayStart,
        ),
      );
    }

    testWidgets('lists usuals grouped by their own meal', (tester) async {
      await pumpSheet(tester, const {
        MealOfTheDay.lunch: [
          UsualMeal(
            id: 'u',
            name: 'Salad',
            nutrition: Nutrition(calories: 250),
          ),
          UsualMeal(id: 'v', name: 'Soup'),
        ],
        MealOfTheDay.dinner: [UsualMeal(id: 'w', name: 'Steak')],
      });

      expect(find.text('Log to Breakfast'), findsOneWidget);
      expect(find.text('LUNCH'), findsOneWidget);
      expect(find.text('Salad'), findsOneWidget);
      expect(find.text('250 cal'), findsOneWidget);
      expect(find.text('Soup'), findsOneWidget);
      // A second group renders below the first, exercising the between-groups
      // gap.
      expect(
        find.text(MealOfTheDay.dinner.label.toUpperCase()),
        findsOneWidget,
      );
      expect(find.text('Steak'), findsOneWidget);
    });

    testWidgets('logs the tapped usual under the current meal', (tester) async {
      await pumpSheet(tester, const {
        MealOfTheDay.lunch: [
          UsualMeal(
            id: 'u',
            name: 'Salad',
            nutrition: Nutrition(calories: 250),
          ),
        ],
      });

      await tester.tap(find.text('Salad'));
      await tester.pumpAndSettle();

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Salad',
            nutrition: Nutrition(calories: 250),
            usualMealId: 'u',
          ),
        ),
      ).called(1);
    });

    testWidgets('forwards day and dayStart when logging a usual', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        const {
          MealOfTheDay.lunch: [
            UsualMeal(
              id: 'u',
              name: 'Salad',
              nutrition: Nutrition(calories: 250),
            ),
          ],
        },
        logDays: [DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(find.text('Salad'));
      await tester.pumpAndSettle();

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Salad',
            nutrition: const Nutrition(calories: 250),
            usualMealId: 'u',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('logs the tapped usual onto every day in a range', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        const {
          MealOfTheDay.lunch: [
            UsualMeal(
              id: 'u',
              name: 'Salad',
              nutrition: Nutrition(calories: 250),
            ),
          ],
        },
        logDays: [DateTime(2026, 6, 15), DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(find.text('Salad'));
      await tester.pumpAndSettle();

      for (final day in [DateTime(2026, 6, 15), DateTime(2026, 6, 16)]) {
        verify(
          () => dailyLogBloc.add(
            DailyLogEvent.mealLogged(
              MealOfTheDay.breakfast,
              'Salad',
              nutrition: const Nutrition(calories: 250),
              usualMealId: 'u',
              day: day,
              dayStart: const TimeOfDay(hour: 4, minute: 0),
            ),
          ),
        ).called(1);
      }
    });
  });
}
