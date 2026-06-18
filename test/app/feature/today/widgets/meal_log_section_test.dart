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
        loggedAt: DateTime.now(),
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
      bool isCurrent = false,
      bool nutritionExpandedByDefault = false,
      DateTime? day,
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
              isCurrent: isCurrent,
              nutritionExpandedByDefault: nutritionExpandedByDefault,
              day: day,
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

      expect(find.text('350 cal · 0P · 0C · 0F'), findsOneWidget);
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

      expect(find.text('+ Oatmeal'), findsOneWidget);

      await tester.tap(find.text('+ Oatmeal'));

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
        day: DateTime(2026, 6, 16),
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(find.text('+ Oatmeal'));

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

    testWidgets('logs something else and adds it to usuals when checked', (
      tester,
    ) async {
      await pumpSection(tester);

      await tester.tap(find.text('Something else'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Burrito');
      await tester.pump();
      await tester.tap(find.text('Log'));
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.usualMealAdded(
            MealOfTheDay.breakfast,
            'Burrito',
            Nutrition(),
          ),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          const DailyLogEvent.mealLogged(MealOfTheDay.breakfast, 'Burrito'),
        ),
      ).called(1);
    });

    testWidgets('does not add to usuals when the checkbox is cleared', (
      tester,
    ) async {
      await pumpSection(tester);

      await tester.tap(find.text('Something else'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField).first, 'Burrito');
      await tester.pump();
      await tester.tap(find.byType(Checkbox));
      await tester.pump();
      await tester.tap(find.text('Log'));
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

      expect(find.text('From another meal'), findsOneWidget);

      await tester.tap(find.text('From another meal'));
      await tester.pumpAndSettle();

      expect(find.byType(OtherMealUsualsSheet), findsOneWidget);
    });

    testWidgets('cancelling the sheet logs nothing', (tester) async {
      await pumpSection(tester);

      await tester.tap(find.text('Something else'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => dailyLogBloc.add(any(that: isA<MealLogged>())));
    });
  });
}
