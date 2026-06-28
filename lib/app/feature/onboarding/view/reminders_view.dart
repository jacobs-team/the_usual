// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template reminders_view}
/// Onboarding screen for how and when the app checks in about meals. The
/// reminder style picker is always shown; the per-meal or end-of-day schedule
/// appears below it once a style other than [ReminderStyle.none] is chosen.
/// {@endtemplate}
class RemindersView extends StatelessWidget {
  /// {@macro reminders_view}
  const RemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return OnboardingScaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.reminders),
      child:
          BlocSelector<
            OnboardingBloc,
            OnboardingState,
            (
              ReminderStyle,
              MealCheckinScheduleMode,
              Map<MealOfTheDay, MealReminder>,
              MealReminder,
              bool,
            )
          >(
            bloc: getIt<OnboardingBloc>(),
            selector: (state) => (
              state.settings.reminderStyle,
              state.settings.mealCheckinScheduleMode,
              state.settings.mealReminders,
              state.settings.endOfDayReminder,
              state.settings.skipLoggedMealReminders,
            ),
            builder: (context, selected) {
              final (
                reminderStyle,
                mealCheckinScheduleMode,
                mealReminders,
                endOfDayReminder,
                skipLoggedMealReminders,
              ) = selected;
              final remindersOff = reminderStyle == ReminderStyle.none;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'How should we check in?',
                            style: textTheme.headlineSmall,
                          ),
                          SizedBox(height: AppDesign.spacing.sm),
                          const Text(
                            'We ask if you ate. You tap what it was.',
                          ),
                          SizedBox(height: AppDesign.spacing.xl),
                          for (final style in ReminderStyle.values) ...[
                            if (style != ReminderStyle.values.first)
                              SizedBox(height: AppDesign.spacing.md),
                            RadioOptionCard(
                              title: style.label,
                              subtitle: style.description,
                              note: style.permissionNote,
                              selected: style == reminderStyle,
                              onTap: () => getIt<OnboardingBloc>().add(
                                OnboardingEvent.reminderStyleSelected(
                                  style,
                                ),
                              ),
                            ),
                          ],
                          if (!remindersOff) ...[
                            SizedBox(height: AppDesign.spacing.xl),
                            const SectionLabel('WHEN SHOULD WE ASK'),
                            SizedBox(height: AppDesign.spacing.md),
                            MealScheduleModeSelector(
                              mealCheckinScheduleMode: mealCheckinScheduleMode,
                              onChanged: (mealCheckinScheduleMode) =>
                                  getIt<OnboardingBloc>().add(
                                    OnboardingEvent.mealCheckinScheduleModeChanged(
                                      mealCheckinScheduleMode,
                                    ),
                                  ),
                            ),
                            SizedBox(height: AppDesign.spacing.md),
                            if (mealCheckinScheduleMode ==
                                MealCheckinScheduleMode.perMeal) ...[
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
                              SkipLoggedRemindersTile(
                                skipLoggedMealReminders:
                                    skipLoggedMealReminders,
                                onChanged: (value) => getIt<OnboardingBloc>().add(
                                  OnboardingEvent.skipLoggedMealRemindersChanged(
                                    skipLoggedMealReminders: value,
                                  ),
                                ),
                              ),
                            ],
                            if (mealCheckinScheduleMode ==
                                MealCheckinScheduleMode.endOfDay)
                              EndOfDayReminderRow(
                                mealReminder: endOfDayReminder,
                                onTimeChanged: (timeOfDay) =>
                                    getIt<OnboardingBloc>().add(
                                      OnboardingEvent.endOfDayTimeChanged(
                                        timeOfDay,
                                      ),
                                    ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppDesign.spacing.md),
                  OnboardingActions(
                    primary: FilledButton(
                      onPressed: () async {
                        // Choosing notifications prompts the OS first. If
                        // it isn't granted, revert to no reminders and stay on
                        // this step so the user can continue with the updated
                        // choice. The service is mobile-only, so on web there's
                        // no permission to request and the choice just sets.
                        if (reminderStyle == ReminderStyle.notifications &&
                            getIt.isRegistered<NotificationService>()) {
                          final status = await getIt<NotificationService>()
                              .requestPermission();
                          if (!status.isGranted) {
                            getIt<OnboardingBloc>().add(
                              const OnboardingEvent.reminderStyleSelected(
                                ReminderStyle.none,
                              ),
                            );
                            if (!context.mounted) return;
                            await showDialog<void>(
                              context: context,
                              builder: (_) =>
                                  const EnableNotificationsInSettingsDialog(),
                            );
                            return;
                          }
                        }
                        getIt<OnboardingBloc>().add(
                          const OnboardingEvent.continuePressed(),
                        );
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
