import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'ai_meal_suggestion.freezed.dart';
part 'ai_meal_suggestion.g.dart';

/// {@template ai_meal_suggestion}
/// An AI-estimated meal awaiting the user's confirmation: a short [name], the
/// per-unit [nutrition], and the [quantity] of that unit. Nutrition times
/// quantity is the total eaten, so a one-off meal is quantity 1 with the
/// combined nutrition. It mirrors the name, quantity, and nutrition the app
/// already models on [MealLogEntry], but carries no id or meal slot until the
/// user confirms it.
/// {@endtemplate}
@freezed
abstract class AiMealSuggestion with _$AiMealSuggestion {
  /// {@macro ai_meal_suggestion}
  @JsonSerializable(explicitToJson: true)
  const factory AiMealSuggestion({
    required String name,
    @Default(1) int quantity,
    @Default(Nutrition()) Nutrition nutrition,
  }) = _AiMealSuggestion;

  factory AiMealSuggestion.fromJson(Map<String, dynamic> json) =>
      _$AiMealSuggestionFromJson(json);
}
