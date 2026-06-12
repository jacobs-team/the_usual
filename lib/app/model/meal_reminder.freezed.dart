// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealReminder {

 bool get enabled;@TimeOfDayConverter() TimeOfDay get time;
/// Create a copy of MealReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealReminderCopyWith<MealReminder> get copyWith => _$MealReminderCopyWithImpl<MealReminder>(this as MealReminder, _$identity);

  /// Serializes this MealReminder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,time);

@override
String toString() {
  return 'MealReminder(enabled: $enabled, time: $time)';
}


}

/// @nodoc
abstract mixin class $MealReminderCopyWith<$Res>  {
  factory $MealReminderCopyWith(MealReminder value, $Res Function(MealReminder) _then) = _$MealReminderCopyWithImpl;
@useResult
$Res call({
 bool enabled,@TimeOfDayConverter() TimeOfDay time
});




}
/// @nodoc
class _$MealReminderCopyWithImpl<$Res>
    implements $MealReminderCopyWith<$Res> {
  _$MealReminderCopyWithImpl(this._self, this._then);

  final MealReminder _self;
  final $Res Function(MealReminder) _then;

/// Create a copy of MealReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [MealReminder].
extension MealReminderPatterns on MealReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealReminder value)  $default,){
final _that = this;
switch (_that) {
case _MealReminder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealReminder value)?  $default,){
final _that = this;
switch (_that) {
case _MealReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled, @TimeOfDayConverter()  TimeOfDay time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealReminder() when $default != null:
return $default(_that.enabled,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled, @TimeOfDayConverter()  TimeOfDay time)  $default,) {final _that = this;
switch (_that) {
case _MealReminder():
return $default(_that.enabled,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled, @TimeOfDayConverter()  TimeOfDay time)?  $default,) {final _that = this;
switch (_that) {
case _MealReminder() when $default != null:
return $default(_that.enabled,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MealReminder implements MealReminder {
  const _MealReminder({required this.enabled, @TimeOfDayConverter() required this.time});
  factory _MealReminder.fromJson(Map<String, dynamic> json) => _$MealReminderFromJson(json);

@override final  bool enabled;
@override@TimeOfDayConverter() final  TimeOfDay time;

/// Create a copy of MealReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealReminderCopyWith<_MealReminder> get copyWith => __$MealReminderCopyWithImpl<_MealReminder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealReminderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealReminder&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,time);

@override
String toString() {
  return 'MealReminder(enabled: $enabled, time: $time)';
}


}

/// @nodoc
abstract mixin class _$MealReminderCopyWith<$Res> implements $MealReminderCopyWith<$Res> {
  factory _$MealReminderCopyWith(_MealReminder value, $Res Function(_MealReminder) _then) = __$MealReminderCopyWithImpl;
@override @useResult
$Res call({
 bool enabled,@TimeOfDayConverter() TimeOfDay time
});




}
/// @nodoc
class __$MealReminderCopyWithImpl<$Res>
    implements _$MealReminderCopyWith<$Res> {
  __$MealReminderCopyWithImpl(this._self, this._then);

  final _MealReminder _self;
  final $Res Function(_MealReminder) _then;

/// Create a copy of MealReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? time = null,}) {
  return _then(_MealReminder(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
