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
        final (style, mode, mealReminders, endOfDayReminder) = selected;

        if (style == ReminderStyle.none) {
          return const InfoBox(
            'Reminders are off. Pick a check-in style above to schedule '
            'them.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MealScheduleModeSelector(
              mode: mode,
              onChanged: (mode) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.mealCheckinScheduleModeChanged(mode),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mode == MealCheckinScheduleMode.perMeal
                  ? 'Logging near when you ate is more accurate.'
                  : 'One check-in covering the whole day.',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (mode == MealCheckinScheduleMode.perMeal)
              for (final meal in MealOfTheDay.values)
                if (mealReminders[meal] case final reminder?)
                  MealReminderRow(
                    meal: meal,
                    reminder: reminder,
                    onToggled: (enabled) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.mealReminderToggled(
                        meal,
                        enabled: enabled,
                      ),
                    ),
                    onTimeChanged: (time) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.mealReminderTimeChanged(meal, time),
                    ),
                  ),
            if (mode == MealCheckinScheduleMode.endOfDay)
              EndOfDayReminderRow(
                reminder: endOfDayReminder,
                onTimeChanged: (time) => getIt<UserSettingsBloc>().add(
                  UserSettingsEvent.endOfDayTimeChanged(time),
                ),
              ),
          ],
        );
      },
    );
  }
}
