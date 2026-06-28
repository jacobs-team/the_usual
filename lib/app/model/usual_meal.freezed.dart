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

/// @nodoc
mixin _$UsualMeal {

 String get id; String get name; String? get photoPath; Nutrition get nutrition; List<MealComponent> get components;
/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UsualMealCopyWith<UsualMeal> get copyWith => _$UsualMealCopyWithImpl<UsualMeal>(this as UsualMeal, _$identity);

  /// Serializes this UsualMeal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UsualMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&const DeepCollectionEquality().equals(other.components, components));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoPath,nutrition,const DeepCollectionEquality().hash(components));

@override
String toString() {
  return 'UsualMeal(id: $id, name: $name, photoPath: $photoPath, nutrition: $nutrition, components: $components)';
}


}

/// @nodoc
abstract mixin class $UsualMealCopyWith<$Res>  {
  factory $UsualMealCopyWith(UsualMeal value, $Res Function(UsualMeal) _then) = _$UsualMealCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoPath, Nutrition nutrition, List<MealComponent> components
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$UsualMealCopyWithImpl<$Res>
    implements $UsualMealCopyWith<$Res> {
  _$UsualMealCopyWithImpl(this._self, this._then);

  final UsualMeal _self;
  final $Res Function(UsualMeal) _then;

/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoPath = freezed,Object? nutrition = null,Object? components = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,components: null == components ? _self.components : components // ignore: cast_nullable_to_non_nullable
as List<MealComponent>,
  ));
}
/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UsualMeal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UsualMeal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UsualMeal value)  $default,){
final _that = this;
switch (_that) {
case _UsualMeal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UsualMeal value)?  $default,){
final _that = this;
switch (_that) {
case _UsualMeal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoPath,  Nutrition nutrition,  List<MealComponent> components)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UsualMeal() when $default != null:
return $default(_that.id,_that.name,_that.photoPath,_that.nutrition,_that.components);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoPath,  Nutrition nutrition,  List<MealComponent> components)  $default,) {final _that = this;
switch (_that) {
case _UsualMeal():
return $default(_that.id,_that.name,_that.photoPath,_that.nutrition,_that.components);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoPath,  Nutrition nutrition,  List<MealComponent> components)?  $default,) {final _that = this;
switch (_that) {
case _UsualMeal() when $default != null:
return $default(_that.id,_that.name,_that.photoPath,_that.nutrition,_that.components);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _UsualMeal implements UsualMeal {
  const _UsualMeal({required this.id, required this.name, this.photoPath, this.nutrition = const Nutrition(), final  List<MealComponent> components = const <MealComponent>[]}): _components = components;
  factory _UsualMeal.fromJson(Map<String, dynamic> json) => _$UsualMealFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? photoPath;
@override@JsonKey() final  Nutrition nutrition;
 final  List<MealComponent> _components;
@override@JsonKey() List<MealComponent> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}


/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UsualMealCopyWith<_UsualMeal> get copyWith => __$UsualMealCopyWithImpl<_UsualMeal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UsualMealToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UsualMeal&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&const DeepCollectionEquality().equals(other._components, _components));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoPath,nutrition,const DeepCollectionEquality().hash(_components));

@override
String toString() {
  return 'UsualMeal(id: $id, name: $name, photoPath: $photoPath, nutrition: $nutrition, components: $components)';
}


}

/// @nodoc
abstract mixin class _$UsualMealCopyWith<$Res> implements $UsualMealCopyWith<$Res> {
  factory _$UsualMealCopyWith(_UsualMeal value, $Res Function(_UsualMeal) _then) = __$UsualMealCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoPath, Nutrition nutrition, List<MealComponent> components
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$UsualMealCopyWithImpl<$Res>
    implements _$UsualMealCopyWith<$Res> {
  __$UsualMealCopyWithImpl(this._self, this._then);

  final _UsualMeal _self;
  final $Res Function(_UsualMeal) _then;

/// Create a copy of UsualMeal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoPath = freezed,Object? nutrition = null,Object? components = null,}) {
  return _then(_UsualMeal(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<MealComponent>,
  ));
}

/// Create a copy of UsualMeal
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
