import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template welcome_view}
/// First onboarding screen: value prop and a single CTA to start the flow.
/// {@endtemplate}
class WelcomeView extends StatelessWidget {
  /// {@macro welcome_view}
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'The Usual',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Spacer(),
              Text(
                'Track what you eat in two taps.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              const Text(
                'Set up your usual meals once and logging takes seconds.',
              ),
              const Spacer(),
              OnboardingActions(
                primary: FilledButton(
                  onPressed: () => getIt<OnboardingBloc>().add(
                    const OnboardingEvent.continuePressed(),
                  ),
                  child: const Text('Get started'),
                ),
                above: const Center(
                  child: Text(
                    'No account needed. Your data stays on your phone.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
