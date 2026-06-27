part of 'workout_log_bloc.dart';

@Freezed()
sealed class WorkoutLogEvent with _$WorkoutLogEvent {
  const factory WorkoutLogEvent.workoutLogged(
    String workoutGroupId,
    String name, {
    @Default(WorkoutType.strength) WorkoutType type,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    Duration? duration,
    String? usualWorkoutId,
    DateTime? day,
    TimeOfDay? dayStart,
  }) = WorkoutLogged;
  const factory WorkoutLogEvent.workoutRemoved(String id) = WorkoutRemoved;
  const factory WorkoutLogEvent.workoutSetsChanged(
    String id,
    List<WorkoutSet> sets,
  ) = WorkoutSetsChanged;
  const factory WorkoutLogEvent.workoutDurationChanged(
    String id,
    Duration duration,
  ) = WorkoutDurationChanged;

  /// Replaces the entire log with state downloaded from the cloud on sign-in.
  const factory WorkoutLogEvent.stateRestored(WorkoutLogState state) =
      WorkoutLogStateRestored;

  /// Replaces the log with seeded months of training, for dev tooling.
  const factory WorkoutLogEvent.sampleDataSeeded() = WorkoutSampleDataSeeded;
}
