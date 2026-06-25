// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calorie_goal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalorieGoalEntry {

 DateTime get effectiveFrom; int? get calories;
/// Create a copy of CalorieGoalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalorieGoalEntryCopyWith<CalorieGoalEntry> get copyWith => _$CalorieGoalEntryCopyWithImpl<CalorieGoalEntry>(this as CalorieGoalEntry, _$identity);

  /// Serializes this CalorieGoalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalorieGoalEntry&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.calories, calories) || other.calories == calories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,calories);

@override
String toString() {
  return 'CalorieGoalEntry(effectiveFrom: $effectiveFrom, calories: $calories)';
}


}

/// @nodoc
abstract mixin class $CalorieGoalEntryCopyWith<$Res>  {
  factory $CalorieGoalEntryCopyWith(CalorieGoalEntry value, $Res Function(CalorieGoalEntry) _then) = _$CalorieGoalEntryCopyWithImpl;
@useResult
$Res call({
 DateTime effectiveFrom, int? calories
});




}
/// @nodoc
class _$CalorieGoalEntryCopyWithImpl<$Res>
    implements $CalorieGoalEntryCopyWith<$Res> {
  _$CalorieGoalEntryCopyWithImpl(this._self, this._then);

  final CalorieGoalEntry _self;
  final $Res Function(CalorieGoalEntry) _then;

/// Create a copy of CalorieGoalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveFrom = null,Object? calories = freezed,}) {
  return _then(_self.copyWith(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalorieGoalEntry].
extension CalorieGoalEntryPatterns on CalorieGoalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalorieGoalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalorieGoalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalorieGoalEntry value)  $default,){
final _that = this;
switch (_that) {
case _CalorieGoalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalorieGoalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CalorieGoalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime effectiveFrom,  int? calories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalorieGoalEntry() when $default != null:
return $default(_that.effectiveFrom,_that.calories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime effectiveFrom,  int? calories)  $default,) {final _that = this;
switch (_that) {
case _CalorieGoalEntry():
return $default(_that.effectiveFrom,_that.calories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime effectiveFrom,  int? calories)?  $default,) {final _that = this;
switch (_that) {
case _CalorieGoalEntry() when $default != null:
return $default(_that.effectiveFrom,_that.calories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalorieGoalEntry implements CalorieGoalEntry {
  const _CalorieGoalEntry({required this.effectiveFrom, this.calories});
  factory _CalorieGoalEntry.fromJson(Map<String, dynamic> json) => _$CalorieGoalEntryFromJson(json);

@override final  DateTime effectiveFrom;
@override final  int? calories;

/// Create a copy of CalorieGoalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalorieGoalEntryCopyWith<_CalorieGoalEntry> get copyWith => __$CalorieGoalEntryCopyWithImpl<_CalorieGoalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalorieGoalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalorieGoalEntry&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.calories, calories) || other.calories == calories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,calories);

@override
String toString() {
  return 'CalorieGoalEntry(effectiveFrom: $effectiveFrom, calories: $calories)';
}


}

/// @nodoc
abstract mixin class _$CalorieGoalEntryCopyWith<$Res> implements $CalorieGoalEntryCopyWith<$Res> {
  factory _$CalorieGoalEntryCopyWith(_CalorieGoalEntry value, $Res Function(_CalorieGoalEntry) _then) = __$CalorieGoalEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime effectiveFrom, int? calories
});




}
/// @nodoc
class __$CalorieGoalEntryCopyWithImpl<$Res>
    implements _$CalorieGoalEntryCopyWith<$Res> {
  __$CalorieGoalEntryCopyWithImpl(this._self, this._then);

  final _CalorieGoalEntry _self;
  final $Res Function(_CalorieGoalEntry) _then;

/// Create a copy of CalorieGoalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveFrom = null,Object? calories = freezed,}) {
  return _then(_CalorieGoalEntry(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
