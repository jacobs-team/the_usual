// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealLogEntry {

 String get id; DateTime get loggedAt; MealOfTheDay get mealOfTheDay; String get name; Nutrition get nutrition; double get quantity; String? get usualMealId; String? get photoPath;
/// Create a copy of MealLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLogEntryCopyWith<MealLogEntry> get copyWith => _$MealLogEntryCopyWithImpl<MealLogEntry>(this as MealLogEntry, _$identity);

  /// Serializes this MealLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,mealOfTheDay,name,nutrition,quantity,usualMealId,photoPath);

@override
String toString() {
  return 'MealLogEntry(id: $id, loggedAt: $loggedAt, mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, quantity: $quantity, usualMealId: $usualMealId, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $MealLogEntryCopyWith<$Res>  {
  factory $MealLogEntryCopyWith(MealLogEntry value, $Res Function(MealLogEntry) _then) = _$MealLogEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime loggedAt, MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, double quantity, String? usualMealId, String? photoPath
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealLogEntryCopyWithImpl<$Res>
    implements $MealLogEntryCopyWith<$Res> {
  _$MealLogEntryCopyWithImpl(this._self, this._then);

  final MealLogEntry _self;
  final $Res Function(MealLogEntry) _then;

/// Create a copy of MealLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? loggedAt = null,Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? quantity = null,Object? usualMealId = freezed,Object? photoPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,usualMealId: freezed == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of MealLogEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}


/// Adds pattern-matching-related methods to [MealLogEntry].
extension MealLogEntryPatterns on MealLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _MealLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _MealLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealLogEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime loggedAt,  MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _MealLogEntry():
return $default(_that.id,_that.loggedAt,_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime loggedAt,  MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _MealLogEntry() when $default != null:
return $default(_that.id,_that.loggedAt,_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _MealLogEntry extends MealLogEntry {
  const _MealLogEntry({required this.id, required this.loggedAt, required this.mealOfTheDay, required this.name, this.nutrition = const Nutrition(), this.quantity = 1, this.usualMealId, this.photoPath}): super._();
  factory _MealLogEntry.fromJson(Map<String, dynamic> json) => _$MealLogEntryFromJson(json);

@override final  String id;
@override final  DateTime loggedAt;
@override final  MealOfTheDay mealOfTheDay;
@override final  String name;
@override@JsonKey() final  Nutrition nutrition;
@override@JsonKey() final  double quantity;
@override final  String? usualMealId;
@override final  String? photoPath;

/// Create a copy of MealLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealLogEntryCopyWith<_MealLogEntry> get copyWith => __$MealLogEntryCopyWithImpl<_MealLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MealLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.loggedAt, loggedAt) || other.loggedAt == loggedAt)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,loggedAt,mealOfTheDay,name,nutrition,quantity,usualMealId,photoPath);

@override
String toString() {
  return 'MealLogEntry(id: $id, loggedAt: $loggedAt, mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, quantity: $quantity, usualMealId: $usualMealId, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$MealLogEntryCopyWith<$Res> implements $MealLogEntryCopyWith<$Res> {
  factory _$MealLogEntryCopyWith(_MealLogEntry value, $Res Function(_MealLogEntry) _then) = __$MealLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime loggedAt, MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, double quantity, String? usualMealId, String? photoPath
});


@override $NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class __$MealLogEntryCopyWithImpl<$Res>
    implements _$MealLogEntryCopyWith<$Res> {
  __$MealLogEntryCopyWithImpl(this._self, this._then);

  final _MealLogEntry _self;
  final $Res Function(_MealLogEntry) _then;

/// Create a copy of MealLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? loggedAt = null,Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? quantity = null,Object? usualMealId = freezed,Object? photoPath = freezed,}) {
  return _then(_MealLogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,loggedAt: null == loggedAt ? _self.loggedAt : loggedAt // ignore: cast_nullable_to_non_nullable
as DateTime,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,usualMealId: freezed == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of MealLogEntry
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
