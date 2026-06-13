part of 'user_settings_bloc.dart';

@Freezed()
sealed class UserSettingsEvent with _$UserSettingsEvent {
  const factory UserSettingsEvent.settingsCommitted(
    UserSettingsState settings,
  ) = SettingsCommitted;
  const factory UserSettingsEvent.reminderStyleSelected(ReminderStyle style) =
      SettingsReminderStyleSelected;
  const factory UserSettingsEvent.mealCheckinScheduleModeChanged(
    MealCheckinScheduleMode mode,
  ) = SettingsMealCheckinScheduleModeChanged;
  const factory UserSettingsEvent.mealReminderToggled(
    MealOfTheDay meal, {
    required bool enabled,
  }) = SettingsMealReminderToggled;
  const factory UserSettingsEvent.mealReminderTimeChanged(
    MealOfTheDay meal,
    TimeOfDay time,
  ) = SettingsMealReminderTimeChanged;
  const factory UserSettingsEvent.endOfDayTimeChanged(TimeOfDay time) =
      SettingsEndOfDayTimeChanged;
  const factory UserSettingsEvent.weightCheckinFrequencySelected(
    WeightCheckinFrequency frequency,
  ) = SettingsWeightCheckinFrequencySelected;
  const factory UserSettingsEvent.weightTimeOfDaySelected(
    WeightTimeOfDay timeOfDay,
  ) = SettingsWeightTimeOfDaySelected;
  const factory UserSettingsEvent.weightUnitSelected(WeightUnit unit) =
      SettingsWeightUnitSelected;
  const factory UserSettingsEvent.startingWeightChanged(double? weight) =
      SettingsStartingWeightChanged;
  const factory UserSettingsEvent.usualAdded(
    MealOfTheDay meal,
    String name,
    int? calories,
  ) = SettingsUsualAdded;
  const factory UserSettingsEvent.usualRemoved(MealOfTheDay meal, String id) =
      SettingsUsualRemoved;
  const factory UserSettingsEvent.usualCaloriesChanged(
    MealOfTheDay meal,
    String id,
    int? calories,
  ) = SettingsUsualCaloriesChanged;
}
