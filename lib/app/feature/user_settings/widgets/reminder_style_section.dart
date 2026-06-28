import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template reminder_style_section}
/// Settings section for choosing how the app checks in about meals.
/// {@endtemplate}
class ReminderStyleSection extends StatelessWidget {
  /// {@macro reminder_style_section}
  const ReminderStyleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, ReminderStyle>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => state.reminderStyle,
      builder: (context, selected) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final reminderStyle in ReminderStyle.values) ...[
              if (reminderStyle != ReminderStyle.values.first)
                SizedBox(height: AppDesign.spacing.sm),
              RadioOptionCard(
                title: reminderStyle.label,
                subtitle: reminderStyle.description,
                selected: reminderStyle == selected,
                onTap: () async {
                  // Switching to notifications needs OS permission. If it
                  // isn't granted, keep the current choice and point the user
                  // to system settings. The service is mobile-only, so on web
                  // there's no permission to request and the choice just sets.
                  if (reminderStyle == ReminderStyle.notifications &&
                      getIt.isRegistered<NotificationService>()) {
                    final status = await getIt<NotificationService>()
                        .requestPermission();
                    if (!status.isGranted) {
                      if (!context.mounted) return;
                      await showDialog<void>(
                        context: context,
                        builder: (_) =>
                            const EnableNotificationsInSettingsDialog(),
                      );
                      return;
                    }
                  }
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.reminderStyleSelected(reminderStyle),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
