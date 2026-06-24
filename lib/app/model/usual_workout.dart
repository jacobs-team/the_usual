import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_workout.freezed.dart';
part 'usual_workout.g.dart';

/// {@template usual_workout}
/// A workout in the user's usuals library that pre-fills a log so it can be
/// adjusted. Strength usuals carry a default set structure; cardio usuals carry
/// a default [duration] and leave [sets] empty.
/// {@endtemplate}
@freezed
abstract class UsualWorkout with _$UsualWorkout {
  /// {@macro usual_workout}
  @JsonSerializable(explicitToJson: true)
  const factory UsualWorkout({
    required String id,
    required String name,
    @Default(WorkoutType.strength) WorkoutType type,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    Duration? duration,
  }) = _UsualWorkout;

  factory UsualWorkout.fromJson(Map<String, dynamic> json) =>
      _$UsualWorkoutFromJson(json);
}
