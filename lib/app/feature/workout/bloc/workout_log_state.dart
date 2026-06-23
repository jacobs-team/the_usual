part of 'workout_log_bloc.dart';

/// {@template workout_log_state}
/// Every workout logged across all days.
/// {@endtemplate}
@freezed
abstract class WorkoutLogState with _$WorkoutLogState {
  /// {@macro workout_log_state}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,
    @Default(<WorkoutLogEntry>[]) List<WorkoutLogEntry> workoutEntries,

    /// The id of the workout logged most recently this session, so the
    /// Workouts view can open it for a quick adjustment. Ephemeral: not
    /// persisted, so a relaunch opens nothing.
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? justLoggedWorkoutId,
  }) = _WorkoutLogState;

  const WorkoutLogState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  factory WorkoutLogState.fromJson(Map<String, dynamic> json) =>
      WorkoutLogState._fromVersionedJson(json);

  factory WorkoutLogState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up before this case.
      case 0:
      case _currentVersion:
        return _$WorkoutLogStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's logged workouts.
        return _$WorkoutLogStateFromJson(json);
    }
  }

  /// The workouts logged on the logical [day] (rolling over at [dayStart]).
  List<WorkoutLogEntry> entriesOn(DateTime day, TimeOfDay dayStart) => [
    for (final workoutLogEntry in workoutEntries)
      if (DateUtils.isSameDay(
        workoutLogEntry.loggedAt.logicalDay(dayStart),
        day,
      ))
        workoutLogEntry,
  ];

  /// Total volume across the workouts logged on the logical [day].
  double volumeOn(DateTime day, TimeOfDay dayStart) => entriesOn(day, dayStart)
      .fold<double>(0, (total, workoutLogEntry) => total + workoutLogEntry.volume);
}
