import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template meal_schedule_view}
/// Fourth onboarding screen: pick per-meal reminder times or a single
/// end-of-day check-in.
/// {@endtemplate}
class MealScheduleView extends StatelessWidget {
  /// {@macro meal_schedule_view}
  const MealScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.mealSchedule),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              BlocSelector<
                OnboardingBloc,
                OnboardingState,
                (
                  MealCheckinScheduleMode,
                  Map<MealOfTheDay, MealReminder>,
                  MealReminder,
                )
              >(
                bloc: getIt<OnboardingBloc>(),
                selector: (state) => (
                  state.settings.mealCheckinScheduleMode,
                  state.settings.mealReminders,
                  state.settings.endOfDayReminder,
                ),
                builder: (context, selected) {
                  final (mode, mealReminders, endOfDayReminder) = selected;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'When should we ask?',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<MealCheckinScheduleMode>(
                        segments: const [
                          ButtonSegment(
                            value: MealCheckinScheduleMode.perMeal,
                            label: Text('After each meal'),
                          ),
                          ButtonSegment(
                            value: MealCheckinScheduleMode.endOfDay,
                            label: Text('Once a day'),
                          ),
                        ],
                        selected: {mode},
                        onSelectionChanged: (selection) =>
                            getIt<OnboardingBloc>().add(
                              OnboardingEvent.mealCheckinScheduleModeChanged(
                                selection.first,
                              ),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mode == MealCheckinScheduleMode.perMeal
                            ? 'Logging near when you ate is more accurate, and '
                                  'you can snap a photo while the food is in '
                                  'front of you.'
                            : 'One check-in covering the whole day.',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 20),
                      if (mode == MealCheckinScheduleMode.perMeal)
                        for (final meal in MealOfTheDay.values)
                          if (mealReminders[meal] case final reminder?)
                            _MealReminderRow(meal: meal, reminder: reminder),
                      if (mode == MealCheckinScheduleMode.endOfDay)
                        _EndOfDayRow(reminder: endOfDayReminder),
                      const SizedBox(height: 16),
                      Text(
                        'You can add a meal any time you eat. Reminders just '
                        'keep you honest.',
                        style: textTheme.bodySmall,
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

Future<void> _pickTime(
  BuildContext context,
  MealReminder reminder,
  void Function(TimeOfDay picked) onPicked,
) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: reminder.time,
  );
  if (picked != null) onPicked(picked);
}

class _MealReminderRow extends StatelessWidget {
  const _MealReminderRow({required this.meal, required this.reminder});

  final MealOfTheDay meal;
  final MealReminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(meal.label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reminder.enabled)
              ActionChip(
                label: Text(reminder.time.format(context)),
                onPressed: () => _pickTime(
                  context,
                  reminder,
                  (picked) => getIt<OnboardingBloc>().add(
                    OnboardingEvent.mealReminderTimeChanged(meal, picked),
                  ),
                ),
              )
            else
              const Text('No reminder'),
            const SizedBox(width: 8),
            Switch(
              value: reminder.enabled,
              onChanged: (enabled) => getIt<OnboardingBloc>().add(
                OnboardingEvent.mealReminderToggled(meal, enabled: enabled),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EndOfDayRow extends StatelessWidget {
  const _EndOfDayRow({required this.reminder});

  final MealReminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: const Text('Daily check-in'),
        trailing: ActionChip(
          label: Text(reminder.time.format(context)),
          onPressed: () => _pickTime(
            context,
            reminder,
            (picked) => getIt<OnboardingBloc>().add(
              OnboardingEvent.endOfDayTimeChanged(picked),
            ),
          ),
        ),
      ),
    );
  }
}
