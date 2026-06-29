part of 'meal_entry_bloc.dart';

/// Where an estimate stands: [idle] (editable, including after a result lands),
/// [generating] while Claude is being called, or [failure] when it errored.
enum MealEntryStatus { idle, generating, failure }

/// {@template meal_entry_state}
/// State for [FoodEntryBloc].
/// {@endtemplate}
@freezed
abstract class MealEntryState with _$MealEntryState {
  /// {@macro meal_entry_state}
  const factory MealEntryState({
    @Default(<FoodDraft>[]) List<FoodDraft> foods,
    @Default(MealEntryMode.wholeMeal) MealEntryMode mealEntryMode,
    @Default(MealOfTheDay.breakfast) MealOfTheDay mealOfTheDay,
    @Default(<MealPhoto>[]) List<MealPhoto> photos,
    @Default(MealEntryStatus.idle) MealEntryStatus status,
    @Default('') String mealName,

    /// Free-text meal description used in by-foods mode to itemize a meal into
    /// its component foods. Separate from [mealName]; cleared once the AI has
    /// turned it into food rows.
    @Default('') String description,
    String? errorMessage,
  }) = _MealEntryState;

  const MealEntryState._();

  /// Whether any row has a name entered.
  bool get hasContent =>
      foods.any((foodDraft) => foodDraft.name.trim().isNotEmpty);

  /// Whether there is anything to estimate from: a named food row, a typed
  /// description, or an attached photo.
  bool get hasEstimateInput =>
      hasContent || description.trim().isNotEmpty || photos.isNotEmpty;

  /// Whether an estimate is currently running.
  bool get isGenerating => status == MealEntryStatus.generating;
}
