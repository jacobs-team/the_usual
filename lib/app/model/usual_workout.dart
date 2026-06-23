import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_workout.freezed.dart';
part 'usual_workout.g.dart';

/// {@template usual_workout}
/// A workout in the user's usuals library, with a default set structure that
/// pre-fills a log so it can be adjusted.
/// {@endtemplate}
@freezed
abstract class UsualWorkout with _$UsualWorkout {
  /// {@macro usual_workout}
  @JsonSerializable(explicitToJson: true)
  const factory UsualWorkout({
    required String id,
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
  }) = _UsualWorkout;

  factory UsualWorkout.fromJson(Map<String, dynamic> json) =>
      _$UsualWorkoutFromJson(json);
}
