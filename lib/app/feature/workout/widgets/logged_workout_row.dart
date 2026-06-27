import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template logged_workout_row}
/// A single logged workout entry: exercise name, sets summary, and
/// inline-editable set fields.
///
/// When the entry is linked to a usual workout and its sets (or, for cardio,
/// its time) differ from that usual, a button appears to push the logged values
/// onto the usual to match.
/// {@endtemplate}
class LoggedWorkoutRow extends StatelessWidget {
  /// {@macro logged_workout_row}
  const LoggedWorkoutRow({
    required this.workoutLogEntry,
    required this.weightUnit,
    required this.expandedByDefault,
    super.key,
  });

  /// The logged entry to show.
  final WorkoutLogEntry workoutLogEntry;

  /// The weight unit shown in set fields.
  final WeightUnit weightUnit;

  /// Whether the set fields start expanded for editing.
  final bool expandedByDefault;

  UsualWorkout? _linkedUsualWorkout(UserSettingsState state) {
    final usualWorkouts =
        state.usualWorkouts[workoutLogEntry.workoutGroupId] ??
        const <UsualWorkout>[];
    for (final usualWorkout in usualWorkouts) {
      if (usualWorkout.id == workoutLogEntry.usualWorkoutId ||
          usualWorkout.name.toLowerCase() ==
              workoutLogEntry.name.toLowerCase()) {
        return usualWorkout;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<UserSettingsBloc, UserSettingsState, UsualWorkout?>(
      bloc: getIt<UserSettingsBloc>(),
      selector: _linkedUsualWorkout,
      builder: (context, usualWorkout) {
        final loggedDuration = workoutLogEntry.duration ?? Duration.zero;
        final differsFromUsual =
            usualWorkout != null &&
            switch (workoutLogEntry.type) {
              WorkoutType.strength =>
                workoutLogEntry.sets.differsInWeightOrReps(
                  usualWorkout.sets,
                ),
              WorkoutType.cardio =>
                loggedDuration != (usualWorkout.duration ?? Duration.zero),
            };

        return ExpandableWorkout(
          name: workoutLogEntry.name,
          type: workoutLogEntry.type,
          sets: workoutLogEntry.sets,
          duration: loggedDuration,
          weightUnit: weightUnit,
          expandedByDefault: expandedByDefault,
          onChanged: (sets) => getIt<WorkoutLogBloc>().add(
            WorkoutLogEvent.workoutSetsChanged(workoutLogEntry.id, sets),
          ),
          onDurationChanged: (duration) => getIt<WorkoutLogBloc>().add(
            WorkoutLogEvent.workoutDurationChanged(
              workoutLogEntry.id,
              duration,
            ),
          ),
          onRemoved: () => getIt<WorkoutLogBloc>().add(
            WorkoutLogEvent.workoutRemoved(workoutLogEntry.id),
          ),
          expandedFooter: usualWorkout == null
              ? UpdateUsualButton(
                  label: 'Save as usual',
                  onPressed: () => getIt<UserSettingsBloc>().add(
                    UserSettingsEvent.usualWorkoutAdded(
                      workoutLogEntry.workoutGroupId,
                      workoutLogEntry.name,
                      workoutLogEntry.sets,
                      type: workoutLogEntry.type,
                      duration: loggedDuration,
                    ),
                  ),
                )
              : differsFromUsual
              ? UpdateUsualButton(
                  label: 'Update usual to match',
                  onPressed: () => getIt<UserSettingsBloc>().add(
                    switch (workoutLogEntry.type) {
                      WorkoutType.strength =>
                        UserSettingsEvent.usualWorkoutSetsChanged(
                          workoutLogEntry.workoutGroupId,
                          usualWorkout.id,
                          workoutLogEntry.sets,
                        ),
                      WorkoutType.cardio =>
                        UserSettingsEvent.usualWorkoutDurationChanged(
                          workoutLogEntry.workoutGroupId,
                          usualWorkout.id,
                          loggedDuration,
                        ),
                    },
                  ),
                )
              : null,
        );
      },
    );
  }
}
