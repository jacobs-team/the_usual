import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'workout_log_entry.freezed.dart';
part 'workout_log_entry.g.dart';

/// {@template workout_log_entry}
/// A single exercise the user logged, at a point in time, with its sets.
/// {@endtemplate}
@freezed
abstract class WorkoutLogEntry with _$WorkoutLogEntry {
  /// {@macro workout_log_entry}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogEntry({
    required String id,
    required DateTime loggedAt,
    required String workoutGroupId,
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    String? usualWorkoutId,
  }) = _WorkoutLogEntry;

  const WorkoutLogEntry._();

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogEntryFromJson(json);

  /// Total load across every set.
  double get volume =>
      sets.fold<double>(0, (total, workoutSet) => total + workoutSet.volume);
}
