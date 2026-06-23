// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutLogEntry {

 String get id; DateTime get loggedAt; String get workoutGroupId; String get name; List<WorkoutSet> get sets; String? get usualWorkoutId;
/// Create a copy of WorkoutLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLogEntryCopyWith<WorkoutLogEntry> get copyWith => _$WorkoutLogEntryCopyWithImpl<WorkoutLogEntry>(this as WorkoutLogEntry, _$identity);

  /// Serializes this WorkoutLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.sets, sets)&&(identical(other.usualWorkoutId, usualWorkoutId) || other.usualWorkoutId == usualWorkoutId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,workoutGroupId,name,const DeepCollectionEquality().hash(sets),usualWorkoutId);

@override
String toString() {
  return 'WorkoutLogEntry(id: $id, loggedAt: $loggedAt, workoutGroupId: $workoutGroupId, name: $name, sets: $sets, usualWorkoutId: $usualWorkoutId)';
}


}

/// @nodoc
abstract mixin class $WorkoutLogEntryCopyWith<$Res>  {
  factory $WorkoutLogEntryCopyWith(WorkoutLogEntry value, $Res Function(WorkoutLogEntry) _then) = _$WorkoutLogEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime loggedAt, String workoutGroupId, String name, List<WorkoutSet> sets, String? usualWorkoutId
});




}
/// @nodoc
class _$WorkoutLogEntryCopyWithImpl<$Res>
    implements $WorkoutLogEntryCopyWith<$Res> {
  _$WorkoutLogEntryCopyWithImpl(this._self, this._then);

  final WorkoutLogEntry _self;
  final $Res Function(WorkoutLogEntry) _then;

/// Create a copy of WorkoutLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loggedAt = null,Object? workoutGroupId = null,Object? name = null,Object? sets = null,Object? usualWorkoutId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,workoutGroupId: null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self.sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,usualWorkoutId: freezed == usualWorkoutId ? _self.usualWorkoutId : usualWorkoutId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutLogEntry].
extension WorkoutLogEntryPatterns on WorkoutLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  String workoutGroupId,  String name,  List<WorkoutSet> sets,  String? usualWorkoutId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutLogEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.workoutGroupId,_that.name,_that.sets,_that.usualWorkoutId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  String workoutGroupId,  String name,  List<WorkoutSet> sets,  String? usualWorkoutId)  $default,) {final _that = this;
switch (_that) {
case _WorkoutLogEntry():
return $default(_that.id,_that.loggedAt,_that.workoutGroupId,_that.name,_that.sets,_that.usualWorkoutId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime loggedAt,  String workoutGroupId,  String name,  List<WorkoutSet> sets,  String? usualWorkoutId)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutLogEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.workoutGroupId,_that.name,_that.sets,_that.usualWorkoutId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WorkoutLogEntry extends WorkoutLogEntry {
  const _WorkoutLogEntry({required this.id, required this.loggedAt, required this.workoutGroupId, required this.name, final  List<WorkoutSet> sets = const <WorkoutSet>[], this.usualWorkoutId}): _sets = sets,super._();
  factory _WorkoutLogEntry.fromJson(Map<String, dynamic> json) => _$WorkoutLogEntryFromJson(json);

@override final  String id;
@override final  DateTime loggedAt;
@override final  String workoutGroupId;
@override final  String name;
 final  List<WorkoutSet> _sets;
@override@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

@override final  String? usualWorkoutId;

/// Create a copy of WorkoutLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutLogEntryCopyWith<_WorkoutLogEntry> get copyWith => __$WorkoutLogEntryCopyWithImpl<_WorkoutLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.usualWorkoutId, usualWorkoutId) || other.usualWorkoutId == usualWorkoutId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,workoutGroupId,name,const DeepCollectionEquality().hash(_sets),usualWorkoutId);

@override
String toString() {
  return 'WorkoutLogEntry(id: $id, loggedAt: $loggedAt, workoutGroupId: $workoutGroupId, name: $name, sets: $sets, usualWorkoutId: $usualWorkoutId)';
}


}

/// @nodoc
abstract mixin class _$WorkoutLogEntryCopyWith<$Res> implements $WorkoutLogEntryCopyWith<$Res> {
  factory _$WorkoutLogEntryCopyWith(_WorkoutLogEntry value, $Res Function(_WorkoutLogEntry) _then) = __$WorkoutLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime loggedAt, String workoutGroupId, String name, List<WorkoutSet> sets, String? usualWorkoutId
});




}
/// @nodoc
class __$WorkoutLogEntryCopyWithImpl<$Res>
    implements _$WorkoutLogEntryCopyWith<$Res> {
  __$WorkoutLogEntryCopyWithImpl(this._self, this._then);

  final _WorkoutLogEntry _self;
  final $Res Function(_WorkoutLogEntry) _then;

/// Create a copy of WorkoutLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loggedAt = null,Object? workoutGroupId = null,Object? name = null,Object? sets = null,Object? usualWorkoutId = freezed,}) {
  return _then(_WorkoutLogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,workoutGroupId: null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,usualWorkoutId: freezed == usualWorkoutId ? _self.usualWorkoutId : usualWorkoutId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
