import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_reminder_row}
/// A card row for one meal's reminder: meal name, a tappable time chip that
/// opens a time picker, and an enable switch.
/// {@endtemplate}
class MealReminderRow extends StatelessWidget {
  /// {@macro meal_reminder_row}
  const MealReminderRow({
    required this.mealOfTheDay,
    required this.mealReminder,
    required this.onToggled,
    required this.onTimeChanged,
    super.key,
  });

  /// The meal this reminder belongs to.
  final MealOfTheDay mealOfTheDay;

  /// The reminder being displayed.
  final MealReminder mealReminder;

  /// Called with the new enabled state when the switch is flipped.
  final ValueChanged<bool> onToggled;

  /// Called with the picked time when a new time is chosen.
  final ValueChanged<TimeOfDay> onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(mealOfTheDay.label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (mealReminder.enabled)
              ActionChip(
                label: Text(mealReminder.timeOfDay.format(context)),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: mealReminder.timeOfDay,
                  );
                  if (picked != null) onTimeChanged(picked);
                },
              )
            else
              const Text('No reminder'),
            const SizedBox(width: 8),
            Switch(value: mealReminder.enabled, onChanged: onToggled),
          ],
        ),
      ),
    );
  }
}
