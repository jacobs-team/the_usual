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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsCommitted value)?  settingsCommitted,TResult Function( SettingsReminderStyleSelected value)?  reminderStyleSelected,TResult Function( SettingsMealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult Function( SettingsMealReminderToggled value)?  mealReminderToggled,TResult Function( SettingsMealReminderTimeChanged value)?  mealReminderTimeChanged,TResult Function( SettingsEndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult Function( SettingsWeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult Function( SettingsWeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult Function( SettingsWeightUnitSelected value)?  weightUnitSelected,TResult Function( SettingsStartingWeightChanged value)?  startingWeightChanged,TResult Function( SettingsUsualAdded value)?  usualAdded,TResult Function( SettingsUsualRemoved value)?  usualRemoved,TResult Function( SettingsUsualCaloriesChanged value)?  usualCaloriesChanged,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case SettingsUsualAdded() when usualAdded != null:
return usualAdded(_that);case SettingsUsualRemoved() when usualRemoved != null:
return usualRemoved(_that);case SettingsUsualCaloriesChanged() when usualCaloriesChanged != null:
return usualCaloriesChanged(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsCommitted value)  settingsCommitted,required TResult Function( SettingsReminderStyleSelected value)  reminderStyleSelected,required TResult Function( SettingsMealCheckinScheduleModeChanged value)  mealCheckinScheduleModeChanged,required TResult Function( SettingsMealReminderToggled value)  mealReminderToggled,required TResult Function( SettingsMealReminderTimeChanged value)  mealReminderTimeChanged,required TResult Function( SettingsEndOfDayTimeChanged value)  endOfDayTimeChanged,required TResult Function( SettingsWeightCheckinFrequencySelected value)  weightCheckinFrequencySelected,required TResult Function( SettingsWeightTimeOfDaySelected value)  weightTimeOfDaySelected,required TResult Function( SettingsWeightUnitSelected value)  weightUnitSelected,required TResult Function( SettingsStartingWeightChanged value)  startingWeightChanged,required TResult Function( SettingsUsualAdded value)  usualAdded,required TResult Function( SettingsUsualRemoved value)  usualRemoved,required TResult Function( SettingsUsualCaloriesChanged value)  usualCaloriesChanged,}){
final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that);case SettingsReminderStyleSelected():
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled():
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged():
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged():
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected():
return weightUnitSelected(_that);case SettingsStartingWeightChanged():
return startingWeightChanged(_that);case SettingsUsualAdded():
return usualAdded(_that);case SettingsUsualRemoved():
return usualRemoved(_that);case SettingsUsualCaloriesChanged():
return usualCaloriesChanged(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsCommitted value)?  settingsCommitted,TResult? Function( SettingsReminderStyleSelected value)?  reminderStyleSelected,TResult? Function( SettingsMealCheckinScheduleModeChanged value)?  mealCheckinScheduleModeChanged,TResult? Function( SettingsMealReminderToggled value)?  mealReminderToggled,TResult? Function( SettingsMealReminderTimeChanged value)?  mealReminderTimeChanged,TResult? Function( SettingsEndOfDayTimeChanged value)?  endOfDayTimeChanged,TResult? Function( SettingsWeightCheckinFrequencySelected value)?  weightCheckinFrequencySelected,TResult? Function( SettingsWeightTimeOfDaySelected value)?  weightTimeOfDaySelected,TResult? Function( SettingsWeightUnitSelected value)?  weightUnitSelected,TResult? Function( SettingsStartingWeightChanged value)?  startingWeightChanged,TResult? Function( SettingsUsualAdded value)?  usualAdded,TResult? Function( SettingsUsualRemoved value)?  usualRemoved,TResult? Function( SettingsUsualCaloriesChanged value)?  usualCaloriesChanged,}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that);case SettingsUsualAdded() when usualAdded != null:
return usualAdded(_that);case SettingsUsualRemoved() when usualRemoved != null:
return usualRemoved(_that);case SettingsUsualCaloriesChanged() when usualCaloriesChanged != null:
return usualCaloriesChanged(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UserSettingsState settings)?  settingsCommitted,TResult Function( ReminderStyle style)?  reminderStyleSelected,TResult Function( MealCheckinScheduleMode mode)?  mealCheckinScheduleModeChanged,TResult Function( MealOfTheDay meal,  bool enabled)?  mealReminderToggled,TResult Function( MealOfTheDay meal,  TimeOfDay time)?  mealReminderTimeChanged,TResult Function( TimeOfDay time)?  endOfDayTimeChanged,TResult Function( WeightCheckinFrequency frequency)?  weightCheckinFrequencySelected,TResult Function( WeightTimeOfDay timeOfDay)?  weightTimeOfDaySelected,TResult Function( WeightUnit unit)?  weightUnitSelected,TResult Function( double? weight)?  startingWeightChanged,TResult Function( MealOfTheDay meal,  String name,  int? calories)?  usualAdded,TResult Function( MealOfTheDay meal,  String id)?  usualRemoved,TResult Function( MealOfTheDay meal,  String id,  int? calories)?  usualCaloriesChanged,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.style);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mode);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.meal,_that.enabled);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.meal,_that.time);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.time);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.frequency);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.timeOfDay);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.unit);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case SettingsUsualAdded() when usualAdded != null:
return usualAdded(_that.meal,_that.name,_that.calories);case SettingsUsualRemoved() when usualRemoved != null:
return usualRemoved(_that.meal,_that.id);case SettingsUsualCaloriesChanged() when usualCaloriesChanged != null:
return usualCaloriesChanged(_that.meal,_that.id,_that.calories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UserSettingsState settings)  settingsCommitted,required TResult Function( ReminderStyle style)  reminderStyleSelected,required TResult Function( MealCheckinScheduleMode mode)  mealCheckinScheduleModeChanged,required TResult Function( MealOfTheDay meal,  bool enabled)  mealReminderToggled,required TResult Function( MealOfTheDay meal,  TimeOfDay time)  mealReminderTimeChanged,required TResult Function( TimeOfDay time)  endOfDayTimeChanged,required TResult Function( WeightCheckinFrequency frequency)  weightCheckinFrequencySelected,required TResult Function( WeightTimeOfDay timeOfDay)  weightTimeOfDaySelected,required TResult Function( WeightUnit unit)  weightUnitSelected,required TResult Function( double? weight)  startingWeightChanged,required TResult Function( MealOfTheDay meal,  String name,  int? calories)  usualAdded,required TResult Function( MealOfTheDay meal,  String id)  usualRemoved,required TResult Function( MealOfTheDay meal,  String id,  int? calories)  usualCaloriesChanged,}) {final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that.settings);case SettingsReminderStyleSelected():
return reminderStyleSelected(_that.style);case SettingsMealCheckinScheduleModeChanged():
return mealCheckinScheduleModeChanged(_that.mode);case SettingsMealReminderToggled():
return mealReminderToggled(_that.meal,_that.enabled);case SettingsMealReminderTimeChanged():
return mealReminderTimeChanged(_that.meal,_that.time);case SettingsEndOfDayTimeChanged():
return endOfDayTimeChanged(_that.time);case SettingsWeightCheckinFrequencySelected():
return weightCheckinFrequencySelected(_that.frequency);case SettingsWeightTimeOfDaySelected():
return weightTimeOfDaySelected(_that.timeOfDay);case SettingsWeightUnitSelected():
return weightUnitSelected(_that.unit);case SettingsStartingWeightChanged():
return startingWeightChanged(_that.weight);case SettingsUsualAdded():
return usualAdded(_that.meal,_that.name,_that.calories);case SettingsUsualRemoved():
return usualRemoved(_that.meal,_that.id);case SettingsUsualCaloriesChanged():
return usualCaloriesChanged(_that.meal,_that.id,_that.calories);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UserSettingsState settings)?  settingsCommitted,TResult? Function( ReminderStyle style)?  reminderStyleSelected,TResult? Function( MealCheckinScheduleMode mode)?  mealCheckinScheduleModeChanged,TResult? Function( MealOfTheDay meal,  bool enabled)?  mealReminderToggled,TResult? Function( MealOfTheDay meal,  TimeOfDay time)?  mealReminderTimeChanged,TResult? Function( TimeOfDay time)?  endOfDayTimeChanged,TResult? Function( WeightCheckinFrequency frequency)?  weightCheckinFrequencySelected,TResult? Function( WeightTimeOfDay timeOfDay)?  weightTimeOfDaySelected,TResult? Function( WeightUnit unit)?  weightUnitSelected,TResult? Function( double? weight)?  startingWeightChanged,TResult? Function( MealOfTheDay meal,  String name,  int? calories)?  usualAdded,TResult? Function( MealOfTheDay meal,  String id)?  usualRemoved,TResult? Function( MealOfTheDay meal,  String id,  int? calories)?  usualCaloriesChanged,}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case SettingsReminderStyleSelected() when reminderStyleSelected != null:
return reminderStyleSelected(_that.style);case SettingsMealCheckinScheduleModeChanged() when mealCheckinScheduleModeChanged != null:
return mealCheckinScheduleModeChanged(_that.mode);case SettingsMealReminderToggled() when mealReminderToggled != null:
return mealReminderToggled(_that.meal,_that.enabled);case SettingsMealReminderTimeChanged() when mealReminderTimeChanged != null:
return mealReminderTimeChanged(_that.meal,_that.time);case SettingsEndOfDayTimeChanged() when endOfDayTimeChanged != null:
return endOfDayTimeChanged(_that.time);case SettingsWeightCheckinFrequencySelected() when weightCheckinFrequencySelected != null:
return weightCheckinFrequencySelected(_that.frequency);case SettingsWeightTimeOfDaySelected() when weightTimeOfDaySelected != null:
return weightTimeOfDaySelected(_that.timeOfDay);case SettingsWeightUnitSelected() when weightUnitSelected != null:
return weightUnitSelected(_that.unit);case SettingsStartingWeightChanged() when startingWeightChanged != null:
return startingWeightChanged(_that.weight);case SettingsUsualAdded() when usualAdded != null:
return usualAdded(_that.meal,_that.name,_that.calories);case SettingsUsualRemoved() when usualRemoved != null:
return usualRemoved(_that.meal,_that.id);case SettingsUsualCaloriesChanged() when usualCaloriesChanged != null:
return usualCaloriesChanged(_that.meal,_that.id,_that.calories);case _:
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


