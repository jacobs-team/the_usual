// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_meal_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiMealSuggestion {

 String get name; double get quantity; Nutrition get nutrition;
/// Create a copy of AiMealSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMealSuggestionCopyWith<AiMealSuggestion> get copyWith => _$AiMealSuggestionCopyWithImpl<AiMealSuggestion>(this as AiMealSuggestion, _$identity);

  /// Serializes this AiMealSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMealSuggestion&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,nutrition);

@override
String toString() {
  return 'AiMealSuggestion(name: $name, quantity: $quantity, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $AiMealSuggestionCopyWith<$Res>  {
  factory $AiMealSuggestionCopyWith(AiMealSuggestion value, $Res Function(AiMealSuggestion) _then) = _$AiMealSuggestionCopyWithImpl;
@useResult
$Res call({
 String name, double quantity, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$AiMealSuggestionCopyWithImpl<$Res>
    implements $AiMealSuggestionCopyWith<$Res> {
  _$AiMealSuggestionCopyWithImpl(this._self, this._then);

  final AiMealSuggestion _self;
  final $Res Function(AiMealSuggestion) _then;

/// Create a copy of AiMealSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? quantity = null,Object? nutrition = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}
/// Create a copy of AiMealSuggestion
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiMealSuggestion].
extension AiMealSuggestionPatterns on AiMealSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMealSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMealSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMealSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _AiMealSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMealSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _AiMealSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double quantity,  Nutrition nutrition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMealSuggestion() when $default != null:
return $default(_that.name,_that.quantity,_that.nutrition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double quantity,  Nutrition nutrition)  $default,) {final _that = this;
switch (_that) {
case _AiMealSuggestion():
return $default(_that.name,_that.quantity,_that.nutrition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double quantity,  Nutrition nutrition)?  $default,) {final _that = this;
switch (_that) {
case _AiMealSuggestion() when $default != null:
return $default(_that.name,_that.quantity,_that.nutrition);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _AiMealSuggestion implements AiMealSuggestion {
  const _AiMealSuggestion({required this.name, this.quantity = 1, this.nutrition = const Nutrition()});
  factory _AiMealSuggestion.fromJson(Map<String, dynamic> json) => _$AiMealSuggestionFromJson(json);

@override final  String name;
@override@JsonKey() final  double quantity;
@override@JsonKey() final  Nutrition nutrition;

/// Create a copy of AiMealSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMealSuggestionCopyWith<_AiMealSuggestion> get copyWith => __$AiMealSuggestionCopyWithImpl<_AiMealSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiMealSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMealSuggestion&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,quantity,nutrition);

@override
String toString() {
  return 'AiMealSuggestion(name: $name, quantity: $quantity, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class _$AiMealSuggestionCopyWith<$Res> implements $AiMealSuggestionCopyWith<$Res> {
  factory _$AiMealSuggestionCopyWith(_AiMealSuggestion value, $Res Function(_AiMealSuggestion) _then) = __$AiMealSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String name, double quantity, Nutrition nutrition
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$AiMealSuggestionCopyWithImpl<$Res>
    implements _$AiMealSuggestionCopyWith<$Res> {
  __$AiMealSuggestionCopyWithImpl(this._self, this._then);

  final _AiMealSuggestion _self;
  final $Res Function(_AiMealSuggestion) _then;

/// Create a copy of AiMealSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? quantity = null,Object? nutrition = null,}) {
  return _then(_AiMealSuggestion(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of AiMealSuggestion
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
