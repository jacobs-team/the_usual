// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_log_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkoutLogEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLogEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WorkoutLogEvent()';
}


}

/// @nodoc
class $WorkoutLogEventCopyWith<$Res>  {
$WorkoutLogEventCopyWith(WorkoutLogEvent _, $Res Function(WorkoutLogEvent) __);
}


/// Adds pattern-matching-related methods to [WorkoutLogEvent].
extension WorkoutLogEventPatterns on WorkoutLogEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WorkoutLogged value)?  workoutLogged,TResult Function( WorkoutRemoved value)?  workoutRemoved,TResult Function( WorkoutSetsChanged value)?  workoutSetsChanged,TResult Function( WorkoutDurationChanged value)?  workoutDurationChanged,TResult Function( WorkoutLogStateRestored value)?  stateRestored,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WorkoutLogged() when workoutLogged != null:
return workoutLogged(_that);case WorkoutRemoved() when workoutRemoved != null:
return workoutRemoved(_that);case WorkoutSetsChanged() when workoutSetsChanged != null:
return workoutSetsChanged(_that);case WorkoutDurationChanged() when workoutDurationChanged != null:
return workoutDurationChanged(_that);case WorkoutLogStateRestored() when stateRestored != null:
return stateRestored(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WorkoutLogged value)  workoutLogged,required TResult Function( WorkoutRemoved value)  workoutRemoved,required TResult Function( WorkoutSetsChanged value)  workoutSetsChanged,required TResult Function( WorkoutDurationChanged value)  workoutDurationChanged,required TResult Function( WorkoutLogStateRestored value)  stateRestored,}){
final _that = this;
switch (_that) {
case WorkoutLogged():
return workoutLogged(_that);case WorkoutRemoved():
return workoutRemoved(_that);case WorkoutSetsChanged():
return workoutSetsChanged(_that);case WorkoutDurationChanged():
return workoutDurationChanged(_that);case WorkoutLogStateRestored():
return stateRestored(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WorkoutLogged value)?  workoutLogged,TResult? Function( WorkoutRemoved value)?  workoutRemoved,TResult? Function( WorkoutSetsChanged value)?  workoutSetsChanged,TResult? Function( WorkoutDurationChanged value)?  workoutDurationChanged,TResult? Function( WorkoutLogStateRestored value)?  stateRestored,}){
final _that = this;
switch (_that) {
case WorkoutLogged() when workoutLogged != null:
return workoutLogged(_that);case WorkoutRemoved() when workoutRemoved != null:
return workoutRemoved(_that);case WorkoutSetsChanged() when workoutSetsChanged != null:
return workoutSetsChanged(_that);case WorkoutDurationChanged() when workoutDurationChanged != null:
return workoutDurationChanged(_that);case WorkoutLogStateRestored() when stateRestored != null:
return stateRestored(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String workoutGroupId,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration,  String? usualWorkoutId,  DateTime? day,  TimeOfDay? dayStart)?  workoutLogged,TResult Function( String id)?  workoutRemoved,TResult Function( String id,  List<WorkoutSet> sets)?  workoutSetsChanged,TResult Function( String id,  Duration duration)?  workoutDurationChanged,TResult Function( WorkoutLogState state)?  stateRestored,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WorkoutLogged() when workoutLogged != null:
return workoutLogged(_that.workoutGroupId,_that.name,_that.type,_that.sets,_that.duration,_that.usualWorkoutId,_that.day,_that.dayStart);case WorkoutRemoved() when workoutRemoved != null:
return workoutRemoved(_that.id);case WorkoutSetsChanged() when workoutSetsChanged != null:
return workoutSetsChanged(_that.id,_that.sets);case WorkoutDurationChanged() when workoutDurationChanged != null:
return workoutDurationChanged(_that.id,_that.duration);case WorkoutLogStateRestored() when stateRestored != null:
return stateRestored(_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String workoutGroupId,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration,  String? usualWorkoutId,  DateTime? day,  TimeOfDay? dayStart)  workoutLogged,required TResult Function( String id)  workoutRemoved,required TResult Function( String id,  List<WorkoutSet> sets)  workoutSetsChanged,required TResult Function( String id,  Duration duration)  workoutDurationChanged,required TResult Function( WorkoutLogState state)  stateRestored,}) {final _that = this;
switch (_that) {
case WorkoutLogged():
return workoutLogged(_that.workoutGroupId,_that.name,_that.type,_that.sets,_that.duration,_that.usualWorkoutId,_that.day,_that.dayStart);case WorkoutRemoved():
return workoutRemoved(_that.id);case WorkoutSetsChanged():
return workoutSetsChanged(_that.id,_that.sets);case WorkoutDurationChanged():
return workoutDurationChanged(_that.id,_that.duration);case WorkoutLogStateRestored():
return stateRestored(_that.state);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String workoutGroupId,  String name,  WorkoutType type,  List<WorkoutSet> sets,  Duration? duration,  String? usualWorkoutId,  DateTime? day,  TimeOfDay? dayStart)?  workoutLogged,TResult? Function( String id)?  workoutRemoved,TResult? Function( String id,  List<WorkoutSet> sets)?  workoutSetsChanged,TResult? Function( String id,  Duration duration)?  workoutDurationChanged,TResult? Function( WorkoutLogState state)?  stateRestored,}) {final _that = this;
switch (_that) {
case WorkoutLogged() when workoutLogged != null:
return workoutLogged(_that.workoutGroupId,_that.name,_that.type,_that.sets,_that.duration,_that.usualWorkoutId,_that.day,_that.dayStart);case WorkoutRemoved() when workoutRemoved != null:
return workoutRemoved(_that.id);case WorkoutSetsChanged() when workoutSetsChanged != null:
return workoutSetsChanged(_that.id,_that.sets);case WorkoutDurationChanged() when workoutDurationChanged != null:
return workoutDurationChanged(_that.id,_that.duration);case WorkoutLogStateRestored() when stateRestored != null:
return stateRestored(_that.state);case _:
  return null;

}
}

}

