part of 'daily_log_bloc.dart';

@Freezed()
sealed class DailyLogEvent with _$DailyLogEvent {
  const factory DailyLogEvent.mealLogged(
    MealOfTheDay mealOfTheDay,
    String name, {
    int? calories,
    String? usualMealId,
    String? photoPath,
  }) = MealLogged;
  const factory DailyLogEvent.mealEntryRemoved(String id) = MealEntryRemoved;
  const factory DailyLogEvent.mealEntryCaloriesChanged(
    String id,
    int? calories,
  ) = MealEntryCaloriesChanged;
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
  const factory DailyLogEvent.weightEntryRemoved(String id) =
      WeightEntryRemoved;

  // TODO(dev): temporary. Seeds sample history in debug; remove before ship.
  const factory DailyLogEvent.sampleDataSeeded() = SampleDataSeeded;
}
