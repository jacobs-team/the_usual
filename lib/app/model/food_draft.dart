import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'food_draft.freezed.dart';

/// {@template food_draft}
/// One editable food row being captured in the meal-entry form: its [name],
/// per-unit [nutrition], [quantity], and whether to also save it as a usual.
/// The [id] is a uuid generated when the draft is created; it keys the row's
/// text controller so an AI estimate that replaces the rows rebuilds them
/// cleanly. In-memory only — never persisted.
/// {@endtemplate}
@freezed
abstract class FoodDraft with _$FoodDraft {
  /// {@macro food_draft}
  const factory FoodDraft({
    required String id,
    @Default('') String name,
    @Default(1) double quantity,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(false) bool addToUsualMeals,
    String? usualFoodId,
  }) = _FoodDraft;
}
