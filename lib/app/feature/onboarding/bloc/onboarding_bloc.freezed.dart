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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BackPressed value)?  backPressed,TResult Function( ResetPressed value)?  resetPressed,TResult Function( SkipPressed value)?  skipPressed,TResult Function( ContinuePressed value)?  continuePressed,TResult Function( UsualAdded value)?  usualAdded,TResult Function( UsualRemoved value)?  usualRemoved,TResult Function( ReminderStyleSelected value)?  reminderStyleSelected,TResult Function( MealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult Function( MealReminderToggled value)?  mealReminderToggled,TResult Function( MealReminderTimeChanged value)?  mealReminderTimeChanged,TResult Function( EndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult Function( WeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult Function( WeightUnitSelected value)?  weightUnitSelected,TResult Function( StartingWeightChanged value)?  startingWeightChanged,TResult Function( FirstLogItemToggled value)?  firstLogItemToggled,TResult Function( SomethingElseLogged value)?  somethingElseLogged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed(_that);case ResetPressed() when resetPressed != null:
return resetPressed(_that);case SkipPressed() when skipPressed != null:
return skipPressed(_that);case ContinuePressed() when continuePressed != null:
return continuePressed(_that);case UsualAdded() when usualAdded != null:
return usualAdded(_that);case UsualRemoved() when usualRemoved != null:
return usualRemoved(_that);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that);case SomethingElseLogged() when somethingElseLogged != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BackPressed value)  backPressed,required TResult Function( ResetPressed value)  resetPressed,required TResult Function( SkipPressed value)  skipPressed,required TResult Function( ContinuePressed value)  continuePressed,required TResult Function( UsualAdded value)  usualAdded,required TResult Function( UsualRemoved value)  usualRemoved,required TResult Function( ReminderStyleSelected value)  reminderStyleSelected,required TResult Function( MealCheckinScheduleModeChanged value)  mealCheckinScheduleModeChanged,required TResult Function( MealReminderToggled value)  mealReminderToggled,required TResult Function( MealReminderTimeChanged value)  mealReminderTimeChanged,required TResult Function( EndOfDayTimeChanged value)  endOfDayTimeChanged,required TResult Function( WeightCheckinFrequencySelected value)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDaySelected value)  weightTimeOfDaySelected,required TResult Function( WeightUnitSelected value)  weightUnitSelected,required TResult Function( StartingWeightChanged value)  startingWeightChanged,required TResult Function( FirstLogItemToggled value)  firstLogItemToggled,required TResult Function( SomethingElseLogged value)  somethingElseLogged,}){
final _that = this;
switch (_that) {
case BackPressed():
return backPressed(_that);case ResetPressed():
return resetPressed(_that);case SkipPressed():
return skipPressed(_that);case ContinuePressed():
return continuePressed(_that);case UsualAdded():
return usualAdded(_that);case UsualRemoved():
return usualRemoved(_that);case ReminderStyleSelected():
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled():
return mealReminderToggled(_that);case MealReminderTimeChanged():
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged():
return endOfDayTimeChanged(_that);case WeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that);case WeightUnitSelected():
return weightUnitSelected(_that);case StartingWeightChanged():
return startingWeightChanged(_that);case FirstLogItemToggled():
return firstLogItemToggled(_that);case SomethingElseLogged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BackPressed value)?  backPressed,TResult? Function( ResetPressed value)?  resetPressed,TResult? Function( SkipPressed value)?  skipPressed,TResult? Function( ContinuePressed value)?  continuePressed,TResult? Function( UsualAdded value)?  usualAdded,TResult? Function( UsualRemoved value)?  usualRemoved,TResult? Function( ReminderStyleSelected value)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult? Function( MealReminderToggled value)?  mealReminderToggled,TResult? Function( MealReminderTimeChanged value)?  mealReminderTimeChanged,TResult? Function( EndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult? Function( WeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult? Function( WeightUnitSelected value)?  weightUnitSelected,TResult? Function( StartingWeightChanged value)?  startingWeightChanged,TResult? Function( FirstLogItemToggled value)?  firstLogItemToggled,TResult? Function( SomethingElseLogged value)?  somethingElseLogged,}){
final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed(_that);case ResetPressed() when resetPressed != null:
return resetPressed(_that);case SkipPressed() when skipPressed != null:
return skipPressed(_that);case ContinuePressed() when continuePressed != null:
return continuePressed(_that);case UsualAdded() when usualAdded != null:
return usualAdded(_that);case UsualRemoved() when usualRemoved != null:
return usualRemoved(_that);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that);case SomethingElseLogged() when somethingElseLogged != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  backPressed,TResult Function()?  resetPressed,TResult Function()?  skipPressed,TResult Function()?  continuePressed,TResult Function( MealOfTheDay meal,  String name)?  usualAdded,TResult Function( MealOfTheDay meal,  String id)?  usualRemoved,TResult Function( ReminderStyle style)?  reminderStyleSelected,TResult Function( MealCheckinScheduleMode mode)?  mealCheckinScheduleModeChanged,TResult Function( MealOfTheDay meal,  bool enabled)?  mealReminderToggled,TResult Function( MealOfTheDay meal,  TimeOfDay time)?  mealReminderTimeChanged,TResult Function( TimeOfDay time)?  endOfDayTimeChanged,TResult Function( WeightCheckinFrequency frequency)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDay timeOfDay)?  weightTimeOfDaySelected,TResult Function( WeightUnit unit)?  weightUnitSelected,TResult Function( double? weight)?  startingWeightChanged,TResult Function( String id)?  firstLogItemToggled,TResult Function( MealOfTheDay meal,  String name)?  somethingElseLogged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed();case ResetPressed() when resetPressed != null:
return resetPressed();case SkipPressed() when skipPressed != null:
return skipPressed();case ContinuePressed() when continuePressed != null:
return continuePressed();case UsualAdded() when usualAdded != null:
return usualAdded(_that.meal,_that.name);case UsualRemoved() when usualRemoved != null:
return usualRemoved(_that.meal,_that.id);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.style);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mode);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.meal,_that.enabled);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.meal,_that.time);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.time);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.frequency);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.timeOfDay);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.unit);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that.id);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that.meal,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  backPressed,required TResult Function()  resetPressed,required TResult Function()  skipPressed,required TResult Function()  continuePressed,required TResult Function( MealOfTheDay meal,  String name)  usualAdded,required TResult Function( MealOfTheDay meal,  String id)  usualRemoved,required TResult Function( ReminderStyle style)  reminderStyleSelected,required TResult Function( MealCheckinScheduleMode mode)  mealCheckinScheduleModeChanged,required TResult Function( MealOfTheDay meal,  bool enabled)  mealReminderToggled,required TResult Function( MealOfTheDay meal,  TimeOfDay time)  mealReminderTimeChanged,required TResult Function( TimeOfDay time)  endOfDayTimeChanged,required TResult Function( WeightCheckinFrequency frequency)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDay timeOfDay)  weightTimeOfDaySelected,required TResult Function( WeightUnit unit)  weightUnitSelected,required TResult Function( double? weight)  startingWeightChanged,required TResult Function( String id)  firstLogItemToggled,required TResult Function( MealOfTheDay meal,  String name)  somethingElseLogged,}) {final _that = this;
switch (_that) {
case BackPressed():
return backPressed();case ResetPressed():
return resetPressed();case SkipPressed():
return skipPressed();case ContinuePressed():
return continuePressed();case UsualAdded():
return usualAdded(_that.meal,_that.name);case UsualRemoved():
return usualRemoved(_that.meal,_that.id);case ReminderStyleSelected():
return reminderStyleSelected(_that.style);case MealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that.mode);case MealReminderToggled():
return mealReminderToggled(_that.meal,_that.enabled);case MealReminderTimeChanged():
return mealReminderTimeChanged(_that.meal,_that.time);case EndOfDayTimeChanged():
return endOfDayTimeChanged(_that.time);case WeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that.frequency);case WeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that.timeOfDay);case WeightUnitSelected():
return weightUnitSelected(_that.unit);case StartingWeightChanged():
return startingWeightChanged(_that.weight);case FirstLogItemToggled():
return firstLogItemToggled(_that.id);case SomethingElseLogged():
return somethingElseLogged(_that.meal,_that.name);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  backPressed,TResult? Function()?  resetPressed,TResult? Function()?  skipPressed,TResult? Function()?  continuePressed,TResult? Function( MealOfTheDay meal,  String name)?  usualAdded,TResult? Function( MealOfTheDay meal,  String id)?  usualRemoved,TResult? Function( ReminderStyle style)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleMode mode)?  mealCheckinScheduleModeChanged,TResult? Function( MealOfTheDay meal,  bool enabled)?  mealReminderToggled,TResult? Function( MealOfTheDay meal,  TimeOfDay time)?  mealReminderTimeChanged,TResult? Function( TimeOfDay time)?  endOfDayTimeChanged,TResult? Function( WeightCheckinFrequency frequency)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDay timeOfDay)?  weightTimeOfDaySelected,TResult? Function( WeightUnit unit)?  weightUnitSelected,TResult? Function( double? weight)?  startingWeightChanged,TResult? Function( String id)?  firstLogItemToggled,TResult? Function( MealOfTheDay meal,  String name)?  somethingElseLogged,}) {final _that = this;
switch (_that) {
case BackPressed() when backPressed != null:
return backPressed();case ResetPressed() when resetPressed != null:
return resetPressed();case SkipPressed() when skipPressed != null:
return skipPressed();case ContinuePressed() when continuePressed != null:
return continuePressed();case UsualAdded() when usualAdded != null:
return usualAdded(_that.meal,_that.name);case UsualRemoved() when usualRemoved != null:
return usualRemoved(_that.meal,_that.id);case ReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.style);case MealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mode);case MealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.meal,_that.enabled);case MealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.meal,_that.time);case EndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.time);case WeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.frequency);case WeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.timeOfDay);case WeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.unit);case StartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case FirstLogItemToggled() when firstLogItemToggled != null:
return firstLogItemToggled(_that.id);case SomethingElseLogged() when somethingElseLogged != null:
return somethingElseLogged(_that.meal,_that.name);case _:
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


