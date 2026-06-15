part of 'daily_log_bloc.dart';

@Freezed()
sealed class DailyLogEvent with _$DailyLogEvent {
  const factory DailyLogEvent.mealLogged(
    MealOfTheDay mealOfTheDay,
    String name, {
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) int quantity,
    String? usualMealId,
    String? photoPath,
  }) = MealLogged;
  const factory DailyLogEvent.mealEntryRemoved(String id) = MealEntryRemoved;
  const factory DailyLogEvent.mealEntryNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = MealEntryNutritionChanged;
  const factory DailyLogEvent.mealEntryQuantityChanged(
    String id,
    int quantity,
  ) = MealEntryQuantityChanged;

  /// Repairs the link from a logged entry to its usual meal by stamping the
  /// usual meal's current id onto the entry. Used to heal entries whose stored
  /// id no longer matches (e.g. logged before the usual meal's current id).
  const factory DailyLogEvent.mealEntryUsualMealLinked(
    String id,
    String usualMealId,
  ) = MealEntryUsualMealLinked;
  const factory DailyLogEvent.weightLogged(
    double weight,
    WeightUnit weightUnit,
  ) = WeightLogged;

  /// Sets the weigh-in on [day]: updates that day's entry if one exists, adds
  /// one if not, or removes it when [weight] is null.
  const factory DailyLogEvent.weightOnDayChanged(
    DateTime day,
    double? weight,
    WeightUnit weightUnit,
  ) = WeightOnDayChanged;

  // TODO(dev): temporary. Replaces the log with sample history; triggered from
  // Dev Tools. Remove before ship.
  const factory DailyLogEvent.sampleDataSeeded() = SampleDataSeeded;
}
