import 'package:flutter/material.dart';
import 'package:the_usual/app/model/model.dart';

/// A day's meal entries grouped for display, with the running nutrition total
/// computed in the same pass.
typedef DailyMealBreakdown = ({
  Nutrition nutrition,
  Map<MealOfTheDay, List<MealLogEntry>> entriesByMeal,
});

extension MealLogEntryListFormatting on List<MealLogEntry> {
  /// Total known nutrition across these entries, each scaled by its quantity.
  /// Values an entry leaves unset add nothing to the total.
  Nutrition get totalNutrition {
    var nutrition = const Nutrition();
    for (final mealLogEntry in this) {
      nutrition += mealLogEntry.scaledNutrition;
    }
    return nutrition;
  }

  /// Groups the entries logged on [day] by meal of the day and sums their
  /// known nutrition, each scaled by its quantity, in a single pass. Values an
  /// entry leaves unset add nothing to the total.
  DailyMealBreakdown breakdownOn(DateTime day) {
    var nutrition = const Nutrition();
    final entriesByMeal = <MealOfTheDay, List<MealLogEntry>>{};
    for (final mealLogEntry in this) {
      if (!DateUtils.isSameDay(mealLogEntry.loggedAt, day)) continue;
      nutrition += mealLogEntry.scaledNutrition;
      entriesByMeal
          .putIfAbsent(mealLogEntry.mealOfTheDay, () => <MealLogEntry>[])
          .add(mealLogEntry);
    }
    return (nutrition: nutrition, entriesByMeal: entriesByMeal);
  }

  /// The user's usuals for [mealOfTheDay]'s quick-pick chips: the most recently
  /// logged usual for this meal first, then this meal's usuals by how often
  /// they've been logged here. Usuals already logged on [day] for [mealOfTheDay]
  /// are dropped, matched by name or linked id so a renamed usual stays hidden.
  List<UsualMeal> orderedQuickPicks({
    required MealOfTheDay mealOfTheDay,
    required Map<MealOfTheDay, List<UsualMeal>> usuals,
    required DateTime day,
  }) {
    final loggedToday = _loggedTodayKeys(mealOfTheDay, day);
    final countAtTiming = <String, int>{};
    final lastLoggedAtTiming = <String, DateTime>{};

    for (final mealLogEntry in this) {
      final usualMealId = mealLogEntry.usualMealId;
      if (usualMealId == null) continue;
      if (mealLogEntry.mealOfTheDay != mealOfTheDay) continue;
      countAtTiming.update(
        usualMealId,
        (count) => count + 1,
        ifAbsent: () => 1,
      );
      final lastAtTiming = lastLoggedAtTiming[usualMealId];
      if (lastAtTiming == null || mealLogEntry.loggedAt.isAfter(lastAtTiming)) {
        lastLoggedAtTiming[usualMealId] = mealLogEntry.loggedAt;
      }
    }

    bool isVisible(UsualMeal usualMeal) =>
        !loggedToday.names.contains(usualMeal.name.toLowerCase()) &&
        !loggedToday.ids.contains(usualMeal.id);

    final thisMealUsuals = (usuals[mealOfTheDay] ?? <UsualMeal>[])
        .where(isVisible)
        .toList();

    UsualMeal? mostRecent;
    for (final usualMeal in thisMealUsuals) {
      final loggedAt = lastLoggedAtTiming[usualMeal.id];
      if (loggedAt == null) continue;
      final currentBest = mostRecent == null
          ? null
          : lastLoggedAtTiming[mostRecent.id];
      if (currentBest == null || loggedAt.isAfter(currentBest)) {
        mostRecent = usualMeal;
      }
    }

    final remaining = thisMealUsuals
        .where((usualMeal) => usualMeal.id != mostRecent?.id)
        .toList();
    _sortByLogActivity(remaining, countAtTiming, lastLoggedAtTiming);

    return [?mostRecent, ...remaining];
  }

  /// The user's usuals from meals other than [mealOfTheDay], grouped by their
  /// own meal in [MealOfTheDay] order and kept in library order within each.
  /// Usuals already logged on [day] for [mealOfTheDay] are dropped, and meals
  /// left with no usuals are omitted. Backs the "from another meal" picker.
  Map<MealOfTheDay, List<UsualMeal>> usualsFromOtherMeals({
    required MealOfTheDay mealOfTheDay,
    required Map<MealOfTheDay, List<UsualMeal>> usuals,
    required DateTime day,
  }) {
    final loggedToday = _loggedTodayKeys(mealOfTheDay, day);

    bool isVisible(UsualMeal usualMeal) =>
        !loggedToday.names.contains(usualMeal.name.toLowerCase()) &&
        !loggedToday.ids.contains(usualMeal.id);

    final grouped = <MealOfTheDay, List<UsualMeal>>{};
    for (final timing in MealOfTheDay.values) {
      if (timing == mealOfTheDay) continue;
      final visible = (usuals[timing] ?? <UsualMeal>[])
          .where(isVisible)
          .toList();
      if (visible.isNotEmpty) grouped[timing] = visible;
    }
    return grouped;
  }

  /// The lowercased names and linked ids of entries logged on [day] for
  /// [mealOfTheDay], used to hide usuals already logged in that section today.
  ({Set<String> names, Set<String> ids}) _loggedTodayKeys(
    MealOfTheDay mealOfTheDay,
    DateTime day,
  ) {
    final names = <String>{};
    final ids = <String>{};
    for (final mealLogEntry in this) {
      if (mealLogEntry.mealOfTheDay != mealOfTheDay) continue;
      if (!DateUtils.isSameDay(mealLogEntry.loggedAt, day)) continue;
      names.add(mealLogEntry.name.toLowerCase());
      final usualMealId = mealLogEntry.usualMealId;
      if (usualMealId != null) ids.add(usualMealId);
    }
    return (names: names, ids: ids);
  }
}

/// Sorts [usualMeals] in place by log [counts] descending, breaking ties by
/// most recent in [lastLogged], then by their original order in the list.
void _sortByLogActivity(
  List<UsualMeal> usualMeals,
  Map<String, int> counts,
  Map<String, DateTime> lastLogged,
) {
  final originalIndex = {
    for (final (index, usualMeal) in usualMeals.indexed) usualMeal.id: index,
  };
  usualMeals.sort((a, b) {
    final countComparison = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
    if (countComparison != 0) return countComparison;

    final lastA = lastLogged[a.id];
    final lastB = lastLogged[b.id];
    if (lastA != null && lastB != null && lastA != lastB) {
      return lastB.compareTo(lastA);
    }
    if (lastA == null && lastB != null) return 1;
    if (lastA != null && lastB == null) return -1;

    return originalIndex[a.id]!.compareTo(originalIndex[b.id]!);
  });
}
