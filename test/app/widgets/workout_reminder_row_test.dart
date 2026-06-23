import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../helpers/helpers.dart';

void main() {
  group(WorkoutReminderRow, () {
    testWidgets('reports the toggle through onToggled', (tester) async {
      bool? toggled;
      await tester.pumpPumpPumpItUP(
        WorkoutReminderRow(
          workoutReminder: const WorkoutReminder(
            enabled: true,
            timeOfDay: TimeOfDay(hour: 18, minute: 0),
          ),
          onToggled: (value) => toggled = value,
          onDayToggled: (_, {required enabled}) {},
          onTimeChanged: (_) {},
        ),
      );

      await tester.tap(find.byType(Switch));

      expect(toggled, isFalse);
    });

    testWidgets(
      'tapping a day chip reports onDayToggled with the correct dayOfWeek',
      (tester) async {
        int? reportedDay;
        bool? reportedEnabled;
        await tester.pumpPumpPumpItUP(
          WorkoutReminderRow(
            workoutReminder: const WorkoutReminder(
              enabled: true,
              timeOfDay: TimeOfDay(hour: 18, minute: 0),
            ),
            onToggled: (_) {},
            onDayToggled: (day, {required enabled}) {
              reportedDay = day;
              reportedEnabled = enabled;
            },
            onTimeChanged: (_) {},
          ),
        );

        await tester.tap(find.byKey(const Key('workout-day-3')));

        expect(reportedDay, equals(3));
        expect(reportedEnabled, isTrue);
      },
    );

    testWidgets('day chips are hidden when disabled', (tester) async {
      await tester.pumpPumpPumpItUP(
        WorkoutReminderRow(
          workoutReminder: const WorkoutReminder(
            timeOfDay: TimeOfDay(hour: 18, minute: 0),
          ),
          onToggled: (_) {},
          onDayToggled: (_, {required enabled}) {},
          onTimeChanged: (_) {},
        ),
      );

      expect(find.byType(FilterChip), findsNothing);
    });
  });
}