class UsualAdded implements OnboardingEvent {
  const UsualAdded(this.meal, this.name);
  

 final  MealOfTheDay meal;
 final  String name;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualAddedCopyWith<UsualAdded> get copyWith => _$UsualAddedCopyWithImpl<UsualAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualAdded&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,meal,name);

@override
String toString() {
  return 'OnboardingEvent.usualAdded(meal: $meal, name: $name)';
}


}

/// @nodoc
abstract mixin class $UsualAddedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualAddedCopyWith(UsualAdded value, $Res Function(UsualAdded) _then) = _$UsualAddedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String name
});




}
/// @nodoc
class _$UsualAddedCopyWithImpl<$Res>
    implements $UsualAddedCopyWith<$Res> {
  _$UsualAddedCopyWithImpl(this._self, this._then);

  final UsualAdded _self;
  final $Res Function(UsualAdded) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? name = null,}) {
  return _then(UsualAdded(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UsualRemoved implements OnboardingEvent {
  const UsualRemoved(this.meal, this.id);
  

 final  MealOfTheDay meal;
 final  String id;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualRemovedCopyWith<UsualRemoved> get copyWith => _$UsualRemovedCopyWithImpl<UsualRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualRemoved&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,meal,id);

@override
String toString() {
  return 'OnboardingEvent.usualRemoved(meal: $meal, id: $id)';
}


}

/// @nodoc
abstract mixin class $UsualRemovedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $UsualRemovedCopyWith(UsualRemoved value, $Res Function(UsualRemoved) _then) = _$UsualRemovedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String id
});




}
/// @nodoc
class _$UsualRemovedCopyWithImpl<$Res>
    implements $UsualRemovedCopyWith<$Res> {
  _$UsualRemovedCopyWithImpl(this._self, this._then);

  final UsualRemoved _self;
  final $Res Function(UsualRemoved) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? id = null,}) {
  return _then(UsualRemoved(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ReminderStyleSelected implements OnboardingEvent {
  const ReminderStyleSelected(this.style);
  

 final  ReminderStyle style;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderStyleSelectedCopyWith<ReminderStyleSelected> get copyWith => _$ReminderStyleSelectedCopyWithImpl<ReminderStyleSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderStyleSelected&&(identical(other.style, style) || other.style == style));
}


@override
int get hashCode => Object.hash(runtimeType,style);

@override
String toString() {
  return 'OnboardingEvent.reminderStyleSelected(style: $style)';
}


}

/// @nodoc
abstract mixin class $ReminderStyleSelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $ReminderStyleSelectedCopyWith(ReminderStyleSelected value, $Res Function(ReminderStyleSelected) _then) = _$ReminderStyleSelectedCopyWithImpl;
@useResult
$Res call({
 ReminderStyle style
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
@pragma('vm:prefer-inline') $Res call({Object? style = null,}) {
  return _then(ReminderStyleSelected(
null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as ReminderStyle,
  ));
}


}

/// @nodoc


class MealCheckinScheduleModeChanged implements OnboardingEvent {
  const MealCheckinScheduleModeChanged(this.mode);
  

 final  MealCheckinScheduleMode mode;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealCheckinScheduleModeChangedCopyWith<MealCheckinScheduleModeChanged> get copyWith => _$MealCheckinScheduleModeChangedCopyWithImpl<MealCheckinScheduleModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealCheckinScheduleModeChanged&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'OnboardingEvent.mealCheckinScheduleModeChanged(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $MealCheckinScheduleModeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealCheckinScheduleModeChangedCopyWith(MealCheckinScheduleModeChanged value, $Res Function(MealCheckinScheduleModeChanged) _then) = _$MealCheckinScheduleModeChangedCopyWithImpl;
@useResult
$Res call({
 MealCheckinScheduleMode mode
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
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(MealCheckinScheduleModeChanged(
null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,
  ));
}


}

/// @nodoc


class MealReminderToggled implements OnboardingEvent {
  const MealReminderToggled(this.meal, {required this.enabled});
  

 final  MealOfTheDay meal;
 final  bool enabled;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealReminderToggledCopyWith<MealReminderToggled> get copyWith => _$MealReminderToggledCopyWithImpl<MealReminderToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminderToggled&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,meal,enabled);

@override
String toString() {
  return 'OnboardingEvent.mealReminderToggled(meal: $meal, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $MealReminderToggledCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealReminderToggledCopyWith(MealReminderToggled value, $Res Function(MealReminderToggled) _then) = _$MealReminderToggledCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, bool enabled
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
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? enabled = null,}) {
  return _then(MealReminderToggled(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MealReminderTimeChanged implements OnboardingEvent {
  const MealReminderTimeChanged(this.meal, this.time);
  

 final  MealOfTheDay meal;
 final  TimeOfDay time;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealReminderTimeChangedCopyWith<MealReminderTimeChanged> get copyWith => _$MealReminderTimeChangedCopyWithImpl<MealReminderTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminderTimeChanged&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,meal,time);

@override
String toString() {
  return 'OnboardingEvent.mealReminderTimeChanged(meal: $meal, time: $time)';
}


}

/// @nodoc
abstract mixin class $MealReminderTimeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $MealReminderTimeChangedCopyWith(MealReminderTimeChanged value, $Res Function(MealReminderTimeChanged) _then) = _$MealReminderTimeChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, TimeOfDay time
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
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? time = null,}) {
  return _then(MealReminderTimeChanged(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class EndOfDayTimeChanged implements OnboardingEvent {
  const EndOfDayTimeChanged(this.time);
  

 final  TimeOfDay time;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndOfDayTimeChangedCopyWith<EndOfDayTimeChanged> get copyWith => _$EndOfDayTimeChangedCopyWithImpl<EndOfDayTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndOfDayTimeChanged&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,time);

@override
String toString() {
  return 'OnboardingEvent.endOfDayTimeChanged(time: $time)';
}


}

/// @nodoc
abstract mixin class $EndOfDayTimeChangedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $EndOfDayTimeChangedCopyWith(EndOfDayTimeChanged value, $Res Function(EndOfDayTimeChanged) _then) = _$EndOfDayTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay time
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
@pragma('vm:prefer-inline') $Res call({Object? time = null,}) {
  return _then(EndOfDayTimeChanged(
null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class WeightCheckinFrequencySelected implements OnboardingEvent {
  const WeightCheckinFrequencySelected(this.frequency);
  

 final  WeightCheckinFrequency frequency;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightCheckinFrequencySelectedCopyWith<WeightCheckinFrequencySelected> get copyWith => _$WeightCheckinFrequencySelectedCopyWithImpl<WeightCheckinFrequencySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightCheckinFrequencySelected&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,frequency);

@override
String toString() {
  return 'OnboardingEvent.weightCheckinFrequencySelected(frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class $WeightCheckinFrequencySelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightCheckinFrequencySelectedCopyWith(WeightCheckinFrequencySelected value, $Res Function(WeightCheckinFrequencySelected) _then) = _$WeightCheckinFrequencySelectedCopyWithImpl;
@useResult
$Res call({
 WeightCheckinFrequency frequency
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
@pragma('vm:prefer-inline') $Res call({Object? frequency = null,}) {
  return _then(WeightCheckinFrequencySelected(
null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,
  ));
}


}

/// @nodoc


class WeightTimeOfDaySelected implements OnboardingEvent {
  const WeightTimeOfDaySelected(this.timeOfDay);
  

 final  WeightTimeOfDay timeOfDay;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightTimeOfDaySelectedCopyWith<WeightTimeOfDaySelected> get copyWith => _$WeightTimeOfDaySelectedCopyWithImpl<WeightTimeOfDaySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightTimeOfDaySelected&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,timeOfDay);

@override
String toString() {
  return 'OnboardingEvent.weightTimeOfDaySelected(timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $WeightTimeOfDaySelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightTimeOfDaySelectedCopyWith(WeightTimeOfDaySelected value, $Res Function(WeightTimeOfDaySelected) _then) = _$WeightTimeOfDaySelectedCopyWithImpl;
@useResult
$Res call({
 WeightTimeOfDay timeOfDay
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
@pragma('vm:prefer-inline') $Res call({Object? timeOfDay = null,}) {
  return _then(WeightTimeOfDaySelected(
null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,
  ));
}


}

/// @nodoc


class WeightUnitSelected implements OnboardingEvent {
  const WeightUnitSelected(this.unit);
  

 final  WeightUnit unit;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightUnitSelectedCopyWith<WeightUnitSelected> get copyWith => _$WeightUnitSelectedCopyWithImpl<WeightUnitSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightUnitSelected&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,unit);

@override
String toString() {
  return 'OnboardingEvent.weightUnitSelected(unit: $unit)';
}


}

/// @nodoc
abstract mixin class $WeightUnitSelectedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $WeightUnitSelectedCopyWith(WeightUnitSelected value, $Res Function(WeightUnitSelected) _then) = _$WeightUnitSelectedCopyWithImpl;
@useResult
$Res call({
 WeightUnit unit
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
@pragma('vm:prefer-inline') $Res call({Object? unit = null,}) {
  return _then(WeightUnitSelected(
null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
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


class SomethingElseLogged implements OnboardingEvent {
  const SomethingElseLogged(this.meal, this.name);
  

 final  MealOfTheDay meal;
 final  String name;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SomethingElseLoggedCopyWith<SomethingElseLogged> get copyWith => _$SomethingElseLoggedCopyWithImpl<SomethingElseLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SomethingElseLogged&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,meal,name);

@override
String toString() {
  return 'OnboardingEvent.somethingElseLogged(meal: $meal, name: $name)';
}


}

/// @nodoc
abstract mixin class $SomethingElseLoggedCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory $SomethingElseLoggedCopyWith(SomethingElseLogged value, $Res Function(SomethingElseLogged) _then) = _$SomethingElseLoggedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String name
});




}
/// @nodoc
class _$SomethingElseLoggedCopyWithImpl<$Res>
    implements $SomethingElseLoggedCopyWith<$Res> {
  _$SomethingElseLoggedCopyWithImpl(this._self, this._then);

  final SomethingElseLogged _self;
  final $Res Function(SomethingElseLogged) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? name = null,}) {
  return _then(SomethingElseLogged(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OnboardingState {

/// Position within [activeSteps], not a raw [OnboardingStep] index.
 int get activeStepIndex;/// Draft of the user's settings and usuals, committed to
/// [UserSettingsBloc] when onboarding completes.
 UserSettingsState get settings; List<String> get firstLogSelectedIds;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);

  /// Serializes this OnboardingState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.firstLogSelectedIds, firstLogSelectedIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeStepIndex,settings,const DeepCollectionEquality().hash(firstLogSelectedIds));

@override
String toString() {
  return 'OnboardingState(activeStepIndex: $activeStepIndex, settings: $settings, firstLogSelectedIds: $firstLogSelectedIds)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 int activeStepIndex, UserSettingsState settings, List<String> firstLogSelectedIds
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
@pragma('vm:prefer-inline') @override $Res call({Object? activeStepIndex = null,Object? settings = null,Object? firstLogSelectedIds = null,}) {
  return _then(_self.copyWith(
activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,firstLogSelectedIds: null == firstLogSelectedIds ? _self.firstLogSelectedIds : firstLogSelectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activeStepIndex,  UserSettingsState settings,  List<String> firstLogSelectedIds)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.activeStepIndex,_that.settings,_that.firstLogSelectedIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _OnboardingState extends OnboardingState {
  const _OnboardingState({this.activeStepIndex = 0, this.settings = const UserSettingsState(), final  List<String> firstLogSelectedIds = const <String>[]}): _firstLogSelectedIds = firstLogSelectedIds,super._();
  factory _OnboardingState.fromJson(Map<String, dynamic> json) => _$OnboardingStateFromJson(json);

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.activeStepIndex, activeStepIndex) || other.activeStepIndex == activeStepIndex)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._firstLogSelectedIds, _firstLogSelectedIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activeStepIndex,settings,const DeepCollectionEquality().hash(_firstLogSelectedIds));

@override
String toString() {
  return 'OnboardingState(activeStepIndex: $activeStepIndex, settings: $settings, firstLogSelectedIds: $firstLogSelectedIds)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 int activeStepIndex, UserSettingsState settings, List<String> firstLogSelectedIds
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
@override @pragma('vm:prefer-inline') $Res call({Object? activeStepIndex = null,Object? settings = null,Object? firstLogSelectedIds = null,}) {
  return _then(_OnboardingState(
activeStepIndex: null == activeStepIndex ? _self.activeStepIndex : activeStepIndex // ignore: cast_nullable_to_non_nullable
as int,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UserSettingsState,firstLogSelectedIds: null == firstLogSelectedIds ? _self._firstLogSelectedIds : firstLogSelectedIds // ignore: cast_nullable_to_non_nullable
as List<String>,
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
