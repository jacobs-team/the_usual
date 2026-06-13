part of 'daily_log_bloc.dart';

/// One logged day rolled up for the history screen: its calorie total,
/// weigh-in, and meals.
typedef HistoryDay = ({
  DateTime day,
  int calories,
  WeightEntry? weightEntry,
  List<MealLogEntry> mealEntries,
});

/// One month of history: its logged days (newest first) and the average daily
/// calories across them.
typedef HistoryMonth = ({
  DateTime month,
  int averageDailyCalories,
  List<HistoryDay> days,
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
        calories: meals.totalCalories,
        weightEntry: weightByDay[day],
        mealEntries: meals,
      ));
    }

    final months = daysByMonth.keys.toList()..sort((a, b) => a.compareTo(b));
    final history = <HistoryMonth>[];
    for (final month in months) {
      final days = daysByMonth[month]!;
      final totalCalories = days.fold(0, (total, day) => total + day.calories);
      history.add((
        month: month,
        averageDailyCalories: (totalCalories / days.length).round(),
        days: days,
      ));
    }
    return history;
  }
}
