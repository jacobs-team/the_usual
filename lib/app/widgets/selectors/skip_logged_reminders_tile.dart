import 'package:flutter/material.dart';

/// {@template skip_logged_reminders_tile}
/// Toggle for whether a per-meal reminder is skipped on a day that meal
/// already has a logged entry. Shared by onboarding and settings so both look
/// and behave identically.
/// {@endtemplate}
class SkipLoggedRemindersTile extends StatelessWidget {
  /// {@macro skip_logged_reminders_tile}
  const SkipLoggedRemindersTile({
    required this.skipLoggedMealReminders,
    required this.onChanged,
    super.key,
  });

  /// Whether already-logged meals are skipped for reminders.
  final bool skipLoggedMealReminders;

  /// Called with the new value when the user toggles the switch.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Skip when already logged'),
      subtitle: const Text(
        "Don't remind you about a meal you've already logged that day.",
      ),
      value: skipLoggedMealReminders,
      onChanged: onChanged,
    );
  }
}
