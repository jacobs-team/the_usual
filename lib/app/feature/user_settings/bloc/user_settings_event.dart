part of 'user_settings_bloc.dart';

@Freezed()
sealed class UserSettingsEvent with _$UserSettingsEvent {
  const factory UserSettingsEvent.settingsCommitted(
    UserSettingsState settings,
  ) = SettingsCommitted;
  const factory UserSettingsEvent.reminderStyleSelected(
    ReminderStyle reminderStyle,
  ) = SettingsReminderStyleSelected;
  const factory UserSettingsEvent.mealCheckinScheduleModeChanged(
    MealCheckinScheduleMode mealCheckinScheduleMode,
  ) = SettingsMealCheckinScheduleModeChanged;
  const factory UserSettingsEvent.mealReminderToggled(
    MealOfTheDay mealOfTheDay, {
    required bool enabled,
  }) = SettingsMealReminderToggled;
  const factory UserSettingsEvent.mealReminderTimeChanged(
    MealOfTheDay mealOfTheDay,
    TimeOfDay timeOfDay,
  ) = SettingsMealReminderTimeChanged;
  const factory UserSettingsEvent.endOfDayTimeChanged(TimeOfDay timeOfDay) =
      SettingsEndOfDayTimeChanged;
  const factory UserSettingsEvent.weightCheckinFrequencySelected(
    WeightCheckinFrequency weightCheckinFrequency,
  ) = SettingsWeightCheckinFrequencySelected;
  const factory UserSettingsEvent.weightTimeOfDaySelected(
    WeightTimeOfDay weightTimeOfDay,
  ) = SettingsWeightTimeOfDaySelected;
  const factory UserSettingsEvent.weightUnitSelected(WeightUnit weightUnit) =
      SettingsWeightUnitSelected;
  const factory UserSettingsEvent.startingWeightChanged(double? weight) =
      SettingsStartingWeightChanged;
  const factory UserSettingsEvent.calorieGoalChanged(int? calorieGoal) =
      SettingsCalorieGoalChanged;
  const factory UserSettingsEvent.weightGoalChanged(double? weightGoal) =
      SettingsWeightGoalChanged;
  const factory UserSettingsEvent.themeModeSelected(ThemeMode themeMode) =
      SettingsThemeModeSelected;
  const factory UserSettingsEvent.expandNutritionByDefaultChanged({
    required bool expandNutritionByDefault,
  }) = SettingsExpandNutritionByDefaultChanged;
  const factory UserSettingsEvent.skipLoggedMealRemindersChanged({
    required bool skipLoggedMealReminders,
  }) = SettingsSkipLoggedMealRemindersChanged;
  const factory UserSettingsEvent.dayStartTimeChanged(TimeOfDay dayStartTime) =
      SettingsDayStartTimeChanged;
  const factory UserSettingsEvent.mealEntryModeChanged(
    MealEntryMode mealEntryMode,
  ) = SettingsMealEntryModeChanged;
  const factory UserSettingsEvent.usualMealAdded(
    MealOfTheDay mealOfTheDay,
    String name,
    Nutrition nutrition,
  ) = SettingsUsualMealAdded;
  const factory UserSettingsEvent.usualMealRemoved(
    MealOfTheDay mealOfTheDay,
    String id,
  ) = SettingsUsualMealRemoved;
  const factory UserSettingsEvent.usualMealNutritionChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    Nutrition nutrition,
  ) = SettingsUsualMealNutritionChanged;
  const factory UserSettingsEvent.usualMealNameChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    String name,
  ) = SettingsUsualMealNameChanged;
}
