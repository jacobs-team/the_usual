// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usual_meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
UsualMeal _$UsualMealFromJson(
  Map<String, dynamic> json
) {
    return _UsualItem.fromJson(
      json
    );
}

/// @nodoc
mixin _$UsualMeal {

 String get id; String get name; String? get photoPath;
/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealCopyWith<UsualMeal> get copyWith => _$UsualMealCopyWithImpl<UsualMeal>(this as UsualMeal, _$identity);

  /// Serializes this UsualMeal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoPath);

@override
String toString() {
  return 'UsualMeal(id: $id, name: $name, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $UsualMealCopyWith<$Res>  {
  factory $UsualMealCopyWith(UsualMeal value, $Res Function(UsualMeal) _then) = _$UsualMealCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoPath
});




}
/// @nodoc
class _$UsualMealCopyWithImpl<$Res>
    implements $UsualMealCopyWith<$Res> {
  _$UsualMealCopyWithImpl(this._self, this._then);

  final UsualMeal _self;
  final $Res Function(UsualMeal) _then;

/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UsualMeal].
extension UsualMealPatterns on UsualMeal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsualItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsualItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsualItem value)  $default,){
final _that = this;
switch (_that) {
case _UsualItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsualItem value)?  $default,){
final _that = this;
switch (_that) {
case _UsualItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsualItem() when $default != null:
return $default(_that.id,_that.name,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _UsualItem():
return $default(_that.id,_that.name,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _UsualItem() when $default != null:
return $default(_that.id,_that.name,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UsualItem implements UsualMeal {
  const _UsualItem({required this.id, required this.name, this.photoPath});
  factory _UsualItem.fromJson(Map<String, dynamic> json) => _$UsualItemFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? photoPath;

/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsualItemCopyWith<_UsualItem> get copyWith => __$UsualItemCopyWithImpl<_UsualItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsualItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsualItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoPath);

@override
String toString() {
  return 'UsualMeal(id: $id, name: $name, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$UsualItemCopyWith<$Res> implements $UsualMealCopyWith<$Res> {
  factory _$UsualItemCopyWith(_UsualItem value, $Res Function(_UsualItem) _then) = __$UsualItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoPath
});




}
/// @nodoc
class __$UsualItemCopyWithImpl<$Res>
    implements _$UsualItemCopyWith<$Res> {
  __$UsualItemCopyWithImpl(this._self, this._then);

  final _UsualItem _self;
  final $Res Function(_UsualItem) _then;

/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoPath = freezed,}) {
  return _then(_UsualItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
