import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:the_usual/app/app.dart';

/// {@template replay_onboarding_row}
/// Settings row that wipes all saved app data and navigates back into the
/// onboarding flow.
/// {@endtemplate}
class ReplayOnboardingRow extends StatelessWidget {
  /// {@macro replay_onboarding_row}
  const ReplayOnboardingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNavRow(
      title: 'Reset app',
      subtitle:
          'Clears all saved data and resets to defaults. Restarts onboarding',
      onTap: () async {
        await HydratedBloc.storage.clear();
        if (context.mounted) context.go(Routes.onboarding);
      },
    );
  }
}
