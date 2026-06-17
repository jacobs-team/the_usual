// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent()';
}


}

/// @nodoc
class $OnboardingEventCopyWith<$Res>  {
$OnboardingEventCopyWith(OnboardingEvent _, $Res Function(OnboardingEvent) __);
}


/// Adds pattern-matching-related methods to [OnboardingEvent].
extension OnboardingEventPatterns on OnboardingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BackPressed value)?  backPressed,TResult Function( ResetPressed value)?  resetPressed,TResult Function( SkipPressed value)?  skipPressed,TResult Function( ContinuePressed value)?  continuePressed,TResult Function( UsualMealAdded value)?  usualMealAdded,TResult Function( UsualMealRemoved value)?  usualMealRemoved,TResult Function( UsualMealNutritionChanged value)?  usualMealNutritionChanged,TResult Function( UsualMealNameChanged value)?  usualMealNameChanged,TResult Function( ReminderStyleSelected value)?  reminderStyleSelected,TResult Function( MealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult Function( MealReminderToggled value)?  mealReminderToggled,TResult Function( MealReminderTimeChanged value)?  mealReminderTimeChanged,TResult Function( EndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult Function( SkipLoggedMealRemindersChanged value)?  skipLoggedMealRemindersChanged,TResult Function( WeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult Function( WeightUnitSelected value)?  weightUnitSelected,TResult Function( StartingWeightChanged value)?  startingWeightChanged,TResult Function( CalorieGoalChanged value)?  calorieGoalChanged,TResult Function( WeightGoalChanged value)?  weightGoalChanged,TResult Function( FirstLogItemToggled value)?  firstLogItemToggled,TResult Function( FirstLogItemQuantityChanged value)?  firstLogItemQuantityChanged,TResult Function( SomethingElseLogged value)?  somethingElseLogged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed(_that);case ResetPressed() when resetPressed != null:
return resetPressed(_that);case SkipPressed() when skipPressed != null:
return skipPressed(_that);case ContinuePressed() when continuePressed != null:
return continuePressed(_that);case UsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that);case UsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that);case UsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that);case UsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case CalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that);case WeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that);case FirstLogItemQuantityChanged() when firstLogItemQuantityChanged != null:
return firstLogItemQuantityChanged(_that);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BackPressed value)  backPressed,required TResult Function( ResetPressed value)  resetPressed,required TResult Function( SkipPressed value)  skipPressed,required TResult Function( ContinuePressed value)  continuePressed,required TResult Function( UsualMealAdded value)  usualMealAdded,required TResult Function( UsualMealRemoved value)  usualMealRemoved,required TResult Function( UsualMealNutritionChanged value)  usualMealNutritionChanged,required TResult Function( UsualMealNameChanged value)  usualMealNameChanged,required TResult Function( ReminderStyleSelected value)  reminderStyleSelected,required TResult Function( MealCheckinScheduleModeChanged value)  mealCheckinScheduleModeChanged,required TResult Function( MealReminderToggled value)  mealReminderToggled,required TResult Function( MealReminderTimeChanged value)  mealReminderTimeChanged,required TResult Function( EndOfDayTimeChanged value)  endOfDayTimeChanged,required TResult Function( SkipLoggedMealRemindersChanged value)  skipLoggedMealRemindersChanged,required TResult Function( WeightCheckinFrequencySelected value)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDaySelected value)  weightTimeOfDaySelected,required TResult Function( WeightUnitSelected value)  weightUnitSelected,required TResult Function( StartingWeightChanged value)  startingWeightChanged,required TResult Function( CalorieGoalChanged value)  calorieGoalChanged,required TResult Function( WeightGoalChanged value)  weightGoalChanged,required TResult Function( FirstLogItemToggled value)  firstLogItemToggled,required TResult Function( FirstLogItemQuantityChanged value)  firstLogItemQuantityChanged,required TResult Function( SomethingElseLogged value)  somethingElseLogged,}){
final _that = this;
switch (_that) {
case BackPressed():
return backPressed(_that);case ResetPressed():
return resetPressed(_that);case SkipPressed():
return skipPressed(_that);case ContinuePressed():
return continuePressed(_that);case UsualMealAdded():
return usualMealAdded(_that);case UsualMealRemoved():
return usualMealRemoved(_that);case UsualMealNutritionChanged():
return usualMealNutritionChanged(_that);case UsualMealNameChanged():
return usualMealNameChanged(_that);case ReminderStyleSelected():
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled():
return mealReminderToggled(_that);case MealReminderTimeChanged():
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged():
return endOfDayTimeChanged(_that);case SkipLoggedMealRemindersChanged():
return skipLoggedMealRemindersChanged(_that);case WeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that);case WeightUnitSelected():
return weightUnitSelected(_that);case StartingWeightChanged():
return startingWeightChanged(_that);case CalorieGoalChanged():
return calorieGoalChanged(_that);case WeightGoalChanged():
return weightGoalChanged(_that);case FirstLogItemToggled():
return firstLogItemToggled(_that);case FirstLogItemQuantityChanged():
return firstLogItemQuantityChanged(_that);case SomethingElseLogged():
return somethingElseLogged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BackPressed value)?  backPressed,TResult? Function( ResetPressed value)?  resetPressed,TResult? Function( SkipPressed value)?  skipPressed,TResult? Function( ContinuePressed value)?  continuePressed,TResult? Function( UsualMealAdded value)?  usualMealAdded,TResult? Function( UsualMealRemoved value)?  usualMealRemoved,TResult? Function( UsualMealNutritionChanged value)?  usualMealNutritionChanged,TResult? Function( UsualMealNameChanged value)?  usualMealNameChanged,TResult? Function( ReminderStyleSelected value)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult? Function( MealReminderToggled value)?  mealReminderToggled,TResult? Function( MealReminderTimeChanged value)?  mealReminderTimeChanged,TResult? Function( EndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult? Function( SkipLoggedMealRemindersChanged value)?  skipLoggedMealRemindersChanged,TResult? Function( WeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult? Function( WeightUnitSelected value)?  weightUnitSelected,TResult? Function( StartingWeightChanged value)?  startingWeightChanged,TResult? Function( CalorieGoalChanged value)?  calorieGoalChanged,TResult? Function( WeightGoalChanged value)?  weightGoalChanged,TResult? Function( FirstLogItemToggled value)?  firstLogItemToggled,TResult? Function( FirstLogItemQuantityChanged value)?  firstLogItemQuantityChanged,TResult? Function( SomethingElseLogged value)?  somethingElseLogged,}){
final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed(_that);case ResetPressed() when resetPressed != null:
return resetPressed(_that);case SkipPressed() when skipPressed != null:
return skipPressed(_that);case ContinuePressed() when continuePressed != null:
return continuePressed(_that);case UsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that);case UsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that);case UsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that);case UsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case CalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that);case WeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that);case FirstLogItemQuantityChanged() when firstLogItemQuantityChanged != null:
return firstLogItemQuantityChanged(_that);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  backPressed,TResult Function()?  resetPressed,TResult Function()?  skipPressed,TResult Function()?  continuePressed,TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition)?  usualMealAdded,TResult Function( MealOfTheDay mealOfTheDay,  String id)?  usualMealRemoved,TResult Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)?  usualMealNutritionChanged,TResult Function( MealOfTheDay mealOfTheDay,  String id,  String name)?  usualMealNameChanged,TResult Function( ReminderStyle reminderStyle)?  reminderStyleSelected,TResult Function( MealCheckinScheduleMode mealCheckinScheduleMode)?  mealCheckinScheduleModeChanged,TResult Function( MealOfTheDay mealOfTheDay,  bool enabled)?  mealReminderToggled,TResult Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)?  mealReminderTimeChanged,TResult Function( TimeOfDay timeOfDay)?  endOfDayTimeChanged,TResult Function( bool skipLoggedMealReminders)?  skipLoggedMealRemindersChanged,TResult Function( WeightCheckinFrequency weightCheckinFrequency)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDay weightTimeOfDay)?  weightTimeOfDaySelected,TResult Function( WeightUnit weightUnit)?  weightUnitSelected,TResult Function( double? weight)?  startingWeightChanged,TResult Function( int? calorieGoal)?  calorieGoalChanged,TResult Function( double? weightGoal)?  weightGoalChanged,TResult Function( String id)?  firstLogItemToggled,TResult Function( String id,  double quantity)?  firstLogItemQuantityChanged,TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity)?  somethingElseLogged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed();case ResetPressed() when resetPressed != null:
return resetPressed();case SkipPressed() when skipPressed != null:
return skipPressed();case ContinuePressed() when continuePressed != null:
return continuePressed();case UsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition);case UsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that.mealOfTheDay,_that.id);case UsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case UsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.reminderStyle);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.timeOfDay);case SkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.weightTimeOfDay);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.weightUnit);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case CalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that.calorieGoal);case WeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that.weightGoal);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that.id);case FirstLogItemQuantityChanged() when firstLogItemQuantityChanged != null:
return firstLogItemQuantityChanged(_that.id,_that.quantity);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  backPressed,required TResult Function()  resetPressed,required TResult Function()  skipPressed,required TResult Function()  continuePressed,required TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition)  usualMealAdded,required TResult Function( MealOfTheDay mealOfTheDay,  String id)  usualMealRemoved,required TResult Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)  usualMealNutritionChanged,required TResult Function( MealOfTheDay mealOfTheDay,  String id,  String name)  usualMealNameChanged,required TResult Function( ReminderStyle reminderStyle)  reminderStyleSelected,required TResult Function( MealCheckinScheduleMode mealCheckinScheduleMode)  mealCheckinScheduleModeChanged,required TResult Function( MealOfTheDay mealOfTheDay,  bool enabled)  mealReminderToggled,required TResult Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)  mealReminderTimeChanged,required TResult Function( TimeOfDay timeOfDay)  endOfDayTimeChanged,required TResult Function( bool skipLoggedMealReminders)  skipLoggedMealRemindersChanged,required TResult Function( WeightCheckinFrequency weightCheckinFrequency)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDay weightTimeOfDay)  weightTimeOfDaySelected,required TResult Function( WeightUnit weightUnit)  weightUnitSelected,required TResult Function( double? weight)  startingWeightChanged,required TResult Function( int? calorieGoal)  calorieGoalChanged,required TResult Function( double? weightGoal)  weightGoalChanged,required TResult Function( String id)  firstLogItemToggled,required TResult Function( String id,  double quantity)  firstLogItemQuantityChanged,required TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity)  somethingElseLogged,}) {final _that = this;
switch (_that) {
case BackPressed():
return backPressed();case ResetPressed():
return resetPressed();case SkipPressed():
return skipPressed();case ContinuePressed():
return continuePressed();case UsualMealAdded():
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition);case UsualMealRemoved():
return usualMealRemoved(_that.mealOfTheDay,_that.id);case UsualMealNutritionChanged():
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case UsualMealNameChanged():
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case ReminderStyleSelected():
return reminderStyleSelected(_that.reminderStyle);case MealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case MealReminderToggled():
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case MealReminderTimeChanged():
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case EndOfDayTimeChanged():
return endOfDayTimeChanged(_that.timeOfDay);case SkipLoggedMealRemindersChanged():
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case WeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case WeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that.weightTimeOfDay);case WeightUnitSelected():
return weightUnitSelected(_that.weightUnit);case StartingWeightChanged():
return startingWeightChanged(_that.weight);case CalorieGoalChanged():
return calorieGoalChanged(_that.calorieGoal);case WeightGoalChanged():
return weightGoalChanged(_that.weightGoal);case FirstLogItemToggled():
return firstLogItemToggled(_that.id);case FirstLogItemQuantityChanged():
return firstLogItemQuantityChanged(_that.id,_that.quantity);case SomethingElseLogged():
return somethingElseLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  backPressed,TResult? Function()?  resetPressed,TResult? Function()?  skipPressed,TResult? Function()?  continuePressed,TResult? Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition)?  usualMealAdded,TResult? Function( MealOfTheDay mealOfTheDay,  String id)?  usualMealRemoved,TResult? Function( MealOfTheDay mealOfTheDay,  String id,  Nutrition nutrition)?  usualMealNutritionChanged,TResult? Function( MealOfTheDay mealOfTheDay,  String id,  String name)?  usualMealNameChanged,TResult? Function( ReminderStyle reminderStyle)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleMode mealCheckinScheduleMode)?  mealCheckinScheduleModeChanged,TResult? Function( MealOfTheDay mealOfTheDay,  bool enabled)?  mealReminderToggled,TResult? Function( MealOfTheDay mealOfTheDay,  TimeOfDay timeOfDay)?  mealReminderTimeChanged,TResult? Function( TimeOfDay timeOfDay)?  endOfDayTimeChanged,TResult? Function( bool skipLoggedMealReminders)?  skipLoggedMealRemindersChanged,TResult? Function( WeightCheckinFrequency weightCheckinFrequency)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDay weightTimeOfDay)?  weightTimeOfDaySelected,TResult? Function( WeightUnit weightUnit)?  weightUnitSelected,TResult? Function( double? weight)?  startingWeightChanged,TResult? Function( int? calorieGoal)?  calorieGoalChanged,TResult? Function( double? weightGoal)?  weightGoalChanged,TResult? Function( String id)?  firstLogItemToggled,TResult? Function( String id,  double quantity)?  firstLogItemQuantityChanged,TResult? Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity)?  somethingElseLogged,}) {final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed();case ResetPressed() when resetPressed != null:
return resetPressed();case SkipPressed() when skipPressed != null:
return skipPressed();case ContinuePressed() when continuePressed != null:
return continuePressed();case UsualMealAdded() when usualMealAdded != null:
return usualMealAdded(_that.mealOfTheDay,_that.name,_that.nutrition);case UsualMealRemoved() when usualMealRemoved != null:
return usualMealRemoved(_that.mealOfTheDay,_that.id);case UsualMealNutritionChanged() when usualMealNutritionChanged != null:
return usualMealNutritionChanged(_that.mealOfTheDay,_that.id,_that.nutrition);case UsualMealNameChanged() when usualMealNameChanged != null:
return usualMealNameChanged(_that.mealOfTheDay,_that.id,_that.name);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.reminderStyle);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mealCheckinScheduleMode);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.mealOfTheDay,_that.enabled);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.mealOfTheDay,_that.timeOfDay);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.timeOfDay);case SkipLoggedMealRemindersChanged() when skipLoggedMealRemindersChanged != null:
return skipLoggedMealRemindersChanged(_that.skipLoggedMealReminders);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.weightCheckinFrequency);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.weightTimeOfDay);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.weightUnit);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case CalorieGoalChanged() when calorieGoalChanged != null:
return calorieGoalChanged(_that.calorieGoal);case WeightGoalChanged() when weightGoalChanged != null:
return weightGoalChanged(_that.weightGoal);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that.id);case FirstLogItemQuantityChanged() when firstLogItemQuantityChanged != null:
return firstLogItemQuantityChanged(_that.id,_that.quantity);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc


