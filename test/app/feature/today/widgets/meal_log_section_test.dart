import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(MealLogSection, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      registerFallbackValue(
        const DailyLogEvent.mealEntryRemoved('x'),
      );
      registerFallbackValue(
        const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'x'),
      );
    });

    MealLogEntry logged(String id, String name, {int? calories}) {
      return MealLogEntry(
        id: id,
        loggedAt: testNow,
        mealOfTheDay: MealOfTheDay.breakfast,
        name: name,
        nutrition: Nutrition(calories: calories),
      );
    }

    Future<void> pumpSection(
      WidgetTester tester, {
      List<MealLogEntry> mealLogEntries = const [],
      List<UsualMeal> quickPicks = const [],
      Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals = const {},
      List<MealLogEntry> sameAsYesterday = const [],
      bool isCurrent = false,
      bool nutritionExpandedByDefault = false,
      List<DateTime>? logDays,
      TimeOfDay? dayStart,
    }) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        CustomScrollView(
          slivers: [
            MealLogSection(
              mealOfTheDay: MealOfTheDay.breakfast,
              mealLogEntries: mealLogEntries,
              quickPicks: quickPicks,
              otherMealUsuals: otherMealUsuals,
              sameAsYesterday: sameAsYesterday,
              isCurrent: isCurrent,
              nutritionExpandedByDefault: nutritionExpandedByDefault,
              logDays: logDays,
              dayStart: dayStart,
            ),
          ],
        ),
      );
    }

    testWidgets('shows the calorie total and logged rows when current', (
      tester,
    ) async {
      // Expanded so the section total is the only place the summary renders,
      // not also the collapsed row summary. The total zero-fills the macros it
      // sums.
      await pumpSection(
        tester,
        mealLogEntries: [logged('a', 'Eggs', calories: 350)],
        isCurrent: true,
        nutritionExpandedByDefault: true,
      );

      final summary = tester.widget<NutritionSummary>(
        find.byType(NutritionSummary),
      );
      expect(summary.nutrition.calories, equals(350));
      expect(find.byType(LoggedEntryRow), findsOneWidget);
    });

    testWidgets('renders a quick pick chip and logs it when tapped', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualMeal(
            id: 'u',
            name: 'Oatmeal',
            nutrition: Nutrition(calories: 300),
          ),
        ],
      );

      final chip = find.descendant(
        of: find.byType(MenuAnchor),
        matching: find.byType(InkWell),
      );
      expect(chip, findsOneWidget);

      await tester.tap(chip);

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: Nutrition(calories: 300),
            usualMealId: 'u',
          ),
        ),
      ).called(1);
    });

    testWidgets('forwards day and dayStart when logging a quick pick', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualMeal(
            id: 'u',
            name: 'Oatmeal',
            nutrition: Nutrition(calories: 300),
          ),
        ],
        logDays: [DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(
        find.descendant(
          of: find.byType(MenuAnchor),
          matching: find.byType(InkWell),
        ),
      );

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: const Nutrition(calories: 300),
            usualMealId: 'u',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('logs a quick pick onto every day in a multi-day range', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualMeal(
            id: 'u',
            name: 'Oatmeal',
            nutrition: Nutrition(calories: 300),
          ),
        ],
        logDays: [DateTime(2026, 6, 15), DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(
        find.descendant(
          of: find.byType(MenuAnchor),
          matching: find.byType(InkWell),
        ),
      );

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: const Nutrition(calories: 300),
            usualMealId: 'u',
            day: DateTime(2026, 6, 15),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: const Nutrition(calories: 300),
            usualMealId: 'u',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('removing a quick pick from its menu drops it from usuals', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualMeal(
            id: 'u',
            name: 'Oatmeal',
            nutrition: Nutrition(calories: 300),
          ),
        ],
      );

      final chip = find.descendant(
        of: find.byType(MenuAnchor),
        matching: find.byType(InkWell),
      );
      await tester.longPress(chip);
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealRemoved(MealOfTheDay.breakfast, 'u'),
        ),
      ).called(1);
    });

    testWidgets('logs something else and adds it to usuals when checked', (
      tester,
    ) async {
      // Saving as a usual goes through saveAsUsualMeal, which returns the id to
      // stamp onto the logged entry so the link is set at log time.
      when(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Burrito',
          const Nutrition(),
        ),
      ).thenReturn('new-id');

      await pumpSection(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Burrito');
      await tester.pump();
      // The section's own "Something else" button is still mounted behind the
      // sheet, so scope to the sheet's confirm button.
      await tester.tap(
        find.descendant(
          of: find.byType(FoodEntrySheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.saveAsUsualMeal(
          MealOfTheDay.breakfast,
          'Burrito',
          const Nutrition(),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Burrito',
            usualMealId: 'new-id',
          ),
        ),
      ).called(1);
    });

    testWidgets('does not add to usuals when the checkbox is cleared', (
      tester,
    ) async {
      await pumpSection(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Burrito');
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      // The section's own "Something else" button is still mounted behind the
      // sheet, so scope to the sheet's confirm button.
      await tester.tap(
        find.descendant(
          of: find.byType(FoodEntrySheet),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      verifyNever(
        () => userSettingsBloc.add(
          any(that: isA<SettingsUsualMealAdded>()),
        ),
      );
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(MealOfTheDay.breakfast, 'Burrito'),
        ),
      ).called(1);
    });

    testWidgets('opens the from-another-meal picker when usuals exist', (
      tester,
    ) async {
      await pumpSection(
        tester,
        otherMealUsuals: const {
          MealOfTheDay.lunch: [UsualMeal(id: 'u', name: 'Salad')],
        },
      );

      await tester.tap(find.byIcon(Icons.restaurant_menu));
      await tester.pumpAndSettle();

      expect(find.byType(OtherMealUsualsSheet), findsOneWidget);
    });

    testWidgets('cancelling the sheet logs nothing', (tester) async {
      await pumpSection(tester);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      // A fresh sheet has one row, so the only close icon is the sheet's.
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      verifyNever(() => dailyLogBloc.add(any(that: isA<MealLogged>())));
    });

    testWidgets('re-logs every prior-day entry when copy previous is tapped', (
      tester,
    ) async {
      final yesterday = [
        logged('y1', 'Eggs', calories: 200),
        logged('y2', 'Coffee', calories: 5),
      ];
      // No entries logged today, so the header offers the copy-previous
      // shortcut instead of a nutrition summary.
      await pumpSection(tester, sameAsYesterday: yesterday);

      await tester.tap(find.byType(CopyPreviousButton));

      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Eggs',
            nutrition: Nutrition(calories: 200),
          ),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Coffee',
            nutrition: Nutrition(calories: 5),
          ),
        ),
      ).called(1);
    });
  });
}
