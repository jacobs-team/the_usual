part of 'daily_log_bloc.dart';

/// One logged day rolled up for the history screen: its nutrition total,
/// weigh-in, and meals.
typedef HistoryDay = ({
  DateTime day,
  Nutrition nutrition,
  WeightEntry? weightEntry,
  List<MealLogEntry> mealEntries,
});

/// One month of history: its logged days (newest first), the average daily
/// nutrition across them, and its weigh-ins (oldest first).
typedef HistoryMonth = ({
  DateTime month,
  Nutrition averageNutrition,
  List<HistoryDay> days,
  List<WeightEntry> weightEntries,
});

/// {@template daily_log_state}
/// Everything logged across all days: meals and weigh-ins.
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

  /// The weigh-in recorded on [day], or null when there isn't one.
  WeightEntry? weightOn(DateTime day) {
    for (final weightEntry in weightEntries) {
      if (DateUtils.isSameDay(weightEntry.loggedAt, day)) return weightEntry;
    }
    return null;
  }

  /// The most recent weigh-in, or null when none have been recorded.
  WeightEntry? get latestWeight {
    if (weightEntries.isEmpty) return null;
    return weightEntries.reduce(
      (a, b) => a.loggedAt.isAfter(b.loggedAt) ? a : b,
    );
  }

  /// The full log rolled up by month for the history screen, oldest month
  /// first. Built in a single pass: meals and weigh-ins are bucketed by day,
  /// days are grouped into months, and each month's average is computed once.
  List<HistoryMonth> get historyByMonth {
    final mealsByDay = <DateTime, List<MealLogEntry>>{};
    for (final mealLogEntry in mealEntries) {
      final day = DateUtils.dateOnly(mealLogEntry.loggedAt);
      mealsByDay.putIfAbsent(day, () => <MealLogEntry>[]).add(mealLogEntry);
    }

    final weightByDay = <DateTime, WeightEntry>{};
    for (final weightEntry in weightEntries) {
      weightByDay[DateUtils.dateOnly(weightEntry.loggedAt)] = weightEntry;
    }

    final allDays = <DateTime>{...mealsByDay.keys, ...weightByDay.keys}.toList()
      ..sort((a, b) => b.compareTo(a));

    final daysByMonth = <DateTime, List<HistoryDay>>{};
    for (final day in allDays) {
      final meals = mealsByDay[day] ?? const <MealLogEntry>[];
      final month = DateTime(day.year, day.month);
      daysByMonth.putIfAbsent(month, () => <HistoryDay>[]).add((
        day: day,
        nutrition: meals.totalNutrition,
        weightEntry: weightByDay[day],
        mealEntries: meals,
      ));
    }

    final months = daysByMonth.keys.toList()..sort((a, b) => a.compareTo(b));
    final history = <HistoryMonth>[];
    for (final month in months) {
      final days = daysByMonth[month]!;
      var monthTotal = const Nutrition();
      for (final day in days) {
        monthTotal += day.nutrition;
      }
      final averageNutrition = Nutrition(
        calories: ((monthTotal.calories ?? 0) / days.length).round(),
        protein: ((monthTotal.protein ?? 0) / days.length).round(),
        fat: ((monthTotal.fat ?? 0) / days.length).round(),
        carbs: ((monthTotal.carbs ?? 0) / days.length).round(),
      );
      final weightEntries = [
        for (final historyDay in days.reversed)
          if (historyDay.weightEntry != null) historyDay.weightEntry!,
      ];
      history.add((
        month: month,
        averageNutrition: averageNutrition,
        days: days,
        weightEntries: weightEntries,
      ));
    }
    return history;
  }
}