class BackPressed implements OnboardingEvent {
  const BackPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.backPressed()';
}


}




/// @nodoc


class ResetPressed implements OnboardingEvent {
  const ResetPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.resetPressed()';
}


}




/// @nodoc


class SkipPressed implements OnboardingEvent {
  const SkipPressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipPressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.skipPressed()';
}


}




/// @nodoc


class ContinuePressed implements OnboardingEvent {
  const ContinuePressed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContinuePressed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.continuePressed()';
}


}




/// @nodoc


class UsualMealAdded implements OnboardingEvent {
  const UsualMealAdded(this.mealOfTheDay, this.name, this.nutrition);
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
 final  Nutrition nutrition;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealAddedCopyWith<UsualMealAdded> get copyWith => _$UsualMealAddedCopyWithImpl<UsualMealAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMealAdded&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,nutrition);

@override
String toString() {
  return 'OnboardingEvent.usualMealAdded(mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $UsualMealAddedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualMealAddedCopyWith(UsualMealAdded value, $Res Function(UsualMealAdded) _then) = _$UsualMealAddedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$UsualMealAddedCopyWithImpl<$Res>
    implements $UsualMealAddedCopyWith<$Res> {
  _$UsualMealAddedCopyWithImpl(this._self, this._then);

  final UsualMealAdded _self;
  final $Res Function(UsualMealAdded) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,}) {
  return _then(UsualMealAdded(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of OnboardingEvent
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


class UsualMealRemoved implements OnboardingEvent {
  const UsualMealRemoved(this.mealOfTheDay, this.id);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealRemovedCopyWith<UsualMealRemoved> get copyWith => _$UsualMealRemovedCopyWithImpl<UsualMealRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMealRemoved&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id);

@override
String toString() {
  return 'OnboardingEvent.usualMealRemoved(mealOfTheDay: $mealOfTheDay, id: $id)';
}


}

/// @nodoc
abstract mixin class $UsualMealRemovedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualMealRemovedCopyWith(UsualMealRemoved value, $Res Function(UsualMealRemoved) _then) = _$UsualMealRemovedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id
});




}
/// @nodoc
class _$UsualMealRemovedCopyWithImpl<$Res>
    implements $UsualMealRemovedCopyWith<$Res> {
  _$UsualMealRemovedCopyWithImpl(this._self, this._then);

  final UsualMealRemoved _self;
  final $Res Function(UsualMealRemoved) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,}) {
  return _then(UsualMealRemoved(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UsualMealNutritionChanged implements OnboardingEvent {
  const UsualMealNutritionChanged(this.mealOfTheDay, this.id, this.nutrition);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;
 final  Nutrition nutrition;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealNutritionChangedCopyWith<UsualMealNutritionChanged> get copyWith => _$UsualMealNutritionChangedCopyWithImpl<UsualMealNutritionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMealNutritionChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id,nutrition);

@override
String toString() {
  return 'OnboardingEvent.usualMealNutritionChanged(mealOfTheDay: $mealOfTheDay, id: $id, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $UsualMealNutritionChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualMealNutritionChangedCopyWith(UsualMealNutritionChanged value, $Res Function(UsualMealNutritionChanged) _then) = _$UsualMealNutritionChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$UsualMealNutritionChangedCopyWithImpl<$Res>
    implements $UsualMealNutritionChangedCopyWith<$Res> {
  _$UsualMealNutritionChangedCopyWithImpl(this._self, this._then);

  final UsualMealNutritionChanged _self;
  final $Res Function(UsualMealNutritionChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,Object? nutrition = null,}) {
  return _then(UsualMealNutritionChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of OnboardingEvent
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


class UsualMealNameChanged implements OnboardingEvent {
  const UsualMealNameChanged(this.mealOfTheDay, this.id, this.name);
  

 final  MealOfTheDay mealOfTheDay;
 final  String id;
 final  String name;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealNameChangedCopyWith<UsualMealNameChanged> get copyWith => _$UsualMealNameChangedCopyWithImpl<UsualMealNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMealNameChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,id,name);

@override
String toString() {
  return 'OnboardingEvent.usualMealNameChanged(mealOfTheDay: $mealOfTheDay, id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $UsualMealNameChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualMealNameChangedCopyWith(UsualMealNameChanged value, $Res Function(UsualMealNameChanged) _then) = _$UsualMealNameChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String id, String name
});




}
/// @nodoc
class _$UsualMealNameChangedCopyWithImpl<$Res>
    implements $UsualMealNameChangedCopyWith<$Res> {
  _$UsualMealNameChangedCopyWithImpl(this._self, this._then);

  final UsualMealNameChanged _self;
  final $Res Function(UsualMealNameChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? id = null,Object? name = null,}) {
  return _then(UsualMealNameChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ReminderStyleSelected implements OnboardingEvent {
  const ReminderStyleSelected(this.reminderStyle);
  

 final  ReminderStyle reminderStyle;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderStyleSelectedCopyWith<ReminderStyleSelected> get copyWith => _$ReminderStyleSelectedCopyWithImpl<ReminderStyleSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderStyleSelected&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle));
}


@override
int get hashCode => Object.hash(runtimeType,reminderStyle);

@override
String toString() {
  return 'OnboardingEvent.reminderStyleSelected(reminderStyle: $reminderStyle)';
}


}

/// @nodoc
abstract mixin class $ReminderStyleSelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $ReminderStyleSelectedCopyWith(ReminderStyleSelected value, $Res Function(ReminderStyleSelected) _then) = _$ReminderStyleSelectedCopyWithImpl;
@useResult
$Res call({
 ReminderStyle reminderStyle
});




}
/// @nodoc
class _$ReminderStyleSelectedCopyWithImpl<$Res>
    implements $ReminderStyleSelectedCopyWith<$Res> {
  _$ReminderStyleSelectedCopyWithImpl(this._self, this._then);

  final ReminderStyleSelected _self;
  final $Res Function(ReminderStyleSelected) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reminderStyle = null,}) {
  return _then(ReminderStyleSelected(
null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,
  ));
}


}

