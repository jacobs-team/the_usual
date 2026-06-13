import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template replay_onboarding_row}
/// Settings row that resets the onboarding flow and navigates back into it.
/// {@endtemplate}
class ReplayOnboardingRow extends StatelessWidget {
  /// {@macro replay_onboarding_row}
  const ReplayOnboardingRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        title: const Text('Replay onboarding'),
        subtitle: const Text(
          'Start setup again. Resets these choices to defaults.',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          getIt<OnboardingBloc>().add(const OnboardingEvent.resetPressed());
          context.go(Routes.onboarding);
        },
      ),
    );
  }
}
