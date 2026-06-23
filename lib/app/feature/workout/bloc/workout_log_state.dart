part of 'workout_log_bloc.dart';

/// One logged day rolled up for the workout history screen: its total volume
/// and the entries that contributed to it.
typedef WorkoutHistoryDay = ({
  DateTime day,
  double volume,
  List<WorkoutLogEntry> workoutEntries,
});

/// One month of workout history: its logged days (newest first) and the
/// average daily volume across them.
typedef WorkoutHistoryMonth = ({
  DateTime month,
  double averageVolume,
  List<WorkoutHistoryDay> days,
});

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

  /// The full log rolled up by month for the history screen, oldest month
  /// first. Entries are bucketed by logical day (rolling over at [dayStart]),
  /// days are grouped into months, and each month's average volume is computed
  /// from its days. Days are newest-first within each month.
  List<WorkoutHistoryMonth> historyByMonth(TimeOfDay dayStart) {
    final entriesByDay = <DateTime, List<WorkoutLogEntry>>{};
    for (final workoutLogEntry in workoutEntries) {
      final day = workoutLogEntry.loggedAt.logicalDay(dayStart);
      entriesByDay
          .putIfAbsent(day, () => <WorkoutLogEntry>[])
          .add(workoutLogEntry);
    }

    final allDays = entriesByDay.keys.toList()..sort((a, b) => b.compareTo(a));

    final daysByMonth = <DateTime, List<WorkoutHistoryDay>>{};
    for (final day in allDays) {
      final dayEntries = entriesByDay[day]!;
      final month = DateTime(day.year, day.month);
      daysByMonth.putIfAbsent(month, () => <WorkoutHistoryDay>[]).add((
        day: day,
        volume: dayEntries.totalVolume,
        workoutEntries: dayEntries,
      ));
    }

    final months = daysByMonth.keys.toList()..sort((a, b) => a.compareTo(b));
    final history = <WorkoutHistoryMonth>[];
    for (final month in months) {
      final days = daysByMonth[month]!;
      final totalVolume = days.fold<double>(
        0,
        (sum, workoutHistoryDay) => sum + workoutHistoryDay.volume,
      );
      history.add((
        month: month,
        averageVolume: totalVolume / days.length,
        days: days,
      ));
    }
    return history;
  }

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
}
