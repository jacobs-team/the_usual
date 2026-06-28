// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserSettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UserSettingsEvent()';
}


}

/// @nodoc
class $UserSettingsEventCopyWith<$Res>  {
$UserSettingsEventCopyWith(UserSettingsEvent _, $Res Function(UserSettingsEvent) __);
}


/// Adds pattern-matching-related methods to [UserSettingsEvent].
extension UserSettingsEventPatterns on UserSettingsEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsCommitted value)?  settingsCommitted,TResult Function( SettingsStateRestored value)?  stateRestored,TResult Function( SettingsReminderStyleSelected value)?  reminderStyleSelected,TResult Function( SettingsMealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult Function( SettingsMealReminderToggled value)?  mealReminderToggled,TResult Function( SettingsMealReminderTimeChanged value)?  mealReminderTimeChanged,TResult Function( SettingsEndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult Function( SettingsWeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult Function( SettingsWeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult Function( SettingsWeightUnitSelected value)?  weightUnitSelected,TResult Function( SettingsStartingWeightChanged value)?  startingWeightChanged,TResult Function( SettingsCalorieGoalChanged value)?  calorieGoalChanged,TResult Function( SettingsWeightGoalChanged value)?  weightGoalChanged,TResult Function( SettingsThemeModeSelected value)?  themeModeSelected,TResult Function( SettingsExpandNutritionByDefaultChanged value)?  expandNutritionByDefaultChanged,TResult Function( SettingsSkipLoggedMealRemindersChanged value)?  skipLoggedMealRemindersChanged,TResult Function( SettingsDayStartTimeChanged value)?  dayStartTimeChanged,TResult Function( SettingsMealEntryModeChanged value)?  mealEntryModeChanged,TResult Function( SettingsUsualMealAdded value)?  usualMealAdded,TResult Function( SettingsUsualMealRemoved value)?  usualMealRemoved,TResult Function( SettingsUsualMealNutritionChanged value)?  usualMealNutritionChanged,TResult Function( SettingsUsualMealNameChanged value)?  usualMealNameChanged,TResult Function( SettingsWorkoutGroupAdded value)?  workoutGroupAdded,TResult Function( SettingsWorkoutGroupRenamed value)?  workoutGroupRenamed,TResult Function( SettingsWorkoutGroupReordered value)?  workoutGroupReordered,TResult Function( SettingsWorkoutGroupRemoved value)?  workoutGroupRemoved,TResult Function( SettingsUsualWorkoutAdded value)?  usualWorkoutAdded,TResult Function( SettingsUsualWorkoutRenamed value)?  usualWorkoutRenamed,TResult Function( SettingsUsualWorkoutSetsChanged value)?  usualWorkoutSetsChanged,TResult Function( SettingsUsualWorkoutDurationChanged value)?  usualWorkoutDurationChanged,TResult Function( SettingsUsualWorkoutRemoved value)?  usualWorkoutRemoved,TResult Function( SettingsWorkoutWeightUnitSelected value)?  workoutWeightUnitSelected,TResult Function( SettingsWorkoutReminderToggled value)?  workoutReminderToggled,TResult Function( SettingsWorkoutReminderDayToggled value)?  workoutReminderDayToggled,TResult Function( SettingsWorkoutReminderTimeChanged value)?  workoutReminderTimeChanged,TResult Function( SettingsSaveMealAsUsualChanged value)?  saveMealAsUsualChanged,TResult Function( SettingsSaveWorkoutAsUsualChanged value)?  saveWorkoutAsUsualChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case SettingsStateRestored() when stateRestored != null:
return stateRestored(_that);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case SettingsCalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that);case SettingsWeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that);case SettingsThemeModeSelected() when themeModeSelected != null:
return themeModeSelected(_that);case SettingsExpandNutritionByDefaultChanged() when expandNutritionByDefaultChanged != null:
return expandNutritionByDefaultChanged(_that);case SettingsSkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that);case SettingsDayStartTimeChanged() when dayStartTimeChanged != null:
return dayStartTimeChanged(_that);case SettingsMealEntryModeChanged() when mealEntryModeChanged != null:
return mealEntryModeChanged(_that);case SettingsUsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that);case SettingsUsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that);case SettingsUsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that);case SettingsUsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that);case SettingsWorkoutGroupAdded() when workoutGroupAdded != null:
return workoutGroupAdded(_that);case SettingsWorkoutGroupRenamed() when workoutGroupRenamed != null:
return workoutGroupRenamed(_that);case SettingsWorkoutGroupReordered() when workoutGroupReordered != null:
return workoutGroupReordered(_that);case SettingsWorkoutGroupRemoved() when workoutGroupRemoved != null:
return workoutGroupRemoved(_that);case SettingsUsualWorkoutAdded() when usualWorkoutAdded != null:
return usualWorkoutAdded(_that);case SettingsUsualWorkoutRenamed() when usualWorkoutRenamed != null:
return usualWorkoutRenamed(_that);case SettingsUsualWorkoutSetsChanged() when usualWorkoutSetsChanged != null:
return usualWorkoutSetsChanged(_that);case SettingsUsualWorkoutDurationChanged() when usualWorkoutDurationChanged != null:
return usualWorkoutDurationChanged(_that);case SettingsUsualWorkoutRemoved() when usualWorkoutRemoved != null:
return usualWorkoutRemoved(_that);case SettingsWorkoutWeightUnitSelected() when workoutWeightUnitSelected != null:
return workoutWeightUnitSelected(_that);case SettingsWorkoutReminderToggled() when workoutReminderToggled != null:
return workoutReminderToggled(_that);case SettingsWorkoutReminderDayToggled() when workoutReminderDayToggled != null:
return workoutReminderDayToggled(_that);case SettingsWorkoutReminderTimeChanged() when workoutReminderTimeChanged != null:
return workoutReminderTimeChanged(_that);case SettingsSaveMealAsUsualChanged() when saveMealAsUsualChanged != null:
return saveMealAsUsualChanged(_that);case SettingsSaveWorkoutAsUsualChanged() when saveWorkoutAsUsualChanged != null:
return saveWorkoutAsUsualChanged(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsCommitted value)  settingsCommitted,required TResult Function( SettingsStateRestored value)  stateRestored,required TResult Function( SettingsReminderStyleSelected value)  reminderStyleSelected,required TResult Function( SettingsMealCheckinScheduleModeChanged value)  mealCheckinScheduleModeChanged,required TResult Function( SettingsMealReminderToggled value)  mealReminderToggled,required TResult Function( SettingsMealReminderTimeChanged value)  mealReminderTimeChanged,required TResult Function( SettingsEndOfDayTimeChanged value)  endOfDayTimeChanged,required TResult Function( SettingsWeightCheckinFrequencySelected value)  weightCheckinFrequencySelected,required TResult Function( SettingsWeightTimeOfDaySelected value)  weightTimeOfDaySelected,required TResult Function( SettingsWeightUnitSelected value)  weightUnitSelected,required TResult Function( SettingsStartingWeightChanged value)  startingWeightChanged,required TResult Function( SettingsCalorieGoalChanged value)  calorieGoalChanged,required TResult Function( SettingsWeightGoalChanged value)  weightGoalChanged,required TResult Function( SettingsThemeModeSelected value)  themeModeSelected,required TResult Function( SettingsExpandNutritionByDefaultChanged value)  expandNutritionByDefaultChanged,required TResult Function( SettingsSkipLoggedMealRemindersChanged value)  skipLoggedMealRemindersChanged,required TResult Function( SettingsDayStartTimeChanged value)  dayStartTimeChanged,required TResult Function( SettingsMealEntryModeChanged value)  mealEntryModeChanged,required TResult Function( SettingsUsualMealAdded value)  usualMealAdded,required TResult Function( SettingsUsualMealRemoved value)  usualMealRemoved,required TResult Function( SettingsUsualMealNutritionChanged value)  usualMealNutritionChanged,required TResult Function( SettingsUsualMealNameChanged value)  usualMealNameChanged,required TResult Function( SettingsWorkoutGroupAdded value)  workoutGroupAdded,required TResult Function( SettingsWorkoutGroupRenamed value)  workoutGroupRenamed,required TResult Function( SettingsWorkoutGroupReordered value)  workoutGroupReordered,required TResult Function( SettingsWorkoutGroupRemoved value)  workoutGroupRemoved,required TResult Function( SettingsUsualWorkoutAdded value)  usualWorkoutAdded,required TResult Function( SettingsUsualWorkoutRenamed value)  usualWorkoutRenamed,required TResult Function( SettingsUsualWorkoutSetsChanged value)  usualWorkoutSetsChanged,required TResult Function( SettingsUsualWorkoutDurationChanged value)  usualWorkoutDurationChanged,required TResult Function( SettingsUsualWorkoutRemoved value)  usualWorkoutRemoved,required TResult Function( SettingsWorkoutWeightUnitSelected value)  workoutWeightUnitSelected,required TResult Function( SettingsWorkoutReminderToggled value)  workoutReminderToggled,required TResult Function( SettingsWorkoutReminderDayToggled value)  workoutReminderDayToggled,required TResult Function( SettingsWorkoutReminderTimeChanged value)  workoutReminderTimeChanged,required TResult Function( SettingsSaveMealAsUsualChanged value)  saveMealAsUsualChanged,required TResult Function( SettingsSaveWorkoutAsUsualChanged value)  saveWorkoutAsUsualChanged,}){
final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that);case SettingsStateRestored():
return stateRestored(_that);case SettingsReminderStyleSelected():
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled():
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged():
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged():
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected():
return weightUnitSelected(_that);case SettingsStartingWeightChanged():
return startingWeightChanged(_that);case SettingsCalorieGoalChanged():
return calorieGoalChanged(_that);case SettingsWeightGoalChanged():
return weightGoalChanged(_that);case SettingsThemeModeSelected():
return themeModeSelected(_that);case SettingsExpandNutritionByDefaultChanged():
return expandNutritionByDefaultChanged(_that);case SettingsSkipLoggedMealRemindersChanged():
return skipLoggedMealRemindersChanged(_that);case SettingsDayStartTimeChanged():
return dayStartTimeChanged(_that);case SettingsMealEntryModeChanged():
return mealEntryModeChanged(_that);case SettingsUsualMealAdded():
return usualMealAdded(_that);case SettingsUsualMealRemoved():
return usualMealRemoved(_that);case SettingsUsualMealNutritionChanged():
return usualMealNutritionChanged(_that);case SettingsUsualMealNameChanged():
return usualMealNameChanged(_that);case SettingsWorkoutGroupAdded():
return workoutGroupAdded(_that);case SettingsWorkoutGroupRenamed():
return workoutGroupRenamed(_that);case SettingsWorkoutGroupReordered():
return workoutGroupReordered(_that);case SettingsWorkoutGroupRemoved():
return workoutGroupRemoved(_that);case SettingsUsualWorkoutAdded():
return usualWorkoutAdded(_that);case SettingsUsualWorkoutRenamed():
return usualWorkoutRenamed(_that);case SettingsUsualWorkoutSetsChanged():
return usualWorkoutSetsChanged(_that);case SettingsUsualWorkoutDurationChanged():
return usualWorkoutDurationChanged(_that);case SettingsUsualWorkoutRemoved():
return usualWorkoutRemoved(_that);case SettingsWorkoutWeightUnitSelected():
return workoutWeightUnitSelected(_that);case SettingsWorkoutReminderToggled():
return workoutReminderToggled(_that);case SettingsWorkoutReminderDayToggled():
return workoutReminderDayToggled(_that);case SettingsWorkoutReminderTimeChanged():
return workoutReminderTimeChanged(_that);case SettingsSaveMealAsUsualChanged():
return saveMealAsUsualChanged(_that);case SettingsSaveWorkoutAsUsualChanged():
return saveWorkoutAsUsualChanged(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsCommitted value)?  settingsCommitted,TResult? Function( SettingsStateRestored value)?  stateRestored,TResult? Function( SettingsReminderStyleSelected value)?  reminderStyleSelected,TResult? Function( SettingsMealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult? Function( SettingsMealReminderToggled value)?  mealReminderToggled,TResult? Function( SettingsMealReminderTimeChanged value)?  mealReminderTimeChanged,TResult? Function( SettingsEndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult? Function( SettingsWeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult? Function( SettingsWeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult? Function( SettingsWeightUnitSelected value)?  weightUnitSelected,TResult? Function( SettingsStartingWeightChanged value)?  startingWeightChanged,TResult? Function( SettingsCalorieGoalChanged value)?  calorieGoalChanged,TResult? Function( SettingsWeightGoalChanged value)?  weightGoalChanged,TResult? Function( SettingsThemeModeSelected value)?  themeModeSelected,TResult? Function( SettingsExpandNutritionByDefaultChanged value)?  expandNutritionByDefaultChanged,TResult? Function( SettingsSkipLoggedMealRemindersChanged value)?  skipLoggedMealRemindersChanged,TResult? Function( SettingsDayStartTimeChanged value)?  dayStartTimeChanged,TResult? Function( SettingsMealEntryModeChanged value)?  mealEntryModeChanged,TResult? Function( SettingsUsualMealAdded value)?  usualMealAdded,TResult? Function( SettingsUsualMealRemoved value)?  usualMealRemoved,TResult? Function( SettingsUsualMealNutritionChanged value)?  usualMealNutritionChanged,TResult? Function( SettingsUsualMealNameChanged value)?  usualMealNameChanged,TResult? Function( SettingsWorkoutGroupAdded value)?  workoutGroupAdded,TResult? Function( SettingsWorkoutGroupRenamed value)?  workoutGroupRenamed,TResult? Function( SettingsWorkoutGroupReordered value)?  workoutGroupReordered,TResult? Function( SettingsWorkoutGroupRemoved value)?  workoutGroupRemoved,TResult? Function( SettingsUsualWorkoutAdded value)?  usualWorkoutAdded,TResult? Function( SettingsUsualWorkoutRenamed value)?  usualWorkoutRenamed,TResult? Function( SettingsUsualWorkoutSetsChanged value)?  usualWorkoutSetsChanged,TResult? Function( SettingsUsualWorkoutDurationChanged value)?  usualWorkoutDurationChanged,TResult? Function( SettingsUsualWorkoutRemoved value)?  usualWorkoutRemoved,TResult? Function( SettingsWorkoutWeightUnitSelected value)?  workoutWeightUnitSelected,TResult? Function( SettingsWorkoutReminderToggled value)?  workoutReminderToggled,TResult? Function( SettingsWorkoutReminderDayToggled value)?  workoutReminderDayToggled,TResult? Function( SettingsWorkoutReminderTimeChanged value)?  workoutReminderTimeChanged,TResult? Function( SettingsSaveMealAsUsualChanged value)?  saveMealAsUsualChanged,TResult? Function( SettingsSaveWorkoutAsUsualChanged value)?  saveWorkoutAsUsualChanged,}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case SettingsStateRestored() when stateRestored != null:
return stateRestored(_that);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case SettingsCalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that);case SettingsWeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that);case SettingsThemeModeSelected() when themeModeSelected != null:
return themeModeSelected(_that);case SettingsExpandNutritionByDefaultChanged() when expandNutritionByDefaultChanged != null:
return expandNutritionByDefaultChanged(_that);case SettingsSkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that);case SettingsDayStartTimeChanged() when dayStartTimeChanged != null:
return dayStartTimeChanged(_that);case SettingsMealEntryModeChanged() when mealEntryModeChanged != null:
return mealEntryModeChanged(_that);case SettingsUsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that);case SettingsUsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that);case SettingsUsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that);case SettingsUsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that);case SettingsWorkoutGroupAdded() when workoutGroupAdded != null:
return workoutGroupAdded(_that);case SettingsWorkoutGroupRenamed() when workoutGroupRenamed != null:
return workoutGroupRenamed(_that);case SettingsWorkoutGroupReordered() when workoutGroupReordered != null:
return workoutGroupReordered(_that);case SettingsWorkoutGroupRemoved() when workoutGroupRemoved != null:
return workoutGroupRemoved(_that);case SettingsUsualWorkoutAdded() when usualWorkoutAdded != null:
return usualWorkoutAdded(_that);case SettingsUsualWorkoutRenamed() when usualWorkoutRenamed != null:
return usualWorkoutRenamed(_that);case SettingsUsualWorkoutSetsChanged() when usualWorkoutSetsChanged != null:
return usualWorkoutSetsChanged(_that);case SettingsUsualWorkoutDurationChanged() when usualWorkoutDurationChanged != null:
return usualWorkoutDurationChanged(_that);case SettingsUsualWorkoutRemoved() when usualWorkoutRemoved != null:
return usualWorkoutRemoved(_that);case SettingsWorkoutWeightUnitSelected() when workoutWeightUnitSelected != null:
return workoutWeightUnitSelected(_that);case SettingsWorkoutReminderToggled() when workoutReminderToggled != null:
return workoutReminderToggled(_that);case SettingsWorkoutReminderDayToggled() when workoutReminderDayToggled != null:
return workoutReminderDayToggled(_that);case SettingsWorkoutReminderTimeChanged() when workoutReminderTimeChanged != null:
return workoutReminderTimeChanged(_that);case SettingsSaveMealAsUsualChanged() when saveMealAsUsualChanged != null:
return saveMealAsUsualChanged(_that);case SettingsSaveWorkoutAsUsualChanged() when saveWorkoutAsUsualChanged != null:
return saveWorkoutAsUsualChanged(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UserSettingsState settings)?  settingsCommitted,TResult Function( UserSettingsState settings)?  stateRestored,TResult Function( ReminderStyle reminderStyle)?  reminderStyleSelected,TResult Function( MealCheckinScheduleMode mealCheckinScheduleMode)?  mealCheckinScheduleModeChanged,TResult Function( MealOfTheDay mealOfTheDay,  bool enabled)?  mealReminderToggled,TResult Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)?  mealReminderTimeChanged,TResult Function( TimeOfDay timeOfDay)?  endOfDayTimeChanged,TResult Function( WeightCheckinFrequency weightCheckinFrequency)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDay weightTimeOfDay)?  weightTimeOfDaySelected,TResult Function( WeightUnit weightUnit)?  weightUnitSelected,TResult Function( double? weight)?  startingWeightChanged,TResult Function( int? calorieGoal)?  calorieGoalChanged,TResult Function( double? weightGoal)?  weightGoalChanged,TResult Function( ThemeMode themeMode)?  themeModeSelected,TResult Function( bool expandNutritionByDefault)?  expandNutritionByDefaultChanged,TResult Function( bool skipLoggedMealReminders)?  skipLoggedMealRemindersChanged,TResult Function( TimeOfDay dayStartTime)?  dayStartTimeChanged,TResult Function( MealEntryMode mealEntryMode)?  mealEntryModeChanged,TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? id)?  usualMealAdded,TResult Function( MealOfTheDay mealOfTheDay,  String id)?  usualMealRemoved,TResult Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)?  usualMealNutritionChanged,TResult Function( MealOfTheDay mealOfTheDay,  String id,  String name)?  usualMealNameChanged,TResult Function( String name)?  workoutGroupAdded,TResult Function( String id,  String name)?  workoutGroupRenamed,TResult Function( List<String> orderedIds)?  workoutGroupReordered,TResult Function( String id)?  workoutGroupRemoved,TResult Function( String workoutGroupId,  String name,  List<WorkoutSet> sets,  WorkoutType type,  Duration? duration)?  usualWorkoutAdded,TResult Function( String workoutGroupId,  String id,  String name)?  usualWorkoutRenamed,TResult Function( String workoutGroupId,  String id,  List<WorkoutSet> sets)?  usualWorkoutSetsChanged,TResult Function( String workoutGroupId,  String id,  Duration duration)?  usualWorkoutDurationChanged,TResult Function( String workoutGroupId,  String id)?  usualWorkoutRemoved,TResult Function( WeightUnit weightUnit)?  workoutWeightUnitSelected,TResult Function( bool enabled)?  workoutReminderToggled,TResult Function( int dayOfWeek,  bool enabled)?  workoutReminderDayToggled,TResult Function( TimeOfDay timeOfDay)?  workoutReminderTimeChanged,TResult Function( bool value)?  saveMealAsUsualChanged,TResult Function( bool value)?  saveWorkoutAsUsualChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case SettingsStateRestored() when stateRestored != null:
return stateRestored(_that.settings);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.reminderStyle);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.timeOfDay);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.weightTimeOfDay);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.weightUnit);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case SettingsCalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that.calorieGoal);case SettingsWeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that.weightGoal);case SettingsThemeModeSelected() when themeModeSelected != null:
return themeModeSelected(_that.themeMode);case SettingsExpandNutritionByDefaultChanged() when expandNutritionByDefaultChanged != null:
return expandNutritionByDefaultChanged(_that.expandNutritionByDefault);case SettingsSkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case SettingsDayStartTimeChanged() when dayStartTimeChanged != null:
return dayStartTimeChanged(_that.dayStartTime);case SettingsMealEntryModeChanged() when mealEntryModeChanged != null:
return mealEntryModeChanged(_that.mealEntryMode);case SettingsUsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition,_that.id);case SettingsUsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that.mealOfTheDay,_that.id);case SettingsUsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case SettingsUsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case SettingsWorkoutGroupAdded() when workoutGroupAdded != null:
return workoutGroupAdded(_that.name);case SettingsWorkoutGroupRenamed() when workoutGroupRenamed != null:
return workoutGroupRenamed(_that.id,_that.name);case SettingsWorkoutGroupReordered() when workoutGroupReordered != null:
return workoutGroupReordered(_that.orderedIds);case SettingsWorkoutGroupRemoved() when workoutGroupRemoved != null:
return workoutGroupRemoved(_that.id);case SettingsUsualWorkoutAdded() when usualWorkoutAdded != null:
return usualWorkoutAdded(_that.workoutGroupId,_that.name,_that.sets,_that.type,_that.duration);case SettingsUsualWorkoutRenamed() when usualWorkoutRenamed != null:
return usualWorkoutRenamed(_that.workoutGroupId,_that.id,_that.name);case SettingsUsualWorkoutSetsChanged() when usualWorkoutSetsChanged != null:
return usualWorkoutSetsChanged(_that.workoutGroupId,_that.id,_that.sets);case SettingsUsualWorkoutDurationChanged() when usualWorkoutDurationChanged != null:
return usualWorkoutDurationChanged(_that.workoutGroupId,_that.id,_that.duration);case SettingsUsualWorkoutRemoved() when usualWorkoutRemoved != null:
return usualWorkoutRemoved(_that.workoutGroupId,_that.id);case SettingsWorkoutWeightUnitSelected() when workoutWeightUnitSelected != null:
return workoutWeightUnitSelected(_that.weightUnit);case SettingsWorkoutReminderToggled() when workoutReminderToggled != null:
return workoutReminderToggled(_that.enabled);case SettingsWorkoutReminderDayToggled() when workoutReminderDayToggled != null:
return workoutReminderDayToggled(_that.dayOfWeek,_that.enabled);case SettingsWorkoutReminderTimeChanged() when workoutReminderTimeChanged != null:
return workoutReminderTimeChanged(_that.timeOfDay);case SettingsSaveMealAsUsualChanged() when saveMealAsUsualChanged != null:
return saveMealAsUsualChanged(_that.value);case SettingsSaveWorkoutAsUsualChanged() when saveWorkoutAsUsualChanged != null:
return saveWorkoutAsUsualChanged(_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UserSettingsState settings)  settingsCommitted,required TResult Function( UserSettingsState settings)  stateRestored,required TResult Function( ReminderStyle reminderStyle)  reminderStyleSelected,required TResult Function( MealCheckinScheduleMode mealCheckinScheduleMode)  mealCheckinScheduleModeChanged,required TResult Function( MealOfTheDay mealOfTheDay,  bool enabled)  mealReminderToggled,required TResult Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)  mealReminderTimeChanged,required TResult Function( TimeOfDay timeOfDay)  endOfDayTimeChanged,required TResult Function( WeightCheckinFrequency weightCheckinFrequency)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDay weightTimeOfDay)  weightTimeOfDaySelected,required TResult Function( WeightUnit weightUnit)  weightUnitSelected,required TResult Function( double? weight)  startingWeightChanged,required TResult Function( int? calorieGoal)  calorieGoalChanged,required TResult Function( double? weightGoal)  weightGoalChanged,required TResult Function( ThemeMode themeMode)  themeModeSelected,required TResult Function( bool expandNutritionByDefault)  expandNutritionByDefaultChanged,required TResult Function( bool skipLoggedMealReminders)  skipLoggedMealRemindersChanged,required TResult Function( TimeOfDay dayStartTime)  dayStartTimeChanged,required TResult Function( MealEntryMode mealEntryMode)  mealEntryModeChanged,required TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? id)  usualMealAdded,required TResult Function( MealOfTheDay mealOfTheDay,  String id)  usualMealRemoved,required TResult Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)  usualMealNutritionChanged,required TResult Function( MealOfTheDay mealOfTheDay,  String id,  String name)  usualMealNameChanged,required TResult Function( String name)  workoutGroupAdded,required TResult Function( String id,  String name)  workoutGroupRenamed,required TResult Function( List<String> orderedIds)  workoutGroupReordered,required TResult Function( String id)  workoutGroupRemoved,required TResult Function( String workoutGroupId,  String name,  List<WorkoutSet> sets,  WorkoutType type,  Duration? duration)  usualWorkoutAdded,required TResult Function( String workoutGroupId,  String id,  String name)  usualWorkoutRenamed,required TResult Function( String workoutGroupId,  String id,  List<WorkoutSet> sets)  usualWorkoutSetsChanged,required TResult Function( String workoutGroupId,  String id,  Duration duration)  usualWorkoutDurationChanged,required TResult Function( String workoutGroupId,  String id)  usualWorkoutRemoved,required TResult Function( WeightUnit weightUnit)  workoutWeightUnitSelected,required TResult Function( bool enabled)  workoutReminderToggled,required TResult Function( int dayOfWeek,  bool enabled)  workoutReminderDayToggled,required TResult Function( TimeOfDay timeOfDay)  workoutReminderTimeChanged,required TResult Function( bool value)  saveMealAsUsualChanged,required TResult Function( bool value)  saveWorkoutAsUsualChanged,}) {final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that.settings);case SettingsStateRestored():
return stateRestored(_that.settings);case SettingsReminderStyleSelected():
return reminderStyleSelected(_that.reminderStyle);case SettingsMealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case SettingsMealReminderToggled():
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case SettingsMealReminderTimeChanged():
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case SettingsEndOfDayTimeChanged():
return endOfDayTimeChanged(_that.timeOfDay);case SettingsWeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case SettingsWeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that.weightTimeOfDay);case SettingsWeightUnitSelected():
return weightUnitSelected(_that.weightUnit);case SettingsStartingWeightChanged():
return startingWeightChanged(_that.weight);case SettingsCalorieGoalChanged():
return calorieGoalChanged(_that.calorieGoal);case SettingsWeightGoalChanged():
return weightGoalChanged(_that.weightGoal);case SettingsThemeModeSelected():
return themeModeSelected(_that.themeMode);case SettingsExpandNutritionByDefaultChanged():
return expandNutritionByDefaultChanged(_that.expandNutritionByDefault);case SettingsSkipLoggedMealRemindersChanged():
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case SettingsDayStartTimeChanged():
return dayStartTimeChanged(_that.dayStartTime);case SettingsMealEntryModeChanged():
return mealEntryModeChanged(_that.mealEntryMode);case SettingsUsualMealAdded():
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition,_that.id);case SettingsUsualMealRemoved():
return usualMealRemoved(_that.mealOfTheDay,_that.id);case SettingsUsualMealNutritionChanged():
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case SettingsUsualMealNameChanged():
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case SettingsWorkoutGroupAdded():
return workoutGroupAdded(_that.name);case SettingsWorkoutGroupRenamed():
return workoutGroupRenamed(_that.id,_that.name);case SettingsWorkoutGroupReordered():
return workoutGroupReordered(_that.orderedIds);case SettingsWorkoutGroupRemoved():
return workoutGroupRemoved(_that.id);case SettingsUsualWorkoutAdded():
return usualWorkoutAdded(_that.workoutGroupId,_that.name,_that.sets,_that.type,_that.duration);case SettingsUsualWorkoutRenamed():
return usualWorkoutRenamed(_that.workoutGroupId,_that.id,_that.name);case SettingsUsualWorkoutSetsChanged():
return usualWorkoutSetsChanged(_that.workoutGroupId,_that.id,_that.sets);case SettingsUsualWorkoutDurationChanged():
return usualWorkoutDurationChanged(_that.workoutGroupId,_that.id,_that.duration);case SettingsUsualWorkoutRemoved():
return usualWorkoutRemoved(_that.workoutGroupId,_that.id);case SettingsWorkoutWeightUnitSelected():
return workoutWeightUnitSelected(_that.weightUnit);case SettingsWorkoutReminderToggled():
return workoutReminderToggled(_that.enabled);case SettingsWorkoutReminderDayToggled():
return workoutReminderDayToggled(_that.dayOfWeek,_that.enabled);case SettingsWorkoutReminderTimeChanged():
return workoutReminderTimeChanged(_that.timeOfDay);case SettingsSaveMealAsUsualChanged():
return saveMealAsUsualChanged(_that.value);case SettingsSaveWorkoutAsUsualChanged():
return saveWorkoutAsUsualChanged(_that.value);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UserSettingsState settings)?  settingsCommitted,TResult? Function( UserSettingsState settings)?  stateRestored,TResult? Function( ReminderStyle reminderStyle)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleMode mealCheckinScheduleMode)?  mealCheckinScheduleModeChanged,TResult? Function( MealOfTheDay mealOfTheDay,  bool enabled)?  mealReminderToggled,TResult? Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)?  mealReminderTimeChanged,TResult? Function( TimeOfDay timeOfDay)?  endOfDayTimeChanged,TResult? Function( WeightCheckinFrequency weightCheckinFrequency)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDay weightTimeOfDay)?  weightTimeOfDaySelected,TResult? Function( WeightUnit weightUnit)?  weightUnitSelected,TResult? Function( double? weight)?  startingWeightChanged,TResult? Function( int? calorieGoal)?  calorieGoalChanged,TResult? Function( double? weightGoal)?  weightGoalChanged,TResult? Function( ThemeMode themeMode)?  themeModeSelected,TResult? Function( bool expandNutritionByDefault)?  expandNutritionByDefaultChanged,TResult? Function( bool skipLoggedMealReminders)?  skipLoggedMealRemindersChanged,TResult? Function( TimeOfDay dayStartTime)?  dayStartTimeChanged,TResult? Function( MealEntryMode mealEntryMode)?  mealEntryModeChanged,TResult? Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? id)?  usualMealAdded,TResult? Function( MealOfTheDay mealOfTheDay,  String id)?  usualMealRemoved,TResult? Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)?  usualMealNutritionChanged,TResult? Function( MealOfTheDay mealOfTheDay,  String id,  String name)?  usualMealNameChanged,TResult? Function( String name)?  workoutGroupAdded,TResult? Function( String id,  String name)?  workoutGroupRenamed,TResult? Function( List<String> orderedIds)?  workoutGroupReordered,TResult? Function( String id)?  workoutGroupRemoved,TResult? Function( String workoutGroupId,  String name,  List<WorkoutSet> sets,  WorkoutType type,  Duration? duration)?  usualWorkoutAdded,TResult? Function( String workoutGroupId,  String id,  String name)?  usualWorkoutRenamed,TResult? Function( String workoutGroupId,  String id,  List<WorkoutSet> sets)?  usualWorkoutSetsChanged,TResult? Function( String workoutGroupId,  String id,  Duration duration)?  usualWorkoutDurationChanged,TResult? Function( String workoutGroupId,  String id)?  usualWorkoutRemoved,TResult? Function( WeightUnit weightUnit)?  workoutWeightUnitSelected,TResult? Function( bool enabled)?  workoutReminderToggled,TResult? Function( int dayOfWeek,  bool enabled)?  workoutReminderDayToggled,TResult? Function( TimeOfDay timeOfDay)?  workoutReminderTimeChanged,TResult? Function( bool value)?  saveMealAsUsualChanged,TResult? Function( bool value)?  saveWorkoutAsUsualChanged,}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case SettingsStateRestored() when stateRestored != null:
return stateRestored(_that.settings);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.reminderStyle);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.timeOfDay);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.weightTimeOfDay);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.weightUnit);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case SettingsCalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that.calorieGoal);case SettingsWeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that.weightGoal);case SettingsThemeModeSelected() when themeModeSelected != null:
return themeModeSelected(_that.themeMode);case SettingsExpandNutritionByDefaultChanged() when expandNutritionByDefaultChanged != null:
return expandNutritionByDefaultChanged(_that.expandNutritionByDefault);case SettingsSkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case SettingsDayStartTimeChanged() when dayStartTimeChanged != null:
return dayStartTimeChanged(_that.dayStartTime);case SettingsMealEntryModeChanged() when mealEntryModeChanged != null:
return mealEntryModeChanged(_that.mealEntryMode);case SettingsUsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition,_that.id);case SettingsUsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that.mealOfTheDay,_that.id);case SettingsUsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case SettingsUsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case SettingsWorkoutGroupAdded() when workoutGroupAdded != null:
return workoutGroupAdded(_that.name);case SettingsWorkoutGroupRenamed() when workoutGroupRenamed != null:
return workoutGroupRenamed(_that.id,_that.name);case SettingsWorkoutGroupReordered() when workoutGroupReordered != null:
return workoutGroupReordered(_that.orderedIds);case SettingsWorkoutGroupRemoved() when workoutGroupRemoved != null:
return workoutGroupRemoved(_that.id);case SettingsUsualWorkoutAdded() when usualWorkoutAdded != null:
return usualWorkoutAdded(_that.workoutGroupId,_that.name,_that.sets,_that.type,_that.duration);case SettingsUsualWorkoutRenamed() when usualWorkoutRenamed != null:
return usualWorkoutRenamed(_that.workoutGroupId,_that.id,_that.name);case SettingsUsualWorkoutSetsChanged() when usualWorkoutSetsChanged != null:
return usualWorkoutSetsChanged(_that.workoutGroupId,_that.id,_that.sets);case SettingsUsualWorkoutDurationChanged() when usualWorkoutDurationChanged != null:
return usualWorkoutDurationChanged(_that.workoutGroupId,_that.id,_that.duration);case SettingsUsualWorkoutRemoved() when usualWorkoutRemoved != null:
return usualWorkoutRemoved(_that.workoutGroupId,_that.id);case SettingsWorkoutWeightUnitSelected() when workoutWeightUnitSelected != null:
return workoutWeightUnitSelected(_that.weightUnit);case SettingsWorkoutReminderToggled() when workoutReminderToggled != null:
return workoutReminderToggled(_that.enabled);case SettingsWorkoutReminderDayToggled() when workoutReminderDayToggled != null:
return workoutReminderDayToggled(_that.dayOfWeek,_that.enabled);case SettingsWorkoutReminderTimeChanged() when workoutReminderTimeChanged != null:
return workoutReminderTimeChanged(_that.timeOfDay);case SettingsSaveMealAsUsualChanged() when saveMealAsUsualChanged != null:
return saveMealAsUsualChanged(_that.value);case SettingsSaveWorkoutAsUsualChanged() when saveWorkoutAsUsualChanged != null:
return saveWorkoutAsUsualChanged(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class SettingsCommitted implements UserSettingsEvent {
  const SettingsCommitted(this.settings);
  

 final  UserSettingsState settings;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCommittedCopyWith<SettingsCommitted> get copyWith => _$SettingsCommittedCopyWithImpl<SettingsCommitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsCommitted&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'UserSettingsEvent.settingsCommitted(settings: $settings)';
}


}

