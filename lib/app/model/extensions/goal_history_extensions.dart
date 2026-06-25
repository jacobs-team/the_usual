import 'package:the_usual/app/model/model.dart';

/// Resolving a dated calorie-goal history to the goal active on a given day.
extension CalorieGoalHistoryResolving on List<CalorieGoalEntry> {
  /// The calories from the most recent entry effective on or before [day], or
  /// null when no goal applies then. Expects the history oldest first.
  int? goalOn(DateTime day) {
    int? calories;
    for (final calorieGoalEntry in this) {
      if (!calorieGoalEntry.effectiveFrom.isAfter(day)) {
        calories = calorieGoalEntry.calories;
      }
    }
    return calories;
  }
}

/// Resolving a dated weight-goal history to the goal active on a given day.
extension WeightGoalHistoryResolving on List<WeightGoalEntry> {
  /// The most recent entry effective on or before [day], or null when no goal
  /// applies then. Expects the history oldest first.
  WeightGoalEntry? goalOn(DateTime day) {
    WeightGoalEntry? active;
    for (final weightGoalEntry in this) {
      if (!weightGoalEntry.effectiveFrom.isAfter(day)) {
        active = weightGoalEntry;
      }
    }
    return active;
  }
}