class SettingsReminderStyleSelected implements UserSettingsEvent {
  const SettingsReminderStyleSelected(this.style);
  

 final  ReminderStyle style;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsReminderStyleSelectedCopyWith<SettingsReminderStyleSelected> get copyWith => _$SettingsReminderStyleSelectedCopyWithImpl<SettingsReminderStyleSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsReminderStyleSelected&&(identical(other.style, style) || other.style == style));
}


@override
int get hashCode => Object.hash(runtimeType,style);

@override
String toString() {
  return 'UserSettingsEvent.reminderStyleSelected(style: $style)';
}


}

/// @nodoc
abstract mixin class $SettingsReminderStyleSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsReminderStyleSelectedCopyWith(SettingsReminderStyleSelected value, $Res Function(SettingsReminderStyleSelected) _then) = _$SettingsReminderStyleSelectedCopyWithImpl;
@useResult
$Res call({
 ReminderStyle style
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
@pragma('vm:prefer-inline') $Res call({Object? style = null,}) {
  return _then(SettingsReminderStyleSelected(
null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as ReminderStyle,
  ));
}


}

/// @nodoc


class SettingsMealCheckinScheduleModeChanged implements UserSettingsEvent {
  const SettingsMealCheckinScheduleModeChanged(this.mode);
  

 final  MealCheckinScheduleMode mode;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealCheckinScheduleModeChangedCopyWith<SettingsMealCheckinScheduleModeChanged> get copyWith => _$SettingsMealCheckinScheduleModeChangedCopyWithImpl<SettingsMealCheckinScheduleModeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealCheckinScheduleModeChanged&&(identical(other.mode, mode) || other.mode == mode));
}