/// @nodoc


class WorkoutLogged implements WorkoutLogEvent {
  const WorkoutLogged(this.workoutGroupId, this.name, {this.type = WorkoutType.strength, final  List<WorkoutSet> sets = const <WorkoutSet>[], this.duration, this.usualWorkoutId, this.day, this.dayStart}): _sets = sets;
  

 final  String workoutGroupId;
 final  String name;
@JsonKey() final  WorkoutType type;
 final  List<WorkoutSet> _sets;
@JsonKey() List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}

 final  Duration? duration;
 final  String? usualWorkoutId;
 final  DateTime? day;
 final  TimeOfDay? dayStart;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLoggedCopyWith<WorkoutLogged> get copyWith => _$WorkoutLoggedCopyWithImpl<WorkoutLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLogged&&(identical(other.workoutGroupId, workoutGroupId) || other.workoutGroupId == workoutGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._sets, _sets)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.usualWorkoutId, usualWorkoutId) || other.usualWorkoutId == usualWorkoutId)&&(identical(other.day, day) || other.day == day)&&(identical(other.dayStart, dayStart) || other.dayStart == dayStart));
}


@override
int get hashCode => Object.hash(runtimeType,workoutGroupId,name,type,const DeepCollectionEquality().hash(_sets),duration,usualWorkoutId,day,dayStart);

@override
String toString() {
  return 'WorkoutLogEvent.workoutLogged(workoutGroupId: $workoutGroupId, name: $name, type: $type, sets: $sets, duration: $duration, usualWorkoutId: $usualWorkoutId, day: $day, dayStart: $dayStart)';
}


}

