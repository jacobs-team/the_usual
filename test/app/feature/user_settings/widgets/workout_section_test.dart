import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutSection, () {
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

    testWidgets(
      'tapping the kg chip dispatches workoutWeightUnitSelected(kg)',
      (tester) async {
        stub(const UserSettingsState());
        await tester.pumpPumpPumpItUP(
          deps: [userSettingsBloc],
          const WorkoutSection(),
        );

        await tester.tap(find.byKey(const Key('workout-unit-kg')));

        verify(
          () => userSettingsBloc.add(
            const UserSettingsEvent.workoutWeightUnitSelected(WeightUnit.kg),
          ),
        ).called(1);
      },
    );

    testWidgets('toggling the reminder switch dispatches '
        'workoutReminderToggled(enabled: true)', (tester) async {
      stub(
        const UserSettingsState(),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WorkoutSection(),
      );

      await tester.tap(find.byType(Switch));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.workoutReminderToggled(enabled: true),
        ),
      ).called(1);
    });

    testWidgets('picking a reminder time dispatches '
        'workoutReminderTimeChanged', (tester) async {
      tester.view.physicalSize = const Size(1600, 3200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      stub(
        const UserSettingsState(
          workoutReminder: WorkoutReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 18, minute: 0),
          ),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WorkoutSection(),
      );

      // The time chip is the only ActionChip shown when the reminder is on.
      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();

      // Confirm the time picker dialog. Its OK/Cancel are the dialog's
      // TextButtons; OK is the trailing one.
      await tester.tap(find.byType(TextButton).last);
      await tester.pumpAndSettle();

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.workoutReminderTimeChanged(
            TimeOfDay(hour: 18, minute: 0),
          ),
        ),
      ).called(1);
    });

    testWidgets('tapping day chip 3 dispatches '
        'workoutReminderDayToggled(3, enabled: true)', (tester) async {
      stub(
        const UserSettingsState(
          workoutReminder: WorkoutReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 18, minute: 0),
          ),
        ),
      );
      await tester.pumpPumpPumpItUP(
        deps: [userSettingsBloc],
        const WorkoutSection(),
      );

      await tester.tap(find.byKey(const Key('workout-day-3')));

      verify(
        () => userSettingsBloc.add(
          const UserSettingsEvent.workoutReminderDayToggled(3, enabled: true),
        ),
      ).called(1);
    });
  });
}
