import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(LoggedEntryRow, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    void stubSettings(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      registerFallbackValue(const DailyLogEvent.mealEntryRemoved('x'));
      registerFallbackValue(
        const DailyLogEvent.mealEntryUsualMealLinked('x', 'y'),
      );
      registerFallbackValue(
        const DailyLogEvent.mealEntryQuantityChanged('x', 1),
      );
      registerFallbackValue(
        const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'x'),
      );
    });

    MealLogEntry entry({
      String? usualMealId,
      int? calories,
      double quantity = 1,
    }) {
      return MealLogEntry(
        id: 'm1',
        loggedAt: testNow,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
        nutrition: Nutrition(calories: calories),
        usualMealId: usualMealId,
        quantity: quantity,
      );
    }

    // Expanded so the nutrition fields and any sync action are reachable.
    Future<void> pumpRow(WidgetTester tester, MealLogEntry mealLogEntry) {
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        LoggedEntryRow(mealLogEntry: mealLogEntry, expandedByDefault: true),
      );
    }

    testWidgets('removes the entry through the bloc', (tester) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry());

      await tester.tap(find.byIcon(Icons.delete_forever_outlined));

      verify(
        () => dailyLogBloc.add(const DailyLogEvent.mealEntryRemoved('m1')),
      ).called(1);
    });

    testWidgets('saves a standalone entry as a usual and links it', (
      tester,
    ) async {
      // Saving goes through saveAsUsualMeal, which returns the new id that is
      // then linked back onto the logged entry.
      when(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Eggs',
          const Nutrition(calories: 400),
        ),
      ).thenReturn('new-id');
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry(calories: 400));

      // The button is right-aligned and the "Save as usual" label is short, so
      // tap the inner TextButton rather than the full-width Align's centre.
      await tester.tap(
        find.descendant(
          of: find.byType(UpdateUsualButton),
          matching: find.byType(TextButton),
        ),
      );

      verify(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Eggs',
          const Nutrition(calories: 400),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryUsualMealLinked('m1', 'new-id'),
        ),
      ).called(1);
    });

    testWidgets('editing a standalone entry only updates the log', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry());

      await tester.enterText(find.byType(TextFormField).first, '400');

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryNutritionChanged(
            'm1',
            Nutrition(calories: 400),
          ),
        ),
      ).called(1);
      verifyNever(
        () => userSettingsBloc.add(
          any(that: isA<SettingsUsualMealNutritionChanged>()),
        ),
      );
    });

    testWidgets('fills a usual meal that had none from the entry', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'u', name: 'Eggs')],
          },
        ),
      );
      // The entry carries nutrition its empty usual meal lacks, so the row
      // offers to push it onto the usual meal.
      await pumpRow(tester, entry(usualMealId: 'u', calories: 400));

      await tester.tap(find.byType(UpdateUsualButton));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'u',
            Nutrition(calories: 400),
          ),
        ),
      ).called(1);
    });

    testWidgets('offers to update a usual meal whose nutrition now differs', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u', calories: 350));

      expect(find.byType(UpdateUsualButton), findsOneWidget);

      await tester.tap(find.byType(UpdateUsualButton));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealNutritionChanged(
            MealOfTheDay.breakfast,
            'u',
            Nutrition(calories: 350),
          ),
        ),
      ).called(1);
    });

    testWidgets('offers to clear a usual meal when the entry is empty', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 300),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u'));

      expect(find.byType(UpdateUsualButton), findsOneWidget);
    });

    testWidgets('shows no update button when nutrition already matches', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [
              UsualMeal(
                id: 'u',
                name: 'Eggs',
                nutrition: Nutrition(calories: 350),
              ),
            ],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u', calories: 350));

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('changing the quantity dispatches through the bloc', (
      tester,
    ) async {
      stubSettings(const UserSettingsState());
      await pumpRow(tester, entry(quantity: 2));

      await tester.tap(find.byIcon(Icons.add));

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryQuantityChanged('m1', 3),
        ),
      ).called(1);
    });
  });
}