/// @nodoc
abstract mixin class $WorkoutLoggedCopyWith<$Res> implements $WorkoutLogEventCopyWith<$Res> {
  factory $WorkoutLoggedCopyWith(WorkoutLogged value, $Res Function(WorkoutLogged) _then) = _$WorkoutLoggedCopyWithImpl;
@useResult
$Res call({
 String workoutGroupId, String name, WorkoutType type, List<WorkoutSet> sets, Duration? duration, String? usualWorkoutId, DateTime? day, TimeOfDay? dayStart
});




}
/// @nodoc
class _$WorkoutLoggedCopyWithImpl<$Res>
    implements $WorkoutLoggedCopyWith<$Res> {
  _$WorkoutLoggedCopyWithImpl(this._self, this._then);

  final WorkoutLogged _self;
  final $Res Function(WorkoutLogged) _then;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workoutGroupId = null,Object? name = null,Object? type = null,Object? sets = null,Object? duration = freezed,Object? usualWorkoutId = freezed,Object? day = freezed,Object? dayStart = freezed,}) {
  return _then(WorkoutLogged(
null == workoutGroupId ? _self.workoutGroupId : workoutGroupId // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as WorkoutType,sets: null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,usualWorkoutId: freezed == usualWorkoutId ? _self.usualWorkoutId : usualWorkoutId // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,dayStart: freezed == dayStart ? _self.dayStart : dayStart // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,
  ));
}


}

/// @nodoc


class WorkoutRemoved implements WorkoutLogEvent {
  const WorkoutRemoved(this.id);
  

 final  String id;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutRemovedCopyWith<WorkoutRemoved> get copyWith => _$WorkoutRemovedCopyWithImpl<WorkoutRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'WorkoutLogEvent.workoutRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $WorkoutRemovedCopyWith<$Res> implements $WorkoutLogEventCopyWith<$Res> {
  factory $WorkoutRemovedCopyWith(WorkoutRemoved value, $Res Function(WorkoutRemoved) _then) = _$WorkoutRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$WorkoutRemovedCopyWithImpl<$Res>
    implements $WorkoutRemovedCopyWith<$Res> {
  _$WorkoutRemovedCopyWithImpl(this._self, this._then);

  final WorkoutRemoved _self;
  final $Res Function(WorkoutRemoved) _then;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(WorkoutRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WorkoutSetsChanged implements WorkoutLogEvent {
  const WorkoutSetsChanged(this.id, final  List<WorkoutSet> sets): _sets = sets;
  

 final  String id;
 final  List<WorkoutSet> _sets;
 List<WorkoutSet> get sets {
  if (_sets is EqualUnmodifiableListView) return _sets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sets);
}


/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutSetsChangedCopyWith<WorkoutSetsChanged> get copyWith => _$WorkoutSetsChangedCopyWithImpl<WorkoutSetsChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutSetsChanged&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._sets, _sets));
}


@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_sets));

@override
String toString() {
  return 'WorkoutLogEvent.workoutSetsChanged(id: $id, sets: $sets)';
}


}

/// @nodoc
abstract mixin class $WorkoutSetsChangedCopyWith<$Res> implements $WorkoutLogEventCopyWith<$Res> {
  factory $WorkoutSetsChangedCopyWith(WorkoutSetsChanged value, $Res Function(WorkoutSetsChanged) _then) = _$WorkoutSetsChangedCopyWithImpl;
@useResult
$Res call({
 String id, List<WorkoutSet> sets
});




}
/// @nodoc
class _$WorkoutSetsChangedCopyWithImpl<$Res>
    implements $WorkoutSetsChangedCopyWith<$Res> {
  _$WorkoutSetsChangedCopyWithImpl(this._self, this._then);

  final WorkoutSetsChanged _self;
  final $Res Function(WorkoutSetsChanged) _then;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sets = null,}) {
  return _then(WorkoutSetsChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == sets ? _self._sets : sets // ignore: cast_nullable_to_non_nullable
as List<WorkoutSet>,
  ));
}


}

/// @nodoc


class WorkoutDurationChanged implements WorkoutLogEvent {
  const WorkoutDurationChanged(this.id, this.duration);
  

 final  String id;
 final  Duration duration;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutDurationChangedCopyWith<WorkoutDurationChanged> get copyWith => _$WorkoutDurationChangedCopyWithImpl<WorkoutDurationChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutDurationChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,id,duration);

