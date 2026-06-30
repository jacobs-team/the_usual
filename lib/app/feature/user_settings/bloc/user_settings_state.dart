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
    @Default(4) int version,

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

    /// The history of the user's daily calorie target, each entry the goal from
    /// the day it took effect, oldest first. Lets historical charts show the
    /// goal active at each point rather than retroactively applying the latest.
    /// Empty when no goal has ever been set.
    @Default(<CalorieGoalEntry>[]) List<CalorieGoalEntry> calorieGoalHistory,

    /// The history of the user's target weight, each entry the goal from the
    /// day it took effect, oldest first. Empty when no goal has ever been set.
    @Default(<WeightGoalEntry>[]) List<WeightGoalEntry> weightGoalHistory,

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

    /// The user's usual foods library: reusable base-unit nutritional items
    /// that compose meals. Flat (not keyed by meal timing) because a food like
    /// "Chicken, 1 oz" is reused across meals.
    @Default(<UsualFood>[]) List<UsualFood> usualFoods,

    /// The user's workout groups, for example Push / Pull / Legs. Ordered by
    /// [WorkoutGroup.order]. Seeded with three defaults that use stable const
    /// ids so they can be a const default and stay linked to logged workouts
    /// across renames.
    @Default(<WorkoutGroup>[
      WorkoutGroup(id: 'push', name: 'Push', order: 0),
      WorkoutGroup(id: 'pull', name: 'Pull', order: 1),
      WorkoutGroup(id: 'legs', name: 'Legs', order: 2),
    ])
    List<WorkoutGroup> workoutGroups,

    /// The user's usual workouts, keyed by [WorkoutGroup.id].
    @Default(<String, List<UsualWorkout>>{})
    Map<String, List<UsualWorkout>> usualWorkouts,

    /// The workout check-in reminder.
    @Default(
      WorkoutReminder(
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      ),
    )
    WorkoutReminder workoutReminder,

    /// The unit workout weights are entered and shown in. Defaults to the
    /// body-weight [weightUnit] for returning users via migration.
    @Default(WeightUnit.lb) WeightUnit workoutWeightUnit,

    /// The last "Save as usual" choice in the food entry sheet, restored as the
    /// checkbox's default the next time it opens.
    @Default(true) bool saveMealAsUsual,

    /// The default value of the per-food "Save food as usual" checkbox. Chosen
    /// in Settings; unlike [saveMealAsUsual] it is not updated by toggling the
    /// checkbox itself.
    @Default(false) bool saveFoodAsUsualDefault,

    /// The last "Save as usual" choice in the workout entry sheet, restored as
    /// the checkbox's default the next time it opens.
    @Default(false) bool saveWorkoutAsUsual,
  }) = _UserSettingsState;

  const UserSettingsState._();

  /// The version written by the current app.
  static const _currentVersion = 4;

  /// The number of usual meals (across all timings) with at least one component
  /// linked to the usual food [usualFoodId].
  int usualMealsUsingFood(String usualFoodId) {
    var count = 0;
    for (final usualMeals in usuals.values) {
      for (final usualMeal in usualMeals) {
        if (usualMeal.components.any((c) => c.usualFoodId == usualFoodId)) {
          count++;
        }
      }
    }
    return count;
  }

  /// The number of saved usual foods in the library.
  int get usualFoodCount => usualFoods.length;

  /// The total number of saved usual meals across all meal timings.
  int get usualMealCount =>
      usuals.values.fold(0, (count, usualMeals) => count + usualMeals.length);

  /// Whether the usuals library alone marks an established user: more than one
  /// saved usual meal.
  bool get hasEstablishedUsuals => usualMealCount > 1;

  /// The current daily calorie target, or null when unset. Drives the length of
  /// the Today nutrition bar; when null the bar's macros fill its full width
  /// instead of a portion of the goal.
  int? get calorieGoal =>
      calorieGoalHistory.isEmpty ? null : calorieGoalHistory.last.calories;

  /// The current target weight in [weightUnit], or null when unset.
  double? get weightGoal =>
      weightGoalHistory.isEmpty ? null : weightGoalHistory.last.weight;

  factory UserSettingsState.fromJson(Map<String, dynamic> json) =>
      UserSettingsState._fromVersionedJson(json);

  factory UserSettingsState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    var migrated = json;

    // The `onAppOpen` reminder style was removed; map data still carrying it to
    // no reminders so the dropped value decodes instead of resetting settings.
    if (migrated['reminderStyle'] == 'onAppOpen') {
      migrated = {...migrated, 'reminderStyle': 'none'};
    }

    // v1 and earlier predate workout settings. Inherit the workout weight unit
    // from the existing body-weight unit instead of the bare lb default; other
    // new keys fall back to their defaults.
    if (version <= 1 && !migrated.containsKey('workoutWeightUnit')) {
      migrated = {
        ...migrated,
        'workoutWeightUnit': migrated['weightUnit'] ?? 'lb',
      };
    }

    // v2 and earlier stored a single calorie/weight goal that applied to all
    // history. Seed each as one entry effective from the epoch so it still
    // covers every past day, after which dated edits stack on top.
    if (version <= 2) {
      migrated = _migrateGoalsToHistory(migrated);
    }

    // A version newer than this build (e.g. after a downgrade) skips every
    // migration above and is read with the current schema as a best effort
    // rather than discarding the user's settings.
    return _$UserSettingsStateFromJson({
      ...migrated,
      'version': _currentVersion,
    });
  }

  /// Converts the pre-v3 scalar `calorieGoal`/`weightGoal` into single-entry
  /// goal histories effective from the epoch, so the goal still applies to all
  /// of the user's existing history.
  static Map<String, dynamic> _migrateGoalsToHistory(
    Map<String, dynamic> json,
  ) {
    const epoch = '1970-01-01T00:00:00.000';
    final migrated = {...json};

    final calorieGoal = json['calorieGoal'] as int?;
    migrated['calorieGoalHistory'] = [
      if (calorieGoal != null)
        {'effectiveFrom': epoch, 'calories': calorieGoal},
    ];

    final weightGoal = (json['weightGoal'] as num?)?.toDouble();
    final weightUnit = json['weightUnit'] as String? ?? 'lb';
    migrated['weightGoalHistory'] = [
      if (weightGoal != null)
        {
          'effectiveFrom': epoch,
          'weight': weightGoal,
          'weightUnit': weightUnit,
        },
    ];

    return migrated
      ..remove('calorieGoal')
      ..remove('weightGoal');
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
    var currentMeal = boundaries.first.meal;
    for (final boundary in boundaries) {
      if (nowMinutes >= boundary.minutes) currentMeal = boundary.meal;
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
    for (final boundary in boundaries.skip(1)) {
      if (boundary.minutes > nowMinutes) {
        return today.add(Duration(minutes: boundary.minutes));
      }
    }
    // Every later reminder has passed; the highlight next changes at midnight,
    // when the highlight returns to the first meal.
    return today.add(const Duration(days: 1));
  }

  /// Enabled per-meal reminders as (meal, minutes-since-midnight), earliest
  /// first. Empty when per-meal reminders don't apply, which signals the
  /// time-of-day fallback.
  List<({MealOfTheDay meal, int minutes})> get _mealBoundaries {
    if (mealCheckinScheduleMode != MealCheckinScheduleMode.perMeal) {
      return const [];
    }
    return [
      for (final entry in mealReminders.entries)
        if (entry.value.enabled)
          (
            meal: entry.key,
            minutes:
                entry.value.timeOfDay.hour * 60 + entry.value.timeOfDay.minute,
          ),
    ]..sort((a, b) => a.minutes.compareTo(b.minutes));
  }
}
