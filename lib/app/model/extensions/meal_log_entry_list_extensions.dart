import 'package:flutter/material.dart';
import 'package:the_usual/app/model/model.dart';

/// A day's meal entries grouped for display, with the running nutrition total
/// computed in the same pass.
typedef DailyMealBreakdown = ({
  Nutrition nutrition,
  Map<MealOfTheDay, List<MealLogEntry>> entriesByMeal,
});

extension MealLogEntryListFormatting on List<MealLogEntry> {
  /// Total known nutrition across these entries. Values an entry leaves unset
  /// add nothing to the total.
  Nutrition get totalNutrition {
    var nutrition = const Nutrition();
    for (final mealLogEntry in this) {
      nutrition += mealLogEntry.nutrition;
    }
    return nutrition;
  }

  /// Groups the entries logged on [day] by meal of the day and sums their
  /// known nutrition in a single pass. Values an entry leaves unset add nothing
  /// to the total.
  DailyMealBreakdown breakdownOn(DateTime day) {
    var nutrition = const Nutrition();
    final entriesByMeal = <MealOfTheDay, List<MealLogEntry>>{};
    for (final mealLogEntry in this) {
      if (!DateUtils.isSameDay(mealLogEntry.loggedAt, day)) continue;
      nutrition += mealLogEntry.nutrition;
      entriesByMeal
          .putIfAbsent(mealLogEntry.mealOfTheDay, () => <MealLogEntry>[])
          .add(mealLogEntry);
    }
    return (nutrition: nutrition, entriesByMeal: entriesByMeal);
  }
}