/// @nodoc


class MealCheckinScheduleModeChanged implements OnboardingEvent {
  const MealCheckinScheduleModeChanged(this.mealCheckinScheduleMode);
  

 final  MealCheckinScheduleMode mealCheckinScheduleMode;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealCheckinScheduleModeChangedCopyWith<MealCheckinScheduleModeChanged> get copyWith => _$MealCheckinScheduleModeChangedCopyWithImpl<MealCheckinScheduleModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealCheckinScheduleModeChanged&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode));
}


@override
int get hashCode => Object.hash(runtimeType,mealCheckinScheduleMode);

@override
String toString() {
  return 'OnboardingEvent.mealCheckinScheduleModeChanged(mealCheckinScheduleMode: $mealCheckinScheduleMode)';
}


}

/// @nodoc
abstract mixin class $MealCheckinScheduleModeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealCheckinScheduleModeChangedCopyWith(MealCheckinScheduleModeChanged value, $Res Function(MealCheckinScheduleModeChanged) _then) = _$MealCheckinScheduleModeChangedCopyWithImpl;
@useResult
$Res call({
 MealCheckinScheduleMode mealCheckinScheduleMode
});




}
/// @nodoc
class _$MealCheckinScheduleModeChangedCopyWithImpl<$Res>
    implements $MealCheckinScheduleModeChangedCopyWith<$Res> {
  _$MealCheckinScheduleModeChangedCopyWithImpl(this._self, this._then);

  final MealCheckinScheduleModeChanged _self;
  final $Res Function(MealCheckinScheduleModeChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealCheckinScheduleMode = null,}) {
  return _then(MealCheckinScheduleModeChanged(
null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,
  ));
}


}

