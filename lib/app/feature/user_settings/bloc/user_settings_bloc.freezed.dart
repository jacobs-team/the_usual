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

 UserSettingsState get settings;
/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsEventCopyWith<UserSettingsEvent> get copyWith => _$UserSettingsEventCopyWithImpl<UserSettingsEvent>(this as UserSettingsEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsEvent&&(identical(other.settings, settings) || other.settings == settings));
}


@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'UserSettingsEvent(settings: $settings)';
}


}

/// @nodoc
abstract mixin class $UserSettingsEventCopyWith<$Res>  {
  factory $UserSettingsEventCopyWith(UserSettingsEvent value, $Res Function(UserSettingsEvent) _then) = _$UserSettingsEventCopyWithImpl;
@useResult
$Res call({
 UserSettingsState settings
});


$UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class _$UserSettingsEventCopyWithImpl<$Res>
    implements $UserSettingsEventCopyWith<$Res> {
  _$UserSettingsEventCopyWithImpl(this._self, this._then);

  final UserSettingsEvent _self;
  final $Res Function(UserSettingsEvent) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = null,}) {
  return _then(_self.copyWith(
settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SettingsCommitted value)?  settingsCommitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SettingsCommitted value)  settingsCommitted,}){
final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SettingsCommitted value)?  settingsCommitted,}){
final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UserSettingsState settings)?  settingsCommitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UserSettingsState settings)  settingsCommitted,}) {final _that = this;
switch (_that) {
case SettingsCommitted():
return settingsCommitted(_that.settings);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UserSettingsState settings)?  settingsCommitted,}) {final _that = this;
switch (_that) {
case SettingsCommitted() when settingsCommitted != null:
return settingsCommitted(_that.settings);case _:
  return null;

}
}

}

/// @nodoc


class SettingsCommitted implements UserSettingsEvent {
  const SettingsCommitted(this.settings);
  

@override final  UserSettingsState settings;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
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
@override @useResult
$Res call({
 UserSettingsState settings
});


@override $UserSettingsStateCopyWith<$Res> get settings;

}
/// @nodoc
class _$SettingsCommittedCopyWithImpl<$Res>
    implements $SettingsCommittedCopyWith<$Res> {
  _$SettingsCommittedCopyWithImpl(this._self, this._then);

  final SettingsCommitted _self;
  final $Res Function(SettingsCommitted) _then;

/// Create a copy of UserSettingsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = null,}) {
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
 double? get startingWeight;
/// Create a copy of UserSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsStateCopyWith<UserSettingsState> get copyWith => _$UserSettingsStateCopyWithImpl<UserSettingsState>(this as UserSettingsState, _$identity);

  /// Serializes this UserSettingsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettingsState&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other.mealReminders, mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight);

@override
String toString() {
  return 'UserSettingsState(reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight)';
}


}

