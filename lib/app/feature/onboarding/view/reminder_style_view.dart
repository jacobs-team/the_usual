import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template reminder_style_view}
/// Third onboarding screen: choose how the app checks in about meals.
/// {@endtemplate}
class ReminderStyleView extends StatelessWidget {
  /// {@macro reminder_style_view}
  const ReminderStyleView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.reminderStyle),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocSelector<OnboardingBloc, OnboardingState, ReminderStyle>(
            bloc: getIt<OnboardingBloc>(),
            selector: (state) => state.settings.reminderStyle,
            builder: (context, selected) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'How should we check in?',
                    style: textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('We ask if you ate. You tap what it was.'),
                  const SizedBox(height: 20),
                  for (final reminderStyle in ReminderStyle.values) ...[
                    if (reminderStyle != ReminderStyle.values.first)
                      const SizedBox(height: 12),
                    RadioOptionCard(
                      title: reminderStyle.label,
                      subtitle: reminderStyle.description,
                      note: reminderStyle == ReminderStyle.notifications
                          ? "We'll ask for permission next."
                          : null,
                      selected: reminderStyle == selected,
                      onTap: () => getIt<OnboardingBloc>().add(
                        OnboardingEvent.reminderStyleSelected(reminderStyle),
                      ),
                    ),
                  ],
                  const Spacer(),
                  OnboardingActions(
                    primary: FilledButton(
                      onPressed: () => getIt<OnboardingBloc>().add(
                        const OnboardingEvent.continuePressed(),
                      ),
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
