import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template workout_section}
/// Settings section for the workout reminder and workout weight unit.
/// {@endtemplate}
class WorkoutSection extends StatelessWidget {
  /// {@macro workout_section}
  const WorkoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState,
        (WorkoutReminder, WeightUnit)>(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (state.workoutReminder, state.workoutWeightUnit),
      builder: (context, selected) {
        final (workoutReminder, workoutWeightUnit) = selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Units', style: Theme.of(context).textTheme.bodySmall),
            SizedBox(height: AppDesign.spacing.sm),
            Wrap(
              spacing: AppDesign.spacing.xs,
              children: [
                for (final option in WeightUnit.values)
                  ChoiceChip(
                    key: Key('workout-unit-${option.name}'),
                    label: Text(option.name),
                    selected: option == workoutWeightUnit,
                    onSelected: (_) => getIt<UserSettingsBloc>().add(
                      UserSettingsEvent.workoutWeightUnitSelected(option),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppDesign.spacing.md),
            WorkoutReminderRow(
              workoutReminder: workoutReminder,
              onToggled: (enabled) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.workoutReminderToggled(enabled: enabled),
              ),
              onDayToggled: (dayOfWeek, {required enabled}) =>
                  getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.workoutReminderDayToggled(
                      dayOfWeek,
                      enabled: enabled,
                    ),
                  ),
              onTimeChanged: (timeOfDay) => getIt<UserSettingsBloc>().add(
                UserSettingsEvent.workoutReminderTimeChanged(timeOfDay),
              ),
            ),
          ],
        );
      },
    );
  }
}
