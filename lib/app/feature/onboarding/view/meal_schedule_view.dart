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
                  final (
                    mealCheckinScheduleMode,
                    mealReminders,
                    endOfDayReminder,
                  ) = selected;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'When should we ask?',
                        style: textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      MealScheduleModeSelector(
                        mealCheckinScheduleMode: mealCheckinScheduleMode,
                        onChanged: (mealCheckinScheduleMode) =>
                            getIt<OnboardingBloc>().add(
                              OnboardingEvent.mealCheckinScheduleModeChanged(
                                mealCheckinScheduleMode,
                              ),
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mealCheckinScheduleMode ==
                                MealCheckinScheduleMode.perMeal
                            ? 'Logging near when you ate is more accurate, and '
                                  'you can snap a photo while the food is in '
                                  'front of you.'
                            : 'One check-in covering the whole day.',
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: 20),
                      if (mealCheckinScheduleMode ==
                          MealCheckinScheduleMode.perMeal)
                        for (final mealOfTheDay in MealOfTheDay.values)
                          if (mealReminders[mealOfTheDay]
                              case final mealReminder?)
                            MealReminderRow(
                              mealOfTheDay: mealOfTheDay,
                              mealReminder: mealReminder,
                              onToggled: (enabled) =>
                                  getIt<OnboardingBloc>().add(
                                    OnboardingEvent.mealReminderToggled(
                                      mealOfTheDay,
                                      enabled: enabled,
                                    ),
                                  ),
                              onTimeChanged: (timeOfDay) =>
                                  getIt<OnboardingBloc>().add(
                                    OnboardingEvent.mealReminderTimeChanged(
                                      mealOfTheDay,
                                      timeOfDay,
                                    ),
                                  ),
                            ),
                      if (mealCheckinScheduleMode ==
                          MealCheckinScheduleMode.endOfDay)
                        EndOfDayReminderRow(
                          mealReminder: endOfDayReminder,
                          onTimeChanged: (timeOfDay) =>
                              getIt<OnboardingBloc>().add(
                                OnboardingEvent.endOfDayTimeChanged(timeOfDay),
                              ),
                        ),
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
