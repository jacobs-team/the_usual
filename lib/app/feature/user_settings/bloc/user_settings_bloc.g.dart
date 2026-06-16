// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettingsState _$UserSettingsStateFromJson(
  Map<String, dynamic> json,
) => _UserSettingsState(
  version: (json['version'] as num?)?.toInt() ?? 1,
  reminderStyle:
      $enumDecodeNullable(_$ReminderStyleEnumMap, json['reminderStyle']) ??
      ReminderStyle.notifications,
  mealCheckinScheduleMode:
      $enumDecodeNullable(
        _$MealCheckinScheduleModeEnumMap,
        json['mealCheckinScheduleMode'],
      ) ??
      MealCheckinScheduleMode.perMeal,
  mealReminders:
      (json['mealReminders'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          $enumDecode(_$MealOfTheDayEnumMap, k),
          MealReminder.fromJson(e as Map<String, dynamic>),
        ),
      ) ??
      const {
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
      },
  endOfDayReminder: json['endOfDayReminder'] == null
      ? const MealReminder(
          enabled: true,
          timeOfDay: TimeOfDay(hour: 20, minute: 0),
        )
      : MealReminder.fromJson(json['endOfDayReminder'] as Map<String, dynamic>),
  weightCheckinFrequency:
      $enumDecodeNullable(
        _$WeightCheckinFrequencyEnumMap,
        json['weightCheckinFrequency'],
      ) ??
      WeightCheckinFrequency.daily,
  weightTimeOfDay:
      $enumDecodeNullable(_$WeightTimeOfDayEnumMap, json['weightTimeOfDay']) ??
      WeightTimeOfDay.morning,
  weightUnit:
      $enumDecodeNullable(_$WeightUnitEnumMap, json['weightUnit']) ??
      WeightUnit.lb,
  startingWeight: (json['startingWeight'] as num?)?.toDouble(),
  calorieGoal: (json['calorieGoal'] as num?)?.toInt(),
  weightGoal: (json['weightGoal'] as num?)?.toDouble(),
  themeMode:
      $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
      ThemeMode.system,
  expandNutritionByDefault: json['expandNutritionByDefault'] as bool? ?? false,
  usuals:
      (json['usuals'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          $enumDecode(_$MealOfTheDayEnumMap, k),
          (e as List<dynamic>)
              .map((e) => UsualMeal.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const <MealOfTheDay, List<UsualMeal>>{},
);

Map<String, dynamic> _$UserSettingsStateToJson(
  _UserSettingsState instance,
) => <String, dynamic>{
  'version': instance.version,
  'reminderStyle': _$ReminderStyleEnumMap[instance.reminderStyle]!,
  'mealCheckinScheduleMode':
      _$MealCheckinScheduleModeEnumMap[instance.mealCheckinScheduleMode]!,
  'mealReminders': instance.mealReminders.map(
    (k, e) => MapEntry(_$MealOfTheDayEnumMap[k]!, e.toJson()),
  ),
  'endOfDayReminder': instance.endOfDayReminder.toJson(),
  'weightCheckinFrequency':
      _$WeightCheckinFrequencyEnumMap[instance.weightCheckinFrequency]!,
  'weightTimeOfDay': _$WeightTimeOfDayEnumMap[instance.weightTimeOfDay]!,
  'weightUnit': _$WeightUnitEnumMap[instance.weightUnit]!,
  'startingWeight': instance.startingWeight,
  'calorieGoal': instance.calorieGoal,
  'weightGoal': instance.weightGoal,
  'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
  'expandNutritionByDefault': instance.expandNutritionByDefault,
  'usuals': instance.usuals.map(
    (k, e) =>
        MapEntry(_$MealOfTheDayEnumMap[k]!, e.map((e) => e.toJson()).toList()),
  ),
};

const _$ReminderStyleEnumMap = {
  ReminderStyle.notifications: 'notifications',
  ReminderStyle.onAppOpen: 'onAppOpen',
  ReminderStyle.none: 'none',
};

const _$MealCheckinScheduleModeEnumMap = {
  MealCheckinScheduleMode.perMeal: 'perMeal',
  MealCheckinScheduleMode.endOfDay: 'endOfDay',
};

const _$MealOfTheDayEnumMap = {
  MealOfTheDay.breakfast: 'breakfast',
  MealOfTheDay.lunch: 'lunch',
  MealOfTheDay.dinner: 'dinner',
  MealOfTheDay.snacks: 'snacks',
};

const _$WeightCheckinFrequencyEnumMap = {
  WeightCheckinFrequency.daily: 'daily',
  WeightCheckinFrequency.everyTwoDays: 'everyTwoDays',
  WeightCheckinFrequency.weekly: 'weekly',
  WeightCheckinFrequency.off: 'off',
};

const _$WeightTimeOfDayEnumMap = {
  WeightTimeOfDay.morning: 'morning',
  WeightTimeOfDay.evening: 'evening',
  WeightTimeOfDay.night: 'night',
};

const _$WeightUnitEnumMap = {WeightUnit.lb: 'lb', WeightUnit.kg: 'kg'};

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
