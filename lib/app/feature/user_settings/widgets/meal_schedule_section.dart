import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template meal_schedule_section}
/// Settings section for when meal check-ins happen: per-meal reminder times
/// or a single end-of-day check-in. Shows an off notice when reminders are
/// disabled entirely.
/// {@endtemplate}
class MealScheduleSection extends StatelessWidget {
  /// {@macro meal_schedule_section}
  const MealScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (
        ReminderStyle,
        MealCheckinScheduleMode,
        Map<MealOfTheDay, MealReminder>,
        MealReminder,
      )
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.reminderStyle,
        state.mealCheckinScheduleMode,
        state.mealReminders,
        state.endOfDayReminder,
      ),
      builder: (context, selected) {
        final (
          reminderStyle,
          mealCheckinScheduleMode,
          mealReminders,
          endOfDayReminder,
        ) = selected;

        if (reminderStyle == ReminderStyle.none) {
          return const InfoBox(
            'Reminders are off. Pick a check-in style above to schedule '
            'them.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MealScheduleModeSelector(
              mealCheckinScheduleMode: mealCheckinScheduleMode,
              onChanged: (mealCheckinScheduleMode) =>
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.mealCheckinScheduleModeChanged(
                      mealCheckinScheduleMode,
                    ),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              mealCheckinScheduleMode == MealCheckinScheduleMode.perMeal
                  ? 'Logging near when you ate is more accurate.'
                  : 'One check-in covering the whole day.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (mealCheckinScheduleMode == MealCheckinScheduleMode.perMeal)
              for (final mealOfTheDay in MealOfTheDay.values)
                if (mealReminders[mealOfTheDay] case final mealReminder?)
                  MealReminderRow(
                    mealOfTheDay: mealOfTheDay,
                    mealReminder: mealReminder,
                    onToggled: (enabled) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.mealReminderToggled(
                        mealOfTheDay,
                        enabled: enabled,
                      ),
                    ),
                    onTimeChanged: (timeOfDay) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.mealReminderTimeChanged(
                        mealOfTheDay,
                        timeOfDay,
                      ),
                    ),
                  ),
            if (mealCheckinScheduleMode == MealCheckinScheduleMode.endOfDay)
              EndOfDayReminderRow(
                mealReminder: endOfDayReminder,
                onTimeChanged: (timeOfDay) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.endOfDayTimeChanged(timeOfDay),
                ),
              ),
          ],
        );
      },
    );
  }
}
