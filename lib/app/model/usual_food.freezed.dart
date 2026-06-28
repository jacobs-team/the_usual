// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usual_food.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UsualFood {

 String get id; String get name; Nutrition get nutrition;
/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualFoodCopyWith<UsualFood> get copyWith => _$UsualFoodCopyWithImpl<UsualFood>(this as UsualFood, _$identity);

  /// Serializes this UsualFood to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualFood&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nutrition);

@override
String toString() {
  return 'UsualFood(id: $id, name: $name, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $UsualFoodCopyWith<$Res>  {
  factory $UsualFoodCopyWith(UsualFood value, $Res Function(UsualFood) _then) = _$UsualFoodCopyWithImpl;
@useResult
$Res call({
 String id, String name, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$UsualFoodCopyWithImpl<$Res>
    implements $UsualFoodCopyWith<$Res> {
  _$UsualFoodCopyWithImpl(this._self, this._then);

  final UsualFood _self;
  final $Res Function(UsualFood) _then;

/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nutrition = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}
/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [UsualFood].
extension UsualFoodPatterns on UsualFood {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsualFood value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsualFood() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsualFood value)  $default,){
final _that = this;
switch (_that) {
case _UsualFood():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsualFood value)?  $default,){
final _that = this;
switch (_that) {
case _UsualFood() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  Nutrition nutrition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsualFood() when $default != null:
return $default(_that.id,_that.name,_that.nutrition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  Nutrition nutrition)  $default,) {final _that = this;
switch (_that) {
case _UsualFood():
return $default(_that.id,_that.name,_that.nutrition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  Nutrition nutrition)?  $default,) {final _that = this;
switch (_that) {
case _UsualFood() when $default != null:
return $default(_that.id,_that.name,_that.nutrition);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UsualFood implements UsualFood {
  const _UsualFood({required this.id, required this.name, this.nutrition = const Nutrition()});
  factory _UsualFood.fromJson(Map<String, dynamic> json) => _$UsualFoodFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  Nutrition nutrition;

/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsualFoodCopyWith<_UsualFood> get copyWith => __$UsualFoodCopyWithImpl<_UsualFood>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsualFoodToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsualFood&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nutrition);

@override
String toString() {
  return 'UsualFood(id: $id, name: $name, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class _$UsualFoodCopyWith<$Res> implements $UsualFoodCopyWith<$Res> {
  factory _$UsualFoodCopyWith(_UsualFood value, $Res Function(_UsualFood) _then) = __$UsualFoodCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, Nutrition nutrition
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$UsualFoodCopyWithImpl<$Res>
    implements _$UsualFoodCopyWith<$Res> {
  __$UsualFoodCopyWithImpl(this._self, this._then);

  final _UsualFood _self;
  final $Res Function(_UsualFood) _then;

/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nutrition = null,}) {
  return _then(_UsualFood(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of UsualFood
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

// dart format on