/// @nodoc


class MealReminderToggled implements OnboardingEvent {
  const MealReminderToggled(this.mealOfTheDay, {required this.enabled});
  

 final  MealOfTheDay mealOfTheDay;
 final  bool enabled;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealReminderToggledCopyWith<MealReminderToggled> get copyWith => _$MealReminderToggledCopyWithImpl<MealReminderToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminderToggled&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,enabled);

@override
String toString() {
  return 'OnboardingEvent.mealReminderToggled(mealOfTheDay: $mealOfTheDay, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $MealReminderToggledCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealReminderToggledCopyWith(MealReminderToggled value, $Res Function(MealReminderToggled) _then) = _$MealReminderToggledCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, bool enabled
});




}
/// @nodoc
class _$MealReminderToggledCopyWithImpl<$Res>
    implements $MealReminderToggledCopyWith<$Res> {
  _$MealReminderToggledCopyWithImpl(this._self, this._then);

  final MealReminderToggled _self;
  final $Res Function(MealReminderToggled) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? enabled = null,}) {
  return _then(MealReminderToggled(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MealReminderTimeChanged implements OnboardingEvent {
  const MealReminderTimeChanged(this.mealOfTheDay, this.timeOfDay);
  

 final  MealOfTheDay mealOfTheDay;
 final  TimeOfDay timeOfDay;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealReminderTimeChangedCopyWith<MealReminderTimeChanged> get copyWith => _$MealReminderTimeChangedCopyWithImpl<MealReminderTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminderTimeChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,timeOfDay);

@override
String toString() {
  return 'OnboardingEvent.mealReminderTimeChanged(mealOfTheDay: $mealOfTheDay, timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $MealReminderTimeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealReminderTimeChangedCopyWith(MealReminderTimeChanged value, $Res Function(MealReminderTimeChanged) _then) = _$MealReminderTimeChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, TimeOfDay timeOfDay
});




}
/// @nodoc
class _$MealReminderTimeChangedCopyWithImpl<$Res>
    implements $MealReminderTimeChangedCopyWith<$Res> {
  _$MealReminderTimeChangedCopyWithImpl(this._self, this._then);

  final MealReminderTimeChanged _self;
  final $Res Function(MealReminderTimeChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? timeOfDay = null,}) {
  return _then(MealReminderTimeChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class EndOfDayTimeChanged implements OnboardingEvent {
  const EndOfDayTimeChanged(this.timeOfDay);
  

 final  TimeOfDay timeOfDay;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndOfDayTimeChangedCopyWith<EndOfDayTimeChanged> get copyWith => _$EndOfDayTimeChangedCopyWithImpl<EndOfDayTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndOfDayTimeChanged&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,timeOfDay);

@override
String toString() {
  return 'OnboardingEvent.endOfDayTimeChanged(timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $EndOfDayTimeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $EndOfDayTimeChangedCopyWith(EndOfDayTimeChanged value, $Res Function(EndOfDayTimeChanged) _then) = _$EndOfDayTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay timeOfDay
});




}
/// @nodoc
class _$EndOfDayTimeChangedCopyWithImpl<$Res>
    implements $EndOfDayTimeChangedCopyWith<$Res> {
  _$EndOfDayTimeChangedCopyWithImpl(this._self, this._then);

  final EndOfDayTimeChanged _self;
  final $Res Function(EndOfDayTimeChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? timeOfDay = null,}) {
  return _then(EndOfDayTimeChanged(
null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SkipLoggedMealRemindersChanged implements OnboardingEvent {
  const SkipLoggedMealRemindersChanged({required this.skipLoggedMealReminders});
  

 final  bool skipLoggedMealReminders;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SkipLoggedMealRemindersChangedCopyWith<SkipLoggedMealRemindersChanged> get copyWith => _$SkipLoggedMealRemindersChangedCopyWithImpl<SkipLoggedMealRemindersChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SkipLoggedMealRemindersChanged&&(identical(other.skipLoggedMealReminders, skipLoggedMealReminders) || other.skipLoggedMealReminders == skipLoggedMealReminders));
}


@override
int get hashCode => Object.hash(runtimeType,skipLoggedMealReminders);

@override
String toString() {
  return 'OnboardingEvent.skipLoggedMealRemindersChanged(skipLoggedMealReminders: $skipLoggedMealReminders)';
}


}

/// @nodoc
abstract mixin class $SkipLoggedMealRemindersChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $SkipLoggedMealRemindersChangedCopyWith(SkipLoggedMealRemindersChanged value, $Res Function(SkipLoggedMealRemindersChanged) _then) = _$SkipLoggedMealRemindersChangedCopyWithImpl;
@useResult
$Res call({
 bool skipLoggedMealReminders
});




}
/// @nodoc
class _$SkipLoggedMealRemindersChangedCopyWithImpl<$Res>
    implements $SkipLoggedMealRemindersChangedCopyWith<$Res> {
  _$SkipLoggedMealRemindersChangedCopyWithImpl(this._self, this._then);

  final SkipLoggedMealRemindersChanged _self;
  final $Res Function(SkipLoggedMealRemindersChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? skipLoggedMealReminders = null,}) {
  return _then(SkipLoggedMealRemindersChanged(
skipLoggedMealReminders: null == skipLoggedMealReminders ? _self.skipLoggedMealReminders : skipLoggedMealReminders // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class WeightCheckinFrequencySelected implements OnboardingEvent {
  const WeightCheckinFrequencySelected(this.weightCheckinFrequency);
  

 final  WeightCheckinFrequency weightCheckinFrequency;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightCheckinFrequencySelectedCopyWith<WeightCheckinFrequencySelected> get copyWith => _$WeightCheckinFrequencySelectedCopyWithImpl<WeightCheckinFrequencySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightCheckinFrequencySelected&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency));
}


@override
int get hashCode => Object.hash(runtimeType,weightCheckinFrequency);

@override
String toString() {
  return 'OnboardingEvent.weightCheckinFrequencySelected(weightCheckinFrequency: $weightCheckinFrequency)';
}


}

