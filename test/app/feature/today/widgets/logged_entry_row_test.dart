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
        const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'x'),
      );
    });

    MealLogEntry entry({String? usualMealId, int? calories}) {
      return MealLogEntry(
        id: 'm1',
        loggedAt: DateTime.now(),
        mealOfTheDay: MealOfTheDay.breakfast,
        name: 'Eggs',
        nutrition: Nutrition(calories: calories),
        usualMealId: usualMealId,
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

      await tester.tap(find.byIcon(Icons.remove));

      verify(
        () => dailyLogBloc.add(const DailyLogEvent.mealEntryRemoved('m1')),
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

    testWidgets('filling nutrition also fills a usual meal that had none', (
      tester,
    ) async {
      stubSettings(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.breakfast: [UsualMeal(id: 'u', name: 'Eggs')],
          },
        ),
      );
      await pumpRow(tester, entry(usualMealId: 'u'));

      await tester.enterText(find.byType(TextFormField).first, '400');

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealEntryNutritionChanged(
            'm1',
            Nutrition(calories: 400),
          ),
        ),
      ).called(1);
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

      expect(find.text('Update usual meal to match'), findsOneWidget);

      await tester.tap(find.text('Update usual meal to match'));

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

      expect(
        find.text("Clear this usual meal's nutrition"),
        findsOneWidget,
      );
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
  });
}
