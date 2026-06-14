import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(MealScheduleView, () {
    late OnboardingBloc onboardingBloc;

    void stubBloc(UserSettingsState settings) {
      when(() => onboardingBloc.state).thenReturn(
        OnboardingState(activeStepIndex: 3, settings: settings),
      );
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
      registerFallbackValue(const TimeOfDay(hour: 0, minute: 0));
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('renders a reminder row per meal in per-meal mode', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const MealScheduleView(),
      );

      expect(find.byType(MealReminderRow), findsNWidgets(4));
    });

    testWidgets('changes schedule mode from the selector', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const MealScheduleView(),
      );

      await tester.tap(find.text(MealCheckinScheduleMode.endOfDay.label));

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealCheckinScheduleModeChanged(
            MealCheckinScheduleMode.endOfDay,
          ),
        ),
      ).called(1);
    });

    testWidgets('toggles and retimes a meal reminder', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const MealScheduleView(),
      );

      await tester.tap(find.byType(Switch).first);
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
      ).called(1);

      await tester.tap(find.byType(ActionChip).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealReminderTimeChanged(
            MealOfTheDay.breakfast,
            TimeOfDay(hour: 9, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('shows the end-of-day row and retimes it', (tester) async {
      useTallWindow(tester);
      stubBloc(
        const UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const MealScheduleView(),
      );

      expect(find.byType(EndOfDayReminderRow), findsOneWidget);

      await tester.tap(find.byType(ActionChip).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.endOfDayTimeChanged(
            TimeOfDay(hour: 20, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('adds continuePressed from the actions', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const MealScheduleView(),
      );

      await tester.tap(find.text('Continue'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });
  });
}
