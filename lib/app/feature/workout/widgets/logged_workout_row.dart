import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template logged_workout_row}
/// A single logged workout entry: exercise name, sets summary, and inline-editable
/// set fields.
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

  @override
  Widget build(BuildContext context) {
    return ExpandableWorkout(
      name: workoutLogEntry.name,
      sets: workoutLogEntry.sets,
      weightUnit: weightUnit,
      expandedByDefault: expandedByDefault,
      onChanged: (sets) => getIt<WorkoutLogBloc>().add(
        WorkoutLogEvent.workoutSetsChanged(workoutLogEntry.id, sets),
      ),
      onRemoved: () => getIt<WorkoutLogBloc>().add(
        WorkoutLogEvent.workoutRemoved(workoutLogEntry.id),
      ),
      onNameChanged: null,
    );
  }
}
