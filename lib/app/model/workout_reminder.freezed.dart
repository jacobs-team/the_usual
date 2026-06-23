// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutReminder {

 bool get enabled; Set<int> get daysOfWeek;@TimeOfDayConverter() TimeOfDay get timeOfDay;
/// Create a copy of WorkoutReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutReminderCopyWith<WorkoutReminder> get copyWith => _$WorkoutReminderCopyWithImpl<WorkoutReminder>(this as WorkoutReminder, _$identity);

  /// Serializes this WorkoutReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.daysOfWeek, daysOfWeek)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(daysOfWeek),timeOfDay);

@override
String toString() {
  return 'WorkoutReminder(enabled: $enabled, daysOfWeek: $daysOfWeek, timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class $WorkoutReminderCopyWith<$Res>  {
  factory $WorkoutReminderCopyWith(WorkoutReminder value, $Res Function(WorkoutReminder) _then) = _$WorkoutReminderCopyWithImpl;
@useResult
$Res call({
 bool enabled, Set<int> daysOfWeek,@TimeOfDayConverter() TimeOfDay timeOfDay
});




}
/// @nodoc
class _$WorkoutReminderCopyWithImpl<$Res>
    implements $WorkoutReminderCopyWith<$Res> {
  _$WorkoutReminderCopyWithImpl(this._self, this._then);

  final WorkoutReminder _self;
  final $Res Function(WorkoutReminder) _then;

/// Create a copy of WorkoutReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? daysOfWeek = null,Object? timeOfDay = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,daysOfWeek: null == daysOfWeek ? _self.daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as Set<int>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutReminder].
extension WorkoutReminderPatterns on WorkoutReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutReminder value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutReminder value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  Set<int> daysOfWeek, @TimeOfDayConverter()  TimeOfDay timeOfDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutReminder() when $default != null:
return $default(_that.enabled,_that.daysOfWeek,_that.timeOfDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  Set<int> daysOfWeek, @TimeOfDayConverter()  TimeOfDay timeOfDay)  $default,) {final _that = this;
switch (_that) {
case _WorkoutReminder():
return $default(_that.enabled,_that.daysOfWeek,_that.timeOfDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  Set<int> daysOfWeek, @TimeOfDayConverter()  TimeOfDay timeOfDay)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutReminder() when $default != null:
return $default(_that.enabled,_that.daysOfWeek,_that.timeOfDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkoutReminder implements WorkoutReminder {
  const _WorkoutReminder({this.enabled = false, final  Set<int> daysOfWeek = const <int>{}, @TimeOfDayConverter() required this.timeOfDay}): _daysOfWeek = daysOfWeek;
  factory _WorkoutReminder.fromJson(Map<String, dynamic> json) => _$WorkoutReminderFromJson(json);

@override@JsonKey() final  bool enabled;
 final  Set<int> _daysOfWeek;
@override@JsonKey() Set<int> get daysOfWeek {
  if (_daysOfWeek is EqualUnmodifiableSetView) return _daysOfWeek;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_daysOfWeek);
}

@override@TimeOfDayConverter() final  TimeOfDay timeOfDay;

/// Create a copy of WorkoutReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutReminderCopyWith<_WorkoutReminder> get copyWith => __$WorkoutReminderCopyWithImpl<_WorkoutReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._daysOfWeek, _daysOfWeek)&&(identical(other.timeOfDay, timeOfDay) || other.timeOfDay == timeOfDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,const DeepCollectionEquality().hash(_daysOfWeek),timeOfDay);

@override
String toString() {
  return 'WorkoutReminder(enabled: $enabled, daysOfWeek: $daysOfWeek, timeOfDay: $timeOfDay)';
}


}

/// @nodoc
abstract mixin class _$WorkoutReminderCopyWith<$Res> implements $WorkoutReminderCopyWith<$Res> {
  factory _$WorkoutReminderCopyWith(_WorkoutReminder value, $Res Function(_WorkoutReminder) _then) = __$WorkoutReminderCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, Set<int> daysOfWeek,@TimeOfDayConverter() TimeOfDay timeOfDay
});




}
/// @nodoc
class __$WorkoutReminderCopyWithImpl<$Res>
    implements _$WorkoutReminderCopyWith<$Res> {
  __$WorkoutReminderCopyWithImpl(this._self, this._then);

  final _WorkoutReminder _self;
  final $Res Function(_WorkoutReminder) _then;

/// Create a copy of WorkoutReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? daysOfWeek = null,Object? timeOfDay = null,}) {
  return _then(_WorkoutReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,daysOfWeek: null == daysOfWeek ? _self._daysOfWeek : daysOfWeek // ignore: cast_nullable_to_non_nullable
as Set<int>,timeOfDay: null == timeOfDay ? _self.timeOfDay : timeOfDay // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
