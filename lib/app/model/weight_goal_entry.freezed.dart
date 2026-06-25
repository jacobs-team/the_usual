// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weight_goal_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeightGoalEntry {

 DateTime get effectiveFrom; WeightUnit get weightUnit; double? get weight;
/// Create a copy of WeightGoalEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightGoalEntryCopyWith<WeightGoalEntry> get copyWith => _$WeightGoalEntryCopyWithImpl<WeightGoalEntry>(this as WeightGoalEntry, _$identity);

  /// Serializes this WeightGoalEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightGoalEntry&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,weightUnit,weight);

@override
String toString() {
  return 'WeightGoalEntry(effectiveFrom: $effectiveFrom, weightUnit: $weightUnit, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $WeightGoalEntryCopyWith<$Res>  {
  factory $WeightGoalEntryCopyWith(WeightGoalEntry value, $Res Function(WeightGoalEntry) _then) = _$WeightGoalEntryCopyWithImpl;
@useResult
$Res call({
 DateTime effectiveFrom, WeightUnit weightUnit, double? weight
});




}
/// @nodoc
class _$WeightGoalEntryCopyWithImpl<$Res>
    implements $WeightGoalEntryCopyWith<$Res> {
  _$WeightGoalEntryCopyWithImpl(this._self, this._then);

  final WeightGoalEntry _self;
  final $Res Function(WeightGoalEntry) _then;

/// Create a copy of WeightGoalEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? effectiveFrom = null,Object? weightUnit = null,Object? weight = freezed,}) {
  return _then(_self.copyWith(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeightGoalEntry].
extension WeightGoalEntryPatterns on WeightGoalEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeightGoalEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeightGoalEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeightGoalEntry value)  $default,){
final _that = this;
switch (_that) {
case _WeightGoalEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeightGoalEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WeightGoalEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime effectiveFrom,  WeightUnit weightUnit,  double? weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeightGoalEntry() when $default != null:
return $default(_that.effectiveFrom,_that.weightUnit,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime effectiveFrom,  WeightUnit weightUnit,  double? weight)  $default,) {final _that = this;
switch (_that) {
case _WeightGoalEntry():
return $default(_that.effectiveFrom,_that.weightUnit,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime effectiveFrom,  WeightUnit weightUnit,  double? weight)?  $default,) {final _that = this;
switch (_that) {
case _WeightGoalEntry() when $default != null:
return $default(_that.effectiveFrom,_that.weightUnit,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeightGoalEntry implements WeightGoalEntry {
  const _WeightGoalEntry({required this.effectiveFrom, required this.weightUnit, this.weight});
  factory _WeightGoalEntry.fromJson(Map<String, dynamic> json) => _$WeightGoalEntryFromJson(json);

@override final  DateTime effectiveFrom;
@override final  WeightUnit weightUnit;
@override final  double? weight;

/// Create a copy of WeightGoalEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeightGoalEntryCopyWith<_WeightGoalEntry> get copyWith => __$WeightGoalEntryCopyWithImpl<_WeightGoalEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeightGoalEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeightGoalEntry&&(identical(other.effectiveFrom, effectiveFrom) || other.effectiveFrom == effectiveFrom)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,effectiveFrom,weightUnit,weight);

@override
String toString() {
  return 'WeightGoalEntry(effectiveFrom: $effectiveFrom, weightUnit: $weightUnit, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$WeightGoalEntryCopyWith<$Res> implements $WeightGoalEntryCopyWith<$Res> {
  factory _$WeightGoalEntryCopyWith(_WeightGoalEntry value, $Res Function(_WeightGoalEntry) _then) = __$WeightGoalEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime effectiveFrom, WeightUnit weightUnit, double? weight
});




}
/// @nodoc
class __$WeightGoalEntryCopyWithImpl<$Res>
    implements _$WeightGoalEntryCopyWith<$Res> {
  __$WeightGoalEntryCopyWithImpl(this._self, this._then);

  final _WeightGoalEntry _self;
  final $Res Function(_WeightGoalEntry) _then;

/// Create a copy of WeightGoalEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? effectiveFrom = null,Object? weightUnit = null,Object? weight = freezed,}) {
  return _then(_WeightGoalEntry(
effectiveFrom: null == effectiveFrom ? _self.effectiveFrom : effectiveFrom // ignore: cast_nullable_to_non_nullable
as DateTime,weightUnit: null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
