part of 'daily_log_bloc.dart';

/// {@template daily_log_state}
/// Everything logged across all days: meals and weigh-ins. Helpers narrow
/// the meal entries to a given day.
/// {@endtemplate}
@freezed
abstract class DailyLogState with _$DailyLogState {
  /// {@macro daily_log_state}
  @JsonSerializable(explicitToJson: true)
  const factory DailyLogState({
    @Default(<MealLogEntry>[]) List<MealLogEntry> mealEntries,
    @Default(<WeightEntry>[]) List<WeightEntry> weightEntries,
  }) = _DailyLogState;

  const DailyLogState._();

  factory DailyLogState.fromJson(Map<String, dynamic> json) =>
      _$DailyLogStateFromJson(json);

  /// Total known calories logged on [day]. Entries without calories don't
  /// contribute until their value is filled in.
  int caloriesOn(DateTime day) {
    return mealEntries
        .where(
          (mealLogEntry) => DateUtils.isSameDay(mealLogEntry.loggedAt, day),
        )
        .fold(
          0,
          (total, mealLogEntry) => total + (mealLogEntry.calories ?? 0),
        );
  }

  /// The weigh-in recorded on [day], or null when there isn't one.
  WeightEntry? weightOn(DateTime day) {
    for (final weightEntry in weightEntries) {
      if (DateUtils.isSameDay(weightEntry.loggedAt, day)) return weightEntry;
    }
    return null;
  }

  /// Every day that has any logged meal or weigh-in, newest first.
  List<DateTime> get loggedDays {
    final days = <DateTime>{
      for (final mealLogEntry in mealEntries)
        DateUtils.dateOnly(mealLogEntry.loggedAt),
      for (final weightEntry in weightEntries)
        DateUtils.dateOnly(weightEntry.loggedAt),
    };
    return days.toList()..sort((a, b) => b.compareTo(a));
  }

  /// Every month that has any logged day, oldest first. Each is the first of
  /// its month, so the newest sits last.
  List<DateTime> get loggedMonths {
    final months = <DateTime>{
      for (final day in loggedDays) DateTime(day.year, day.month),
    };
    return months.toList()..sort((a, b) => a.compareTo(b));
  }

  /// The logged days that fall within [month], newest first.
  List<DateTime> loggedDaysIn(DateTime month) {
    return loggedDays
        .where((day) => day.year == month.year && day.month == month.month)
        .toList();
  }

  /// Average calories across the logged days in [month], rounded. Days with no
  /// calories still count as a zero-calorie day.
  int averageDailyCaloriesIn(DateTime month) {
    final daysInMonth = loggedDaysIn(month);
    if (daysInMonth.isEmpty) return 0;
    final totalCalories = daysInMonth.fold(
      0,
      (total, day) => total + caloriesOn(day),
    );
    return (totalCalories / daysInMonth.length).round();
  }

  /// The meal entries logged on [day].
  List<MealLogEntry> mealEntriesOn(DateTime day) {
    return mealEntries
        .where(
          (mealLogEntry) => DateUtils.isSameDay(mealLogEntry.loggedAt, day),
        )
        .toList();
  }

  /// The most recent weigh-in, or null when none have been recorded.
  WeightEntry? get latestWeight {
    if (weightEntries.isEmpty) return null;
    return weightEntries.reduce(
      (a, b) => a.loggedAt.isAfter(b.loggedAt) ? a : b,
    );
  }
}
