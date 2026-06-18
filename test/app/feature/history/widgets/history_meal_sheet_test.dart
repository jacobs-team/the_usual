import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(HistoryMealSheet, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    final day = DateTime(2026, 6, 16);

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.dinner: [
              UsualMeal(
                id: 'd',
                name: 'Tacos',
                nutrition: Nutrition(calories: 650),
              ),
            ],
          },
        ),
      );
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      registerFallbackValue(
        const DailyLogEvent.mealLogged(MealOfTheDay.dinner, 'x'),
      );
    });

    testWidgets('shows the meal card with that meal\'s quick picks', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        HistoryMealSheet(mealOfTheDay: MealOfTheDay.dinner, day: day),
      );

      expect(find.byType(MealLogSection), findsOneWidget);
      expect(find.text('+ Tacos'), findsOneWidget);
    });

    testWidgets('logs a quick pick onto the given day', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        HistoryMealSheet(mealOfTheDay: MealOfTheDay.dinner, day: day),
      );

      await tester.tap(find.text('+ Tacos'));

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.dinner,
            'Tacos',
            nutrition: const Nutrition(calories: 650),
            usualMealId: 'd',
            day: day,
            dayStart: const TimeOfDay(hour: 0, minute: 0),
          ),
        ),
      ).called(1);
    });
  });
}
