import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
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
              const Center(child: Text("You're all set.")),
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