/// @nodoc
abstract mixin class $SettingsCommittedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsCommittedCopyWith(SettingsCommitted value, $Res Function(SettingsCommitted) _then) = _$SettingsCommittedCopyWithImpl;
@useResult
$Res call({
 UserSettingsState settings
});


$UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class _$SettingsCommittedCopyWithImpl<$Res>
    implements $SettingsCommittedCopyWith<$Res> {
  _$SettingsCommittedCopyWithImpl(this._self, this._then);

  final SettingsCommitted _self;
  final $Res Function(SettingsCommitted) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,}) {
  return _then(SettingsCommitted(
null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,
  ));
}

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<$Res> get settings {
  
  return $UserSettingsStateCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

/// @nodoc


class SettingsStateRestored implements UserSettingsEvent {
  const SettingsStateRestored(this.settings);
  

 final  UserSettingsState settings;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateRestoredCopyWith<SettingsStateRestored> get copyWith => _$SettingsStateRestoredCopyWithImpl<SettingsStateRestored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStateRestored&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'UserSettingsEvent.stateRestored(settings: $settings)';
}


}

/// @nodoc
abstract mixin class $SettingsStateRestoredCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsStateRestoredCopyWith(SettingsStateRestored value, $Res Function(SettingsStateRestored) _then) = _$SettingsStateRestoredCopyWithImpl;
@useResult
$Res call({
 UserSettingsState settings
});


$UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class _$SettingsStateRestoredCopyWithImpl<$Res>
    implements $SettingsStateRestoredCopyWith<$Res> {
  _$SettingsStateRestoredCopyWithImpl(this._self, this._then);

  final SettingsStateRestored _self;
  final $Res Function(SettingsStateRestored) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? settings = null,}) {
  return _then(SettingsStateRestored(
null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,
  ));
}

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<$Res> get settings {
  
  return $UserSettingsStateCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

/// @nodoc


class SettingsReminderStyleSelected implements UserSettingsEvent {
  const SettingsReminderStyleSelected(this.reminderStyle);
  

 final  ReminderStyle reminderStyle;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsReminderStyleSelectedCopyWith<SettingsReminderStyleSelected> get copyWith => _$SettingsReminderStyleSelectedCopyWithImpl<SettingsReminderStyleSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsReminderStyleSelected&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle));
}


@override
int get hashCode => Object.hash(runtimeType,reminderStyle);

@override
String toString() {
  return 'UserSettingsEvent.reminderStyleSelected(reminderStyle: $reminderStyle)';
}


}

/// @nodoc
abstract mixin class $SettingsReminderStyleSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsReminderStyleSelectedCopyWith(SettingsReminderStyleSelected value, $Res Function(SettingsReminderStyleSelected) _then) = _$SettingsReminderStyleSelectedCopyWithImpl;
@useResult
$Res call({
 ReminderStyle reminderStyle
});




}
/// @nodoc
class _$SettingsReminderStyleSelectedCopyWithImpl<$Res>
    implements $SettingsReminderStyleSelectedCopyWith<$Res> {
  _$SettingsReminderStyleSelectedCopyWithImpl(this._self, this._then);

  final SettingsReminderStyleSelected _self;
  final $Res Function(SettingsReminderStyleSelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reminderStyle = null,}) {
  return _then(SettingsReminderStyleSelected(
null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,
  ));
}


}

/// @nodoc


class SettingsMealCheckinScheduleModeChanged implements UserSettingsEvent {
  const SettingsMealCheckinScheduleModeChanged(this.mealCheckinScheduleMode);
  

 final  MealCheckinScheduleMode mealCheckinScheduleMode;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealCheckinScheduleModeChangedCopyWith<SettingsMealCheckinScheduleModeChanged> get copyWith => _$SettingsMealCheckinScheduleModeChangedCopyWithImpl<SettingsMealCheckinScheduleModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealCheckinScheduleModeChanged&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode));
}


@override
int get hashCode => Object.hash(runtimeType,mealCheckinScheduleMode);

@override
String toString() {
  return 'UserSettingsEvent.mealCheckinScheduleModeChanged(mealCheckinScheduleMode: $mealCheckinScheduleMode)';
}


}

/// @nodoc
abstract mixin class $SettingsMealCheckinScheduleModeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealCheckinScheduleModeChangedCopyWith(SettingsMealCheckinScheduleModeChanged value, $Res Function(SettingsMealCheckinScheduleModeChanged) _then) = _$SettingsMealCheckinScheduleModeChangedCopyWithImpl;
@useResult
$Res call({
 MealCheckinScheduleMode mealCheckinScheduleMode
});




}
/// @nodoc
class _$SettingsMealCheckinScheduleModeChangedCopyWithImpl<$Res>
    implements $SettingsMealCheckinScheduleModeChangedCopyWith<$Res> {
  _$SettingsMealCheckinScheduleModeChangedCopyWithImpl(this._self, this._then);

  final SettingsMealCheckinScheduleModeChanged _self;
  final $Res Function(SettingsMealCheckinScheduleModeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealCheckinScheduleMode = null,}) {
  return _then(SettingsMealCheckinScheduleModeChanged(
null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,
  ));
}


}

/// @nodoc


class SettingsMealReminderToggled implements UserSettingsEvent {
  const SettingsMealReminderToggled(this.mealOfTheDay, {required this.enabled});
  

 final  MealOfTheDay mealOfTheDay;
 final  bool enabled;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealReminderToggledCopyWith<SettingsMealReminderToggled> get copyWith => _$SettingsMealReminderToggledCopyWithImpl<SettingsMealReminderToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealReminderToggled&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,enabled);

