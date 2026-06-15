// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_log_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DailyLogEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLogEvent()';
}


}

/// @nodoc
class $DailyLogEventCopyWith<$Res>  {
$DailyLogEventCopyWith(DailyLogEvent _, $Res Function(DailyLogEvent) __);
}


/// Adds pattern-matching-related methods to [DailyLogEvent].
extension DailyLogEventPatterns on DailyLogEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealLogged value)?  mealLogged,TResult Function( MealEntryRemoved value)?  mealEntryRemoved,TResult Function( MealEntryNutritionChanged value)?  mealEntryNutritionChanged,TResult Function( MealEntryUsualMealLinked value)?  mealEntryUsualMealLinked,TResult Function( WeightLogged value)?  weightLogged,TResult Function( WeightOnDayChanged value)?  weightOnDayChanged,TResult Function( SampleDataSeeded value)?  sampleDataSeeded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealLogged value)  mealLogged,required TResult Function( MealEntryRemoved value)  mealEntryRemoved,required TResult Function( MealEntryNutritionChanged value)  mealEntryNutritionChanged,required TResult Function( MealEntryUsualMealLinked value)  mealEntryUsualMealLinked,required TResult Function( WeightLogged value)  weightLogged,required TResult Function( WeightOnDayChanged value)  weightOnDayChanged,required TResult Function( SampleDataSeeded value)  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that);case MealEntryRemoved():
return mealEntryRemoved(_that);case MealEntryNutritionChanged():
return mealEntryNutritionChanged(_that);case MealEntryUsualMealLinked():
return mealEntryUsualMealLinked(_that);case WeightLogged():
return weightLogged(_that);case WeightOnDayChanged():
return weightOnDayChanged(_that);case SampleDataSeeded():
return sampleDataSeeded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealLogged value)?  mealLogged,TResult? Function( MealEntryRemoved value)?  mealEntryRemoved,TResult? Function( MealEntryNutritionChanged value)?  mealEntryNutritionChanged,TResult? Function( MealEntryUsualMealLinked value)?  mealEntryUsualMealLinked,TResult? Function( WeightLogged value)?  weightLogged,TResult? Function( WeightOnDayChanged value)?  weightOnDayChanged,TResult? Function( SampleDataSeeded value)?  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? usualMealId,  String? photoPath)?  mealLogged,TResult Function( String id)?  mealEntryRemoved,TResult Function( String id,  Nutrition nutrition)?  mealEntryNutritionChanged,TResult Function( String id,  String usualMealId)?  mealEntryUsualMealLinked,TResult Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult Function( DateTime day,  double? weight,  WeightUnit weightUnit)?  weightOnDayChanged,TResult Function()?  sampleDataSeeded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.usualMealId,_that.photoPath);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? usualMealId,  String? photoPath)  mealLogged,required TResult Function( String id)  mealEntryRemoved,required TResult Function( String id,  Nutrition nutrition)  mealEntryNutritionChanged,required TResult Function( String id,  String usualMealId)  mealEntryUsualMealLinked,required TResult Function( double weight,  WeightUnit weightUnit)  weightLogged,required TResult Function( DateTime day,  double? weight,  WeightUnit weightUnit)  weightOnDayChanged,required TResult Function()  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.usualMealId,_that.photoPath);case MealEntryRemoved():
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged():
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryUsualMealLinked():
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged():
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged():
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit);case SampleDataSeeded():
return sampleDataSeeded();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  String? usualMealId,  String? photoPath)?  mealLogged,TResult? Function( String id)?  mealEntryRemoved,TResult? Function( String id,  Nutrition nutrition)?  mealEntryNutritionChanged,TResult? Function( String id,  String usualMealId)?  mealEntryUsualMealLinked,TResult? Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult? Function( DateTime day,  double? weight,  WeightUnit weightUnit)?  weightOnDayChanged,TResult? Function()?  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.usualMealId,_that.photoPath);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded();case _:
  return null;

}
}

}

/// @nodoc


