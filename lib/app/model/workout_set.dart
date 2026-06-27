import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set.freezed.dart';
part 'workout_set.g.dart';

/// {@template workout_set}
/// One set of an exercise: the weight lifted and the reps performed. A
/// bodyweight set carries an estimated weight once resolved, flagged by
/// [weightAutoEstimated]. Each value is null until supplied.
/// {@endtemplate}
@freezed
abstract class WorkoutSet with _$WorkoutSet {
  /// {@macro workout_set}
  const factory WorkoutSet({
    double? weight,
    int? reps,
    @Default(false) bool weightAutoEstimated,
  }) = _WorkoutSet;

  const WorkoutSet._();

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);

  /// The load this set contributes: weight times reps. An unset weight or rep
  /// count contributes zero.
  double get volume => (weight ?? 0) * (reps ?? 0);

  /// An Epley estimate of the one-rep max this set implies: `weight × (1 +
  /// reps/30)`. A single rep is just the weight, and above 12 reps the estimate
  /// is unreliable so it falls back to the raw weight. Returns 0 when weight or
  /// reps is missing, so an incomplete set contributes nothing.
  double get estimatedOneRepMax {
    final weight = this.weight;
    final reps = this.reps;
    if (weight == null || reps == null || reps <= 0) return 0;
    if (reps == 1 || reps > 12) return weight;
    return weight * (1 + reps / 30);
  }
}