@override
String toString() {
  return 'WorkoutLogEvent.workoutDurationChanged(id: $id, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $WorkoutDurationChangedCopyWith<$Res> implements $WorkoutLogEventCopyWith<$Res> {
  factory $WorkoutDurationChangedCopyWith(WorkoutDurationChanged value, $Res Function(WorkoutDurationChanged) _then) = _$WorkoutDurationChangedCopyWithImpl;
@useResult
$Res call({
 String id, Duration duration
});




}
/// @nodoc
class _$WorkoutDurationChangedCopyWithImpl<$Res>
    implements $WorkoutDurationChangedCopyWith<$Res> {
  _$WorkoutDurationChangedCopyWithImpl(this._self, this._then);

  final WorkoutDurationChanged _self;
  final $Res Function(WorkoutDurationChanged) _then;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? duration = null,}) {
  return _then(WorkoutDurationChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class WorkoutLogStateRestored implements WorkoutLogEvent {
  const WorkoutLogStateRestored(this.state);
  

 final  WorkoutLogState state;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLogStateRestoredCopyWith<WorkoutLogStateRestored> get copyWith => _$WorkoutLogStateRestoredCopyWithImpl<WorkoutLogStateRestored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLogStateRestored&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'WorkoutLogEvent.stateRestored(state: $state)';
}


}

/// @nodoc
abstract mixin class $WorkoutLogStateRestoredCopyWith<$Res> implements $WorkoutLogEventCopyWith<$Res> {
  factory $WorkoutLogStateRestoredCopyWith(WorkoutLogStateRestored value, $Res Function(WorkoutLogStateRestored) _then) = _$WorkoutLogStateRestoredCopyWithImpl;
@useResult
$Res call({
 WorkoutLogState state
});


$WorkoutLogStateCopyWith<$Res> get state;

}
/// @nodoc
class _$WorkoutLogStateRestoredCopyWithImpl<$Res>
    implements $WorkoutLogStateRestoredCopyWith<$Res> {
  _$WorkoutLogStateRestoredCopyWithImpl(this._self, this._then);

  final WorkoutLogStateRestored _self;
  final $Res Function(WorkoutLogStateRestored) _then;

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(WorkoutLogStateRestored(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as WorkoutLogState,
  ));
}

/// Create a copy of WorkoutLogEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkoutLogStateCopyWith<$Res> get state {
  
  return $WorkoutLogStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
}
}


/// @nodoc
mixin _$WorkoutLogState {

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
 int get version; List<WorkoutLogEntry> get workoutEntries;/// The id of the workout logged most recently this session. Ephemeral: not
/// persisted, so a relaunch clears it, and it is ignored when comparing
/// state for cloud sync.
@JsonKey(includeFromJson: false, includeToJson: false) String? get justLoggedWorkoutId;
/// Create a copy of WorkoutLogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutLogStateCopyWith<WorkoutLogState> get copyWith => _$WorkoutLogStateCopyWithImpl<WorkoutLogState>(this as WorkoutLogState, _$identity);

  /// Serializes this WorkoutLogState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutLogState&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.workoutEntries, workoutEntries)&&(identical(other.justLoggedWorkoutId, justLoggedWorkoutId) || other.justLoggedWorkoutId == justLoggedWorkoutId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(workoutEntries),justLoggedWorkoutId);

@override
String toString() {
  return 'WorkoutLogState(version: $version, workoutEntries: $workoutEntries, justLoggedWorkoutId: $justLoggedWorkoutId)';
}


}

