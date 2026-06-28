import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_meal.freezed.dart';
part 'usual_meal.g.dart';

/// {@template usual_meal}
/// A food item in the user's usuals library.
/// {@endtemplate}
@freezed
abstract class UsualMeal with _$UsualMeal {
  /// {@macro usual_meal}
  @JsonSerializable(explicitToJson: true)
  const factory UsualMeal({
    required String id,
    required String name,
    String? photoPath,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(<MealComponent>[]) List<MealComponent> components,
  }) = _UsualMeal;

  factory UsualMeal.fromJson(Map<String, dynamic> json) =>
      _$UsualMealFromJson(Nutrition.migrateLegacyJson(json));
}
