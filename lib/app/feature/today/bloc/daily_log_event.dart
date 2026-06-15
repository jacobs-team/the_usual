part of 'daily_log_bloc.dart';

@Freezed()
sealed class DailyLogEvent with _$DailyLogEvent {
  const factory DailyLogEvent.mealLogged(
    MealOfTheDay mealOfTheDay,
    String name, {
    @Default(Nutrition()) Nutrition nutrition,
    String? usualMealId,
    String? photoPath,
  }) = MealLogged;
  const factory DailyLogEvent.mealEntryRemoved(String id) = MealEntryRemoved;
  const factory DailyLogEvent.mealEntryNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = MealEntryNutritionChanged;
  const factory DailyLogEvent.weightLogged(
    double weight,
    WeightUnit weightUnit,
  ) = WeightLogged;

  /// Sets today's weigh-in: updates today's entry if one exists, adds one if
  /// not, or removes it when [weight] is null.
  const factory DailyLogEvent.todayWeightChanged(
    double? weight,
    WeightUnit weightUnit,
  ) = TodayWeightChanged;

  // TODO(dev): temporary. Replaces the log with sample history; triggered from
  // Dev Tools. Remove before ship.
  const factory DailyLogEvent.sampleDataSeeded() = SampleDataSeeded;
}
