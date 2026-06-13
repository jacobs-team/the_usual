import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template complete_view}
/// Shown when onboarding finishes. Routes the user home or to settings.
/// {@endtemplate}
class CompleteView extends StatelessWidget {
  /// {@macro complete_view}
  const CompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("You're all set."),
                    SizedBox(height: AppDesign.spacing.lg),
                    OutlinedButton(
                      onPressed: () => getIt<OnboardingBloc>().add(
                        const OnboardingEvent.resetPressed(),
                      ),
                      child: const Text('Reset app state'),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              OnboardingActions(
                primary: FilledButton(
                  onPressed: () => context.go(Routes.today),
                  child: const Text('Done'),
                ),
                secondary: TextButton(
                  onPressed: () => context.go(Routes.settings),
                  child: const Text('Adjust settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
