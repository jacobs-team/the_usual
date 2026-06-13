import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template meal_reminder_row}
/// A card row for one meal's reminder: meal name, a tappable time chip that
/// opens a time picker, and an enable switch.
/// {@endtemplate}
class MealReminderRow extends StatelessWidget {
  /// {@macro meal_reminder_row}
  const MealReminderRow({
    required this.meal,
    required this.reminder,
    required this.onToggled,
    required this.onTimeChanged,
    super.key,
  });

  /// The meal this reminder belongs to.
  final MealOfTheDay meal;

  /// The reminder being displayed.
  final MealReminder reminder;

  /// Called with the new enabled state when the switch is flipped.
  final ValueChanged<bool> onToggled;

  /// Called with the picked time when a new time is chosen.
  final ValueChanged<TimeOfDay> onTimeChanged;

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminder.time,
    );
    if (picked != null) onTimeChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(meal.label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reminder.enabled)
              ActionChip(
                label: Text(reminder.time.format(context)),
                onPressed: () => _pickTime(context),
              )
            else
              const Text('No reminder'),
            const SizedBox(width: 8),
            Switch(value: reminder.enabled, onChanged: onToggled),
          ],
        ),
      ),
    );
  }
}
