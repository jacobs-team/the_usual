import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(MealScheduleSection, () {
    late UserSettingsBloc userSettingsBloc;

    void stub(UserSettingsState state) {
      when(() => userSettingsBloc.state).thenReturn(state);
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    }

    setUp(() {
      userSettingsBloc = MockUserSettingsBloc();
      registerFallbackValue(const TimeOfDay(hour: 0, minute: 0));
    });

    void useTallWindow(WidgetTester tester) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
    }

    testWidgets('shows an off notice when reminders are off', (tester) async {
      stub(const UserSettingsState(reminderStyle: ReminderStyle.none));
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      expect(find.byType(InfoBox), findsOneWidget);
    });

    testWidgets('shows a reminder row per meal in per-meal mode', (
      tester,
    ) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      expect(find.byType(MealReminderRow), findsNWidgets(4));
    });

    testWidgets('toggles and retimes a meal reminder', (tester) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      await tester.tap(find.byType(Switch).first);
      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.mealReminderToggled(
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
        () => userSettingsBloc.add(
          const UserSettingsEvent.mealReminderTimeChanged(
            MealOfTheDay.breakfast,
            TimeOfDay(hour: 9, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('changes the schedule mode from the selector', (tester) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      // Segments render in MealCheckinScheduleMode.values order.
      final endOfDaySegment = find
          .descendant(
            of: find.byType(MealScheduleModeSelector),
            matching: find.byType(TextButton),
          )
          .at(
            MealCheckinScheduleMode.values.indexOf(
              MealCheckinScheduleMode.endOfDay,
            ),
          );
      await tester.tap(endOfDaySegment);

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.mealCheckinScheduleModeChanged(
            MealCheckinScheduleMode.endOfDay,
          ),
        ),
      ).called(1);
    });

    testWidgets('toggles skip-when-logged reminders', (tester) async {
      useTallWindow(tester);
      stub(const UserSettingsState());
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      await tester.tap(
        find.descendant(
          of: find.byType(SkipLoggedRemindersTile),
          matching: find.byType(Switch),
        ),
      );

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.skipLoggedMealRemindersChanged(
            skipLoggedMealReminders: true,
          ),
        ),
      ).called(1);
    });

    testWidgets('shows and retimes the end-of-day row', (tester) async {
      useTallWindow(tester);
      stub(
        const UserSettingsState(
          mealCheckinScheduleMode: MealCheckinScheduleMode.endOfDay,
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const MealScheduleSection(),
      );

      expect(find.byType(EndOfDayReminderRow), findsOneWidget);

      await tester.tap(find.byType(ActionChip).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.endOfDayTimeChanged(
            TimeOfDay(hour: 20, minute: 0),
          ),
        ),
      ).called(1);
    });
  });
}
