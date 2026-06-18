import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(RemindersView, () {
    late OnboardingBloc onboardingBloc;

    void stubBloc(UserSettingsState settings) {
      when(() => onboardingBloc.state).thenReturn(
        OnboardingState(step: OnboardingStep.reminders, settings: settings),
      );
      when(
        () => onboardingBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      onboardingBloc = MockOnboardingBloc();
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows a reminder style option per style', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      expect(
        find.byType(RadioOptionCard),
        findsNWidgets(ReminderStyle.values.length),
      );
    });

    testWidgets('hides the schedule when reminders are off', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState(reminderStyle: ReminderStyle.none));
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      expect(find.byType(MealScheduleModeSelector), findsNothing);
    });

    testWidgets('shows the schedule when a reminder style is chosen', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      expect(find.byType(MealScheduleModeSelector), findsOneWidget);
      expect(find.byType(MealReminderRow), findsNWidgets(4));
    });

    testWidgets('adds continuePressed from the actions', (tester) async {
      useTallWindow(tester);
      stubBloc(const UserSettingsState(reminderStyle: ReminderStyle.onAppOpen));
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      await tester.tap(find.text('Continue'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });
  });
}
