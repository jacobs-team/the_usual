import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(WorkoutReminderRow, () {
    Future<void> pumpRow(
      WidgetTester tester, {
      required WorkoutReminder workoutReminder,
      ValueChanged<bool>? onToggled,
      void Function(int dayOfWeek, {required bool enabled})? onDayToggled,
      ValueChanged<TimeOfDay>? onTimeChanged,
    }) {
      return tester.pumpPumpPumpItUP(
        WorkoutReminderRow(
          workoutReminder: workoutReminder,
          onToggled: onToggled ?? (_) {},
          onDayToggled: onDayToggled ?? (_, {required enabled}) {},
          onTimeChanged: onTimeChanged ?? (_) {},
        ),
      );
    }

    testWidgets('disabled reminder hides the time chip and day chips', (
      tester,
    ) async {
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        ),
      );

      expect(find.byType(ActionChip), findsNothing);
      expect(find.byType(FilterChip), findsNothing);
    });

    testWidgets('enabled reminder shows the time chip and seven day chips', (
      tester,
    ) async {
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
          daysOfWeek: {1, 3},
        ),
      );

      expect(find.byType(ActionChip), findsOneWidget);
      expect(find.byType(FilterChip), findsNWidgets(7));
    });

    testWidgets('toggling the switch calls onToggled', (tester) async {
      bool? toggled;
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        ),
        onToggled: (value) => toggled = value,
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(toggled, isTrue);
    });

    testWidgets('tapping a day chip calls onDayToggled', (tester) async {
      int? toggledDay;
      bool? toggledEnabled;
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        ),
        onDayToggled: (dayOfWeek, {required enabled}) {
          toggledDay = dayOfWeek;
          toggledEnabled = enabled;
        },
      );

      await tester.tap(find.byKey(const Key('workout-day-1')));
      await tester.pump();

      expect(toggledDay, equals(1));
      expect(toggledEnabled, isTrue);
    });

    testWidgets('picking a time from the chip calls onTimeChanged', (
      tester,
    ) async {
      TimeOfDay? picked;
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        ),
        onTimeChanged: (time) => picked = time,
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();

      // Confirm the picker with its OK action, accepting the initial time.
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(picked, equals(const TimeOfDay(hour: 18, minute: 0)));
    });

    testWidgets('cancelling the time picker leaves onTimeChanged uncalled', (
      tester,
    ) async {
      var called = false;
      await pumpRow(
        tester,
        workoutReminder: const WorkoutReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        ),
        onTimeChanged: (_) => called = true,
      );

      await tester.tap(find.byType(ActionChip));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(called, isFalse);
    });
  });
}
