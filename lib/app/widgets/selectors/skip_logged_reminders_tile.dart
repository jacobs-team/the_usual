import 'package:flutter/material.dart';

/// {@template skip_logged_reminders_tile}
/// Toggle for whether a reminder is skipped on a day its entry is already
/// logged: a meal reminder once that meal is logged, and the weigh-in reminder
/// once today's weight is logged. Shared by onboarding and settings so both
/// look and behave identically.
/// {@endtemplate}
class SkipLoggedRemindersTile extends StatelessWidget {
  /// {@macro skip_logged_reminders_tile}
  const SkipLoggedRemindersTile({
    required this.skipLoggedMealReminders,
    required this.onChanged,
    super.key,
  });

  /// Whether reminders are skipped once their entry is logged that day.
  final bool skipLoggedMealReminders;

  /// Called with the new value when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Skip when already logged'),
      subtitle: const Text(
        "Don't remind you about a meal or weigh-in you've already logged "
        'that day.',
      ),
      value: skipLoggedMealReminders,
      onChanged: onChanged,
    );
  }
}