@override
String toString() {
  return 'UserSettingsEvent.mealReminderToggled(mealOfTheDay: $mealOfTheDay, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $SettingsMealReminderToggledCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealReminderToggledCopyWith(SettingsMealReminderToggled value, $Res Function(SettingsMealReminderToggled) _then) = _$SettingsMealReminderToggledCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, bool enabled
});




}
/// @nodoc
class _$SettingsMealReminderToggledCopyWithImpl<$Res>
    implements $SettingsMealReminderToggledCopyWith<$Res> {
  _$SettingsMealReminderToggledCopyWithImpl(this._self, this._then);

  final SettingsMealReminderToggled _self;
  final $Res Function(SettingsMealReminderToggled) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? enabled = null,}) {
  return _then(SettingsMealReminderToggled(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsMealReminderTimeChanged implements UserSettingsEvent {
  const SettingsMealReminderTimeChanged(this.mealOfTheDay, this.timeOfDay);
  

 final  MealOfTheDay mealOfTheDay;
 final  TimeOfDay timeOfDay;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealReminderTimeChangedCopyWith<SettingsMealReminderTimeChanged> get copyWith => _$SettingsMealReminderTimeChangedCopyWithImpl<SettingsMealReminderTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealReminderTimeChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,timeOfDay);

@override
String toString() {
  return 'UserSettingsEvent.mealReminderTimeChanged(mealOfTheDay: $mealOfTheDay, timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $SettingsMealReminderTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealReminderTimeChangedCopyWith(SettingsMealReminderTimeChanged value, $Res Function(SettingsMealReminderTimeChanged) _then) = _$SettingsMealReminderTimeChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, TimeOfDay timeOfDay
});




}
/// @nodoc
class _$SettingsMealReminderTimeChangedCopyWithImpl<$Res>
    implements $SettingsMealReminderTimeChangedCopyWith<$Res> {
  _$SettingsMealReminderTimeChangedCopyWithImpl(this._self, this._then);

  final SettingsMealReminderTimeChanged _self;
  final $Res Function(SettingsMealReminderTimeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? timeOfDay = null,}) {
  return _then(SettingsMealReminderTimeChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsEndOfDayTimeChanged implements UserSettingsEvent {
  const SettingsEndOfDayTimeChanged(this.timeOfDay);
  

 final  TimeOfDay timeOfDay;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsEndOfDayTimeChangedCopyWith<SettingsEndOfDayTimeChanged> get copyWith => _$SettingsEndOfDayTimeChangedCopyWithImpl<SettingsEndOfDayTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEndOfDayTimeChanged&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,timeOfDay);

@override
String toString() {
  return 'UserSettingsEvent.endOfDayTimeChanged(timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $SettingsEndOfDayTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsEndOfDayTimeChangedCopyWith(SettingsEndOfDayTimeChanged value, $Res Function(SettingsEndOfDayTimeChanged) _then) = _$SettingsEndOfDayTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay timeOfDay
});




}
/// @nodoc
class _$SettingsEndOfDayTimeChangedCopyWithImpl<$Res>
    implements $SettingsEndOfDayTimeChangedCopyWith<$Res> {
  _$SettingsEndOfDayTimeChangedCopyWithImpl(this._self, this._then);

  final SettingsEndOfDayTimeChanged _self;
  final $Res Function(SettingsEndOfDayTimeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timeOfDay = null,}) {
  return _then(SettingsEndOfDayTimeChanged(
null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsWeightCheckinFrequencySelected implements UserSettingsEvent {
  const SettingsWeightCheckinFrequencySelected(this.weightCheckinFrequency);
  

 final  WeightCheckinFrequency weightCheckinFrequency;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightCheckinFrequencySelectedCopyWith<SettingsWeightCheckinFrequencySelected> get copyWith => _$SettingsWeightCheckinFrequencySelectedCopyWithImpl<SettingsWeightCheckinFrequencySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightCheckinFrequencySelected&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,weightCheckinFrequency);

@override
String toString() {
  return 'UserSettingsEvent.weightCheckinFrequencySelected(weightCheckinFrequency: $weightCheckinFrequency)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightCheckinFrequencySelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightCheckinFrequencySelectedCopyWith(SettingsWeightCheckinFrequencySelected value, $Res Function(SettingsWeightCheckinFrequencySelected) _then) = _$SettingsWeightCheckinFrequencySelectedCopyWithImpl;
@useResult
$Res call({
 WeightCheckinFrequency weightCheckinFrequency
});




}
/// @nodoc
class _$SettingsWeightCheckinFrequencySelectedCopyWithImpl<$Res>
    implements $SettingsWeightCheckinFrequencySelectedCopyWith<$Res> {
  _$SettingsWeightCheckinFrequencySelectedCopyWithImpl(this._self, this._then);

  final SettingsWeightCheckinFrequencySelected _self;
  final $Res Function(SettingsWeightCheckinFrequencySelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightCheckinFrequency = null,}) {
  return _then(SettingsWeightCheckinFrequencySelected(
null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,
  ));
}


}

/// @nodoc


class SettingsWeightTimeOfDaySelected implements UserSettingsEvent {
  const SettingsWeightTimeOfDaySelected(this.weightTimeOfDay);
  

 final  WeightTimeOfDay weightTimeOfDay;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightTimeOfDaySelectedCopyWith<SettingsWeightTimeOfDaySelected> get copyWith => _$SettingsWeightTimeOfDaySelectedCopyWithImpl<SettingsWeightTimeOfDaySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightTimeOfDaySelected&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,weightTimeOfDay);

@override
String toString() {
  return 'UserSettingsEvent.weightTimeOfDaySelected(weightTimeOfDay: $weightTimeOfDay)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightTimeOfDaySelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightTimeOfDaySelectedCopyWith(SettingsWeightTimeOfDaySelected value, $Res Function(SettingsWeightTimeOfDaySelected) _then) = _$SettingsWeightTimeOfDaySelectedCopyWithImpl;
@useResult
$Res call({
 WeightTimeOfDay weightTimeOfDay
});




}
/// @nodoc
class _$SettingsWeightTimeOfDaySelectedCopyWithImpl<$Res>
    implements $SettingsWeightTimeOfDaySelectedCopyWith<$Res> {
  _$SettingsWeightTimeOfDaySelectedCopyWithImpl(this._self, this._then);

  final SettingsWeightTimeOfDaySelected _self;
  final $Res Function(SettingsWeightTimeOfDaySelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightTimeOfDay = null,}) {
  return _then(SettingsWeightTimeOfDaySelected(
null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,
  ));
}


}

/// @nodoc


class SettingsWeightUnitSelected implements UserSettingsEvent {
  const SettingsWeightUnitSelected(this.weightUnit);
  

 final  WeightUnit weightUnit;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightUnitSelectedCopyWith<SettingsWeightUnitSelected> get copyWith => _$SettingsWeightUnitSelectedCopyWithImpl<SettingsWeightUnitSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightUnitSelected&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weightUnit);

@override
String toString() {
  return 'UserSettingsEvent.weightUnitSelected(weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightUnitSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightUnitSelectedCopyWith(SettingsWeightUnitSelected value, $Res Function(SettingsWeightUnitSelected) _then) = _$SettingsWeightUnitSelectedCopyWithImpl;
@useResult
$Res call({
 WeightUnit weightUnit
});




}
/// @nodoc
class _$SettingsWeightUnitSelectedCopyWithImpl<$Res>
    implements $SettingsWeightUnitSelectedCopyWith<$Res> {
  _$SettingsWeightUnitSelectedCopyWithImpl(this._self, this._then);

  final SettingsWeightUnitSelected _self;
  final $Res Function(SettingsWeightUnitSelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightUnit = null,}) {
  return _then(SettingsWeightUnitSelected(
null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class SettingsStartingWeightChanged implements UserSettingsEvent {
  const SettingsStartingWeightChanged(this.weight);
  

 final  double? weight;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStartingWeightChangedCopyWith<SettingsStartingWeightChanged> get copyWith => _$SettingsStartingWeightChangedCopyWithImpl<SettingsStartingWeightChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsStartingWeightChanged&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,weight);

@override
String toString() {
  return 'UserSettingsEvent.startingWeightChanged(weight: $weight)';
}


}

/// @nodoc
abstract mixin class $SettingsStartingWeightChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsStartingWeightChangedCopyWith(SettingsStartingWeightChanged value, $Res Function(SettingsStartingWeightChanged) _then) = _$SettingsStartingWeightChangedCopyWithImpl;
@useResult
$Res call({
 double? weight
});




}
/// @nodoc
class _$SettingsStartingWeightChangedCopyWithImpl<$Res>
    implements $SettingsStartingWeightChangedCopyWith<$Res> {
  _$SettingsStartingWeightChangedCopyWithImpl(this._self, this._then);

  final SettingsStartingWeightChanged _self;
  final $Res Function(SettingsStartingWeightChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weight = freezed,}) {
  return _then(SettingsStartingWeightChanged(
freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class SettingsCalorieGoalChanged implements UserSettingsEvent {
  const SettingsCalorieGoalChanged(this.calorieGoal);
  

 final  int? calorieGoal;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCalorieGoalChangedCopyWith<SettingsCalorieGoalChanged> get copyWith => _$SettingsCalorieGoalChangedCopyWithImpl<SettingsCalorieGoalChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsCalorieGoalChanged&&(identical(other.calorieGoal, calorieGoal) || other.calorieGoal == calorieGoal));
}


@override
int get hashCode => Object.hash(runtimeType,calorieGoal);

@override
String toString() {
  return 'UserSettingsEvent.calorieGoalChanged(calorieGoal: $calorieGoal)';
}


}

/// @nodoc
abstract mixin class $SettingsCalorieGoalChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsCalorieGoalChangedCopyWith(SettingsCalorieGoalChanged value, $Res Function(SettingsCalorieGoalChanged) _then) = _$SettingsCalorieGoalChangedCopyWithImpl;
@useResult
$Res call({
 int? calorieGoal
});




}
/// @nodoc
class _$SettingsCalorieGoalChangedCopyWithImpl<$Res>
    implements $SettingsCalorieGoalChangedCopyWith<$Res> {
  _$SettingsCalorieGoalChangedCopyWithImpl(this._self, this._then);

  final SettingsCalorieGoalChanged _self;
  final $Res Function(SettingsCalorieGoalChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? calorieGoal = freezed,}) {
  return _then(SettingsCalorieGoalChanged(
freezed == calorieGoal ? _self.calorieGoal : calorieGoal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class SettingsWeightGoalChanged implements UserSettingsEvent {
  const SettingsWeightGoalChanged(this.weightGoal);
  

 final  double? weightGoal;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightGoalChangedCopyWith<SettingsWeightGoalChanged> get copyWith => _$SettingsWeightGoalChangedCopyWithImpl<SettingsWeightGoalChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightGoalChanged&&(identical(other.weightGoal, weightGoal) || other.weightGoal == weightGoal));
}


@override
int get hashCode => Object.hash(runtimeType,weightGoal);

@override
String toString() {
  return 'UserSettingsEvent.weightGoalChanged(weightGoal: $weightGoal)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightGoalChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightGoalChangedCopyWith(SettingsWeightGoalChanged value, $Res Function(SettingsWeightGoalChanged) _then) = _$SettingsWeightGoalChangedCopyWithImpl;
@useResult
$Res call({
 double? weightGoal
});




}
/// @nodoc
class _$SettingsWeightGoalChangedCopyWithImpl<$Res>
    implements $SettingsWeightGoalChangedCopyWith<$Res> {
  _$SettingsWeightGoalChangedCopyWithImpl(this._self, this._then);

  final SettingsWeightGoalChanged _self;
  final $Res Function(SettingsWeightGoalChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightGoal = freezed,}) {
  return _then(SettingsWeightGoalChanged(
freezed == weightGoal ? _self.weightGoal : weightGoal // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class SettingsThemeModeSelected implements UserSettingsEvent {
  const SettingsThemeModeSelected(this.themeMode);
  

 final  ThemeMode themeMode;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsThemeModeSelectedCopyWith<SettingsThemeModeSelected> get copyWith => _$SettingsThemeModeSelectedCopyWithImpl<SettingsThemeModeSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsThemeModeSelected&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode);

@override
String toString() {
  return 'UserSettingsEvent.themeModeSelected(themeMode: $themeMode)';
}


}

/// @nodoc
abstract mixin class $SettingsThemeModeSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsThemeModeSelectedCopyWith(SettingsThemeModeSelected value, $Res Function(SettingsThemeModeSelected) _then) = _$SettingsThemeModeSelectedCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode
});




}
/// @nodoc
class _$SettingsThemeModeSelectedCopyWithImpl<$Res>
    implements $SettingsThemeModeSelectedCopyWith<$Res> {
  _$SettingsThemeModeSelectedCopyWithImpl(this._self, this._then);

  final SettingsThemeModeSelected _self;
  final $Res Function(SettingsThemeModeSelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? themeMode = null,}) {
  return _then(SettingsThemeModeSelected(
null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,
  ));
}


}

/// @nodoc


class SettingsExpandNutritionByDefaultChanged implements UserSettingsEvent {
  const SettingsExpandNutritionByDefaultChanged({required this.expandNutritionByDefault});
  

 final  bool expandNutritionByDefault;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsExpandNutritionByDefaultChangedCopyWith<SettingsExpandNutritionByDefaultChanged> get copyWith => _$SettingsExpandNutritionByDefaultChangedCopyWithImpl<SettingsExpandNutritionByDefaultChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsExpandNutritionByDefaultChanged&&(identical(other.expandNutritionByDefault, expandNutritionByDefault) || other.expandNutritionByDefault == expandNutritionByDefault));
}


@override
int get hashCode => Object.hash(runtimeType,expandNutritionByDefault);

@override
String toString() {
  return 'UserSettingsEvent.expandNutritionByDefaultChanged(expandNutritionByDefault: $expandNutritionByDefault)';
}


}

/// @nodoc
abstract mixin class $SettingsExpandNutritionByDefaultChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsExpandNutritionByDefaultChangedCopyWith(SettingsExpandNutritionByDefaultChanged value, $Res Function(SettingsExpandNutritionByDefaultChanged) _then) = _$SettingsExpandNutritionByDefaultChangedCopyWithImpl;
@useResult
$Res call({
 bool expandNutritionByDefault
});




}
/// @nodoc
class _$SettingsExpandNutritionByDefaultChangedCopyWithImpl<$Res>
    implements $SettingsExpandNutritionByDefaultChangedCopyWith<$Res> {
  _$SettingsExpandNutritionByDefaultChangedCopyWithImpl(this._self, this._then);

  final SettingsExpandNutritionByDefaultChanged _self;
  final $Res Function(SettingsExpandNutritionByDefaultChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expandNutritionByDefault = null,}) {
  return _then(SettingsExpandNutritionByDefaultChanged(
expandNutritionByDefault: null == expandNutritionByDefault ? _self.expandNutritionByDefault : expandNutritionByDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsSkipLoggedMealRemindersChanged implements UserSettingsEvent {
  const SettingsSkipLoggedMealRemindersChanged({required this.skipLoggedMealReminders});
  

 final  bool skipLoggedMealReminders;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSkipLoggedMealRemindersChangedCopyWith<SettingsSkipLoggedMealRemindersChanged> get copyWith => _$SettingsSkipLoggedMealRemindersChangedCopyWithImpl<SettingsSkipLoggedMealRemindersChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSkipLoggedMealRemindersChanged&&(identical(other.skipLoggedMealReminders, skipLoggedMealReminders) || other.skipLoggedMealReminders == skipLoggedMealReminders));
}


@override
int get hashCode => Object.hash(runtimeType,skipLoggedMealReminders);

@override
String toString() {
  return 'UserSettingsEvent.skipLoggedMealRemindersChanged(skipLoggedMealReminders: $skipLoggedMealReminders)';
}


}

/// @nodoc
abstract mixin class $SettingsSkipLoggedMealRemindersChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsSkipLoggedMealRemindersChangedCopyWith(SettingsSkipLoggedMealRemindersChanged value, $Res Function(SettingsSkipLoggedMealRemindersChanged) _then) = _$SettingsSkipLoggedMealRemindersChangedCopyWithImpl;
@useResult
$Res call({
 bool skipLoggedMealReminders
});




}
/// @nodoc
class _$SettingsSkipLoggedMealRemindersChangedCopyWithImpl<$Res>
    implements $SettingsSkipLoggedMealRemindersChangedCopyWith<$Res> {
  _$SettingsSkipLoggedMealRemindersChangedCopyWithImpl(this._self, this._then);

  final SettingsSkipLoggedMealRemindersChanged _self;
  final $Res Function(SettingsSkipLoggedMealRemindersChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? skipLoggedMealReminders = null,}) {
  return _then(SettingsSkipLoggedMealRemindersChanged(
skipLoggedMealReminders: null == skipLoggedMealReminders ? _self.skipLoggedMealReminders : skipLoggedMealReminders // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsDayStartTimeChanged implements UserSettingsEvent {
  const SettingsDayStartTimeChanged(this.dayStartTime);
  

 final  TimeOfDay dayStartTime;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsDayStartTimeChangedCopyWith<SettingsDayStartTimeChanged> get copyWith => _$SettingsDayStartTimeChangedCopyWithImpl<SettingsDayStartTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsDayStartTimeChanged&&(identical(other.dayStartTime, dayStartTime) || other.dayStartTime == dayStartTime));
}


@override
int get hashCode => Object.hash(runtimeType,dayStartTime);

@override
String toString() {
  return 'UserSettingsEvent.dayStartTimeChanged(dayStartTime: $dayStartTime)';
}


}

