// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_component.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealComponent {

 String get name; Nutrition get nutrition; double get quantity; String? get usualFoodId;
/// Create a copy of MealComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealComponentCopyWith<MealComponent> get copyWith => _$MealComponentCopyWithImpl<MealComponent>(this as MealComponent, _$identity);

  /// Serializes this MealComponent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealComponent&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.usualFoodId, usualFoodId) || other.usualFoodId == usualFoodId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nutrition,quantity,usualFoodId);

@override
String toString() {
  return 'MealComponent(name: $name, nutrition: $nutrition, quantity: $quantity, usualFoodId: $usualFoodId)';
}


}

/// @nodoc
abstract mixin class $MealComponentCopyWith<$Res>  {
  factory $MealComponentCopyWith(MealComponent value, $Res Function(MealComponent) _then) = _$MealComponentCopyWithImpl;
@useResult
$Res call({
 String name, Nutrition nutrition, double quantity, String? usualFoodId
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealComponentCopyWithImpl<$Res>
    implements $MealComponentCopyWith<$Res> {
  _$MealComponentCopyWithImpl(this._self, this._then);

  final MealComponent _self;
  final $Res Function(MealComponent) _then;

/// Create a copy of MealComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? nutrition = null,Object? quantity = null,Object? usualFoodId = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,usualFoodId: freezed == usualFoodId ? _self.usualFoodId : usualFoodId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MealComponent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [MealComponent].
extension MealComponentPatterns on MealComponent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealComponent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealComponent value)  $default,){
final _that = this;
switch (_that) {
case _MealComponent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealComponent value)?  $default,){
final _that = this;
switch (_that) {
case _MealComponent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  Nutrition nutrition,  double quantity,  String? usualFoodId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealComponent() when $default != null:
return $default(_that.name,_that.nutrition,_that.quantity,_that.usualFoodId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  Nutrition nutrition,  double quantity,  String? usualFoodId)  $default,) {final _that = this;
switch (_that) {
case _MealComponent():
return $default(_that.name,_that.nutrition,_that.quantity,_that.usualFoodId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  Nutrition nutrition,  double quantity,  String? usualFoodId)?  $default,) {final _that = this;
switch (_that) {
case _MealComponent() when $default != null:
return $default(_that.name,_that.nutrition,_that.quantity,_that.usualFoodId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MealComponent extends MealComponent {
  const _MealComponent({required this.name, this.nutrition = const Nutrition(), this.quantity = 1, this.usualFoodId}): super._();
  factory _MealComponent.fromJson(Map<String, dynamic> json) => _$MealComponentFromJson(json);

@override final  String name;
@override@JsonKey() final  Nutrition nutrition;
@override@JsonKey() final  double quantity;
@override final  String? usualFoodId;

/// Create a copy of MealComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealComponentCopyWith<_MealComponent> get copyWith => __$MealComponentCopyWithImpl<_MealComponent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealComponentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealComponent&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.usualFoodId, usualFoodId) || other.usualFoodId == usualFoodId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,nutrition,quantity,usualFoodId);

@override
String toString() {
  return 'MealComponent(name: $name, nutrition: $nutrition, quantity: $quantity, usualFoodId: $usualFoodId)';
}


}

/// @nodoc
abstract mixin class _$MealComponentCopyWith<$Res> implements $MealComponentCopyWith<$Res> {
  factory _$MealComponentCopyWith(_MealComponent value, $Res Function(_MealComponent) _then) = __$MealComponentCopyWithImpl;
@override @useResult
$Res call({
 String name, Nutrition nutrition, double quantity, String? usualFoodId
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$MealComponentCopyWithImpl<$Res>
    implements _$MealComponentCopyWith<$Res> {
  __$MealComponentCopyWithImpl(this._self, this._then);

  final _MealComponent _self;
  final $Res Function(_MealComponent) _then;

/// Create a copy of MealComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nutrition = null,Object? quantity = null,Object? usualFoodId = freezed,}) {
  return _then(_MealComponent(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,usualFoodId: freezed == usualFoodId ? _self.usualFoodId : usualFoodId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MealComponent
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
