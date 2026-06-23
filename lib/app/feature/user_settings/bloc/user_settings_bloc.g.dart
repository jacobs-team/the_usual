// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserSettingsState _$UserSettingsStateFromJson(
  Map<String, dynamic> json,
) => _UserSettingsState(
  version: (json['version'] as num?)?.toInt() ?? 2,
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
  skipLoggedMealReminders: json['skipLoggedMealReminders'] as bool? ?? false,
  dayStartTime: json['dayStartTime'] == null
      ? const TimeOfDay(hour: 0, minute: 0)
      : const TimeOfDayConverter().fromJson(
          json['dayStartTime'] as Map<String, dynamic>,
        ),
  mealEntryMode:
      $enumDecodeNullable(_$MealEntryModeEnumMap, json['mealEntryMode']) ??
      MealEntryMode.wholeMeal,
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
  workoutGroups:
      (json['workoutGroups'] as List<dynamic>?)
          ?.map((e) => WorkoutGroup.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WorkoutGroup>[
        WorkoutGroup(id: 'push', name: 'Push', order: 0),
        WorkoutGroup(id: 'pull', name: 'Pull', order: 1),
        WorkoutGroup(id: 'legs', name: 'Legs', order: 2),
      ],
  usualWorkouts:
      (json['usualWorkouts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => UsualWorkout.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ) ??
      const <String, List<UsualWorkout>>{},
  workoutReminder: json['workoutReminder'] == null
      ? const WorkoutReminder(
          enabled: false,
          timeOfDay: TimeOfDay(hour: 18, minute: 0),
        )
      : WorkoutReminder.fromJson(
          json['workoutReminder'] as Map<String, dynamic>,
        ),
  workoutWeightUnit:
      $enumDecodeNullable(_$WeightUnitEnumMap, json['workoutWeightUnit']) ??
      WeightUnit.lb,
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
  'skipLoggedMealReminders': instance.skipLoggedMealReminders,
  'dayStartTime': const TimeOfDayConverter().toJson(instance.dayStartTime),
  'mealEntryMode': _$MealEntryModeEnumMap[instance.mealEntryMode]!,
  'usuals': instance.usuals.map(
    (k, e) =>
        MapEntry(_$MealOfTheDayEnumMap[k]!, e.map((e) => e.toJson()).toList()),
  ),
  'workoutGroups': instance.workoutGroups.map((e) => e.toJson()).toList(),
  'usualWorkouts': instance.usualWorkouts.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'workoutReminder': instance.workoutReminder.toJson(),
  'workoutWeightUnit': _$WeightUnitEnumMap[instance.workoutWeightUnit]!,
};

const _$ReminderStyleEnumMap = {
  ReminderStyle.notifications: 'notifications',
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

const _$MealEntryModeEnumMap = {
  MealEntryMode.wholeMeal: 'wholeMeal',
  MealEntryMode.itemized: 'itemized',
};
