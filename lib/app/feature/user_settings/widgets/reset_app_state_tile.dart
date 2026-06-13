import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:the_usual/app/app.dart';

/// {@template reset_app_state_tile}
/// Settings tile that, after confirmation, wipes all saved app data and
/// returns to onboarding.
/// {@endtemplate}
class ResetAppStateTile extends StatelessWidget {
  /// {@macro reset_app_state_tile}
  const ResetAppStateTile({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNavRow(
      title: 'Reset app',
      subtitle:
          'Clears all saved data and resets to defaults. Restarts onboarding',
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Reset app?'),
            content: const Text(
              'This clears all your saved data and resets everything to '
              'defaults. It cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Reset'),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
        await HydratedBloc.storage.clear();
        if (context.mounted) context.go(Routes.onboarding);
      },
    );
  }
}
