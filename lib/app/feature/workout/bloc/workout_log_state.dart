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

/// One session's strength data point for an exercise: the logical day trained,
/// the best estimated one-rep max across that day's sets, and the set that
/// achieved it.
typedef ExerciseStrengthPoint = ({
  DateTime sessionDay,
  double estimatedOneRepMax,
  WorkoutSet topSet,
});

/// One strength exercise's progress over time: its display name and its session
/// points, oldest first.
typedef ExerciseStrengthSeries = ({
  String name,
  List<ExerciseStrengthPoint> points,
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

    /// The id of the workout logged most recently this session. Ephemeral: not
    /// persisted, so a relaunch clears it, and it is ignored when comparing
    /// state for cloud sync.
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

  /// Every strength exercise's estimated-1RM progress, one [ExerciseStrength
  /// Series] per exercise that has at least two logged sessions, most recently
  /// trained first. Exercises are grouped by name (case-insensitive), with
  /// entries sharing a [WorkoutLogEntry.usualWorkoutId] treated as one exercise
  /// even if renamed. Each session is a logical day; its point is the strongest
  /// set across that day's entries for the exercise.
  List<ExerciseStrengthSeries> strengthProgress(TimeOfDay dayStart) {
    final strengthEntries = workoutEntries
        .where(
          (workoutLogEntry) => workoutLogEntry.type == WorkoutType.strength,
        )
        .toList();

    // The lowercased name of each usual's most-recently-logged entry, used to
    // keep renamed usuals in one group.
    final canonicalNameByUsualId = <String, String>{};
    final canonicalLoggedAtByUsualId = <String, DateTime>{};
    for (final workoutLogEntry in strengthEntries) {
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId == null) continue;
      final seenAt = canonicalLoggedAtByUsualId[usualWorkoutId];
      if (seenAt == null || workoutLogEntry.loggedAt.isAfter(seenAt)) {
        canonicalLoggedAtByUsualId[usualWorkoutId] = workoutLogEntry.loggedAt;
        canonicalNameByUsualId[usualWorkoutId] = workoutLogEntry.name
            .toLowerCase();
      }
    }

    String keyFor(WorkoutLogEntry workoutLogEntry) {
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId != null) {
        return canonicalNameByUsualId[usualWorkoutId] ??
            workoutLogEntry.name.toLowerCase();
      }
      return workoutLogEntry.name.toLowerCase();
    }

    final entriesByKey = <String, List<WorkoutLogEntry>>{};
    for (final workoutLogEntry in strengthEntries) {
      entriesByKey
          .putIfAbsent(keyFor(workoutLogEntry), () => <WorkoutLogEntry>[])
          .add(workoutLogEntry);
    }

    final series = <ExerciseStrengthSeries>[];
    for (final groupEntries in entriesByKey.values) {
      // Display name and group recency from the most recent entry.
      final mostRecentEntry = groupEntries.reduce(
        (a, b) => a.loggedAt.isAfter(b.loggedAt) ? a : b,
      );

      final setsByDay = <DateTime, List<WorkoutSet>>{};
      for (final workoutLogEntry in groupEntries) {
        final day = workoutLogEntry.loggedAt.logicalDay(dayStart);
        setsByDay
            .putIfAbsent(day, () => <WorkoutSet>[])
            .addAll(workoutLogEntry.sets);
      }

      final points = <ExerciseStrengthPoint>[];
      for (final day
          in setsByDay.keys.toList()..sort((a, b) => a.compareTo(b))) {
        final topSet = setsByDay[day]!.topEstimatedOneRepMaxSet;
        if (topSet == null) continue;
        points.add((
          sessionDay: day,
          estimatedOneRepMax: topSet.estimatedOneRepMax,
          topSet: topSet,
        ));
      }

      if (points.length < 2) continue;
      series.add((name: mostRecentEntry.name, points: points));
    }

    series.sort(
      (a, b) => b.points.last.sessionDay.compareTo(a.points.last.sessionDay),
    );
    return series;
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
