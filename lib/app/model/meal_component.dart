import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'meal_component.freezed.dart';
part 'meal_component.g.dart';

/// {@template meal_component}
/// One food within a composed meal: a snapshot of the food's [name] and
/// per-unit [nutrition], the [quantity] of units in the meal, and an optional
/// [usualFoodId] linking back to the library food it was built from. The
/// component owns its nutrition copy, so editing the library food never changes
/// a meal already built from it; the link only identifies which meals use a
/// food when the user chooses to propagate an edit.
/// {@endtemplate}
@freezed
abstract class MealComponent with _$MealComponent {
  /// {@macro meal_component}
  @JsonSerializable(explicitToJson: true)
  const factory MealComponent({
    required String name,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) double quantity,
    String? usualFoodId,
  }) = _MealComponent;

  const MealComponent._();

  factory MealComponent.fromJson(Map<String, dynamic> json) =>
      _$MealComponentFromJson(json);

  /// This component's contribution to its meal's total: its per-unit
  /// [nutrition] scaled by [quantity].
  Nutrition get scaledNutrition => nutrition * quantity;
}
