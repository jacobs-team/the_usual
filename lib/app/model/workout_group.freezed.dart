// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkoutGroup {

 String get id; String get name; int get order;
/// Create a copy of WorkoutGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkoutGroupCopyWith<WorkoutGroup> get copyWith => _$WorkoutGroupCopyWithImpl<WorkoutGroup>(this as WorkoutGroup, _$identity);

  /// Serializes this WorkoutGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkoutGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order);

@override
String toString() {
  return 'WorkoutGroup(id: $id, name: $name, order: $order)';
}


}

/// @nodoc
abstract mixin class $WorkoutGroupCopyWith<$Res>  {
  factory $WorkoutGroupCopyWith(WorkoutGroup value, $Res Function(WorkoutGroup) _then) = _$WorkoutGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name, int order
});




}
/// @nodoc
class _$WorkoutGroupCopyWithImpl<$Res>
    implements $WorkoutGroupCopyWith<$Res> {
  _$WorkoutGroupCopyWithImpl(this._self, this._then);

  final WorkoutGroup _self;
  final $Res Function(WorkoutGroup) _then;

/// Create a copy of WorkoutGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkoutGroup].
extension WorkoutGroupPatterns on WorkoutGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkoutGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkoutGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkoutGroup value)  $default,){
final _that = this;
switch (_that) {
case _WorkoutGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkoutGroup value)?  $default,){
final _that = this;
switch (_that) {
case _WorkoutGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkoutGroup() when $default != null:
return $default(_that.id,_that.name,_that.order);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int order)  $default,) {final _that = this;
switch (_that) {
case _WorkoutGroup():
return $default(_that.id,_that.name,_that.order);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int order)?  $default,) {final _that = this;
switch (_that) {
case _WorkoutGroup() when $default != null:
return $default(_that.id,_that.name,_that.order);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _WorkoutGroup implements WorkoutGroup {
  const _WorkoutGroup({required this.id, required this.name, required this.order});
  factory _WorkoutGroup.fromJson(Map<String, dynamic> json) => _$WorkoutGroupFromJson(json);

@override final  String id;
@override final  String name;
@override final  int order;

/// Create a copy of WorkoutGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkoutGroupCopyWith<_WorkoutGroup> get copyWith => __$WorkoutGroupCopyWithImpl<_WorkoutGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkoutGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkoutGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,order);

@override
String toString() {
  return 'WorkoutGroup(id: $id, name: $name, order: $order)';
}


}

/// @nodoc
abstract mixin class _$WorkoutGroupCopyWith<$Res> implements $WorkoutGroupCopyWith<$Res> {
  factory _$WorkoutGroupCopyWith(_WorkoutGroup value, $Res Function(_WorkoutGroup) _then) = __$WorkoutGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int order
});




}
/// @nodoc
class __$WorkoutGroupCopyWithImpl<$Res>
    implements _$WorkoutGroupCopyWith<$Res> {
  __$WorkoutGroupCopyWithImpl(this._self, this._then);

  final _WorkoutGroup _self;
  final $Res Function(_WorkoutGroup) _then;

/// Create a copy of WorkoutGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? order = null,}) {
  return _then(_WorkoutGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
