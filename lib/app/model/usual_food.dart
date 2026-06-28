import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_food.freezed.dart';
part 'usual_food.g.dart';

/// {@template usual_food}
/// A base nutritional item in the user's usual foods library: a [name]
/// describing one unit (e.g. "Chicken, 1 oz") and the [nutrition] for that
/// single unit. Foods are combined into composed meals, where a [MealComponent]
/// holds the food and how many units of it the meal contains.
/// {@endtemplate}
@freezed
abstract class UsualFood with _$UsualFood {
  /// {@macro usual_food}
  @JsonSerializable(explicitToJson: true)
  const factory UsualFood({
    required String id,
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
  }) = _UsualFood;

  factory UsualFood.fromJson(Map<String, dynamic> json) =>
      _$UsualFoodFromJson(json);
}
