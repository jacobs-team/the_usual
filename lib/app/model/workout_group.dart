import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_group.freezed.dart';
part 'workout_group.g.dart';

/// {@template workout_group}
/// A user-configurable grouping of workouts, for example Push, Pull, or Legs.
/// The [id] is stable across renames so logged workouts stay linked.
/// {@endtemplate}
@freezed
abstract class WorkoutGroup with _$WorkoutGroup {
  /// {@macro workout_group}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutGroup({
    required String id,
    required String name,
    required int order,
  }) = _WorkoutGroup;

  factory WorkoutGroup.fromJson(Map<String, dynamic> json) =>
      _$WorkoutGroupFromJson(json);
}
