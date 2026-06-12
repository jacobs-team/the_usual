import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template complete_view}
/// Shown when onboarding finishes. Offers a reset until the home/log
/// feature exists to route to.
/// {@endtemplate}
class CompleteView extends StatelessWidget {
  /// {@macro complete_view}
  const CompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You're all set."),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => getIt<OnboardingBloc>().add(
                const OnboardingEvent.resetPressed(),
              ),
              child: const Text('Reset app state'),
            ),
          ],
        ),
      ),
    );
  }
}
