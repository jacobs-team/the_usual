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
}