/// @nodoc
abstract mixin class $WeightCheckinFrequencySelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightCheckinFrequencySelectedCopyWith(WeightCheckinFrequencySelected value, $Res Function(WeightCheckinFrequencySelected) _then) = _$WeightCheckinFrequencySelectedCopyWithImpl;
@useResult
$Res call({
 WeightCheckinFrequency weightCheckinFrequency
});




}
/// @nodoc
class _$WeightCheckinFrequencySelectedCopyWithImpl<$Res>
    implements $WeightCheckinFrequencySelectedCopyWith<$Res> {
  _$WeightCheckinFrequencySelectedCopyWithImpl(this._self, this._then);

  final WeightCheckinFrequencySelected _self;
  final $Res Function(WeightCheckinFrequencySelected) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightCheckinFrequency = null,}) {
  return _then(WeightCheckinFrequencySelected(
null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,
  ));
}


}

/// @nodoc


class WeightTimeOfDaySelected implements OnboardingEvent {
  const WeightTimeOfDaySelected(this.weightTimeOfDay);
  

 final  WeightTimeOfDay weightTimeOfDay;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightTimeOfDaySelectedCopyWith<WeightTimeOfDaySelected> get copyWith => _$WeightTimeOfDaySelectedCopyWithImpl<WeightTimeOfDaySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightTimeOfDaySelected&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,weightTimeOfDay);

