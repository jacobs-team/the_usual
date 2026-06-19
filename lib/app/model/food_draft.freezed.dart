// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodDraft {

 String get id; String get name; double get quantity; Nutrition get nutrition; bool get addToUsualMeals;
/// Create a copy of FoodDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodDraftCopyWith<FoodDraft> get copyWith => _$FoodDraftCopyWithImpl<FoodDraft>(this as FoodDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.addToUsualMeals, addToUsualMeals) || other.addToUsualMeals == addToUsualMeals));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,nutrition,addToUsualMeals);

@override
String toString() {
  return 'FoodDraft(id: $id, name: $name, quantity: $quantity, nutrition: $nutrition, addToUsualMeals: $addToUsualMeals)';
}


}

/// @nodoc
abstract mixin class $FoodDraftCopyWith<$Res>  {
  factory $FoodDraftCopyWith(FoodDraft value, $Res Function(FoodDraft) _then) = _$FoodDraftCopyWithImpl;
@useResult
$Res call({
 String id, String name, double quantity, Nutrition nutrition, bool addToUsualMeals
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$FoodDraftCopyWithImpl<$Res>
    implements $FoodDraftCopyWith<$Res> {
  _$FoodDraftCopyWithImpl(this._self, this._then);

  final FoodDraft _self;
  final $Res Function(FoodDraft) _then;

/// Create a copy of FoodDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? nutrition = null,Object? addToUsualMeals = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,addToUsualMeals: null == addToUsualMeals ? _self.addToUsualMeals : addToUsualMeals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of FoodDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [FoodDraft].
extension FoodDraftPatterns on FoodDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodDraft value)  $default,){
final _that = this;
switch (_that) {
case _FoodDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodDraft value)?  $default,){
final _that = this;
switch (_that) {
case _FoodDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  double quantity,  Nutrition nutrition,  bool addToUsualMeals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodDraft() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.nutrition,_that.addToUsualMeals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  double quantity,  Nutrition nutrition,  bool addToUsualMeals)  $default,) {final _that = this;
switch (_that) {
case _FoodDraft():
return $default(_that.id,_that.name,_that.quantity,_that.nutrition,_that.addToUsualMeals);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  double quantity,  Nutrition nutrition,  bool addToUsualMeals)?  $default,) {final _that = this;
switch (_that) {
case _FoodDraft() when $default != null:
return $default(_that.id,_that.name,_that.quantity,_that.nutrition,_that.addToUsualMeals);case _:
  return null;

}
}

}

/// @nodoc


class _FoodDraft implements FoodDraft {
  const _FoodDraft({required this.id, this.name = '', this.quantity = 1, this.nutrition = const Nutrition(), this.addToUsualMeals = false});
  

@override final  String id;
@override@JsonKey() final  String name;
@override@JsonKey() final  double quantity;
@override@JsonKey() final  Nutrition nutrition;
@override@JsonKey() final  bool addToUsualMeals;

/// Create a copy of FoodDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodDraftCopyWith<_FoodDraft> get copyWith => __$FoodDraftCopyWithImpl<_FoodDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodDraft&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.addToUsualMeals, addToUsualMeals) || other.addToUsualMeals == addToUsualMeals));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,quantity,nutrition,addToUsualMeals);

@override
String toString() {
  return 'FoodDraft(id: $id, name: $name, quantity: $quantity, nutrition: $nutrition, addToUsualMeals: $addToUsualMeals)';
}


}

/// @nodoc
abstract mixin class _$FoodDraftCopyWith<$Res> implements $FoodDraftCopyWith<$Res> {
  factory _$FoodDraftCopyWith(_FoodDraft value, $Res Function(_FoodDraft) _then) = __$FoodDraftCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, double quantity, Nutrition nutrition, bool addToUsualMeals
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$FoodDraftCopyWithImpl<$Res>
    implements _$FoodDraftCopyWith<$Res> {
  __$FoodDraftCopyWithImpl(this._self, this._then);

  final _FoodDraft _self;
  final $Res Function(_FoodDraft) _then;

/// Create a copy of FoodDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? quantity = null,Object? nutrition = null,Object? addToUsualMeals = null,}) {
  return _then(_FoodDraft(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,addToUsualMeals: null == addToUsualMeals ? _self.addToUsualMeals : addToUsualMeals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of FoodDraft
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
