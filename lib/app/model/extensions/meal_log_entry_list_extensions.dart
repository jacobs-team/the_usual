import 'package:flutter/material.dart';
import 'package:the_usual/app/model/model.dart';

/// A day's meal entries grouped for display, with the running calorie total
/// computed in the same pass.
typedef DailyMealBreakdown = ({
  int calories,
  Map<MealOfTheDay, List<MealLogEntry>> entriesByMeal,
});

extension MealLogEntryListFormatting on List<MealLogEntry> {
  /// Total known calories across these entries. Entries without calories add
  /// nothing to the total.
  int get totalCalories {
    var calories = 0;
    for (final mealLogEntry in this) {
      calories += mealLogEntry.calories ?? 0;
    }
    return calories;
  }

  /// Groups the entries logged on [day] by meal of the day and sums their
  /// known calories in a single pass. Entries without calories add nothing to
  /// the total.
  DailyMealBreakdown breakdownOn(DateTime day) {
    var calories = 0;
    final entriesByMeal = <MealOfTheDay, List<MealLogEntry>>{};
    for (final mealLogEntry in this) {
      if (!DateUtils.isSameDay(mealLogEntry.loggedAt, day)) continue;
      calories += mealLogEntry.calories ?? 0;
      entriesByMeal
          .putIfAbsent(mealLogEntry.mealOfTheDay, () => <MealLogEntry>[])
          .add(mealLogEntry);
    }
    return (calories: calories, entriesByMeal: entriesByMeal);
  }
}