@override
String toString() {
  return 'OnboardingEvent.weightTimeOfDaySelected(weightTimeOfDay: $weightTimeOfDay)';
}


}

/// @nodoc
abstract mixin class $WeightTimeOfDaySelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightTimeOfDaySelectedCopyWith(WeightTimeOfDaySelected value, $Res Function(WeightTimeOfDaySelected) _then) = _$WeightTimeOfDaySelectedCopyWithImpl;
@useResult
$Res call({
 WeightTimeOfDay weightTimeOfDay
});




}
/// @nodoc
class _$WeightTimeOfDaySelectedCopyWithImpl<$Res>
    implements $WeightTimeOfDaySelectedCopyWith<$Res> {
  _$WeightTimeOfDaySelectedCopyWithImpl(this._self, this._then);

  final WeightTimeOfDaySelected _self;
  final $Res Function(WeightTimeOfDaySelected) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightTimeOfDay = null,}) {
  return _then(WeightTimeOfDaySelected(
null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,
  ));
}


}

/// @nodoc


class WeightUnitSelected implements OnboardingEvent {
  const WeightUnitSelected(this.weightUnit);
  

 final  WeightUnit weightUnit;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightUnitSelectedCopyWith<WeightUnitSelected> get copyWith => _$WeightUnitSelectedCopyWithImpl<WeightUnitSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightUnitSelected&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weightUnit);

