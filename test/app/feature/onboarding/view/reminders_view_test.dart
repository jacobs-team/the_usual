import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';
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
      // A non-notifications style avoids the permission prompt on Continue.
      stubBloc(const UserSettingsState(reminderStyle: ReminderStyle.none));
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      await tester.tap(find.text('Continue'));

      verify(
        () => onboardingBloc.add(const OnboardingEvent.continuePressed()),
      ).called(1);
    });

    testWidgets('forwards the per-meal schedule interactions to the bloc', (
      tester,
    ) async {
      useTallWindow(tester);
      stubBloc(
        const UserSettingsState(
          mealReminders: {
            MealOfTheDay.breakfast: MealReminder(
              enabled: true,
              timeOfDay: TimeOfDay(hour: 8, minute: 0),
            ),
          },
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      // Pick a reminder style (the last card is "don't remind me").
      await tester.tap(find.byType(RadioOptionCard).last);
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.reminderStyleSelected(ReminderStyle.none),
        ),
      ).called(1);

      // Switch the check-in schedule mode.
      await tester.tap(find.text(MealCheckinScheduleMode.endOfDay.label));
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealCheckinScheduleModeChanged(
            MealCheckinScheduleMode.endOfDay,
          ),
        ),
      ).called(1);

      // Toggle the breakfast reminder off (its row switch comes first).
      await tester.tap(find.byType(Switch).first);
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealReminderToggled(
            MealOfTheDay.breakfast,
            enabled: false,
          ),
        ),
      ).called(1);

      // Toggle the skip-logged setting on.
      await tester.tap(find.byType(SwitchListTile));
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.skipLoggedMealRemindersChanged(
            skipLoggedMealReminders: true,
          ),
        ),
      ).called(1);

      // Change the breakfast reminder time via the picker.
      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.mealReminderTimeChanged(
            MealOfTheDay.breakfast,
            TimeOfDay(hour: 8, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('changes the end-of-day reminder time via the picker', (
      tester,
    ) async {
      useTallWindow(tester);
      // The default end-of-day reminder is 8:00 PM, which the picker keeps.
      stubBloc(
        const UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc],
        const RemindersView(),
      );

      await tester.tap(find.byType(ActionChip));
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

    testWidgets('reverts and explains when notifications are denied', (
      tester,
    ) async {
      useTallWindow(tester);
      final notificationService = MockNotificationService();
      when(
        notificationService.requestPermission,
      ).thenAnswer((_) async => PermissionStatus.denied);
      // The default reminder style is notifications, which prompts the OS.
      stubBloc(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [onboardingBloc, notificationService],
        const RemindersView(),
      );

      await tester.tap(
        find.descendant(
          of: find.byType(OnboardingActions),
          matching: find.byType(FilledButton),
        ),
      );
      await tester.pumpAndSettle();

      verify(
        () => onboardingBloc.add(
          const OnboardingEvent.reminderStyleSelected(ReminderStyle.none),
        ),
      ).called(1);
      expect(
        find.byType(EnableNotificationsInSettingsDialog),
        findsOneWidget,
      );
    });
  });
}