/// @nodoc
abstract mixin class $WorkoutLogStateCopyWith<$Res>  {
  factory $WorkoutLogStateCopyWith(WorkoutLogState value, $Res Function(WorkoutLogState) _then) = _$WorkoutLogStateCopyWithImpl;
@useResult
$Res call({
 int version, List<WorkoutLogEntry> workoutEntries,@JsonKey(includeFromJson: false, includeToJson: false) String? justLoggedWorkoutId
});




}
/// @nodoc
class _$WorkoutLogStateCopyWithImpl<$Res>
    implements $WorkoutLogStateCopyWith<$Res> {
  _$WorkoutLogStateCopyWithImpl(this._self, this._then);

  final WorkoutLogState _self;
  final $Res Function(WorkoutLogState) _then;

/// Create a copy of WorkoutLogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? workoutEntries = null,Object? justLoggedWorkoutId = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,workoutEntries: null == workoutEntries ? _self.workoutEntries : workoutEntries // ignore: cast_nullable_to_non_nullable
as List<WorkoutLogEntry>,justLoggedWorkoutId: freezed == justLoggedWorkoutId ? _self.justLoggedWorkoutId : justLoggedWorkoutId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutLogState].
extension WorkoutLogStatePatterns on WorkoutLogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutLogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutLogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutLogState value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutLogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutLogState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutLogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<WorkoutLogEntry> workoutEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedWorkoutId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutLogState() when $default != null:
return $default(_that.version,_that.workoutEntries,_that.justLoggedWorkoutId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<WorkoutLogEntry> workoutEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedWorkoutId)  $default,) {final _that = this;
switch (_that) {
case _WorkoutLogState():
return $default(_that.version,_that.workoutEntries,_that.justLoggedWorkoutId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<WorkoutLogEntry> workoutEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedWorkoutId)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutLogState() when $default != null:
return $default(_that.version,_that.workoutEntries,_that.justLoggedWorkoutId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WorkoutLogState extends WorkoutLogState {
  const _WorkoutLogState({this.version = 1, final  List<WorkoutLogEntry> workoutEntries = const <WorkoutLogEntry>[], @JsonKey(includeFromJson: false, includeToJson: false) this.justLoggedWorkoutId}): _workoutEntries = workoutEntries,super._();
  factory _WorkoutLogState.fromJson(Map<String, dynamic> json) => _$WorkoutLogStateFromJson(json);

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
@override@JsonKey() final  int version;
 final  List<WorkoutLogEntry> _workoutEntries;
@override@JsonKey() List<WorkoutLogEntry> get workoutEntries {
  if (_workoutEntries is EqualUnmodifiableListView) return _workoutEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_workoutEntries);
}

/// The id of the workout logged most recently this session. Ephemeral: not
/// persisted, so a relaunch clears it, and it is ignored when comparing
/// state for cloud sync.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? justLoggedWorkoutId;

/// Create a copy of WorkoutLogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutLogStateCopyWith<_WorkoutLogState> get copyWith => __$WorkoutLogStateCopyWithImpl<_WorkoutLogState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutLogStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutLogState&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._workoutEntries, _workoutEntries)&&(identical(other.justLoggedWorkoutId, justLoggedWorkoutId) || other.justLoggedWorkoutId == justLoggedWorkoutId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_workoutEntries),justLoggedWorkoutId);

@override
String toString() {
  return 'WorkoutLogState(version: $version, workoutEntries: $workoutEntries, justLoggedWorkoutId: $justLoggedWorkoutId)';
}


}

/// @nodoc
abstract mixin class _$WorkoutLogStateCopyWith<$Res> implements $WorkoutLogStateCopyWith<$Res> {
  factory _$WorkoutLogStateCopyWith(_WorkoutLogState value, $Res Function(_WorkoutLogState) _then) = __$WorkoutLogStateCopyWithImpl;
@override @useResult
$Res call({
 int version, List<WorkoutLogEntry> workoutEntries,@JsonKey(includeFromJson: false, includeToJson: false) String? justLoggedWorkoutId
});




}
/// @nodoc
class __$WorkoutLogStateCopyWithImpl<$Res>
    implements _$WorkoutLogStateCopyWith<$Res> {
  __$WorkoutLogStateCopyWithImpl(this._self, this._then);

  final _WorkoutLogState _self;
  final $Res Function(_WorkoutLogState) _then;

/// Create a copy of WorkoutLogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? workoutEntries = null,Object? justLoggedWorkoutId = freezed,}) {
  return _then(_WorkoutLogState(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,workoutEntries: null == workoutEntries ? _self._workoutEntries : workoutEntries // ignore: cast_nullable_to_non_nullable
as List<WorkoutLogEntry>,justLoggedWorkoutId: freezed == justLoggedWorkoutId ? _self.justLoggedWorkoutId : justLoggedWorkoutId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
