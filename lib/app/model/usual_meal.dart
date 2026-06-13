import 'package:freezed_annotation/freezed_annotation.dart';

part 'usual_meal.freezed.dart';
part 'usual_meal.g.dart';

/// {@template usual_meal}
/// A food item in the user's usuals library.
/// {@endtemplate}
@freezed
abstract class UsualMeal with _$UsualMeal {
  /// {@macro usual_meal}
  const factory UsualMeal({
    required String id,
    required String name,
    String? photoPath,

    /// Estimated or user-entered calories, null when not set yet.
    int? calories,
  }) = _UsualItem;

  factory UsualMeal.fromJson(Map<String, dynamic> json) =>
      _$UsualItemFromJson(json);
}
