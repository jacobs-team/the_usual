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
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,
    @Default(<MealLogEntry>[]) List<MealLogEntry> mealEntries,
    @Default(<WeightEntry>[]) List<WeightEntry> weightEntries,

    /// The id of the entry logged most recently this session. Ephemeral: it is
    /// not persisted, so a relaunch clears it, and it is ignored when comparing
    /// state for cloud sync.
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? justLoggedEntryId,
  }) = _DailyLogState;

  const DailyLogState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  factory DailyLogState.fromJson(Map<String, dynamic> json) =>
      DailyLogState._fromVersionedJson(json);

  factory DailyLogState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up to the current one before this case.
      case 0:
      case _currentVersion:
        return _$DailyLogStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's logged meals and weigh-ins: unknown keys are
        // ignored and missing ones fall back to defaults.
        return _$DailyLogStateFromJson(json);
    }
  }

  /// The weigh-in recorded on the logical [day] (rolling over at [dayStart]),
  /// or null when there isn't one.
  WeightEntry? weightOn(DateTime day, TimeOfDay dayStart) {
    for (final weightEntry in weightEntries) {
      final loggedDay = weightEntry.loggedAt.logicalDay(dayStart);
      if (DateUtils.isSameDay(loggedDay, day)) return weightEntry;
    }
    return null;
  }

  /// Whether the log alone marks an established user: any logged meal, or
  /// weigh-ins on more than one logical day (rolling over at [dayStart]).
  bool hasEstablishedLog(TimeOfDay dayStart) {
    if (mealEntries.isNotEmpty) return true;
    final weighInDays = <DateTime>{
      for (final weightEntry in weightEntries)
        weightEntry.loggedAt.logicalDay(dayStart),
    };
    return weighInDays.length > 1;
  }

  /// The most recent weigh-in, or null when none have been recorded.
  WeightEntry? get latestWeight {
    if (weightEntries.isEmpty) return null;
    return weightEntries.reduce(
      (a, b) => a.loggedAt.isAfter(b.loggedAt) ? a : b,
    );
  }

  /// The full log rolled up by month for the history screen, oldest month
  /// first. Built in a single pass: meals and weigh-ins are bucketed by logical
  /// day (rolling over at [dayStart]), days are grouped into months, and each
  /// month's average is computed once.
  List<HistoryMonth> historyByMonth(TimeOfDay dayStart) {
    final mealsByDay = <DateTime, List<MealLogEntry>>{};
    for (final mealLogEntry in mealEntries) {
      final day = mealLogEntry.loggedAt.logicalDay(dayStart);
      mealsByDay.putIfAbsent(day, () => <MealLogEntry>[]).add(mealLogEntry);
    }

    final weightByDay = <DateTime, WeightEntry>{};
    for (final weightEntry in weightEntries) {
      weightByDay[weightEntry.loggedAt.logicalDay(dayStart)] = weightEntry;
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
