part of 'user_settings_bloc.dart';

@Freezed()
sealed class UserSettingsEvent with _$UserSettingsEvent {
  const factory UserSettingsEvent.settingsCommitted(
    UserSettingsState settings,
  ) = SettingsCommitted;

  /// Replaces all settings with state downloaded from the cloud on sign-in.
  const factory UserSettingsEvent.stateRestored(UserSettingsState settings) =
      SettingsStateRestored;
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
    Nutrition nutrition, {
    String? id,
    @Default(<MealComponent>[]) List<MealComponent> components,
  }) = SettingsUsualMealAdded;
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

  const factory UserSettingsEvent.usualFoodPropagatedToMeals(
    String usualFoodId,
    Nutrition nutrition,
  ) = SettingsUsualFoodPropagatedToMeals;
  const factory UserSettingsEvent.usualMealComponentsChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    List<MealComponent> components,
    Nutrition nutrition,
  ) = SettingsUsualMealComponentsChanged;

  const factory UserSettingsEvent.usualFoodAdded(
    String name,
    Nutrition nutrition, {
    String? id,
  }) = SettingsUsualFoodAdded;
  const factory UserSettingsEvent.usualFoodRemoved(String id) =
      SettingsUsualFoodRemoved;
  const factory UserSettingsEvent.usualFoodNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = SettingsUsualFoodNutritionChanged;
  const factory UserSettingsEvent.usualFoodNameChanged(String id, String name) =
      SettingsUsualFoodNameChanged;

  const factory UserSettingsEvent.workoutGroupAdded(String name) =
      SettingsWorkoutGroupAdded;
  const factory UserSettingsEvent.workoutGroupRenamed(String id, String name) =
      SettingsWorkoutGroupRenamed;
  const factory UserSettingsEvent.workoutGroupReordered(
    List<String> orderedIds,
  ) = SettingsWorkoutGroupReordered;
  const factory UserSettingsEvent.workoutGroupRemoved(String id) =
      SettingsWorkoutGroupRemoved;

  const factory UserSettingsEvent.usualWorkoutAdded(
    String workoutGroupId,
    String name,
    List<WorkoutSet> sets, {
    @Default(WorkoutType.strength) WorkoutType type,
    Duration? duration,
  }) = SettingsUsualWorkoutAdded;
  const factory UserSettingsEvent.usualWorkoutRenamed(
    String workoutGroupId,
    String id,
    String name,
  ) = SettingsUsualWorkoutRenamed;
  const factory UserSettingsEvent.usualWorkoutSetsChanged(
    String workoutGroupId,
    String id,
    List<WorkoutSet> sets,
  ) = SettingsUsualWorkoutSetsChanged;
  const factory UserSettingsEvent.usualWorkoutDurationChanged(
    String workoutGroupId,
    String id,
    Duration duration,
  ) = SettingsUsualWorkoutDurationChanged;
  const factory UserSettingsEvent.usualWorkoutRemoved(
    String workoutGroupId,
    String id,
  ) = SettingsUsualWorkoutRemoved;
  const factory UserSettingsEvent.workoutWeightUnitSelected(
    WeightUnit weightUnit,
  ) = SettingsWorkoutWeightUnitSelected;

  const factory UserSettingsEvent.workoutReminderToggled({
    required bool enabled,
  }) = SettingsWorkoutReminderToggled;
  const factory UserSettingsEvent.workoutReminderDayToggled(
    int dayOfWeek, {
    required bool enabled,
  }) = SettingsWorkoutReminderDayToggled;
  const factory UserSettingsEvent.workoutReminderTimeChanged(
    TimeOfDay timeOfDay,
  ) = SettingsWorkoutReminderTimeChanged;

  const factory UserSettingsEvent.saveMealAsUsualChanged({
    required bool value,
  }) = SettingsSaveMealAsUsualChanged;
  const factory UserSettingsEvent.saveWorkoutAsUsualChanged({
    required bool value,
  }) = SettingsSaveWorkoutAsUsualChanged;
}
