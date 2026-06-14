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

    /// Whether the app follows the system theme or is forced light or dark.
    @Default(ThemeMode.system) ThemeMode themeMode,

    /// The user's usuals library, keyed by meal timing.
    @Default(<MealOfTheDay, List<UsualMeal>>{})
    Map<MealOfTheDay, List<UsualMeal>> usuals,
  }) = _UserSettingsState;

  factory UserSettingsState.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsStateFromJson(json);
}
