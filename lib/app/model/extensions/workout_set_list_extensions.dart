import 'package:flutter/material.dart';
import 'package:the_usual/app/core/extensions/extensions.dart';
import 'package:the_usual/app/model/model.dart';

/// Display formatting for a single set.
extension WorkoutSetFormatting on WorkoutSet {
  /// A short "weight×reps" label, e.g. "135×8". A missing value reads "—".
  String get label {
    final weightLabel = weight == null ? '—' : weight!.trimmedDecimal;
    final repsLabel = reps?.toString() ?? '—';
    return '$weightLabel×$repsLabel';
  }
}

/// Aggregation and display formatting across a list of sets.
extension WorkoutSetListFormatting on List<WorkoutSet> {
  /// Total volume across these sets.
  double get totalVolume =>
      fold<double>(0, (total, workoutSet) => total + workoutSet.volume);

  /// A one-line summary, e.g. "3 sets · 135×8, 145×6". Empty reads "No sets".
  String get summary {
    if (isEmpty) return 'No sets';
    final unit = length == 1 ? 'set' : 'sets';
    final labels = map((workoutSet) => workoutSet.label).join(', ');
    return '$length $unit · $labels';
  }

  /// The set with the highest [WorkoutSet.estimatedOneRepMax], or null when no
  /// set has both a weight and reps to estimate from.
  WorkoutSet? get topEstimatedOneRepMaxSet {
    WorkoutSet? best;
    var bestEstimate = 0.0;
    for (final workoutSet in this) {
      final estimate = workoutSet.estimatedOneRepMax;
      if (estimate > bestEstimate) {
        bestEstimate = estimate;
        best = workoutSet;
      }
    }
    return best;
  }

  /// The highest estimated one-rep max across these sets, or 0 when none can be
  /// estimated.
  double get bestEstimatedOneRepMax =>
      topEstimatedOneRepMaxSet?.estimatedOneRepMax ?? 0;

  /// Whether these sets differ from [other] in count, weight, or reps. The
  /// bodyweight auto-estimate flag is ignored, so resolving an estimate doesn't
  /// count as a change.
  bool differsInWeightOrReps(List<WorkoutSet> other) {
    if (length != other.length) return true;
    for (var index = 0; index < length; index++) {
      if (this[index].weight != other[index].weight ||
          this[index].reps != other[index].reps) {
        return true;
      }
    }
    return false;
  }
}

/// Aggregation across a list of logged workouts.
extension WorkoutLogEntryListFormatting on List<WorkoutLogEntry> {
  /// Total volume across these logged workouts.
  double get totalVolume => fold<double>(
    0,
    (total, workoutLogEntry) => total + workoutLogEntry.volume,
  );

  /// The entries whose [WorkoutLogEntry.loggedAt] falls on the logical [day]
  /// (rolling over at [dayStart]).
  List<WorkoutLogEntry> entriesOn(DateTime day, TimeOfDay dayStart) => [
    for (final workoutLogEntry in this)
      if (DateUtils.isSameDay(
        workoutLogEntry.loggedAt.logicalDay(dayStart),
        day,
      ))
        workoutLogEntry,
  ];

  /// Total volume across the entries on the logical [day].
  double volumeOn(DateTime day, TimeOfDay dayStart) =>
      entriesOn(day, dayStart).totalVolume;

  /// The user's usuals for [workoutGroupId]'s quick-pick chips: the most
  /// recently logged usual for this group first, then this group's usuals by
  /// how often they've been logged here. Usuals already logged on [day] for
  /// this group are dropped, matched by name or linked id so a renamed usual
  /// stays hidden.
  List<UsualWorkout> orderedQuickPicks({
    required String workoutGroupId,
    required List<UsualWorkout> usuals,
    required DateTime day,
    required TimeOfDay dayStart,
  }) {
    final loggedToday = _loggedTodayKeys(workoutGroupId, day, dayStart);
    final countInGroup = <String, int>{};
    final lastLoggedInGroup = <String, DateTime>{};

    for (final workoutLogEntry in this) {
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId == null) continue;
      if (workoutLogEntry.workoutGroupId != workoutGroupId) continue;
      countInGroup.update(
        usualWorkoutId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      final lastInGroup = lastLoggedInGroup[usualWorkoutId];
      if (lastInGroup == null ||
          workoutLogEntry.loggedAt.isAfter(lastInGroup)) {
        lastLoggedInGroup[usualWorkoutId] = workoutLogEntry.loggedAt;
      }
    }

    bool isVisible(UsualWorkout usualWorkout) =>
        !loggedToday.names.contains(usualWorkout.name.toLowerCase()) &&
        !loggedToday.ids.contains(usualWorkout.id);

    final groupUsuals = usuals.where(isVisible).toList();

    UsualWorkout? mostRecent;
    for (final usualWorkout in groupUsuals) {
      final loggedAt = lastLoggedInGroup[usualWorkout.id];
      if (loggedAt == null) continue;
      final currentBest = mostRecent == null
          ? null
          : lastLoggedInGroup[mostRecent.id];
      if (currentBest == null || loggedAt.isAfter(currentBest)) {
        mostRecent = usualWorkout;
      }
    }

    final remaining = groupUsuals
        .where((usualWorkout) => usualWorkout.id != mostRecent?.id)
        .toList();
    _sortByLogActivity(remaining, countInGroup, lastLoggedInGroup);

    return [?mostRecent, ...remaining];
  }

  /// The lowercased names and linked ids of entries logged on the logical
  /// [day] (rolling over at [dayStart]) for [workoutGroupId], used to hide
  /// usuals already logged in that group today.
  ({Set<String> names, Set<String> ids}) _loggedTodayKeys(
    String workoutGroupId,
    DateTime day,
    TimeOfDay dayStart,
  ) {
    final names = <String>{};
    final ids = <String>{};
    for (final workoutLogEntry in this) {
      if (workoutLogEntry.workoutGroupId != workoutGroupId) continue;
      final loggedDay = workoutLogEntry.loggedAt.logicalDay(dayStart);
      if (!DateUtils.isSameDay(loggedDay, day)) continue;
      names.add(workoutLogEntry.name.toLowerCase());
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId != null) ids.add(usualWorkoutId);
    }
    return (names: names, ids: ids);
  }
}

/// Sorts [usualWorkouts] in place by log [counts] descending, breaking ties by
/// most recent in [lastLogged], then by their original order in the list.
void _sortByLogActivity(
  List<UsualWorkout> usualWorkouts,
  Map<String, int> counts,
  Map<String, DateTime> lastLogged,
) {
  final originalIndex = {
    for (final (index, usualWorkout) in usualWorkouts.indexed)
      usualWorkout.id: index,
  };
  usualWorkouts.sort((a, b) {
    final countComparison = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
    if (countComparison != 0) return countComparison;

    final lastA = lastLogged[a.id];
    final lastB = lastLogged[b.id];
    if (lastA != null && lastB != null && lastA != lastB) {
      return lastB.compareTo(lastA);
    }
    if (lastA == null && lastB != null) return 1;
    if (lastA != null && lastB == null) return -1;

    return originalIndex[a.id]!.compareTo(originalIndex[b.id]!);
  });
}