/// @nodoc
abstract mixin class $UserSettingsStateCopyWith<$Res>  {
  factory $UserSettingsStateCopyWith(UserSettingsState value, $Res Function(UserSettingsState) _then) = _$UserSettingsStateCopyWithImpl;
@useResult
$Res call({
 ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight
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
@pragma('vm:prefer-inline') @override $Res call({Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,}) {
  return _then(_self.copyWith(
reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self.mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight)  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState():
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReminderStyle reminderStyle,  MealCheckinScheduleMode mealCheckinScheduleMode,  Map<MealOfTheDay, MealReminder> mealReminders,  MealReminder endOfDayReminder,  WeightCheckinFrequency weightCheckinFrequency,  WeightTimeOfDay weightTimeOfDay,  WeightUnit weightUnit,  double? startingWeight)?  $default,) {final _that = this;
switch (_that) {
case _UserSettingsState() when $default != null:
return $default(_that.reminderStyle,_that.mealCheckinScheduleMode,_that.mealReminders,_that.endOfDayReminder,_that.weightCheckinFrequency,_that.weightTimeOfDay,_that.weightUnit,_that.startingWeight);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UserSettingsState implements UserSettingsState {
  const _UserSettingsState({this.reminderStyle = ReminderStyle.notifications, this.mealCheckinScheduleMode = MealCheckinScheduleMode.perMeal, final  Map<MealOfTheDay, MealReminder> mealReminders = const {MealOfTheDay.breakfast : MealReminder(enabled: true, time: TimeOfDay(hour: 9, minute: 0)), MealOfTheDay.lunch : MealReminder(enabled: true, time: TimeOfDay(hour: 14, minute: 0)), MealOfTheDay.dinner : MealReminder(enabled: true, time: TimeOfDay(hour: 19, minute: 30)), MealOfTheDay.snacks : MealReminder(enabled: false, time: TimeOfDay(hour: 15, minute: 0))}, this.endOfDayReminder = const MealReminder(enabled: true, time: TimeOfDay(hour: 20, minute: 0)), this.weightCheckinFrequency = WeightCheckinFrequency.daily, this.weightTimeOfDay = WeightTimeOfDay.morning, this.weightUnit = WeightUnit.lb, this.startingWeight}): _mealReminders = mealReminders;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettingsState&&(identical(other.reminderStyle, reminderStyle) || other.reminderStyle == reminderStyle)&&(identical(other.mealCheckinScheduleMode, mealCheckinScheduleMode) || other.mealCheckinScheduleMode == mealCheckinScheduleMode)&&const DeepCollectionEquality().equals(other._mealReminders, _mealReminders)&&(identical(other.endOfDayReminder, endOfDayReminder) || other.endOfDayReminder == endOfDayReminder)&&(identical(other.weightCheckinFrequency, weightCheckinFrequency) || other.weightCheckinFrequency == weightCheckinFrequency)&&(identical(other.weightTimeOfDay, weightTimeOfDay) || other.weightTimeOfDay == weightTimeOfDay)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.startingWeight, startingWeight) || other.startingWeight == startingWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reminderStyle,mealCheckinScheduleMode,const DeepCollectionEquality().hash(_mealReminders),endOfDayReminder,weightCheckinFrequency,weightTimeOfDay,weightUnit,startingWeight);

@override
String toString() {
  return 'UserSettingsState(reminderStyle: $reminderStyle, mealCheckinScheduleMode: $mealCheckinScheduleMode, mealReminders: $mealReminders, endOfDayReminder: $endOfDayReminder, weightCheckinFrequency: $weightCheckinFrequency, weightTimeOfDay: $weightTimeOfDay, weightUnit: $weightUnit, startingWeight: $startingWeight)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsStateCopyWith<$Res> implements $UserSettingsStateCopyWith<$Res> {
  factory _$UserSettingsStateCopyWith(_UserSettingsState value, $Res Function(_UserSettingsState) _then) = __$UserSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ReminderStyle reminderStyle, MealCheckinScheduleMode mealCheckinScheduleMode, Map<MealOfTheDay, MealReminder> mealReminders, MealReminder endOfDayReminder, WeightCheckinFrequency weightCheckinFrequency, WeightTimeOfDay weightTimeOfDay, WeightUnit weightUnit, double? startingWeight
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
@override @pragma('vm:prefer-inline') $Res call({Object? reminderStyle = null,Object? mealCheckinScheduleMode = null,Object? mealReminders = null,Object? endOfDayReminder = null,Object? weightCheckinFrequency = null,Object? weightTimeOfDay = null,Object? weightUnit = null,Object? startingWeight = freezed,}) {
  return _then(_UserSettingsState(
reminderStyle: null == reminderStyle ? _self.reminderStyle : reminderStyle // ignore: cast_nullable_to_non_nullable
as ReminderStyle,mealCheckinScheduleMode: null == mealCheckinScheduleMode ? _self.mealCheckinScheduleMode : mealCheckinScheduleMode // ignore: cast_nullable_to_non_nullable
as MealCheckinScheduleMode,mealReminders: null == mealReminders ? _self._mealReminders : mealReminders // ignore: cast_nullable_to_non_nullable
as Map<MealOfTheDay, MealReminder>,endOfDayReminder: null == endOfDayReminder ? _self.endOfDayReminder : endOfDayReminder // ignore: cast_nullable_to_non_nullable
as MealReminder,weightCheckinFrequency: null == weightCheckinFrequency ? _self.weightCheckinFrequency : weightCheckinFrequency // ignore: cast_nullable_to_non_nullable
as WeightCheckinFrequency,weightTimeOfDay: null == weightTimeOfDay ? _self.weightTimeOfDay : weightTimeOfDay // ignore: cast_nullable_to_non_nullable
as WeightTimeOfDay,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,startingWeight: freezed == startingWeight ? _self.startingWeight : startingWeight // ignore: cast_nullable_to_non_nullable
as double?,
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