/// @nodoc
abstract mixin class $SettingsDayStartTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsDayStartTimeChangedCopyWith(SettingsDayStartTimeChanged value, $Res Function(SettingsDayStartTimeChanged) _then) = _$SettingsDayStartTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay dayStartTime
});




}
/// @nodoc
class _$SettingsDayStartTimeChangedCopyWithImpl<$Res>
    implements $SettingsDayStartTimeChangedCopyWith<$Res> {
  _$SettingsDayStartTimeChangedCopyWithImpl(this._self, this._then);

  final SettingsDayStartTimeChanged _self;
  final $Res Function(SettingsDayStartTimeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dayStartTime = null,}) {
  return _then(SettingsDayStartTimeChanged(
null == dayStartTime ? _self.dayStartTime : dayStartTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsMealEntryModeChanged implements UserSettingsEvent {
  const SettingsMealEntryModeChanged(this.mealEntryMode);
  

 final  MealEntryMode mealEntryMode;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealEntryModeChangedCopyWith<SettingsMealEntryModeChanged> get copyWith => _$SettingsMealEntryModeChangedCopyWithImpl<SettingsMealEntryModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealEntryModeChanged&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode));
}


@override
int get hashCode => Object.hash(runtimeType,mealEntryMode);

@override
String toString() {
  return 'UserSettingsEvent.mealEntryModeChanged(mealEntryMode: $mealEntryMode)';
}


}

/// @nodoc
abstract mixin class $SettingsMealEntryModeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealEntryModeChangedCopyWith(SettingsMealEntryModeChanged value, $Res Function(SettingsMealEntryModeChanged) _then) = _$SettingsMealEntryModeChangedCopyWithImpl;
@useResult
$Res call({
 MealEntryMode mealEntryMode
});




}
/// @nodoc
class _$SettingsMealEntryModeChangedCopyWithImpl<$Res>
    implements $SettingsMealEntryModeChangedCopyWith<$Res> {
  _$SettingsMealEntryModeChangedCopyWithImpl(this._self, this._then);

  final SettingsMealEntryModeChanged _self;
  final $Res Function(SettingsMealEntryModeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealEntryMode = null,}) {
  return _then(SettingsMealEntryModeChanged(
null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,
  ));
}


}

/// @nodoc


class SettingsUsualMealAdded implements UserSettingsEvent {
  const SettingsUsualMealAdded(this.mealOfTheDay, this.name, this.nutrition, {this.id});
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
 final  Nutrition nutrition;
 final  String? id;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualMealAddedCopyWith<SettingsUsualMealAdded> get copyWith => _$SettingsUsualMealAddedCopyWithImpl<SettingsUsualMealAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualMealAdded&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,nutrition,id);