@override
int get hashCode => Object.hash(runtimeType,mode);

@override
String toString() {
  return 'UserSettingsEvent.mealCheckinScheduleModeChanged(mode: $mode)';
}


}

/// @nodoc
abstract mixin class $SettingsMealCheckinScheduleModeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealCheckinScheduleModeChangedCopyWith(SettingsMealCheckinScheduleModeChanged value, $Res Function(SettingsMealCheckinScheduleModeChanged) _then) = _$SettingsMealCheckinScheduleModeChangedCopyWithImpl;
@useResult
$Res call({
 MealCheckinScheduleMode mode
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
@pragma('vm:prefer-inline') $Res call({Object? mode = null,}) {
  return _then(SettingsMealCheckinScheduleModeChanged(
null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,
  ));
}


}

/// @nodoc


class SettingsMealReminderToggled implements UserSettingsEvent {
  const SettingsMealReminderToggled(this.meal, {required this.enabled});
  

 final  MealOfTheDay meal;
 final  bool enabled;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealReminderToggledCopyWith<SettingsMealReminderToggled> get copyWith => _$SettingsMealReminderToggledCopyWithImpl<SettingsMealReminderToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealReminderToggled&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,meal,enabled);

@override
String toString() {
  return 'UserSettingsEvent.mealReminderToggled(meal: $meal, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $SettingsMealReminderToggledCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealReminderToggledCopyWith(SettingsMealReminderToggled value, $Res Function(SettingsMealReminderToggled) _then) = _$SettingsMealReminderToggledCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, bool enabled
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
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? enabled = null,}) {
  return _then(SettingsMealReminderToggled(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class SettingsMealReminderTimeChanged implements UserSettingsEvent {
  const SettingsMealReminderTimeChanged(this.meal, this.time);
  

 final  MealOfTheDay meal;
 final  TimeOfDay time;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsMealReminderTimeChangedCopyWith<SettingsMealReminderTimeChanged> get copyWith => _$SettingsMealReminderTimeChangedCopyWithImpl<SettingsMealReminderTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsMealReminderTimeChanged&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,meal,time);

@override
String toString() {
  return 'UserSettingsEvent.mealReminderTimeChanged(meal: $meal, time: $time)';
}


}

/// @nodoc
abstract mixin class $SettingsMealReminderTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsMealReminderTimeChangedCopyWith(SettingsMealReminderTimeChanged value, $Res Function(SettingsMealReminderTimeChanged) _then) = _$SettingsMealReminderTimeChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, TimeOfDay time
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
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? time = null,}) {
  return _then(SettingsMealReminderTimeChanged(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsEndOfDayTimeChanged implements UserSettingsEvent {
  const SettingsEndOfDayTimeChanged(this.time);
  

 final  TimeOfDay time;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsEndOfDayTimeChangedCopyWith<SettingsEndOfDayTimeChanged> get copyWith => _$SettingsEndOfDayTimeChangedCopyWithImpl<SettingsEndOfDayTimeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEndOfDayTimeChanged&&(identical(other.time, time) || other.time == time));
}


@override
int get hashCode => Object.hash(runtimeType,time);

@override
String toString() {
  return 'UserSettingsEvent.endOfDayTimeChanged(time: $time)';
}


}

/// @nodoc
abstract mixin class $SettingsEndOfDayTimeChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsEndOfDayTimeChangedCopyWith(SettingsEndOfDayTimeChanged value, $Res Function(SettingsEndOfDayTimeChanged) _then) = _$SettingsEndOfDayTimeChangedCopyWithImpl;
@useResult
$Res call({
 TimeOfDay time
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
@pragma('vm:prefer-inline') $Res call({Object? time = null,}) {
  return _then(SettingsEndOfDayTimeChanged(
null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class SettingsWeightCheckinFrequencySelected implements UserSettingsEvent {
  const SettingsWeightCheckinFrequencySelected(this.frequency);
  

 final  WeightCheckinFrequency frequency;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightCheckinFrequencySelectedCopyWith<SettingsWeightCheckinFrequencySelected> get copyWith => _$SettingsWeightCheckinFrequencySelectedCopyWithImpl<SettingsWeightCheckinFrequencySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightCheckinFrequencySelected&&(identical(other.frequency, frequency) || other.frequency == frequency));
}


@override
int get hashCode => Object.hash(runtimeType,frequency);

@override
String toString() {
  return 'UserSettingsEvent.weightCheckinFrequencySelected(frequency: $frequency)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightCheckinFrequencySelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightCheckinFrequencySelectedCopyWith(SettingsWeightCheckinFrequencySelected value, $Res Function(SettingsWeightCheckinFrequencySelected) _then) = _$SettingsWeightCheckinFrequencySelectedCopyWithImpl;
@useResult
$Res call({
 WeightCheckinFrequency frequency
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
@pragma('vm:prefer-inline') $Res call({Object? frequency = null,}) {
  return _then(SettingsWeightCheckinFrequencySelected(
null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,
  ));
}


}

/// @nodoc


class SettingsWeightTimeOfDaySelected implements UserSettingsEvent {
  const SettingsWeightTimeOfDaySelected(this.timeOfDay);
  

 final  WeightTimeOfDay timeOfDay;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightTimeOfDaySelectedCopyWith<SettingsWeightTimeOfDaySelected> get copyWith => _$SettingsWeightTimeOfDaySelectedCopyWithImpl<SettingsWeightTimeOfDaySelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightTimeOfDaySelected&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}


@override
int get hashCode => Object.hash(runtimeType,timeOfDay);

@override
String toString() {
  return 'UserSettingsEvent.weightTimeOfDaySelected(timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightTimeOfDaySelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightTimeOfDaySelectedCopyWith(SettingsWeightTimeOfDaySelected value, $Res Function(SettingsWeightTimeOfDaySelected) _then) = _$SettingsWeightTimeOfDaySelectedCopyWithImpl;
@useResult
$Res call({
 WeightTimeOfDay timeOfDay
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
@pragma('vm:prefer-inline') $Res call({Object? timeOfDay = null,}) {
  return _then(SettingsWeightTimeOfDaySelected(
null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,
  ));
}


}

/// @nodoc


class SettingsWeightUnitSelected implements UserSettingsEvent {
  const SettingsWeightUnitSelected(this.unit);
  

 final  WeightUnit unit;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsWeightUnitSelectedCopyWith<SettingsWeightUnitSelected> get copyWith => _$SettingsWeightUnitSelectedCopyWithImpl<SettingsWeightUnitSelected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsWeightUnitSelected&&(identical(other.unit, unit) || other.unit == unit));
}


@override
int get hashCode => Object.hash(runtimeType,unit);

@override
String toString() {
  return 'UserSettingsEvent.weightUnitSelected(unit: $unit)';
}


}

/// @nodoc
abstract mixin class $SettingsWeightUnitSelectedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsWeightUnitSelectedCopyWith(SettingsWeightUnitSelected value, $Res Function(SettingsWeightUnitSelected) _then) = _$SettingsWeightUnitSelectedCopyWithImpl;
@useResult
$Res call({
 WeightUnit unit
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
@pragma('vm:prefer-inline') $Res call({Object? unit = null,}) {
  return _then(SettingsWeightUnitSelected(
null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
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


class SettingsUsualAdded implements UserSettingsEvent {
  const SettingsUsualAdded(this.meal, this.name, this.calories);
  

 final  MealOfTheDay meal;
 final  String name;
 final  int? calories;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualAddedCopyWith<SettingsUsualAdded> get copyWith => _$SettingsUsualAddedCopyWithImpl<SettingsUsualAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualAdded&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories));
}


@override
int get hashCode => Object.hash(runtimeType,meal,name,calories);

@override
String toString() {
  return 'UserSettingsEvent.usualAdded(meal: $meal, name: $name, calories: $calories)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualAddedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualAddedCopyWith(SettingsUsualAdded value, $Res Function(SettingsUsualAdded) _then) = _$SettingsUsualAddedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String name, int? calories
});




}
/// @nodoc
class _$SettingsUsualAddedCopyWithImpl<$Res>
    implements $SettingsUsualAddedCopyWith<$Res> {
  _$SettingsUsualAddedCopyWithImpl(this._self, this._then);

  final SettingsUsualAdded _self;
  final $Res Function(SettingsUsualAdded) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? name = null,Object? calories = freezed,}) {
  return _then(SettingsUsualAdded(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class SettingsUsualRemoved implements UserSettingsEvent {
  const SettingsUsualRemoved(this.meal, this.id);
  

 final  MealOfTheDay meal;
 final  String id;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualRemovedCopyWith<SettingsUsualRemoved> get copyWith => _$SettingsUsualRemovedCopyWithImpl<SettingsUsualRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualRemoved&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,meal,id);

@override
String toString() {
  return 'UserSettingsEvent.usualRemoved(meal: $meal, id: $id)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualRemovedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualRemovedCopyWith(SettingsUsualRemoved value, $Res Function(SettingsUsualRemoved) _then) = _$SettingsUsualRemovedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String id
});




}
/// @nodoc
class _$SettingsUsualRemovedCopyWithImpl<$Res>
    implements $SettingsUsualRemovedCopyWith<$Res> {
  _$SettingsUsualRemovedCopyWithImpl(this._self, this._then);

  final SettingsUsualRemoved _self;
  final $Res Function(SettingsUsualRemoved) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? id = null,}) {
  return _then(SettingsUsualRemoved(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SettingsUsualCaloriesChanged implements UserSettingsEvent {
  const SettingsUsualCaloriesChanged(this.meal, this.id, this.calories);
  

 final  MealOfTheDay meal;
 final  String id;
 final  int? calories;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsUsualCaloriesChangedCopyWith<SettingsUsualCaloriesChanged> get copyWith => _$SettingsUsualCaloriesChangedCopyWithImpl<SettingsUsualCaloriesChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsUsualCaloriesChanged&&(identical(other.meal, meal) || other.meal == meal)&&(identical(other.id, id) || other.id == id)&&(identical(other.calories, calories) || other.calories == calories));
}


@override
int get hashCode => Object.hash(runtimeType,meal,id,calories);

@override
String toString() {
  return 'UserSettingsEvent.usualCaloriesChanged(meal: $meal, id: $id, calories: $calories)';
}


}

/// @nodoc
abstract mixin class $SettingsUsualCaloriesChangedCopyWith<$Res> implements $UserSettingsEventCopyWith<$Res> {
  factory $SettingsUsualCaloriesChangedCopyWith(SettingsUsualCaloriesChanged value, $Res Function(SettingsUsualCaloriesChanged) _then) = _$SettingsUsualCaloriesChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay meal, String id, int? calories
});




}
/// @nodoc
class _$SettingsUsualCaloriesChangedCopyWithImpl<$Res>
    implements $SettingsUsualCaloriesChangedCopyWith<$Res> {
  _$SettingsUsualCaloriesChangedCopyWithImpl(this._self, this._then);

  final SettingsUsualCaloriesChanged _self;
  final $Res Function(SettingsUsualCaloriesChanged) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? meal = null,Object? id = null,Object? calories = freezed,}) {
  return _then(SettingsUsualCaloriesChanged(
null == meal ? _self.meal : meal // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$UserSettingsState {

/// How the app checks in about meals.
 ReminderStyle get reminderStyle;/// Whether meal check-ins happen per meal or once at the end of the day.
 MealCheckinScheduleMode get mealCheckinScheduleMode;/// Per-meal check-in reminders, used in
/// [MealCheckinScheduleMode.perMeal].
 Map<MealOfTheDay, MealReminder> get mealReminders;/// The single daily check-in covering all meals, used in
/// [MealCheckinScheduleMode.endOfDay].
 MealReminder get endOfDayReminder;/// How often the user weighs in. [WeightCheckinFrequency.off] disables
/// weight check-ins.
 WeightCheckinFrequency get weightCheckinFrequency;/// When in the day the weigh-in reminder fires.
 WeightTimeOfDay get weightTimeOfDay; WeightUnit get weightUnit;/// Baseline weight in [weightUnit], null when never provided.
 double? get startingWeight;/// The user's usuals library, keyed by meal timing.
 Map<MealOfTheDay, List<UsualMeal>> get usuals;
/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<UserSettingsState> get copyWith => _$UserSettingsStateCopyWithImpl<UserSettingsState>(this as UserSettingsState, _$identity);

  /// Serializes this UserSettingsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsState&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other.mealReminders, mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight)&&const DeepCollectionEquality().equals(other.usuals, usuals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight,const DeepCollectionEquality().hash(usuals));

@override
String toString() {
  return 'UserSettingsState(reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight, usuals: $usuals)';
}


}

/// @nodoc
abstract mixin class $UserSettingsStateCopyWith<$Res>  {
  factory $UserSettingsStateCopyWith(UserSettingsState value, $Res Function(UserSettingsState) _then) = _$UserSettingsStateCopyWithImpl;
@useResult
$Res call({
 ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight, Map<MealOfTheDay, List<UsualMeal>> usuals
});


$MealReminderCopyWith<$Res> get endOfDayReminder;

}
/// @nodoc
class _$UserSettingsStateCopyWithImpl<$Res>
    implements $UserSettingsStateCopyWith<$Res> {
  _$UserSettingsStateCopyWithImpl(this._self, this._then);

  final UserSettingsState _self;
  final $Res Function(UserSettingsState) _then;

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,Object? usuals = null,}) {
  return _then(_self.copyWith(
reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self.mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,usuals: null == usuals ? _self.usuals : usuals // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, List<UsualMeal>>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  Map<MealOfTheDay, List<UsualMeal>> usuals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.usuals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  Map<MealOfTheDay, List<UsualMeal>> usuals)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState():
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.usuals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight,  Map<MealOfTheDay, List<UsualMeal>> usuals)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight,_that.usuals);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserSettingsState implements UserSettingsState {
  const _UserSettingsState({this.reminderStyle = ReminderStyle.notifications, this.mealCheckinScheduleMode = MealCheckinScheduleMode.perMeal, final  Map<MealOfTheDay, MealReminder> mealReminders = const {MealOfTheDay.breakfast : MealReminder(enabled: true, time: TimeOfDay(hour: 9, minute: 0)), MealOfTheDay.lunch : MealReminder(enabled: true, time: TimeOfDay(hour: 14, minute: 0)), MealOfTheDay.dinner : MealReminder(enabled: true, time: TimeOfDay(hour: 19, minute: 30)), MealOfTheDay.snacks : MealReminder(enabled: false, time: TimeOfDay(hour: 15, minute: 0))}, this.endOfDayReminder = const MealReminder(enabled: true, time: TimeOfDay(hour: 20, minute: 0)), this.weightCheckinFrequency = WeightCheckinFrequency.daily, this.weightTimeOfDay = WeightTimeOfDay.morning, this.weightUnit = WeightUnit.lb, this.startingWeight, final  Map<MealOfTheDay, List<UsualMeal>> usuals = const <MealOfTheDay, List<UsualMeal>>{}}): _mealReminders = mealReminders,_usuals = usuals;
  factory _UserSettingsState.fromJson(Map<String, dynamic> json) => _$UserSettingsStateFromJson(json);

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
/// The user's usuals library, keyed by meal timing.
 final  Map<MealOfTheDay, List<UsualMeal>> _usuals;
/// The user's usuals library, keyed by meal timing.
@override@JsonKey() Map<MealOfTheDay, List<UsualMeal>> get usuals {
  if (_usuals is EqualUnmodifiableMapView) return _usuals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_usuals);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsState&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other._mealReminders, _mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight)&&const DeepCollectionEquality().equals(other._usuals, _usuals));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(_mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight,const DeepCollectionEquality().hash(_usuals));

@override
String toString() {
  return 'UserSettingsState(reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight, usuals: $usuals)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsStateCopyWith<$Res> implements $UserSettingsStateCopyWith<$Res> {
  factory _$UserSettingsStateCopyWith(_UserSettingsState value, $Res Function(_UserSettingsState) _then) = __$UserSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight, Map<MealOfTheDay, List<UsualMeal>> usuals
});


@override $MealReminderCopyWith<$Res> get endOfDayReminder;

}
/// @nodoc
class __$UserSettingsStateCopyWithImpl<$Res>
    implements _$UserSettingsStateCopyWith<$Res> {
  __$UserSettingsStateCopyWithImpl(this._self, this._then);

  final _UserSettingsState _self;
  final $Res Function(_UserSettingsState) _then;

/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,Object? usuals = null,}) {
  return _then(_UserSettingsState(
reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self._mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,usuals: null == usuals ? _self._usuals : usuals // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, List<UsualMeal>>,
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
}
}

// dart format on
