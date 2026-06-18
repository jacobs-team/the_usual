import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template onboarding_view}
/// Hosts the onboarding flow, rendering the screen for the
/// current [OnboardingStep].
/// {@endtemplate}
class OnboardingView extends StatelessWidget {
  /// {@macro onboarding_view}
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, OnboardingStep>(
      bloc: getIt<OnboardingBloc>(),
      selector: (state) => state.step,
      builder: (context, step) {
        return switch (step) {
          OnboardingStep.welcome => const WelcomeView(),
          OnboardingStep.buildUsuals => const BuildUsualsView(),
          OnboardingStep.firstLog => const FirstLogView(),
          OnboardingStep.reminders => const RemindersView(),
          OnboardingStep.weightTracking => const WeightTrackingView(),
          OnboardingStep.goals => const GoalsView(),
          OnboardingStep.complete => const CompleteView(),
        };
      },
    );
  }
}
