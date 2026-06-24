// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usual_workout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsualWorkout {

 String get id; String get name; WorkoutType get type; List<WorkoutSet> get sets; Duration? get duration;
/// Create a copy of UsualWorkout
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualWorkoutCopyWith<UsualWorkout> get copyWith => _$UsualWorkoutCopyWithImpl<UsualWorkout>(this as UsualWorkout, _$identity);

  /// Serializes this UsualWorkout to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualWorkout&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.sets, sets)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,const DeepCollectionEquality().hash(sets),duration);

@override
String toString() {
  return 'UsualWorkout(id: $id, name: $name, type: $type, sets: $sets, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $UsualWorkoutCopyWith<$Res>  {
  factory $UsualWorkoutCopyWith(UsualWorkout value, $Res Function(UsualWorkout) _then) = _$UsualWorkoutCopyWithImpl;
@useResult
$Res call({
 String id, String name, WorkoutType type, List<WorkoutSet> sets, Duration? duration
});




}
/// @nodoc
class _$UsualWorkoutCopyWithImpl<$Res>
    implements $UsualWorkoutCopyWith<$Res> {
  _$UsualWorkoutCopyWithImpl(this._self, this._then);

  final UsualWorkout _self;
  final $Res Function(UsualWorkout) _then;

/// Create a copy of UsualWorkout
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sets = null,Object? duration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkoutType,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsualWorkout].
extension UsualWorkoutPatterns on UsualWorkout {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsualWorkout value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsualWorkout() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsualWorkout value)  $default,){
final _that = this;
switch (_that) {
case _UsualWorkout():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsualWorkout value)?  $default,){
final _that = this;
switch (_that) {
case _UsualWorkout() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsualWorkout() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sets,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration)  $default,) {final _that = this;
switch (_that) {
case _UsualWorkout():
return $default(_that.id,_that.name,_that.type,_that.sets,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration)?  $default,) {final _that = this;
switch (_that) {
case _UsualWorkout() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.sets,_that.duration);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UsualWorkout implements UsualWorkout {
  const _UsualWorkout({required this.id, required this.name, this.type = WorkoutType.strength, final  List<WorkoutSet> sets = const <WorkoutSet>[], this.duration}): _sets = sets;
  factory _UsualWorkout.fromJson(Map<String, dynamic> json) => _$UsualWorkoutFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  WorkoutType type;
 final  List<WorkoutSet> _sets;
@override@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@override final  Duration? duration;

/// Create a copy of UsualWorkout
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsualWorkoutCopyWith<_UsualWorkout> get copyWith => __$UsualWorkoutCopyWithImpl<_UsualWorkout>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsualWorkoutToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsualWorkout&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,const DeepCollectionEquality().hash(_sets),duration);

@override
String toString() {
  return 'UsualWorkout(id: $id, name: $name, type: $type, sets: $sets, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$UsualWorkoutCopyWith<$Res> implements $UsualWorkoutCopyWith<$Res> {
  factory _$UsualWorkoutCopyWith(_UsualWorkout value, $Res Function(_UsualWorkout) _then) = __$UsualWorkoutCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, WorkoutType type, List<WorkoutSet> sets, Duration? duration
});




}
/// @nodoc
class __$UsualWorkoutCopyWithImpl<$Res>
    implements _$UsualWorkoutCopyWith<$Res> {
  __$UsualWorkoutCopyWithImpl(this._self, this._then);

  final _UsualWorkout _self;
  final $Res Function(_UsualWorkout) _then;

/// Create a copy of UsualWorkout
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? sets = null,Object? duration = freezed,}) {
  return _then(_UsualWorkout(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkoutType,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,
  ));
}


}

// dart format on