@override
String toString() {
  return 'UserSettingsEvent.usualMealAdded(mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, id: $id)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualMealAddedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualMealAddedCopyWith(SettingsUsualMealAdded value, $Res Function(SettingsUsualMealAdded) _then) = _$SettingsUsualMealAddedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, String? id
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$SettingsUsualMealAddedCopyWithImpl<$Res>
    implements $SettingsUsualMealAddedCopyWith<$Res> {
  _$SettingsUsualMealAddedCopyWithImpl(this._self, this._then);

  final SettingsUsualMealAdded _self;
  final $Res Function(SettingsUsualMealAdded) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? id = freezed,}) {
  return _then(SettingsUsualMealAdded(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

/// @nodoc


class SettingsUsualMealRemoved implements UserSettingsEvent {
  const SettingsUsualMealRemoved(this.mealOfTheDay, this.id);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualMealRemovedCopyWith<SettingsUsualMealRemoved> get copyWith => _$SettingsUsualMealRemovedCopyWithImpl<SettingsUsualMealRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualMealRemoved&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id);

@override
String toString() {
  return 'UserSettingsEvent.usualMealRemoved(mealOfTheDay: $mealOfTheDay, id: $id)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualMealRemovedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualMealRemovedCopyWith(SettingsUsualMealRemoved value, $Res Function(SettingsUsualMealRemoved) _then) = _$SettingsUsualMealRemovedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id
});




}
/// @nodoc
class _$SettingsUsualMealRemovedCopyWithImpl<$Res>
    implements $SettingsUsualMealRemovedCopyWith<$Res> {
  _$SettingsUsualMealRemovedCopyWithImpl(this._self, this._then);

  final SettingsUsualMealRemoved _self;
  final $Res Function(SettingsUsualMealRemoved) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,}) {
  return _then(SettingsUsualMealRemoved(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsUsualMealNutritionChanged implements UserSettingsEvent {
  const SettingsUsualMealNutritionChanged(this.mealOfTheDay, this.id, this.nutrition);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;
 final  Nutrition nutrition;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualMealNutritionChangedCopyWith<SettingsUsualMealNutritionChanged> get copyWith => _$SettingsUsualMealNutritionChangedCopyWithImpl<SettingsUsualMealNutritionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualMealNutritionChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id,nutrition);

@override
String toString() {
  return 'UserSettingsEvent.usualMealNutritionChanged(mealOfTheDay: $mealOfTheDay, id: $id, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualMealNutritionChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualMealNutritionChangedCopyWith(SettingsUsualMealNutritionChanged value, $Res Function(SettingsUsualMealNutritionChanged) _then) = _$SettingsUsualMealNutritionChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$SettingsUsualMealNutritionChangedCopyWithImpl<$Res>
    implements $SettingsUsualMealNutritionChangedCopyWith<$Res> {
  _$SettingsUsualMealNutritionChangedCopyWithImpl(this._self, this._then);

  final SettingsUsualMealNutritionChanged _self;
  final $Res Function(SettingsUsualMealNutritionChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,Object? nutrition = null,}) {
  return _then(SettingsUsualMealNutritionChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

/// @nodoc


class SettingsUsualMealNameChanged implements UserSettingsEvent {
  const SettingsUsualMealNameChanged(this.mealOfTheDay, this.id, this.name);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;
 final  String name;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualMealNameChangedCopyWith<SettingsUsualMealNameChanged> get copyWith => _$SettingsUsualMealNameChangedCopyWithImpl<SettingsUsualMealNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualMealNameChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id,name);

@override
String toString() {
  return 'UserSettingsEvent.usualMealNameChanged(mealOfTheDay: $mealOfTheDay, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualMealNameChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualMealNameChangedCopyWith(SettingsUsualMealNameChanged value, $Res Function(SettingsUsualMealNameChanged) _then) = _$SettingsUsualMealNameChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id, String name
});




}
/// @nodoc
class _$SettingsUsualMealNameChangedCopyWithImpl<$Res>
    implements $SettingsUsualMealNameChangedCopyWith<$Res> {
  _$SettingsUsualMealNameChangedCopyWithImpl(this._self, this._then);

  final SettingsUsualMealNameChanged _self;
  final $Res Function(SettingsUsualMealNameChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,Object? name = null,}) {
  return _then(SettingsUsualMealNameChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsWorkoutGroupAdded implements UserSettingsEvent {
  const SettingsWorkoutGroupAdded(this.name);
  

 final  String name;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutGroupAddedCopyWith<SettingsWorkoutGroupAdded> get copyWith => _$SettingsWorkoutGroupAddedCopyWithImpl<SettingsWorkoutGroupAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutGroupAdded&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'UserSettingsEvent.workoutGroupAdded(name: $name)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutGroupAddedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutGroupAddedCopyWith(SettingsWorkoutGroupAdded value, $Res Function(SettingsWorkoutGroupAdded) _then) = _$SettingsWorkoutGroupAddedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$SettingsWorkoutGroupAddedCopyWithImpl<$Res>
    implements $SettingsWorkoutGroupAddedCopyWith<$Res> {
  _$SettingsWorkoutGroupAddedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutGroupAdded _self;
  final $Res Function(SettingsWorkoutGroupAdded) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(SettingsWorkoutGroupAdded(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsWorkoutGroupRenamed implements UserSettingsEvent {
  const SettingsWorkoutGroupRenamed(this.id, this.name);
  

 final  String id;
 final  String name;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutGroupRenamedCopyWith<SettingsWorkoutGroupRenamed> get copyWith => _$SettingsWorkoutGroupRenamedCopyWithImpl<SettingsWorkoutGroupRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutGroupRenamed&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'UserSettingsEvent.workoutGroupRenamed(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutGroupRenamedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutGroupRenamedCopyWith(SettingsWorkoutGroupRenamed value, $Res Function(SettingsWorkoutGroupRenamed) _then) = _$SettingsWorkoutGroupRenamedCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$SettingsWorkoutGroupRenamedCopyWithImpl<$Res>
    implements $SettingsWorkoutGroupRenamedCopyWith<$Res> {
  _$SettingsWorkoutGroupRenamedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutGroupRenamed _self;
  final $Res Function(SettingsWorkoutGroupRenamed) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(SettingsWorkoutGroupRenamed(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsWorkoutGroupReordered implements UserSettingsEvent {
  const SettingsWorkoutGroupReordered(final  List<String> orderedIds): _orderedIds = orderedIds;
  

 final  List<String> _orderedIds;
 List<String> get orderedIds {
  if (_orderedIds is EqualUnmodifiableListView) return _orderedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_orderedIds);
}


/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutGroupReorderedCopyWith<SettingsWorkoutGroupReordered> get copyWith => _$SettingsWorkoutGroupReorderedCopyWithImpl<SettingsWorkoutGroupReordered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutGroupReordered&&const DeepCollectionEquality().equals(other._orderedIds, _orderedIds));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_orderedIds));

@override
String toString() {
  return 'UserSettingsEvent.workoutGroupReordered(orderedIds: $orderedIds)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutGroupReorderedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutGroupReorderedCopyWith(SettingsWorkoutGroupReordered value, $Res Function(SettingsWorkoutGroupReordered) _then) = _$SettingsWorkoutGroupReorderedCopyWithImpl;
@useResult
$Res call({
 List<String> orderedIds
});




}
/// @nodoc
class _$SettingsWorkoutGroupReorderedCopyWithImpl<$Res>
    implements $SettingsWorkoutGroupReorderedCopyWith<$Res> {
  _$SettingsWorkoutGroupReorderedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutGroupReordered _self;
  final $Res Function(SettingsWorkoutGroupReordered) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? orderedIds = null,}) {
  return _then(SettingsWorkoutGroupReordered(
null == orderedIds ? _self._orderedIds : orderedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class SettingsWorkoutGroupRemoved implements UserSettingsEvent {
  const SettingsWorkoutGroupRemoved(this.id);
  

 final  String id;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutGroupRemovedCopyWith<SettingsWorkoutGroupRemoved> get copyWith => _$SettingsWorkoutGroupRemovedCopyWithImpl<SettingsWorkoutGroupRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutGroupRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'UserSettingsEvent.workoutGroupRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutGroupRemovedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutGroupRemovedCopyWith(SettingsWorkoutGroupRemoved value, $Res Function(SettingsWorkoutGroupRemoved) _then) = _$SettingsWorkoutGroupRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$SettingsWorkoutGroupRemovedCopyWithImpl<$Res>
    implements $SettingsWorkoutGroupRemovedCopyWith<$Res> {
  _$SettingsWorkoutGroupRemovedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutGroupRemoved _self;
  final $Res Function(SettingsWorkoutGroupRemoved) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(SettingsWorkoutGroupRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsUsualWorkoutAdded implements UserSettingsEvent {
  const SettingsUsualWorkoutAdded(this.workoutGroupId, this.name, final  List<WorkoutSet> sets, {this.type = WorkoutType.strength, this.duration}): _sets = sets;
  

 final  String workoutGroupId;
 final  String name;
 final  List<WorkoutSet> _sets;
 List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@JsonKey() final  WorkoutType type;
 final  Duration? duration;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualWorkoutAddedCopyWith<SettingsUsualWorkoutAdded> get copyWith => _$SettingsUsualWorkoutAddedCopyWithImpl<SettingsUsualWorkoutAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualWorkoutAdded&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,name,const DeepCollectionEquality().hash(_sets),type,duration);

@override
String toString() {
  return 'UserSettingsEvent.usualWorkoutAdded(workoutGroupId: $workoutGroupId, name: $name, sets: $sets, type: $type, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualWorkoutAddedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualWorkoutAddedCopyWith(SettingsUsualWorkoutAdded value, $Res Function(SettingsUsualWorkoutAdded) _then) = _$SettingsUsualWorkoutAddedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String name, List<WorkoutSet> sets, WorkoutType type, Duration? duration
});




}
/// @nodoc
class _$SettingsUsualWorkoutAddedCopyWithImpl<$Res>
    implements $SettingsUsualWorkoutAddedCopyWith<$Res> {
  _$SettingsUsualWorkoutAddedCopyWithImpl(this._self, this._then);

  final SettingsUsualWorkoutAdded _self;
  final $Res Function(SettingsUsualWorkoutAdded) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? name = null,Object? sets = null,Object? type = null,Object? duration = freezed,}) {
  return _then(SettingsUsualWorkoutAdded(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkoutType,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

/// @nodoc


class SettingsUsualWorkoutRenamed implements UserSettingsEvent {
  const SettingsUsualWorkoutRenamed(this.workoutGroupId, this.id, this.name);
  

 final  String workoutGroupId;
 final  String id;
 final  String name;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualWorkoutRenamedCopyWith<SettingsUsualWorkoutRenamed> get copyWith => _$SettingsUsualWorkoutRenamedCopyWithImpl<SettingsUsualWorkoutRenamed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualWorkoutRenamed&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,id,name);

@override
String toString() {
  return 'UserSettingsEvent.usualWorkoutRenamed(workoutGroupId: $workoutGroupId, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualWorkoutRenamedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualWorkoutRenamedCopyWith(SettingsUsualWorkoutRenamed value, $Res Function(SettingsUsualWorkoutRenamed) _then) = _$SettingsUsualWorkoutRenamedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String id, String name
});




}
/// @nodoc
class _$SettingsUsualWorkoutRenamedCopyWithImpl<$Res>
    implements $SettingsUsualWorkoutRenamedCopyWith<$Res> {
  _$SettingsUsualWorkoutRenamedCopyWithImpl(this._self, this._then);

  final SettingsUsualWorkoutRenamed _self;
  final $Res Function(SettingsUsualWorkoutRenamed) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? id = null,Object? name = null,}) {
  return _then(SettingsUsualWorkoutRenamed(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsUsualWorkoutSetsChanged implements UserSettingsEvent {
  const SettingsUsualWorkoutSetsChanged(this.workoutGroupId, this.id, final  List<WorkoutSet> sets): _sets = sets;
  

 final  String workoutGroupId;
 final  String id;
 final  List<WorkoutSet> _sets;
 List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualWorkoutSetsChangedCopyWith<SettingsUsualWorkoutSetsChanged> get copyWith => _$SettingsUsualWorkoutSetsChangedCopyWithImpl<SettingsUsualWorkoutSetsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualWorkoutSetsChanged&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._sets, _sets));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,id,const DeepCollectionEquality().hash(_sets));

@override
String toString() {
  return 'UserSettingsEvent.usualWorkoutSetsChanged(workoutGroupId: $workoutGroupId, id: $id, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualWorkoutSetsChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualWorkoutSetsChangedCopyWith(SettingsUsualWorkoutSetsChanged value, $Res Function(SettingsUsualWorkoutSetsChanged) _then) = _$SettingsUsualWorkoutSetsChangedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String id, List<WorkoutSet> sets
});




}
/// @nodoc
class _$SettingsUsualWorkoutSetsChangedCopyWithImpl<$Res>
    implements $SettingsUsualWorkoutSetsChangedCopyWith<$Res> {
  _$SettingsUsualWorkoutSetsChangedCopyWithImpl(this._self, this._then);

  final SettingsUsualWorkoutSetsChanged _self;
  final $Res Function(SettingsUsualWorkoutSetsChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? id = null,Object? sets = null,}) {
  return _then(SettingsUsualWorkoutSetsChanged(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,
  ));
}


}

/// @nodoc


class SettingsUsualWorkoutDurationChanged implements UserSettingsEvent {
  const SettingsUsualWorkoutDurationChanged(this.workoutGroupId, this.id, this.duration);
  

 final  String workoutGroupId;
 final  String id;
 final  Duration duration;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualWorkoutDurationChangedCopyWith<SettingsUsualWorkoutDurationChanged> get copyWith => _$SettingsUsualWorkoutDurationChangedCopyWithImpl<SettingsUsualWorkoutDurationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualWorkoutDurationChanged&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,id,duration);

@override
String toString() {
  return 'UserSettingsEvent.usualWorkoutDurationChanged(workoutGroupId: $workoutGroupId, id: $id, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualWorkoutDurationChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualWorkoutDurationChangedCopyWith(SettingsUsualWorkoutDurationChanged value, $Res Function(SettingsUsualWorkoutDurationChanged) _then) = _$SettingsUsualWorkoutDurationChangedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String id, Duration duration
});




}
/// @nodoc
class _$SettingsUsualWorkoutDurationChangedCopyWithImpl<$Res>
    implements $SettingsUsualWorkoutDurationChangedCopyWith<$Res> {
  _$SettingsUsualWorkoutDurationChangedCopyWithImpl(this._self, this._then);

  final SettingsUsualWorkoutDurationChanged _self;
  final $Res Function(SettingsUsualWorkoutDurationChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? id = null,Object? duration = null,}) {
  return _then(SettingsUsualWorkoutDurationChanged(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class SettingsUsualWorkoutRemoved implements UserSettingsEvent {
  const SettingsUsualWorkoutRemoved(this.workoutGroupId, this.id);
  

 final  String workoutGroupId;
 final  String id;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualWorkoutRemovedCopyWith<SettingsUsualWorkoutRemoved> get copyWith => _$SettingsUsualWorkoutRemovedCopyWithImpl<SettingsUsualWorkoutRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualWorkoutRemoved&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,id);

@override
String toString() {
  return 'UserSettingsEvent.usualWorkoutRemoved(workoutGroupId: $workoutGroupId, id: $id)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualWorkoutRemovedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualWorkoutRemovedCopyWith(SettingsUsualWorkoutRemoved value, $Res Function(SettingsUsualWorkoutRemoved) _then) = _$SettingsUsualWorkoutRemovedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String id
});




}
/// @nodoc
class _$SettingsUsualWorkoutRemovedCopyWithImpl<$Res>
    implements $SettingsUsualWorkoutRemovedCopyWith<$Res> {
  _$SettingsUsualWorkoutRemovedCopyWithImpl(this._self, this._then);

  final SettingsUsualWorkoutRemoved _self;
  final $Res Function(SettingsUsualWorkoutRemoved) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? id = null,}) {
  return _then(SettingsUsualWorkoutRemoved(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsWorkoutWeightUnitSelected implements UserSettingsEvent {
  const SettingsWorkoutWeightUnitSelected(this.weightUnit);
  

 final  WeightUnit weightUnit;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutWeightUnitSelectedCopyWith<SettingsWorkoutWeightUnitSelected> get copyWith => _$SettingsWorkoutWeightUnitSelectedCopyWithImpl<SettingsWorkoutWeightUnitSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutWeightUnitSelected&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weightUnit);

@override
String toString() {
  return 'UserSettingsEvent.workoutWeightUnitSelected(weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutWeightUnitSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutWeightUnitSelectedCopyWith(SettingsWorkoutWeightUnitSelected value, $Res Function(SettingsWorkoutWeightUnitSelected) _then) = _$SettingsWorkoutWeightUnitSelectedCopyWithImpl;
@useResult
$Res call({
 WeightUnit weightUnit
});




}
/// @nodoc
class _$SettingsWorkoutWeightUnitSelectedCopyWithImpl<$Res>
    implements $SettingsWorkoutWeightUnitSelectedCopyWith<$Res> {
  _$SettingsWorkoutWeightUnitSelectedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutWeightUnitSelected _self;
  final $Res Function(SettingsWorkoutWeightUnitSelected) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightUnit = null,}) {
  return _then(SettingsWorkoutWeightUnitSelected(
null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class SettingsWorkoutReminderToggled implements UserSettingsEvent {
  const SettingsWorkoutReminderToggled({required this.enabled});
  

 final  bool enabled;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutReminderToggledCopyWith<SettingsWorkoutReminderToggled> get copyWith => _$SettingsWorkoutReminderToggledCopyWithImpl<SettingsWorkoutReminderToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutReminderToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'UserSettingsEvent.workoutReminderToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutReminderToggledCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutReminderToggledCopyWith(SettingsWorkoutReminderToggled value, $Res Function(SettingsWorkoutReminderToggled) _then) = _$SettingsWorkoutReminderToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$SettingsWorkoutReminderToggledCopyWithImpl<$Res>
    implements $SettingsWorkoutReminderToggledCopyWith<$Res> {
  _$SettingsWorkoutReminderToggledCopyWithImpl(this._self, this._then);

  final SettingsWorkoutReminderToggled _self;
  final $Res Function(SettingsWorkoutReminderToggled) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(SettingsWorkoutReminderToggled(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsWorkoutReminderDayToggled implements UserSettingsEvent {
  const SettingsWorkoutReminderDayToggled(this.dayOfWeek, {required this.enabled});
  

 final  int dayOfWeek;
 final  bool enabled;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutReminderDayToggledCopyWith<SettingsWorkoutReminderDayToggled> get copyWith => _$SettingsWorkoutReminderDayToggledCopyWithImpl<SettingsWorkoutReminderDayToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutReminderDayToggled&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,dayOfWeek,enabled);

@override
String toString() {
  return 'UserSettingsEvent.workoutReminderDayToggled(dayOfWeek: $dayOfWeek, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutReminderDayToggledCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutReminderDayToggledCopyWith(SettingsWorkoutReminderDayToggled value, $Res Function(SettingsWorkoutReminderDayToggled) _then) = _$SettingsWorkoutReminderDayToggledCopyWithImpl;
@useResult
$Res call({
 int dayOfWeek, bool enabled
});




}
/// @nodoc
class _$SettingsWorkoutReminderDayToggledCopyWithImpl<$Res>
    implements $SettingsWorkoutReminderDayToggledCopyWith<$Res> {
  _$SettingsWorkoutReminderDayToggledCopyWithImpl(this._self, this._then);

  final SettingsWorkoutReminderDayToggled _self;
  final $Res Function(SettingsWorkoutReminderDayToggled) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? dayOfWeek = null,Object? enabled = null,}) {
  return _then(SettingsWorkoutReminderDayToggled(
null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsWorkoutReminderTimeChanged implements UserSettingsEvent {
  const SettingsWorkoutReminderTimeChanged(this.timeOfDay);
  

 final  TimeOfDay timeOfDay;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWorkoutReminderTimeChangedCopyWith<SettingsWorkoutReminderTimeChanged> get copyWith => _$SettingsWorkoutReminderTimeChangedCopyWithImpl<SettingsWorkoutReminderTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWorkoutReminderTimeChanged&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,timeOfDay);

@override
String toString() {
  return 'UserSettingsEvent.workoutReminderTimeChanged(timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $SettingsWorkoutReminderTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWorkoutReminderTimeChangedCopyWith(SettingsWorkoutReminderTimeChanged value, $Res Function(SettingsWorkoutReminderTimeChanged) _then) = _$SettingsWorkoutReminderTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay timeOfDay
});




}
/// @nodoc
class _$SettingsWorkoutReminderTimeChangedCopyWithImpl<$Res>
    implements $SettingsWorkoutReminderTimeChangedCopyWith<$Res> {
  _$SettingsWorkoutReminderTimeChangedCopyWithImpl(this._self, this._then);

  final SettingsWorkoutReminderTimeChanged _self;
  final $Res Function(SettingsWorkoutReminderTimeChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timeOfDay = null,}) {
  return _then(SettingsWorkoutReminderTimeChanged(
null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsSaveMealAsUsualChanged implements UserSettingsEvent {
  const SettingsSaveMealAsUsualChanged({required this.value});
  

 final  bool value;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSaveMealAsUsualChangedCopyWith<SettingsSaveMealAsUsualChanged> get copyWith => _$SettingsSaveMealAsUsualChangedCopyWithImpl<SettingsSaveMealAsUsualChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSaveMealAsUsualChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'UserSettingsEvent.saveMealAsUsualChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $SettingsSaveMealAsUsualChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsSaveMealAsUsualChangedCopyWith(SettingsSaveMealAsUsualChanged value, $Res Function(SettingsSaveMealAsUsualChanged) _then) = _$SettingsSaveMealAsUsualChangedCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$SettingsSaveMealAsUsualChangedCopyWithImpl<$Res>
    implements $SettingsSaveMealAsUsualChangedCopyWith<$Res> {
  _$SettingsSaveMealAsUsualChangedCopyWithImpl(this._self, this._then);

  final SettingsSaveMealAsUsualChanged _self;
  final $Res Function(SettingsSaveMealAsUsualChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(SettingsSaveMealAsUsualChanged(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsSaveWorkoutAsUsualChanged implements UserSettingsEvent {
  const SettingsSaveWorkoutAsUsualChanged({required this.value});
  

 final  bool value;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsSaveWorkoutAsUsualChangedCopyWith<SettingsSaveWorkoutAsUsualChanged> get copyWith => _$SettingsSaveWorkoutAsUsualChangedCopyWithImpl<SettingsSaveWorkoutAsUsualChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsSaveWorkoutAsUsualChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'UserSettingsEvent.saveWorkoutAsUsualChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class $SettingsSaveWorkoutAsUsualChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsSaveWorkoutAsUsualChangedCopyWith(SettingsSaveWorkoutAsUsualChanged value, $Res Function(SettingsSaveWorkoutAsUsualChanged) _then) = _$SettingsSaveWorkoutAsUsualChangedCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$SettingsSaveWorkoutAsUsualChangedCopyWithImpl<$Res>
    implements $SettingsSaveWorkoutAsUsualChangedCopyWith<$Res> {
  _$SettingsSaveWorkoutAsUsualChangedCopyWithImpl(this._self, this._then);

  final SettingsSaveWorkoutAsUsualChanged _self;
  final $Res Function(SettingsSaveWorkoutAsUsualChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(SettingsSaveWorkoutAsUsualChanged(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UserSettingsState {

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
 int get version;/// How the app checks in about meals.
 ReminderStyle get reminderStyle;/// Whether meal check-ins happen per meal or once at the end of the day.
 MealCheckinScheduleMode get mealCheckinScheduleMode;/// Per-meal check-in reminders, used in
/// [MealCheckinScheduleMode.perMeal].
 Map<MealOfTheDay, MealReminder> get mealReminders;/// The single daily check-in covering all meals, used in
/// [MealCheckinScheduleMode.endOfDay].
 MealReminder get endOfDayReminder;/// How often the user weighs in. [WeightCheckinFrequency.off] disables
/// weight check-ins.
 WeightCheckinFrequency get weightCheckinFrequency;/// When in the day the weigh-in reminder fires.
 WeightTimeOfDay get weightTimeOfDay; WeightUnit get weightUnit;/// Baseline weight in [weightUnit], null when never provided.
 double? get startingWeight;/// The history of the user's daily calorie target, each entry the goal from
/// the day it took effect, oldest first. Lets historical charts show the
/// goal active at each point rather than retroactively applying the latest.
/// Empty when no goal has ever been set.
 List<CalorieGoalEntry> get calorieGoalHistory;/// The history of the user's target weight, each entry the goal from the
/// day it took effect, oldest first. Empty when no goal has ever been set.
 List<WeightGoalEntry> get weightGoalHistory;/// Whether the app follows the system theme or is forced light or dark.
 ThemeMode get themeMode;/// Whether a meal's nutrition fields start expanded for editing rather than
/// collapsed to a summary.
 bool get expandNutritionByDefault;/// Whether a reminder is skipped on a day its entry is already logged: a
/// meal reminder once that meal is logged, and the weigh-in reminder once
/// today's weight is logged. When false, reminders fire regardless of
/// what's logged.
 bool get skipLoggedMealReminders;/// When a new day begins. Meals and weigh-ins logged before this time count
/// toward the previous day, so late-night logging lands on the right day
/// and the Today view doesn't roll over at midnight.
@TimeOfDayConverter() TimeOfDay get dayStartTime;/// How AI-assisted entry turns a meal into log entries: one combined item
/// or a breakdown into individual foods. Remembered as the user's default
/// and switchable per entry from the food entry sheet.
 MealEntryMode get mealEntryMode;/// The user's usuals library, keyed by meal timing.
 Map<MealOfTheDay, List<UsualMeal>> get usuals;/// The user's usual foods library: reusable base-unit nutritional items
/// that compose meals. Flat (not keyed by meal timing) because a food like
/// "Chicken, 1 oz" is reused across meals.
 List<UsualFood> get usualFoods;/// The user's workout groups, for example Push / Pull / Legs. Ordered by
/// [WorkoutGroup.order]. Seeded with three defaults that use stable const
/// ids so they can be a const default and stay linked to logged workouts
/// across renames.
 List<WorkoutGroup> get workoutGroups;/// The user's usual workouts, keyed by [WorkoutGroup.id].
 Map<String, List<UsualWorkout>> get usualWorkouts;/// The workout check-in reminder.
 WorkoutReminder get workoutReminder;/// The unit workout weights are entered and shown in. Defaults to the
/// body-weight [weightUnit] for returning users via migration.
 WeightUnit get workoutWeightUnit;/// The last "Save as usual" choice in the food entry sheet, restored as the
/// checkbox's default the next time it opens.
 bool get saveMealAsUsual;/// The last "Save as usual" choice in the workout entry sheet, restored as
/// the checkbox's default the next time it opens.
 bool get saveWorkoutAsUsual;
/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<UserSettingsState> get copyWith => _$UserSettingsStateCopyWithImpl<UserSettingsState>(this as UserSettingsState, _$identity);

  /// Serializes this UserSettingsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsState&&(identical(other.version, version) || other.version == version)&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other.mealReminders, mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight)&&const DeepCollectionEquality().equals(other.calorieGoalHistory, calorieGoalHistory)&&const DeepCollectionEquality().equals(other.weightGoalHistory, weightGoalHistory)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.expandNutritionByDefault, expandNutritionByDefault) || other.expandNutritionByDefault == expandNutritionByDefault)&&(identical(other.skipLoggedMealReminders, skipLoggedMealReminders) || other.skipLoggedMealReminders == skipLoggedMealReminders)&&(identical(other.dayStartTime, dayStartTime) || other.dayStartTime == dayStartTime)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&const DeepCollectionEquality().equals(other.usuals, usuals)&&const DeepCollectionEquality().equals(other.usualFoods, usualFoods)&&const DeepCollectionEquality().equals(other.workoutGroups, workoutGroups)&&const DeepCollectionEquality().equals(other.usualWorkouts, usualWorkouts)&&(identical(other.workoutReminder, workoutReminder) || other.workoutReminder == workoutReminder)&&(identical(other.workoutWeightUnit, workoutWeightUnit) || other.workoutWeightUnit == workoutWeightUnit)&&(identical(other.saveMealAsUsual, saveMealAsUsual) || other.saveMealAsUsual == saveMealAsUsual)&&(identical(other.saveWorkoutAsUsual, saveWorkoutAsUsual) || other.saveWorkoutAsUsual == saveWorkoutAsUsual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,version,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight,const DeepCollectionEquality().hash(calorieGoalHistory),const DeepCollectionEquality().hash(weightGoalHistory),themeMode,expandNutritionByDefault,skipLoggedMealReminders,dayStartTime,mealEntryMode,const DeepCollectionEquality().hash(usuals),const DeepCollectionEquality().hash(usualFoods),const DeepCollectionEquality().hash(workoutGroups),const DeepCollectionEquality().hash(usualWorkouts),workoutReminder,workoutWeightUnit,saveMealAsUsual,saveWorkoutAsUsual]);

@override
String toString() {
  return 'UserSettingsState(version: $version, reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight, calorieGoalHistory: $calorieGoalHistory, weightGoalHistory: $weightGoalHistory, themeMode: $themeMode, expandNutritionByDefault: $expandNutritionByDefault, skipLoggedMealReminders: $skipLoggedMealReminders, dayStartTime: $dayStartTime, mealEntryMode: $mealEntryMode, usuals: $usuals, usualFoods: $usualFoods, workoutGroups: $workoutGroups, usualWorkouts: $usualWorkouts, workoutReminder: $workoutReminder, workoutWeightUnit: $workoutWeightUnit, saveMealAsUsual: $saveMealAsUsual, saveWorkoutAsUsual: $saveWorkoutAsUsual)';
}


}

/// @nodoc
abstract mixin class $UserSettingsStateCopyWith<$Res>  {
  factory $UserSettingsStateCopyWith(UserSettingsState value, $Res Function(UserSettingsState) _then) = _$UserSettingsStateCopyWithImpl;
@useResult
$Res call({
 int version, ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight, List<CalorieGoalEntry> calorieGoalHistory, List<WeightGoalEntry> weightGoalHistory, ThemeMode themeMode, bool expandNutritionByDefault, bool skipLoggedMealReminders,@TimeOfDayConverter() TimeOfDay dayStartTime, MealEntryMode mealEntryMode, Map<MealOfTheDay, List<UsualMeal>> usuals, List<UsualFood> usualFoods, List<WorkoutGroup> workoutGroups, Map<String, List<UsualWorkout>> usualWorkouts, WorkoutReminder workoutReminder, WeightUnit workoutWeightUnit, bool saveMealAsUsual, bool saveWorkoutAsUsual
});


$MealReminderCopyWith<$Res> get endOfDayReminder;$WorkoutReminderCopyWith<$Res> get workoutReminder;

}
/// @nodoc
class _$UserSettingsStateCopyWithImpl<$Res>
    implements $UserSettingsStateCopyWith<$Res> {
  _$UserSettingsStateCopyWithImpl(this._self, this._then);

  final UserSettingsState _self;
  final $Res Function(UserSettingsState) _then;

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,Object? calorieGoalHistory = null,Object? weightGoalHistory = null,Object? themeMode = null,Object? expandNutritionByDefault = null,Object? skipLoggedMealReminders = null,Object? dayStartTime = null,Object? mealEntryMode = null,Object? usuals = null,Object? usualFoods = null,Object? workoutGroups = null,Object? usualWorkouts = null,Object? workoutReminder = null,Object? workoutWeightUnit = null,Object? saveMealAsUsual = null,Object? saveWorkoutAsUsual = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self.mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,calorieGoalHistory: null == calorieGoalHistory ? _self.calorieGoalHistory : calorieGoalHistory // ignore: cast_nullable_to_non_nullable
as List<CalorieGoalEntry>,weightGoalHistory: null == weightGoalHistory ? _self.weightGoalHistory : weightGoalHistory // ignore: cast_nullable_to_non_nullable
as List<WeightGoalEntry>,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,expandNutritionByDefault: null == expandNutritionByDefault ? _self.expandNutritionByDefault : expandNutritionByDefault // ignore: cast_nullable_to_non_nullable
as bool,skipLoggedMealReminders: null == skipLoggedMealReminders ? _self.skipLoggedMealReminders : skipLoggedMealReminders // ignore: cast_nullable_to_non_nullable
as bool,dayStartTime: null == dayStartTime ? _self.dayStartTime : dayStartTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,usuals: null == usuals ? _self.usuals : usuals // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, List<UsualMeal>>,usualFoods: null == usualFoods ? _self.usualFoods : usualFoods // ignore: cast_nullable_to_non_nullable
as List<UsualFood>,workoutGroups: null == workoutGroups ? _self.workoutGroups : workoutGroups // ignore: cast_nullable_to_non_nullable
as List<WorkoutGroup>,usualWorkouts: null == usualWorkouts ? _self.usualWorkouts : usualWorkouts // ignore: cast_nullable_to_non_nullable
as Map<String, List<UsualWorkout>>,workoutReminder: null == workoutReminder ? _self.workoutReminder : workoutReminder // ignore: cast_nullable_to_non_nullable
as WorkoutReminder,workoutWeightUnit: null == workoutWeightUnit ? _self.workoutWeightUnit : workoutWeightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,saveMealAsUsual: null == saveMealAsUsual ? _self.saveMealAsUsual : saveMealAsUsual // ignore: cast_nullable_to_non_nullable
as bool,saveWorkoutAsUsual: null == saveWorkoutAsUsual ? _self.saveWorkoutAsUsual : saveWorkoutAsUsual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealReminderCopyWith<$Res> get endOfDayReminder {
  
  return $MealReminderCopyWith<$Res>(_self.endOfDayReminder, (value) {
    return _then(_self.copyWith(endOfDayReminder: value));
  });
}/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutReminderCopyWith<$Res> get workoutReminder {
  
  return $WorkoutReminderCopyWith<$Res>(_self.workoutReminder, (value) {
    return _then(_self.copyWith(workoutReminder: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSettingsState].
extension UserSettingsStatePatterns on UserSettingsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _UserSettingsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  List<CalorieGoalEntry> calorieGoalHistory,  List<WeightGoalEntry> weightGoalHistory,  ThemeMode themeMode,  bool expandNutritionByDefault,  bool skipLoggedMealReminders, @TimeOfDayConverter()  TimeOfDay dayStartTime,  MealEntryMode mealEntryMode,  Map<MealOfTheDay, List<UsualMeal>> usuals,  List<UsualFood> usualFoods,  List<WorkoutGroup> workoutGroups,  Map<String, List<UsualWorkout>> usualWorkouts,  WorkoutReminder workoutReminder,  WeightUnit workoutWeightUnit,  bool saveMealAsUsual,  bool saveWorkoutAsUsual)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.version,_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.calorieGoalHistory,_that.weightGoalHistory,_that.themeMode,_that.expandNutritionByDefault,_that.skipLoggedMealReminders,_that.dayStartTime,_that.mealEntryMode,_that.usuals,_that.usualFoods,_that.workoutGroups,_that.usualWorkouts,_that.workoutReminder,_that.workoutWeightUnit,_that.saveMealAsUsual,_that.saveWorkoutAsUsual);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  List<CalorieGoalEntry> calorieGoalHistory,  List<WeightGoalEntry> weightGoalHistory,  ThemeMode themeMode,  bool expandNutritionByDefault,  bool skipLoggedMealReminders, @TimeOfDayConverter()  TimeOfDay dayStartTime,  MealEntryMode mealEntryMode,  Map<MealOfTheDay, List<UsualMeal>> usuals,  List<UsualFood> usualFoods,  List<WorkoutGroup> workoutGroups,  Map<String, List<UsualWorkout>> usualWorkouts,  WorkoutReminder workoutReminder,  WeightUnit workoutWeightUnit,  bool saveMealAsUsual,  bool saveWorkoutAsUsual)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState():
return $default(_that.version,_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.calorieGoalHistory,_that.weightGoalHistory,_that.themeMode,_that.expandNutritionByDefault,_that.skipLoggedMealReminders,_that.dayStartTime,_that.mealEntryMode,_that.usuals,_that.usualFoods,_that.workoutGroups,_that.usualWorkouts,_that.workoutReminder,_that.workoutWeightUnit,_that.saveMealAsUsual,_that.saveWorkoutAsUsual);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  List<CalorieGoalEntry> calorieGoalHistory,  List<WeightGoalEntry> weightGoalHistory,  ThemeMode themeMode,  bool expandNutritionByDefault,  bool skipLoggedMealReminders, @TimeOfDayConverter()  TimeOfDay dayStartTime,  MealEntryMode mealEntryMode,  Map<MealOfTheDay, List<UsualMeal>> usuals,  List<UsualFood> usualFoods,  List<WorkoutGroup> workoutGroups,  Map<String, List<UsualWorkout>> usualWorkouts,  WorkoutReminder workoutReminder,  WeightUnit workoutWeightUnit,  bool saveMealAsUsual,  bool saveWorkoutAsUsual)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.version,_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.calorieGoalHistory,_that.weightGoalHistory,_that.themeMode,_that.expandNutritionByDefault,_that.skipLoggedMealReminders,_that.dayStartTime,_that.mealEntryMode,_that.usuals,_that.usualFoods,_that.workoutGroups,_that.usualWorkouts,_that.workoutReminder,_that.workoutWeightUnit,_that.saveMealAsUsual,_that.saveWorkoutAsUsual);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserSettingsState extends UserSettingsState {
  const _UserSettingsState({this.version = 4, this.reminderStyle = ReminderStyle.notifications, this.mealCheckinScheduleMode = MealCheckinScheduleMode.perMeal, final  Map<MealOfTheDay, MealReminder> mealReminders = const {MealOfTheDay.breakfast : MealReminder(enabled: true, timeOfDay: TimeOfDay(hour: 9, minute: 0)), MealOfTheDay.lunch : MealReminder(enabled: true, timeOfDay: TimeOfDay(hour: 14, minute: 0)), MealOfTheDay.dinner : MealReminder(enabled: true, timeOfDay: TimeOfDay(hour: 19, minute: 30)), MealOfTheDay.snacks : MealReminder(enabled: false, timeOfDay: TimeOfDay(hour: 15, minute: 0))}, this.endOfDayReminder = const MealReminder(enabled: true, timeOfDay: TimeOfDay(hour: 20, minute: 0)), this.weightCheckinFrequency = WeightCheckinFrequency.daily, this.weightTimeOfDay = WeightTimeOfDay.morning, this.weightUnit = WeightUnit.lb, this.startingWeight, final  List<CalorieGoalEntry> calorieGoalHistory = const <CalorieGoalEntry>[], final  List<WeightGoalEntry> weightGoalHistory = const <WeightGoalEntry>[], this.themeMode = ThemeMode.system, this.expandNutritionByDefault = false, this.skipLoggedMealReminders = false, @TimeOfDayConverter() this.dayStartTime = const TimeOfDay(hour: 0, minute: 0), this.mealEntryMode = MealEntryMode.wholeMeal, final  Map<MealOfTheDay, List<UsualMeal>> usuals = const <MealOfTheDay, List<UsualMeal>>{}, final  List<UsualFood> usualFoods = const <UsualFood>[], final  List<WorkoutGroup> workoutGroups = const <WorkoutGroup>[WorkoutGroup(id: 'push', name: 'Push', order: 0), WorkoutGroup(id: 'pull', name: 'Pull', order: 1), WorkoutGroup(id: 'legs', name: 'Legs', order: 2)], final  Map<String, List<UsualWorkout>> usualWorkouts = const <String, List<UsualWorkout>>{}, this.workoutReminder = const WorkoutReminder(timeOfDay: TimeOfDay(hour: 18, minute: 0)), this.workoutWeightUnit = WeightUnit.lb, this.saveMealAsUsual = true, this.saveWorkoutAsUsual = false}): _mealReminders = mealReminders,_calorieGoalHistory = calorieGoalHistory,_weightGoalHistory = weightGoalHistory,_usuals = usuals,_usualFoods = usualFoods,_workoutGroups = workoutGroups,_usualWorkouts = usualWorkouts,super._();
  factory _UserSettingsState.fromJson(Map<String, dynamic> json) => _$UserSettingsStateFromJson(json);

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
@override@JsonKey() final  int version;
/// How the app checks in about meals.
@override@JsonKey() final  ReminderStyle reminderStyle;
/// Whether meal check-ins happen per meal or once at the end of the day.
@override@JsonKey() final  MealCheckinScheduleMode mealCheckinScheduleMode;
/// Per-meal check-in reminders, used in
/// [MealCheckinScheduleMode.perMeal].
 final  Map<MealOfTheDay, MealReminder> _mealReminders;
/// Per-meal check-in reminders, used in
/// [MealCheckinScheduleMode.perMeal].
@override@JsonKey() Map<MealOfTheDay, MealReminder> get mealReminders {
  if (_mealReminders is EqualUnmodifiableMapView) return _mealReminders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_mealReminders);
}

/// The single daily check-in covering all meals, used in
/// [MealCheckinScheduleMode.endOfDay].
@override@JsonKey() final  MealReminder endOfDayReminder;
/// How often the user weighs in. [WeightCheckinFrequency.off] disables
/// weight check-ins.
@override@JsonKey() final  WeightCheckinFrequency weightCheckinFrequency;
/// When in the day the weigh-in reminder fires.
@override@JsonKey() final  WeightTimeOfDay weightTimeOfDay;
@override@JsonKey() final  WeightUnit weightUnit;
/// Baseline weight in [weightUnit], null when never provided.
@override final  double? startingWeight;
/// The history of the user's daily calorie target, each entry the goal from
/// the day it took effect, oldest first. Lets historical charts show the
/// goal active at each point rather than retroactively applying the latest.
/// Empty when no goal has ever been set.
 final  List<CalorieGoalEntry> _calorieGoalHistory;
/// The history of the user's daily calorie target, each entry the goal from
/// the day it took effect, oldest first. Lets historical charts show the
/// goal active at each point rather than retroactively applying the latest.
/// Empty when no goal has ever been set.
@override@JsonKey() List<CalorieGoalEntry> get calorieGoalHistory {
  if (_calorieGoalHistory is EqualUnmodifiableListView) return _calorieGoalHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calorieGoalHistory);
}

/// The history of the user's target weight, each entry the goal from the
/// day it took effect, oldest first. Empty when no goal has ever been set.
 final  List<WeightGoalEntry> _weightGoalHistory;
/// The history of the user's target weight, each entry the goal from the
/// day it took effect, oldest first. Empty when no goal has ever been set.
@override@JsonKey() List<WeightGoalEntry> get weightGoalHistory {
  if (_weightGoalHistory is EqualUnmodifiableListView) return _weightGoalHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weightGoalHistory);
}

/// Whether the app follows the system theme or is forced light or dark.
@override@JsonKey() final  ThemeMode themeMode;
/// Whether a meal's nutrition fields start expanded for editing rather than
/// collapsed to a summary.
@override@JsonKey() final  bool expandNutritionByDefault;
/// Whether a reminder is skipped on a day its entry is already logged: a
/// meal reminder once that meal is logged, and the weigh-in reminder once
/// today's weight is logged. When false, reminders fire regardless of
/// what's logged.
@override@JsonKey() final  bool skipLoggedMealReminders;
/// When a new day begins. Meals and weigh-ins logged before this time count
/// toward the previous day, so late-night logging lands on the right day
/// and the Today view doesn't roll over at midnight.
@override@JsonKey()@TimeOfDayConverter() final  TimeOfDay dayStartTime;
/// How AI-assisted entry turns a meal into log entries: one combined item
/// or a breakdown into individual foods. Remembered as the user's default
/// and switchable per entry from the food entry sheet.
@override@JsonKey() final  MealEntryMode mealEntryMode;
/// The user's usuals library, keyed by meal timing.
 final  Map<MealOfTheDay, List<UsualMeal>> _usuals;
/// The user's usuals library, keyed by meal timing.
@override@JsonKey() Map<MealOfTheDay, List<UsualMeal>> get usuals {
  if (_usuals is EqualUnmodifiableMapView) return _usuals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usuals);
}

/// The user's usual foods library: reusable base-unit nutritional items
/// that compose meals. Flat (not keyed by meal timing) because a food like
/// "Chicken, 1 oz" is reused across meals.
 final  List<UsualFood> _usualFoods;
/// The user's usual foods library: reusable base-unit nutritional items
/// that compose meals. Flat (not keyed by meal timing) because a food like
/// "Chicken, 1 oz" is reused across meals.
@override@JsonKey() List<UsualFood> get usualFoods {
  if (_usualFoods is EqualUnmodifiableListView) return _usualFoods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_usualFoods);
}

/// The user's workout groups, for example Push / Pull / Legs. Ordered by
/// [WorkoutGroup.order]. Seeded with three defaults that use stable const
/// ids so they can be a const default and stay linked to logged workouts
/// across renames.
 final  List<WorkoutGroup> _workoutGroups;
/// The user's workout groups, for example Push / Pull / Legs. Ordered by
/// [WorkoutGroup.order]. Seeded with three defaults that use stable const
/// ids so they can be a const default and stay linked to logged workouts
/// across renames.
@override@JsonKey() List<WorkoutGroup> get workoutGroups {
  if (_workoutGroups is EqualUnmodifiableListView) return _workoutGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workoutGroups);
}

/// The user's usual workouts, keyed by [WorkoutGroup.id].
 final  Map<String, List<UsualWorkout>> _usualWorkouts;
/// The user's usual workouts, keyed by [WorkoutGroup.id].
@override@JsonKey() Map<String, List<UsualWorkout>> get usualWorkouts {
  if (_usualWorkouts is EqualUnmodifiableMapView) return _usualWorkouts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usualWorkouts);
}

/// The workout check-in reminder.
@override@JsonKey() final  WorkoutReminder workoutReminder;
/// The unit workout weights are entered and shown in. Defaults to the
/// body-weight [weightUnit] for returning users via migration.
@override@JsonKey() final  WeightUnit workoutWeightUnit;
/// The last "Save as usual" choice in the food entry sheet, restored as the
/// checkbox's default the next time it opens.
@override@JsonKey() final  bool saveMealAsUsual;
/// The last "Save as usual" choice in the workout entry sheet, restored as
/// the checkbox's default the next time it opens.
@override@JsonKey() final  bool saveWorkoutAsUsual;

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsStateCopyWith<_UserSettingsState> get copyWith => __$UserSettingsStateCopyWithImpl<_UserSettingsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsState&&(identical(other.version, version) || other.version == version)&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other._mealReminders, _mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight)&&const DeepCollectionEquality().equals(other._calorieGoalHistory, _calorieGoalHistory)&&const DeepCollectionEquality().equals(other._weightGoalHistory, _weightGoalHistory)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.expandNutritionByDefault, expandNutritionByDefault) || other.expandNutritionByDefault == expandNutritionByDefault)&&(identical(other.skipLoggedMealReminders, skipLoggedMealReminders) || other.skipLoggedMealReminders == skipLoggedMealReminders)&&(identical(other.dayStartTime, dayStartTime) || other.dayStartTime == dayStartTime)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&const DeepCollectionEquality().equals(other._usuals, _usuals)&&const DeepCollectionEquality().equals(other._usualFoods, _usualFoods)&&const DeepCollectionEquality().equals(other._workoutGroups, _workoutGroups)&&const DeepCollectionEquality().equals(other._usualWorkouts, _usualWorkouts)&&(identical(other.workoutReminder, workoutReminder) || other.workoutReminder == workoutReminder)&&(identical(other.workoutWeightUnit, workoutWeightUnit) || other.workoutWeightUnit == workoutWeightUnit)&&(identical(other.saveMealAsUsual, saveMealAsUsual) || other.saveMealAsUsual == saveMealAsUsual)&&(identical(other.saveWorkoutAsUsual, saveWorkoutAsUsual) || other.saveWorkoutAsUsual == saveWorkoutAsUsual));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,version,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(_mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight,const DeepCollectionEquality().hash(_calorieGoalHistory),const DeepCollectionEquality().hash(_weightGoalHistory),themeMode,expandNutritionByDefault,skipLoggedMealReminders,dayStartTime,mealEntryMode,const DeepCollectionEquality().hash(_usuals),const DeepCollectionEquality().hash(_usualFoods),const DeepCollectionEquality().hash(_workoutGroups),const DeepCollectionEquality().hash(_usualWorkouts),workoutReminder,workoutWeightUnit,saveMealAsUsual,saveWorkoutAsUsual]);

@override
String toString() {
  return 'UserSettingsState(version: $version, reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight, calorieGoalHistory: $calorieGoalHistory, weightGoalHistory: $weightGoalHistory, themeMode: $themeMode, expandNutritionByDefault: $expandNutritionByDefault, skipLoggedMealReminders: $skipLoggedMealReminders, dayStartTime: $dayStartTime, mealEntryMode: $mealEntryMode, usuals: $usuals, usualFoods: $usualFoods, workoutGroups: $workoutGroups, usualWorkouts: $usualWorkouts, workoutReminder: $workoutReminder, workoutWeightUnit: $workoutWeightUnit, saveMealAsUsual: $saveMealAsUsual, saveWorkoutAsUsual: $saveWorkoutAsUsual)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsStateCopyWith<$Res> implements $UserSettingsStateCopyWith<$Res> {
  factory _$UserSettingsStateCopyWith(_UserSettingsState value, $Res Function(_UserSettingsState) _then) = __$UserSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 int version, ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight, List<CalorieGoalEntry> calorieGoalHistory, List<WeightGoalEntry> weightGoalHistory, ThemeMode themeMode, bool expandNutritionByDefault, bool skipLoggedMealReminders,@TimeOfDayConverter() TimeOfDay dayStartTime, MealEntryMode mealEntryMode, Map<MealOfTheDay, List<UsualMeal>> usuals, List<UsualFood> usualFoods, List<WorkoutGroup> workoutGroups, Map<String, List<UsualWorkout>> usualWorkouts, WorkoutReminder workoutReminder, WeightUnit workoutWeightUnit, bool saveMealAsUsual, bool saveWorkoutAsUsual
});


@override $MealReminderCopyWith<$Res> get endOfDayReminder;@override $WorkoutReminderCopyWith<$Res> get workoutReminder;

}
/// @nodoc
class __$UserSettingsStateCopyWithImpl<$Res>
    implements _$UserSettingsStateCopyWith<$Res> {
  __$UserSettingsStateCopyWithImpl(this._self, this._then);

  final _UserSettingsState _self;
  final $Res Function(_UserSettingsState) _then;

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,Object? calorieGoalHistory = null,Object? weightGoalHistory = null,Object? themeMode = null,Object? expandNutritionByDefault = null,Object? skipLoggedMealReminders = null,Object? dayStartTime = null,Object? mealEntryMode = null,Object? usuals = null,Object? usualFoods = null,Object? workoutGroups = null,Object? usualWorkouts = null,Object? workoutReminder = null,Object? workoutWeightUnit = null,Object? saveMealAsUsual = null,Object? saveWorkoutAsUsual = null,}) {
  return _then(_UserSettingsState(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self._mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,calorieGoalHistory: null == calorieGoalHistory ? _self._calorieGoalHistory : calorieGoalHistory // ignore: cast_nullable_to_non_nullable
as List<CalorieGoalEntry>,weightGoalHistory: null == weightGoalHistory ? _self._weightGoalHistory : weightGoalHistory // ignore: cast_nullable_to_non_nullable
as List<WeightGoalEntry>,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,expandNutritionByDefault: null == expandNutritionByDefault ? _self.expandNutritionByDefault : expandNutritionByDefault // ignore: cast_nullable_to_non_nullable
as bool,skipLoggedMealReminders: null == skipLoggedMealReminders ? _self.skipLoggedMealReminders : skipLoggedMealReminders // ignore: cast_nullable_to_non_nullable
as bool,dayStartTime: null == dayStartTime ? _self.dayStartTime : dayStartTime // ignore: cast_nullable_to_non_nullable
as TimeOfDay,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,usuals: null == usuals ? _self._usuals : usuals // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, List<UsualMeal>>,usualFoods: null == usualFoods ? _self._usualFoods : usualFoods // ignore: cast_nullable_to_non_nullable
as List<UsualFood>,workoutGroups: null == workoutGroups ? _self._workoutGroups : workoutGroups // ignore: cast_nullable_to_non_nullable
as List<WorkoutGroup>,usualWorkouts: null == usualWorkouts ? _self._usualWorkouts : usualWorkouts // ignore: cast_nullable_to_non_nullable
as Map<String, List<UsualWorkout>>,workoutReminder: null == workoutReminder ? _self.workoutReminder : workoutReminder // ignore: cast_nullable_to_non_nullable
as WorkoutReminder,workoutWeightUnit: null == workoutWeightUnit ? _self.workoutWeightUnit : workoutWeightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,saveMealAsUsual: null == saveMealAsUsual ? _self.saveMealAsUsual : saveMealAsUsual // ignore: cast_nullable_to_non_nullable
as bool,saveWorkoutAsUsual: null == saveWorkoutAsUsual ? _self.saveWorkoutAsUsual : saveWorkoutAsUsual // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealReminderCopyWith<$Res> get endOfDayReminder {
  
  return $MealReminderCopyWith<$Res>(_self.endOfDayReminder, (value) {
    return _then(_self.copyWith(endOfDayReminder: value));
  });
}/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutReminderCopyWith<$Res> get workoutReminder {
  
  return $WorkoutReminderCopyWith<$Res>(_self.workoutReminder, (value) {
    return _then(_self.copyWith(workoutReminder: value));
  });
}
}

// dart format on