@override
String toString() {
  return 'OnboardingEvent.weightUnitSelected(weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $WeightUnitSelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightUnitSelectedCopyWith(WeightUnitSelected value, $Res Function(WeightUnitSelected) _then) = _$WeightUnitSelectedCopyWithImpl;
@useResult
$Res call({
 WeightUnit weightUnit
});




}
/// @nodoc
class _$WeightUnitSelectedCopyWithImpl<$Res>
    implements $WeightUnitSelectedCopyWith<$Res> {
  _$WeightUnitSelectedCopyWithImpl(this._self, this._then);

  final WeightUnitSelected _self;
  final $Res Function(WeightUnitSelected) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightUnit = null,}) {
  return _then(WeightUnitSelected(
null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class StartingWeightChanged implements OnboardingEvent {
  const StartingWeightChanged(this.weight);
  

 final  double? weight;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartingWeightChangedCopyWith<StartingWeightChanged> get copyWith => _$StartingWeightChangedCopyWithImpl<StartingWeightChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartingWeightChanged&&(identical(other.weight, weight) || other.weight == weight));
}


@override
int get hashCode => Object.hash(runtimeType,weight);

@override
String toString() {
  return 'OnboardingEvent.startingWeightChanged(weight: $weight)';
}


}

/// @nodoc
abstract mixin class $StartingWeightChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $StartingWeightChangedCopyWith(StartingWeightChanged value, $Res Function(StartingWeightChanged) _then) = _$StartingWeightChangedCopyWithImpl;
@useResult
$Res call({
 double? weight
});




}
/// @nodoc
class _$StartingWeightChangedCopyWithImpl<$Res>
    implements $StartingWeightChangedCopyWith<$Res> {
  _$StartingWeightChangedCopyWithImpl(this._self, this._then);

  final StartingWeightChanged _self;
  final $Res Function(StartingWeightChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weight = freezed,}) {
  return _then(StartingWeightChanged(
freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class CalorieGoalChanged implements OnboardingEvent {
  const CalorieGoalChanged(this.calorieGoal);
  

 final  int? calorieGoal;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalorieGoalChangedCopyWith<CalorieGoalChanged> get copyWith => _$CalorieGoalChangedCopyWithImpl<CalorieGoalChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalorieGoalChanged&&(identical(other.calorieGoal, calorieGoal) || other.calorieGoal == calorieGoal));
}


@override
int get hashCode => Object.hash(runtimeType,calorieGoal);

@override
String toString() {
  return 'OnboardingEvent.calorieGoalChanged(calorieGoal: $calorieGoal)';
}


}

/// @nodoc
abstract mixin class $CalorieGoalChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $CalorieGoalChangedCopyWith(CalorieGoalChanged value, $Res Function(CalorieGoalChanged) _then) = _$CalorieGoalChangedCopyWithImpl;
@useResult
$Res call({
 int? calorieGoal
});




}
/// @nodoc
class _$CalorieGoalChangedCopyWithImpl<$Res>
    implements $CalorieGoalChangedCopyWith<$Res> {
  _$CalorieGoalChangedCopyWithImpl(this._self, this._then);

  final CalorieGoalChanged _self;
  final $Res Function(CalorieGoalChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? calorieGoal = freezed,}) {
  return _then(CalorieGoalChanged(
freezed == calorieGoal ? _self.calorieGoal : calorieGoal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class WeightGoalChanged implements OnboardingEvent {
  const WeightGoalChanged(this.weightGoal);
  

 final  double? weightGoal;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightGoalChangedCopyWith<WeightGoalChanged> get copyWith => _$WeightGoalChangedCopyWithImpl<WeightGoalChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightGoalChanged&&(identical(other.weightGoal, weightGoal) || other.weightGoal == weightGoal));
}


@override
int get hashCode => Object.hash(runtimeType,weightGoal);

@override
String toString() {
  return 'OnboardingEvent.weightGoalChanged(weightGoal: $weightGoal)';
}


}

/// @nodoc
abstract mixin class $WeightGoalChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightGoalChangedCopyWith(WeightGoalChanged value, $Res Function(WeightGoalChanged) _then) = _$WeightGoalChangedCopyWithImpl;
@useResult
$Res call({
 double? weightGoal
});




}
/// @nodoc
class _$WeightGoalChangedCopyWithImpl<$Res>
    implements $WeightGoalChangedCopyWith<$Res> {
  _$WeightGoalChangedCopyWithImpl(this._self, this._then);

  final WeightGoalChanged _self;
  final $Res Function(WeightGoalChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weightGoal = freezed,}) {
  return _then(WeightGoalChanged(
freezed == weightGoal ? _self.weightGoal : weightGoal // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc


class FirstLogItemToggled implements OnboardingEvent {
  const FirstLogItemToggled(this.id);
  

 final  String id;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirstLogItemToggledCopyWith<FirstLogItemToggled> get copyWith => _$FirstLogItemToggledCopyWithImpl<FirstLogItemToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirstLogItemToggled&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'OnboardingEvent.firstLogItemToggled(id: $id)';
}


}

/// @nodoc
abstract mixin class $FirstLogItemToggledCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $FirstLogItemToggledCopyWith(FirstLogItemToggled value, $Res Function(FirstLogItemToggled) _then) = _$FirstLogItemToggledCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$FirstLogItemToggledCopyWithImpl<$Res>
    implements $FirstLogItemToggledCopyWith<$Res> {
  _$FirstLogItemToggledCopyWithImpl(this._self, this._then);

  final FirstLogItemToggled _self;
  final $Res Function(FirstLogItemToggled) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(FirstLogItemToggled(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class FirstLogItemQuantityChanged implements OnboardingEvent {
  const FirstLogItemQuantityChanged(this.id, this.quantity);
  

 final  String id;
 final  double quantity;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FirstLogItemQuantityChangedCopyWith<FirstLogItemQuantityChanged> get copyWith => _$FirstLogItemQuantityChangedCopyWithImpl<FirstLogItemQuantityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FirstLogItemQuantityChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity);

@override
String toString() {
  return 'OnboardingEvent.firstLogItemQuantityChanged(id: $id, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $FirstLogItemQuantityChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $FirstLogItemQuantityChangedCopyWith(FirstLogItemQuantityChanged value, $Res Function(FirstLogItemQuantityChanged) _then) = _$FirstLogItemQuantityChangedCopyWithImpl;
@useResult
$Res call({
 String id, double quantity
});




}
/// @nodoc
class _$FirstLogItemQuantityChangedCopyWithImpl<$Res>
    implements $FirstLogItemQuantityChangedCopyWith<$Res> {
  _$FirstLogItemQuantityChangedCopyWithImpl(this._self, this._then);

  final FirstLogItemQuantityChanged _self;
  final $Res Function(FirstLogItemQuantityChanged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,}) {
  return _then(FirstLogItemQuantityChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class SomethingElseLogged implements OnboardingEvent {
  const SomethingElseLogged(this.mealOfTheDay, this.name, {this.nutrition = const Nutrition(), this.quantity = 1});
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
@JsonKey() final  Nutrition nutrition;
@JsonKey() final  double quantity;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SomethingElseLoggedCopyWith<SomethingElseLogged> get copyWith => _$SomethingElseLoggedCopyWithImpl<SomethingElseLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SomethingElseLogged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,nutrition,quantity);

@override
String toString() {
  return 'OnboardingEvent.somethingElseLogged(mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $SomethingElseLoggedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $SomethingElseLoggedCopyWith(SomethingElseLogged value, $Res Function(SomethingElseLogged) _then) = _$SomethingElseLoggedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, double quantity
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$SomethingElseLoggedCopyWithImpl<$Res>
    implements $SomethingElseLoggedCopyWith<$Res> {
  _$SomethingElseLoggedCopyWithImpl(this._self, this._then);

  final SomethingElseLogged _self;
  final $Res Function(SomethingElseLogged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? quantity = null,}) {
  return _then(SomethingElseLogged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of OnboardingEvent
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
mixin _$OnboardingState {

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
 int get version;/// Position within [activeSteps], not a raw [OnboardingStep] index.
 int get activeStepIndex;/// Draft of the user's settings and usuals, committed to
/// [UserSettingsBloc] when onboarding completes.
 UserSettingsState get settings; List<String> get firstLogSelectedIds;/// How many of each selected first-log item the user had, keyed by usual
/// meal id. An item absent from the map defaults to one. Whole counts saved
/// by older versions read back fine, since json reads each value as a num.
 Map<String, double> get firstLogQuantities;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);

  /// Serializes this OnboardingState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.version, version) || other.version == version)&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.firstLogSelectedIds, firstLogSelectedIds)&&const DeepCollectionEquality().equals(other.firstLogQuantities, firstLogQuantities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,activeStepIndex,settings,const DeepCollectionEquality().hash(firstLogSelectedIds),const DeepCollectionEquality().hash(firstLogQuantities));

@override
String toString() {
  return 'OnboardingState(version: $version, activeStepIndex: $activeStepIndex, settings: $settings, firstLogSelectedIds: $firstLogSelectedIds, firstLogQuantities: $firstLogQuantities)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int version, int activeStepIndex, UserSettingsState settings, List<String> firstLogSelectedIds, Map<String, double> firstLogQuantities
});


$UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? activeStepIndex = null,Object? settings = null,Object? firstLogSelectedIds = null,Object? firstLogQuantities = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,firstLogSelectedIds: null == firstLogSelectedIds ? _self.firstLogSelectedIds : firstLogSelectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,firstLogQuantities: null == firstLogQuantities ? _self.firstLogQuantities : firstLogQuantities // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<$Res> get settings {
  
  return $UserSettingsStateCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds,  Map<String, double> firstLogQuantities)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.version,_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds,_that.firstLogQuantities);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds,  Map<String, double> firstLogQuantities)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.version,_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds,_that.firstLogQuantities);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds,  Map<String, double> firstLogQuantities)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.version,_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds,_that.firstLogQuantities);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnboardingState extends OnboardingState {
  const _OnboardingState({this.version = 1, this.activeStepIndex = 0, this.settings = const UserSettingsState(), final  List<String> firstLogSelectedIds = const <String>[], final  Map<String, double> firstLogQuantities = const <String, double>{}}): _firstLogSelectedIds = firstLogSelectedIds,_firstLogQuantities = firstLogQuantities,super._();
  factory _OnboardingState.fromJson(Map<String, dynamic> json) => _$OnboardingStateFromJson(json);

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
@override@JsonKey() final  int version;
/// Position within [activeSteps], not a raw [OnboardingStep] index.
@override@JsonKey() final  int activeStepIndex;
/// Draft of the user's settings and usuals, committed to
/// [UserSettingsBloc] when onboarding completes.
@override@JsonKey() final  UserSettingsState settings;
 final  List<String> _firstLogSelectedIds;
@override@JsonKey() List<String> get firstLogSelectedIds {
  if (_firstLogSelectedIds is EqualUnmodifiableListView) return _firstLogSelectedIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_firstLogSelectedIds);
}

/// How many of each selected first-log item the user had, keyed by usual
/// meal id. An item absent from the map defaults to one. Whole counts saved
/// by older versions read back fine, since json reads each value as a num.
 final  Map<String, double> _firstLogQuantities;
/// How many of each selected first-log item the user had, keyed by usual
/// meal id. An item absent from the map defaults to one. Whole counts saved
/// by older versions read back fine, since json reads each value as a num.
@override@JsonKey() Map<String, double> get firstLogQuantities {
  if (_firstLogQuantities is EqualUnmodifiableMapView) return _firstLogQuantities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_firstLogQuantities);
}


/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.version, version) || other.version == version)&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._firstLogSelectedIds, _firstLogSelectedIds)&&const DeepCollectionEquality().equals(other._firstLogQuantities, _firstLogQuantities));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,activeStepIndex,settings,const DeepCollectionEquality().hash(_firstLogSelectedIds),const DeepCollectionEquality().hash(_firstLogQuantities));

@override
String toString() {
  return 'OnboardingState(version: $version, activeStepIndex: $activeStepIndex, settings: $settings, firstLogSelectedIds: $firstLogSelectedIds, firstLogQuantities: $firstLogQuantities)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int version, int activeStepIndex, UserSettingsState settings, List<String> firstLogSelectedIds, Map<String, double> firstLogQuantities
});


@override $UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? activeStepIndex = null,Object? settings = null,Object? firstLogSelectedIds = null,Object? firstLogQuantities = null,}) {
  return _then(_OnboardingState(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,firstLogSelectedIds: null == firstLogSelectedIds ? _self._firstLogSelectedIds : firstLogSelectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,firstLogQuantities: null == firstLogQuantities ? _self._firstLogQuantities : firstLogQuantities // ignore: cast_nullable_to_non_nullable
as Map<String, double>,
  ));
}

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<$Res> get settings {
  
  return $UserSettingsStateCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
