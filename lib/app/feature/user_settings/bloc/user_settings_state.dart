part of 'user_settings_bloc.dart';

/// {@template user_settings_state}
/// The user's settings, chosen during onboarding and editable later from the
/// settings screen.
/// {@endtemplate}
@freezed
abstract class UserSettingsState with _$UserSettingsState {
  /// {@macro user_settings_state}
  @JsonSerializable(explicitToJson: true)
  const factory UserSettingsState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,

    /// How the app checks in about meals.
    @Default(ReminderStyle.notifications) ReminderStyle reminderStyle,

    /// Whether meal check-ins happen per meal or once at the end of the day.
    @Default(MealCheckinScheduleMode.perMeal)
    MealCheckinScheduleMode mealCheckinScheduleMode,

    /// Per-meal check-in reminders, used in
    /// [MealCheckinScheduleMode.perMeal].
    @Default({
      MealOfTheDay.breakfast: MealReminder(
        enabled: true,
        timeOfDay: TimeOfDay(hour: 9, minute: 0),
      ),
      MealOfTheDay.lunch: MealReminder(
        enabled: true,
        timeOfDay: TimeOfDay(hour: 14, minute: 0),
      ),
      MealOfTheDay.dinner: MealReminder(
        enabled: true,
        timeOfDay: TimeOfDay(hour: 19, minute: 30),
      ),
      MealOfTheDay.snacks: MealReminder(
        enabled: false,
        timeOfDay: TimeOfDay(hour: 15, minute: 0),
      ),
    })
    Map<MealOfTheDay, MealReminder> mealReminders,

    /// The single daily check-in covering all meals, used in
    /// [MealCheckinScheduleMode.endOfDay].
    @Default(
      MealReminder(enabled: true, timeOfDay: TimeOfDay(hour: 20, minute: 0)),
    )
    MealReminder endOfDayReminder,

    /// How often the user weighs in. [WeightCheckinFrequency.off] disables
    /// weight check-ins.
    @Default(WeightCheckinFrequency.daily)
    WeightCheckinFrequency weightCheckinFrequency,

    /// When in the day the weigh-in reminder fires.
    @Default(WeightTimeOfDay.morning) WeightTimeOfDay weightTimeOfDay,
    @Default(WeightUnit.lb) WeightUnit weightUnit,

    /// Baseline weight in [weightUnit], null when never provided.
    double? startingWeight,

    /// The user's daily calorie target, null when they haven't set one. Drives
    /// the length of the Today nutrition bar; when null the bar's macros fill
    /// its full width instead of a portion of the goal.
    int? calorieGoal,

    /// The user's target weight in [weightUnit], null when they haven't set
    /// one.
    double? weightGoal,

    /// Whether the app follows the system theme or is forced light or dark.
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// Whether a meal's nutrition fields start expanded for editing rather than
    /// collapsed to a summary.
    @Default(false) bool expandNutritionByDefault,

    /// Whether a reminder is skipped on a day its entry is already logged: a
    /// meal reminder once that meal is logged, and the weigh-in reminder once
    /// today's weight is logged. When false, reminders fire regardless of
    /// what's logged.
    @Default(false) bool skipLoggedMealReminders,

    /// When a new day begins. Meals and weigh-ins logged before this time count
    /// toward the previous day, so late-night logging lands on the right day
    /// and the Today view doesn't roll over at midnight.
    @TimeOfDayConverter()
    @Default(TimeOfDay(hour: 0, minute: 0))
    TimeOfDay dayStartTime,

    /// How AI-assisted entry turns a meal into log entries: one combined item
    /// or a breakdown into individual foods. Remembered as the user's default
    /// and switchable per entry from the food entry sheet.
    @Default(MealEntryMode.wholeMeal) MealEntryMode mealEntryMode,

    /// The user's usuals library, keyed by meal timing.
    @Default(<MealOfTheDay, List<UsualMeal>>{})
    Map<MealOfTheDay, List<UsualMeal>> usuals,
  }) = _UserSettingsState;

  const UserSettingsState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  factory UserSettingsState.fromJson(Map<String, dynamic> json) =>
      UserSettingsState._fromVersionedJson(json);

  factory UserSettingsState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up to the current one before this case.
      case 0:
      case _currentVersion:
        return _$UserSettingsStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's settings: unknown keys are ignored and missing
        // ones fall back to defaults.
        return _$UserSettingsStateFromJson(json);
    }
  }

  /// The meal section to highlight as current at [now].
  ///
  /// With per-meal reminders on, it is the latest meal whose reminder time has
  /// passed — so once a meal's reminder fires the highlight moves to it, ready
  /// for the user to log what they just ate, and stays there until the next
  /// meal's reminder. Before any reminder has fired it rests on the first meal,
  /// since nothing precedes breakfast after midnight. With no per-meal
  /// reminders it falls back to typical meal times.
  MealOfTheDay currentMeal(DateTime now) {
    final boundaries = _mealBoundaries;
    if (boundaries.isEmpty) {
      return MealOfTheDay.fromTime(TimeOfDay.fromDateTime(now));
    }
    final nowMinutes = now.hour * 60 + now.minute;
    var currentMeal = boundaries.first.$1;
    for (final (meal, minutes) in boundaries) {
      if (nowMinutes >= minutes) currentMeal = meal;
    }
    return currentMeal;
  }

  /// The next instant after [now] when [currentMeal] changes, so the Today
  /// view can refresh exactly when the highlighted meal does.
  DateTime nextMealBoundary(DateTime now) {
    final boundaries = _mealBoundaries;
    final today = DateUtils.dateOnly(now);
    if (boundaries.isEmpty) {
      // The fallback only changes on the hour (see [MealOfTheDay.fromTime]),
      // so the next change is the top of the next hour.
      return DateTime(now.year, now.month, now.day, now.hour + 1);
    }
    final nowMinutes = now.hour * 60 + now.minute;
    // The first reminder isn't a change point: before it the highlight already
    // rests on the first meal, and crossing it leaves the highlight there. Only
    // later reminders move it.
    for (final (_, minutes) in boundaries.skip(1)) {
      if (minutes > nowMinutes) return today.add(Duration(minutes: minutes));
    }
    // Every later reminder has passed; the highlight next changes at midnight,
    // when the highlight returns to the first meal.
    return today.add(const Duration(days: 1));
  }

  /// Enabled per-meal reminders as (meal, minutes-since-midnight), earliest
  /// first. Empty when per-meal reminders don't apply, which signals the
  /// time-of-day fallback.
  List<(MealOfTheDay, int)> get _mealBoundaries {
    if (mealCheckinScheduleMode != MealCheckinScheduleMode.perMeal) {
      return const [];
    }
    return [
      for (final entry in mealReminders.entries)
        if (entry.value.enabled)
          (
            entry.key,
            entry.value.timeOfDay.hour * 60 + entry.value.timeOfDay.minute,
          ),
    ]..sort((a, b) => a.$2.compareTo(b.$2));
  }
}
