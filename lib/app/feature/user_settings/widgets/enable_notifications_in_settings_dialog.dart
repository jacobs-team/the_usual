import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template enable_notifications_in_settings_dialog}
/// Shown when notification permission is denied. Explains that notifications
/// are off and offers to open the app's OS settings page to turn them on.
/// {@endtemplate}
class EnableNotificationsInSettingsDialog extends StatelessWidget {
  /// {@macro enable_notifications_in_settings_dialog}
  const EnableNotificationsInSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Notifications are off'),
      content: const Text(
        'Turn on notifications for The Usual in your system settings to get '
        'meal and weight reminders.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Not now'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await getIt<NotificationService>().openSystemSettings();
          },
          child: const Text('Open settings'),
        ),
      ],
    );
  }
}
