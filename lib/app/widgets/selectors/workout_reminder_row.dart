import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workout_reminder_row}
/// A card row for the workout reminder: an enable switch, a tappable time chip
/// when enabled, and a row of day-of-week filter chips (Mon–Sun).
/// {@endtemplate}
class WorkoutReminderRow extends StatelessWidget {
  /// {@macro workout_reminder_row}
  const WorkoutReminderRow({
    required this.workoutReminder,
    required this.onToggled,
    required this.onDayToggled,
    required this.onTimeChanged,
    super.key,
  });

  /// The reminder being displayed.
  final WorkoutReminder workoutReminder;

  /// Called with the new enabled state when the switch is flipped.
  final ValueChanged<bool> onToggled;

  /// Called with the day of week (1–7) and new selected state when a day chip
  /// is tapped.
  final void Function(int dayOfWeek, bool enabled) onDayToggled;

  /// Called with the picked time when a new time is chosen.
  final ValueChanged<TimeOfDay> onTimeChanged;

  static const _dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Workout reminder'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (workoutReminder.enabled)
                  ActionChip(
                    label: Text(workoutReminder.timeOfDay.format(context)),
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: workoutReminder.timeOfDay,
                      );
                      if (picked != null) onTimeChanged(picked);
                    },
                  )
                else
                  const Text('No reminder'),
                SizedBox(width: AppDesign.spacing.sm),
                Switch(value: workoutReminder.enabled, onChanged: onToggled),
              ],
            ),
          ),
          if (workoutReminder.enabled)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppDesign.spacing.md,
                0,
                AppDesign.spacing.md,
                AppDesign.spacing.sm,
              ),
              child: Wrap(
                spacing: AppDesign.spacing.xs,
                children: [
                  for (var i = 0; i < _dayLabels.length; i++)
                    FilterChip(
                      key: Key('workout-day-${i + 1}'),
                      label: Text(_dayLabels[i]),
                      selected: workoutReminder.daysOfWeek.contains(i + 1),
                      onSelected: (selected) => onDayToggled(i + 1, selected),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
