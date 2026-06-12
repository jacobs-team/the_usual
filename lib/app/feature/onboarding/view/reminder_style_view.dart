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
                  _ReminderOption(
                    style: ReminderStyle.notifications,
                    title: 'Notifications',
                    subtitle: 'A quick nudge at your meal times.',
                    note: "We'll ask for permission next.",
                    selected: selected == ReminderStyle.notifications,
                  ),
                  const SizedBox(height: 12),
                  _ReminderOption(
                    style: ReminderStyle.onAppOpen,
                    title: 'When I open the app',
                    subtitle: 'No pings. We ask when you launch.',
                    selected: selected == ReminderStyle.onAppOpen,
                  ),
                  const SizedBox(height: 12),
                  _ReminderOption(
                    style: ReminderStyle.none,
                    title: "Don't remind me",
                    subtitle: 'Log on your own schedule.',
                    selected: selected == ReminderStyle.none,
                  ),
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

class _ReminderOption extends StatelessWidget {
  const _ReminderOption({
    required this.style,
    required this.title,
    required this.subtitle,
    required this.selected,
    this.note,
  });

  final ReminderStyle style;
  final String title;
  final String subtitle;
  final String? note;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => getIt<OnboardingBloc>().add(
        OnboardingEvent.reminderStyleSelected(style),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall),
                  if (note != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      note!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: selected ? theme.colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}
