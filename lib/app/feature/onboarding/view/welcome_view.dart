import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template welcome_view}
/// First onboarding screen: the value prop and the account choice. Signing in
/// backs up and syncs to the cloud; staying offline keeps everything local as a
/// guest. A returning account with cloud data skips the rest of onboarding.
/// {@endtemplate}
class WelcomeView extends StatelessWidget {
  /// {@macro welcome_view}
  const WelcomeView({super.key});

  void _continueOnboarding() =>
      getIt<OnboardingBloc>().add(const OnboardingEvent.continuePressed());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return OnboardingScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('The Usual', style: theme.textTheme.headlineLarge),
          const Spacer(),
          Text(
            'Track what you eat in two taps.',
            style: theme.textTheme.headlineMedium,
          ),
          SizedBox(height: AppDesign.spacing.md),
          const Text(
            'Set up your usual meals once and logging takes seconds.',
          ),
          const Spacer(),
          GoogleSignInButton(
            onSignedIn: () {
              // Cancelled sign-in leaves the user on this screen to choose
              // again. A signed-in existing account has onboarding marked
              // complete already (the router moves to the app); a new account
              // continues onboarding from here.
              if (!getIt<AuthCubit>().state.signedIn) return;
              if (getIt<OnboardingBloc>().state.step !=
                  OnboardingStep.complete) {
                _continueOnboarding();
              }
            },
          ),
          SizedBox(height: AppDesign.spacing.xs),
          Text(
            'Backs up your meals and settings and syncs them across your '
            'devices.',
            style: captionStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDesign.spacing.md),
          OutlinedButton(
            onPressed: () {
              getIt<AuthCubit>().continueAsGuest();
              _continueOnboarding();
            },
            child: const Text('Keep it offline'),
          ),
          SizedBox(height: AppDesign.spacing.xs),
          Text(
            'Keeps everything on this device only. You can sign in later to '
            'back up.',
            style: captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