class MealLogged implements DailyLogEvent {
  const MealLogged(this.mealOfTheDay, this.name, {this.nutrition = const Nutrition(), this.usualMealId, this.photoPath});
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
@JsonKey() final  Nutrition nutrition;
 final  String? usualMealId;
 final  String? photoPath;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLoggedCopyWith<MealLogged> get copyWith => _$MealLoggedCopyWithImpl<MealLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLogged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,nutrition,usualMealId,photoPath);

@override
String toString() {
  return 'DailyLogEvent.mealLogged(mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, usualMealId: $usualMealId, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $MealLoggedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealLoggedCopyWith(MealLogged value, $Res Function(MealLogged) _then) = _$MealLoggedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, String? usualMealId, String? photoPath
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealLoggedCopyWithImpl<$Res>
    implements $MealLoggedCopyWith<$Res> {
  _$MealLoggedCopyWithImpl(this._self, this._then);

  final MealLogged _self;
  final $Res Function(MealLogged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? usualMealId = freezed,Object? photoPath = freezed,}) {
  return _then(MealLogged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,usualMealId: freezed == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

/// @nodoc


class MealEntryRemoved implements DailyLogEvent {
  const MealEntryRemoved(this.id);
  

 final  String id;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryRemovedCopyWith<MealEntryRemoved> get copyWith => _$MealEntryRemovedCopyWithImpl<MealEntryRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'DailyLogEvent.mealEntryRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $MealEntryRemovedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryRemovedCopyWith(MealEntryRemoved value, $Res Function(MealEntryRemoved) _then) = _$MealEntryRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$MealEntryRemovedCopyWithImpl<$Res>
    implements $MealEntryRemovedCopyWith<$Res> {
  _$MealEntryRemovedCopyWithImpl(this._self, this._then);

  final MealEntryRemoved _self;
  final $Res Function(MealEntryRemoved) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(MealEntryRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MealEntryNutritionChanged implements DailyLogEvent {
  const MealEntryNutritionChanged(this.id, this.nutrition);
  

 final  String id;
 final  Nutrition nutrition;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryNutritionChangedCopyWith<MealEntryNutritionChanged> get copyWith => _$MealEntryNutritionChangedCopyWithImpl<MealEntryNutritionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryNutritionChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,id,nutrition);

@override
String toString() {
  return 'DailyLogEvent.mealEntryNutritionChanged(id: $id, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $MealEntryNutritionChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryNutritionChangedCopyWith(MealEntryNutritionChanged value, $Res Function(MealEntryNutritionChanged) _then) = _$MealEntryNutritionChangedCopyWithImpl;
@useResult
$Res call({
 String id, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealEntryNutritionChangedCopyWithImpl<$Res>
    implements $MealEntryNutritionChangedCopyWith<$Res> {
  _$MealEntryNutritionChangedCopyWithImpl(this._self, this._then);

  final MealEntryNutritionChanged _self;
  final $Res Function(MealEntryNutritionChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nutrition = null,}) {
  return _then(MealEntryNutritionChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NutritionCopyWith<$Res> get nutrition {
  
  return $NutritionCopyWith<$Res>(_self.nutrition, (value) {
    return _then(_self.copyWith(nutrition: value));
  });
}
}

/// @nodoc


class MealEntryUsualMealLinked implements DailyLogEvent {
  const MealEntryUsualMealLinked(this.id, this.usualMealId);
  

 final  String id;
 final  String usualMealId;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryUsualMealLinkedCopyWith<MealEntryUsualMealLinked> get copyWith => _$MealEntryUsualMealLinkedCopyWithImpl<MealEntryUsualMealLinked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryUsualMealLinked&&(identical(other.id, id) || other.id == id)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId));
}


@override
int get hashCode => Object.hash(runtimeType,id,usualMealId);

@override
String toString() {
  return 'DailyLogEvent.mealEntryUsualMealLinked(id: $id, usualMealId: $usualMealId)';
}


}

/// @nodoc
abstract mixin class $MealEntryUsualMealLinkedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryUsualMealLinkedCopyWith(MealEntryUsualMealLinked value, $Res Function(MealEntryUsualMealLinked) _then) = _$MealEntryUsualMealLinkedCopyWithImpl;
@useResult
$Res call({
 String id, String usualMealId
});




}
/// @nodoc
class _$MealEntryUsualMealLinkedCopyWithImpl<$Res>
    implements $MealEntryUsualMealLinkedCopyWith<$Res> {
  _$MealEntryUsualMealLinkedCopyWithImpl(this._self, this._then);

  final MealEntryUsualMealLinked _self;
  final $Res Function(MealEntryUsualMealLinked) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? usualMealId = null,}) {
  return _then(MealEntryUsualMealLinked(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class WeightLogged implements DailyLogEvent {
  const WeightLogged(this.weight, this.weightUnit);
  

 final  double weight;
 final  WeightUnit weightUnit;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightLoggedCopyWith<WeightLogged> get copyWith => _$WeightLoggedCopyWithImpl<WeightLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightLogged&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weight,weightUnit);

@override
String toString() {
  return 'DailyLogEvent.weightLogged(weight: $weight, weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $WeightLoggedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $WeightLoggedCopyWith(WeightLogged value, $Res Function(WeightLogged) _then) = _$WeightLoggedCopyWithImpl;
@useResult
$Res call({
 double weight, WeightUnit weightUnit
});




}
/// @nodoc
class _$WeightLoggedCopyWithImpl<$Res>
    implements $WeightLoggedCopyWith<$Res> {
  _$WeightLoggedCopyWithImpl(this._self, this._then);

  final WeightLogged _self;
  final $Res Function(WeightLogged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weight = null,Object? weightUnit = null,}) {
  return _then(WeightLogged(
null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class WeightOnDayChanged implements DailyLogEvent {
  const WeightOnDayChanged(this.day, this.weight, this.weightUnit);
  

 final  DateTime day;
 final  double? weight;
 final  WeightUnit weightUnit;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightOnDayChangedCopyWith<WeightOnDayChanged> get copyWith => _$WeightOnDayChangedCopyWithImpl<WeightOnDayChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightOnDayChanged&&(identical(other.day, day) || other.day == day)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,day,weight,weightUnit);

@override
String toString() {
  return 'DailyLogEvent.weightOnDayChanged(day: $day, weight: $weight, weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $WeightOnDayChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $WeightOnDayChangedCopyWith(WeightOnDayChanged value, $Res Function(WeightOnDayChanged) _then) = _$WeightOnDayChangedCopyWithImpl;
@useResult
$Res call({
 DateTime day, double? weight, WeightUnit weightUnit
});




}
/// @nodoc
class _$WeightOnDayChangedCopyWithImpl<$Res>
    implements $WeightOnDayChangedCopyWith<$Res> {
  _$WeightOnDayChangedCopyWithImpl(this._self, this._then);

  final WeightOnDayChanged _self;
  final $Res Function(WeightOnDayChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? day = null,Object? weight = freezed,Object? weightUnit = null,}) {
  return _then(WeightOnDayChanged(
null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class SampleDataSeeded implements DailyLogEvent {
  const SampleDataSeeded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDataSeeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DailyLogEvent.sampleDataSeeded()';
}


}





/// @nodoc
mixin _$DailyLogState {

 List<MealLogEntry> get mealEntries; List<WeightEntry> get weightEntries;
/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyLogStateCopyWith<DailyLogState> get copyWith => _$DailyLogStateCopyWithImpl<DailyLogState>(this as DailyLogState, _$identity);

  /// Serializes this DailyLogState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogState&&const DeepCollectionEquality().equals(other.mealEntries, mealEntries)&&const DeepCollectionEquality().equals(other.weightEntries, weightEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mealEntries),const DeepCollectionEquality().hash(weightEntries));

@override
String toString() {
  return 'DailyLogState(mealEntries: $mealEntries, weightEntries: $weightEntries)';
}


}

/// @nodoc
abstract mixin class $DailyLogStateCopyWith<$Res>  {
  factory $DailyLogStateCopyWith(DailyLogState value, $Res Function(DailyLogState) _then) = _$DailyLogStateCopyWithImpl;
@useResult
$Res call({
 List<MealLogEntry> mealEntries, List<WeightEntry> weightEntries
});




}
/// @nodoc
class _$DailyLogStateCopyWithImpl<$Res>
    implements $DailyLogStateCopyWith<$Res> {
  _$DailyLogStateCopyWithImpl(this._self, this._then);

  final DailyLogState _self;
  final $Res Function(DailyLogState) _then;

/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mealEntries = null,Object? weightEntries = null,}) {
  return _then(_self.copyWith(
mealEntries: null == mealEntries ? _self.mealEntries : mealEntries // ignore: cast_nullable_to_non_nullable
as List<MealLogEntry>,weightEntries: null == weightEntries ? _self.weightEntries : weightEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyLogState].
extension DailyLogStatePatterns on DailyLogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyLogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyLogState value)  $default,){
final _that = this;
switch (_that) {
case _DailyLogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyLogState value)?  $default,){
final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
return $default(_that.mealEntries,_that.weightEntries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries)  $default,) {final _that = this;
switch (_that) {
case _DailyLogState():
return $default(_that.mealEntries,_that.weightEntries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries)?  $default,) {final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
return $default(_that.mealEntries,_that.weightEntries);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DailyLogState extends DailyLogState {
  const _DailyLogState({final  List<MealLogEntry> mealEntries = const <MealLogEntry>[], final  List<WeightEntry> weightEntries = const <WeightEntry>[]}): _mealEntries = mealEntries,_weightEntries = weightEntries,super._();
  factory _DailyLogState.fromJson(Map<String, dynamic> json) => _$DailyLogStateFromJson(json);

 final  List<MealLogEntry> _mealEntries;
@override@JsonKey() List<MealLogEntry> get mealEntries {
  if (_mealEntries is EqualUnmodifiableListView) return _mealEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mealEntries);
}

 final  List<WeightEntry> _weightEntries;
@override@JsonKey() List<WeightEntry> get weightEntries {
  if (_weightEntries is EqualUnmodifiableListView) return _weightEntries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weightEntries);
}


/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyLogStateCopyWith<_DailyLogState> get copyWith => __$DailyLogStateCopyWithImpl<_DailyLogState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyLogStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyLogState&&const DeepCollectionEquality().equals(other._mealEntries, _mealEntries)&&const DeepCollectionEquality().equals(other._weightEntries, _weightEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mealEntries),const DeepCollectionEquality().hash(_weightEntries));

@override
String toString() {
  return 'DailyLogState(mealEntries: $mealEntries, weightEntries: $weightEntries)';
}


}

/// @nodoc
abstract mixin class _$DailyLogStateCopyWith<$Res> implements $DailyLogStateCopyWith<$Res> {
  factory _$DailyLogStateCopyWith(_DailyLogState value, $Res Function(_DailyLogState) _then) = __$DailyLogStateCopyWithImpl;
@override @useResult
$Res call({
 List<MealLogEntry> mealEntries, List<WeightEntry> weightEntries
});




}
/// @nodoc
class __$DailyLogStateCopyWithImpl<$Res>
    implements _$DailyLogStateCopyWith<$Res> {
  __$DailyLogStateCopyWithImpl(this._self, this._then);

  final _DailyLogState _self;
  final $Res Function(_DailyLogState) _then;

/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mealEntries = null,Object? weightEntries = null,}) {
  return _then(_DailyLogState(
mealEntries: null == mealEntries ? _self._mealEntries : mealEntries // ignore: cast_nullable_to_non_nullable
as List<MealLogEntry>,weightEntries: null == weightEntries ? _self._weightEntries : weightEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntry>,
  ));
}


}

// dart format on
