import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template end_of_day_reminder_row}
/// A card row for the single daily check-in covering all meals, with a
/// tappable time chip that opens a time picker.
/// {@endtemplate}
class EndOfDayReminderRow extends StatelessWidget {
  /// {@macro end_of_day_reminder_row}
  const EndOfDayReminderRow({
    required this.reminder,
    required this.onTimeChanged,
    super.key,
  });

  /// The reminder being displayed.
  final MealReminder reminder;

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
        title: const Text('Daily check-in'),
        subtitle: const Text('Covers all meals at once'),
        trailing: ActionChip(
          label: Text(reminder.time.format(context)),
          onPressed: () => _pickTime(context),
        ),
      ),
    );
  }
}
