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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealLogged value)?  mealLogged,TResult Function( MealEntryRemoved value)?  mealEntryRemoved,TResult Function( MealEntryNutritionChanged value)?  mealEntryNutritionChanged,TResult Function( MealEntryQuantityChanged value)?  mealEntryQuantityChanged,TResult Function( MealEntryComponentQuantityChanged value)?  mealEntryComponentQuantityChanged,TResult Function( MealEntryComponentNutritionChanged value)?  mealEntryComponentNutritionChanged,TResult Function( MealEntryComponentAdded value)?  mealEntryComponentAdded,TResult Function( MealEntryComponentRemoved value)?  mealEntryComponentRemoved,TResult Function( MealEntryComponentUsualFoodLinked value)?  mealEntryComponentUsualFoodLinked,TResult Function( MealEntryUsualMealLinked value)?  mealEntryUsualMealLinked,TResult Function( WeightLogged value)?  weightLogged,TResult Function( WeightOnDayChanged value)?  weightOnDayChanged,TResult Function( DailyLogStateRestored value)?  stateRestored,TResult Function( SampleDataSeeded value)?  sampleDataSeeded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that);case MealEntryQuantityChanged() when mealEntryQuantityChanged != null:
return mealEntryQuantityChanged(_that);case MealEntryComponentQuantityChanged() when mealEntryComponentQuantityChanged != null:
return mealEntryComponentQuantityChanged(_that);case MealEntryComponentNutritionChanged() when mealEntryComponentNutritionChanged != null:
return mealEntryComponentNutritionChanged(_that);case MealEntryComponentAdded() when mealEntryComponentAdded != null:
return mealEntryComponentAdded(_that);case MealEntryComponentRemoved() when mealEntryComponentRemoved != null:
return mealEntryComponentRemoved(_that);case MealEntryComponentUsualFoodLinked() when mealEntryComponentUsualFoodLinked != null:
return mealEntryComponentUsualFoodLinked(_that);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that);case DailyLogStateRestored() when stateRestored != null:
return stateRestored(_that);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealLogged value)  mealLogged,required TResult Function( MealEntryRemoved value)  mealEntryRemoved,required TResult Function( MealEntryNutritionChanged value)  mealEntryNutritionChanged,required TResult Function( MealEntryQuantityChanged value)  mealEntryQuantityChanged,required TResult Function( MealEntryComponentQuantityChanged value)  mealEntryComponentQuantityChanged,required TResult Function( MealEntryComponentNutritionChanged value)  mealEntryComponentNutritionChanged,required TResult Function( MealEntryComponentAdded value)  mealEntryComponentAdded,required TResult Function( MealEntryComponentRemoved value)  mealEntryComponentRemoved,required TResult Function( MealEntryComponentUsualFoodLinked value)  mealEntryComponentUsualFoodLinked,required TResult Function( MealEntryUsualMealLinked value)  mealEntryUsualMealLinked,required TResult Function( WeightLogged value)  weightLogged,required TResult Function( WeightOnDayChanged value)  weightOnDayChanged,required TResult Function( DailyLogStateRestored value)  stateRestored,required TResult Function( SampleDataSeeded value)  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that);case MealEntryRemoved():
return mealEntryRemoved(_that);case MealEntryNutritionChanged():
return mealEntryNutritionChanged(_that);case MealEntryQuantityChanged():
return mealEntryQuantityChanged(_that);case MealEntryComponentQuantityChanged():
return mealEntryComponentQuantityChanged(_that);case MealEntryComponentNutritionChanged():
return mealEntryComponentNutritionChanged(_that);case MealEntryComponentAdded():
return mealEntryComponentAdded(_that);case MealEntryComponentRemoved():
return mealEntryComponentRemoved(_that);case MealEntryComponentUsualFoodLinked():
return mealEntryComponentUsualFoodLinked(_that);case MealEntryUsualMealLinked():
return mealEntryUsualMealLinked(_that);case WeightLogged():
return weightLogged(_that);case WeightOnDayChanged():
return weightOnDayChanged(_that);case DailyLogStateRestored():
return stateRestored(_that);case SampleDataSeeded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealLogged value)?  mealLogged,TResult? Function( MealEntryRemoved value)?  mealEntryRemoved,TResult? Function( MealEntryNutritionChanged value)?  mealEntryNutritionChanged,TResult? Function( MealEntryQuantityChanged value)?  mealEntryQuantityChanged,TResult? Function( MealEntryComponentQuantityChanged value)?  mealEntryComponentQuantityChanged,TResult? Function( MealEntryComponentNutritionChanged value)?  mealEntryComponentNutritionChanged,TResult? Function( MealEntryComponentAdded value)?  mealEntryComponentAdded,TResult? Function( MealEntryComponentRemoved value)?  mealEntryComponentRemoved,TResult? Function( MealEntryComponentUsualFoodLinked value)?  mealEntryComponentUsualFoodLinked,TResult? Function( MealEntryUsualMealLinked value)?  mealEntryUsualMealLinked,TResult? Function( WeightLogged value)?  weightLogged,TResult? Function( WeightOnDayChanged value)?  weightOnDayChanged,TResult? Function( DailyLogStateRestored value)?  stateRestored,TResult? Function( SampleDataSeeded value)?  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that);case MealEntryQuantityChanged() when mealEntryQuantityChanged != null:
return mealEntryQuantityChanged(_that);case MealEntryComponentQuantityChanged() when mealEntryComponentQuantityChanged != null:
return mealEntryComponentQuantityChanged(_that);case MealEntryComponentNutritionChanged() when mealEntryComponentNutritionChanged != null:
return mealEntryComponentNutritionChanged(_that);case MealEntryComponentAdded() when mealEntryComponentAdded != null:
return mealEntryComponentAdded(_that);case MealEntryComponentRemoved() when mealEntryComponentRemoved != null:
return mealEntryComponentRemoved(_that);case MealEntryComponentUsualFoodLinked() when mealEntryComponentUsualFoodLinked != null:
return mealEntryComponentUsualFoodLinked(_that);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that);case DailyLogStateRestored() when stateRestored != null:
return stateRestored(_that);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath,  DateTime? day,  TimeOfDay? dayStart,  List<MealComponent> components)?  mealLogged,TResult Function( String id)?  mealEntryRemoved,TResult Function( String id,  Nutrition nutrition)?  mealEntryNutritionChanged,TResult Function( String id,  double quantity)?  mealEntryQuantityChanged,TResult Function( String id,  int componentIndex,  double quantity)?  mealEntryComponentQuantityChanged,TResult Function( String id,  int componentIndex,  Nutrition nutrition)?  mealEntryComponentNutritionChanged,TResult Function( String id,  MealComponent component)?  mealEntryComponentAdded,TResult Function( String id,  int componentIndex)?  mealEntryComponentRemoved,TResult Function( String id,  int componentIndex,  String usualFoodId)?  mealEntryComponentUsualFoodLinked,TResult Function( String id,  String usualMealId)?  mealEntryUsualMealLinked,TResult Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult Function( DateTime day,  double? weight,  WeightUnit weightUnit,  TimeOfDay dayStart)?  weightOnDayChanged,TResult Function( DailyLogState state)?  stateRestored,TResult Function()?  sampleDataSeeded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath,_that.day,_that.dayStart,_that.components);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryQuantityChanged() when mealEntryQuantityChanged != null:
return mealEntryQuantityChanged(_that.id,_that.quantity);case MealEntryComponentQuantityChanged() when mealEntryComponentQuantityChanged != null:
return mealEntryComponentQuantityChanged(_that.id,_that.componentIndex,_that.quantity);case MealEntryComponentNutritionChanged() when mealEntryComponentNutritionChanged != null:
return mealEntryComponentNutritionChanged(_that.id,_that.componentIndex,_that.nutrition);case MealEntryComponentAdded() when mealEntryComponentAdded != null:
return mealEntryComponentAdded(_that.id,_that.component);case MealEntryComponentRemoved() when mealEntryComponentRemoved != null:
return mealEntryComponentRemoved(_that.id,_that.componentIndex);case MealEntryComponentUsualFoodLinked() when mealEntryComponentUsualFoodLinked != null:
return mealEntryComponentUsualFoodLinked(_that.id,_that.componentIndex,_that.usualFoodId);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit,_that.dayStart);case DailyLogStateRestored() when stateRestored != null:
return stateRestored(_that.state);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath,  DateTime? day,  TimeOfDay? dayStart,  List<MealComponent> components)  mealLogged,required TResult Function( String id)  mealEntryRemoved,required TResult Function( String id,  Nutrition nutrition)  mealEntryNutritionChanged,required TResult Function( String id,  double quantity)  mealEntryQuantityChanged,required TResult Function( String id,  int componentIndex,  double quantity)  mealEntryComponentQuantityChanged,required TResult Function( String id,  int componentIndex,  Nutrition nutrition)  mealEntryComponentNutritionChanged,required TResult Function( String id,  MealComponent component)  mealEntryComponentAdded,required TResult Function( String id,  int componentIndex)  mealEntryComponentRemoved,required TResult Function( String id,  int componentIndex,  String usualFoodId)  mealEntryComponentUsualFoodLinked,required TResult Function( String id,  String usualMealId)  mealEntryUsualMealLinked,required TResult Function( double weight,  WeightUnit weightUnit)  weightLogged,required TResult Function( DateTime day,  double? weight,  WeightUnit weightUnit,  TimeOfDay dayStart)  weightOnDayChanged,required TResult Function( DailyLogState state)  stateRestored,required TResult Function()  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath,_that.day,_that.dayStart,_that.components);case MealEntryRemoved():
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged():
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryQuantityChanged():
return mealEntryQuantityChanged(_that.id,_that.quantity);case MealEntryComponentQuantityChanged():
return mealEntryComponentQuantityChanged(_that.id,_that.componentIndex,_that.quantity);case MealEntryComponentNutritionChanged():
return mealEntryComponentNutritionChanged(_that.id,_that.componentIndex,_that.nutrition);case MealEntryComponentAdded():
return mealEntryComponentAdded(_that.id,_that.component);case MealEntryComponentRemoved():
return mealEntryComponentRemoved(_that.id,_that.componentIndex);case MealEntryComponentUsualFoodLinked():
return mealEntryComponentUsualFoodLinked(_that.id,_that.componentIndex,_that.usualFoodId);case MealEntryUsualMealLinked():
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged():
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged():
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit,_that.dayStart);case DailyLogStateRestored():
return stateRestored(_that.state);case SampleDataSeeded():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( MealOfTheDay mealOfTheDay,  String name,  Nutrition nutrition,  double quantity,  String? usualMealId,  String? photoPath,  DateTime? day,  TimeOfDay? dayStart,  List<MealComponent> components)?  mealLogged,TResult? Function( String id)?  mealEntryRemoved,TResult? Function( String id,  Nutrition nutrition)?  mealEntryNutritionChanged,TResult? Function( String id,  double quantity)?  mealEntryQuantityChanged,TResult? Function( String id,  int componentIndex,  double quantity)?  mealEntryComponentQuantityChanged,TResult? Function( String id,  int componentIndex,  Nutrition nutrition)?  mealEntryComponentNutritionChanged,TResult? Function( String id,  MealComponent component)?  mealEntryComponentAdded,TResult? Function( String id,  int componentIndex)?  mealEntryComponentRemoved,TResult? Function( String id,  int componentIndex,  String usualFoodId)?  mealEntryComponentUsualFoodLinked,TResult? Function( String id,  String usualMealId)?  mealEntryUsualMealLinked,TResult? Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult? Function( DateTime day,  double? weight,  WeightUnit weightUnit,  TimeOfDay dayStart)?  weightOnDayChanged,TResult? Function( DailyLogState state)?  stateRestored,TResult? Function()?  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.nutrition,_that.quantity,_that.usualMealId,_that.photoPath,_that.day,_that.dayStart,_that.components);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryNutritionChanged() when mealEntryNutritionChanged != null:
return mealEntryNutritionChanged(_that.id,_that.nutrition);case MealEntryQuantityChanged() when mealEntryQuantityChanged != null:
return mealEntryQuantityChanged(_that.id,_that.quantity);case MealEntryComponentQuantityChanged() when mealEntryComponentQuantityChanged != null:
return mealEntryComponentQuantityChanged(_that.id,_that.componentIndex,_that.quantity);case MealEntryComponentNutritionChanged() when mealEntryComponentNutritionChanged != null:
return mealEntryComponentNutritionChanged(_that.id,_that.componentIndex,_that.nutrition);case MealEntryComponentAdded() when mealEntryComponentAdded != null:
return mealEntryComponentAdded(_that.id,_that.component);case MealEntryComponentRemoved() when mealEntryComponentRemoved != null:
return mealEntryComponentRemoved(_that.id,_that.componentIndex);case MealEntryComponentUsualFoodLinked() when mealEntryComponentUsualFoodLinked != null:
return mealEntryComponentUsualFoodLinked(_that.id,_that.componentIndex,_that.usualFoodId);case MealEntryUsualMealLinked() when mealEntryUsualMealLinked != null:
return mealEntryUsualMealLinked(_that.id,_that.usualMealId);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case WeightOnDayChanged() when weightOnDayChanged != null:
return weightOnDayChanged(_that.day,_that.weight,_that.weightUnit,_that.dayStart);case DailyLogStateRestored() when stateRestored != null:
return stateRestored(_that.state);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded();case _:
  return null;

}
}

}

/// @nodoc


class MealLogged implements DailyLogEvent {
  const MealLogged(this.mealOfTheDay, this.name, {this.nutrition = const Nutrition(), this.quantity = 1, this.usualMealId, this.photoPath, this.day, this.dayStart, final  List<MealComponent> components = const <MealComponent>[]}): _components = components;
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
@JsonKey() final  Nutrition nutrition;
@JsonKey() final  double quantity;
 final  String? usualMealId;
 final  String? photoPath;
 final  DateTime? day;
 final  TimeOfDay? dayStart;
 final  List<MealComponent> _components;
@JsonKey() List<MealComponent> get components {
  if (_components is EqualUnmodifiableListView) return _components;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_components);
}


/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLoggedCopyWith<MealLogged> get copyWith => _$MealLoggedCopyWithImpl<MealLogged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLogged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.day, day) || other.day == day)&&(identical(other.dayStart, dayStart) || other.dayStart == dayStart)&&const DeepCollectionEquality().equals(other._components, _components));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,nutrition,quantity,usualMealId,photoPath,day,dayStart,const DeepCollectionEquality().hash(_components));

@override
String toString() {
  return 'DailyLogEvent.mealLogged(mealOfTheDay: $mealOfTheDay, name: $name, nutrition: $nutrition, quantity: $quantity, usualMealId: $usualMealId, photoPath: $photoPath, day: $day, dayStart: $dayStart, components: $components)';
}


}

/// @nodoc
abstract mixin class $MealLoggedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealLoggedCopyWith(MealLogged value, $Res Function(MealLogged) _then) = _$MealLoggedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, Nutrition nutrition, double quantity, String? usualMealId, String? photoPath, DateTime? day, TimeOfDay? dayStart, List<MealComponent> components
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
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? nutrition = null,Object? quantity = null,Object? usualMealId = freezed,Object? photoPath = freezed,Object? day = freezed,Object? dayStart = freezed,Object? components = null,}) {
  return _then(MealLogged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,usualMealId: freezed == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime?,dayStart: freezed == dayStart ? _self.dayStart : dayStart // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,components: null == components ? _self._components : components // ignore: cast_nullable_to_non_nullable
as List<MealComponent>,
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


class MealEntryQuantityChanged implements DailyLogEvent {
  const MealEntryQuantityChanged(this.id, this.quantity);
  

 final  String id;
 final  double quantity;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryQuantityChangedCopyWith<MealEntryQuantityChanged> get copyWith => _$MealEntryQuantityChangedCopyWithImpl<MealEntryQuantityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryQuantityChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity);

@override
String toString() {
  return 'DailyLogEvent.mealEntryQuantityChanged(id: $id, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $MealEntryQuantityChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryQuantityChangedCopyWith(MealEntryQuantityChanged value, $Res Function(MealEntryQuantityChanged) _then) = _$MealEntryQuantityChangedCopyWithImpl;
@useResult
$Res call({
 String id, double quantity
});




}
/// @nodoc
class _$MealEntryQuantityChangedCopyWithImpl<$Res>
    implements $MealEntryQuantityChangedCopyWith<$Res> {
  _$MealEntryQuantityChangedCopyWithImpl(this._self, this._then);

  final MealEntryQuantityChanged _self;
  final $Res Function(MealEntryQuantityChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,}) {
  return _then(MealEntryQuantityChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class MealEntryComponentQuantityChanged implements DailyLogEvent {
  const MealEntryComponentQuantityChanged(this.id, this.componentIndex, this.quantity);
  

 final  String id;
 final  int componentIndex;
 final  double quantity;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryComponentQuantityChangedCopyWith<MealEntryComponentQuantityChanged> get copyWith => _$MealEntryComponentQuantityChangedCopyWithImpl<MealEntryComponentQuantityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryComponentQuantityChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.componentIndex, componentIndex) || other.componentIndex == componentIndex)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,componentIndex,quantity);

@override
String toString() {
  return 'DailyLogEvent.mealEntryComponentQuantityChanged(id: $id, componentIndex: $componentIndex, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $MealEntryComponentQuantityChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryComponentQuantityChangedCopyWith(MealEntryComponentQuantityChanged value, $Res Function(MealEntryComponentQuantityChanged) _then) = _$MealEntryComponentQuantityChangedCopyWithImpl;
@useResult
$Res call({
 String id, int componentIndex, double quantity
});




}
/// @nodoc
class _$MealEntryComponentQuantityChangedCopyWithImpl<$Res>
    implements $MealEntryComponentQuantityChangedCopyWith<$Res> {
  _$MealEntryComponentQuantityChangedCopyWithImpl(this._self, this._then);

  final MealEntryComponentQuantityChanged _self;
  final $Res Function(MealEntryComponentQuantityChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? componentIndex = null,Object? quantity = null,}) {
  return _then(MealEntryComponentQuantityChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == componentIndex ? _self.componentIndex : componentIndex // ignore: cast_nullable_to_non_nullable
as int,null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class MealEntryComponentNutritionChanged implements DailyLogEvent {
  const MealEntryComponentNutritionChanged(this.id, this.componentIndex, this.nutrition);
  

 final  String id;
 final  int componentIndex;
 final  Nutrition nutrition;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryComponentNutritionChangedCopyWith<MealEntryComponentNutritionChanged> get copyWith => _$MealEntryComponentNutritionChangedCopyWithImpl<MealEntryComponentNutritionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryComponentNutritionChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.componentIndex, componentIndex) || other.componentIndex == componentIndex)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,id,componentIndex,nutrition);

@override
String toString() {
  return 'DailyLogEvent.mealEntryComponentNutritionChanged(id: $id, componentIndex: $componentIndex, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $MealEntryComponentNutritionChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryComponentNutritionChangedCopyWith(MealEntryComponentNutritionChanged value, $Res Function(MealEntryComponentNutritionChanged) _then) = _$MealEntryComponentNutritionChangedCopyWithImpl;
@useResult
$Res call({
 String id, int componentIndex, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealEntryComponentNutritionChangedCopyWithImpl<$Res>
    implements $MealEntryComponentNutritionChangedCopyWith<$Res> {
  _$MealEntryComponentNutritionChangedCopyWithImpl(this._self, this._then);

  final MealEntryComponentNutritionChanged _self;
  final $Res Function(MealEntryComponentNutritionChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? componentIndex = null,Object? nutrition = null,}) {
  return _then(MealEntryComponentNutritionChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == componentIndex ? _self.componentIndex : componentIndex // ignore: cast_nullable_to_non_nullable
as int,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
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


class MealEntryComponentAdded implements DailyLogEvent {
  const MealEntryComponentAdded(this.id, this.component);
  

 final  String id;
 final  MealComponent component;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryComponentAddedCopyWith<MealEntryComponentAdded> get copyWith => _$MealEntryComponentAddedCopyWithImpl<MealEntryComponentAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryComponentAdded&&(identical(other.id, id) || other.id == id)&&(identical(other.component, component) || other.component == component));
}


@override
int get hashCode => Object.hash(runtimeType,id,component);

@override
String toString() {
  return 'DailyLogEvent.mealEntryComponentAdded(id: $id, component: $component)';
}


}

/// @nodoc
abstract mixin class $MealEntryComponentAddedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryComponentAddedCopyWith(MealEntryComponentAdded value, $Res Function(MealEntryComponentAdded) _then) = _$MealEntryComponentAddedCopyWithImpl;
@useResult
$Res call({
 String id, MealComponent component
});


$MealComponentCopyWith<$Res> get component;

}
/// @nodoc
class _$MealEntryComponentAddedCopyWithImpl<$Res>
    implements $MealEntryComponentAddedCopyWith<$Res> {
  _$MealEntryComponentAddedCopyWithImpl(this._self, this._then);

  final MealEntryComponentAdded _self;
  final $Res Function(MealEntryComponentAdded) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? component = null,}) {
  return _then(MealEntryComponentAdded(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == component ? _self.component : component // ignore: cast_nullable_to_non_nullable
as MealComponent,
  ));
}

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MealComponentCopyWith<$Res> get component {
  
  return $MealComponentCopyWith<$Res>(_self.component, (value) {
    return _then(_self.copyWith(component: value));
  });
}
}

/// @nodoc


class MealEntryComponentRemoved implements DailyLogEvent {
  const MealEntryComponentRemoved(this.id, this.componentIndex);
  

 final  String id;
 final  int componentIndex;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryComponentRemovedCopyWith<MealEntryComponentRemoved> get copyWith => _$MealEntryComponentRemovedCopyWithImpl<MealEntryComponentRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryComponentRemoved&&(identical(other.id, id) || other.id == id)&&(identical(other.componentIndex, componentIndex) || other.componentIndex == componentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,id,componentIndex);

@override
String toString() {
  return 'DailyLogEvent.mealEntryComponentRemoved(id: $id, componentIndex: $componentIndex)';
}


}

/// @nodoc
abstract mixin class $MealEntryComponentRemovedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryComponentRemovedCopyWith(MealEntryComponentRemoved value, $Res Function(MealEntryComponentRemoved) _then) = _$MealEntryComponentRemovedCopyWithImpl;
@useResult
$Res call({
 String id, int componentIndex
});




}
/// @nodoc
class _$MealEntryComponentRemovedCopyWithImpl<$Res>
    implements $MealEntryComponentRemovedCopyWith<$Res> {
  _$MealEntryComponentRemovedCopyWithImpl(this._self, this._then);

  final MealEntryComponentRemoved _self;
  final $Res Function(MealEntryComponentRemoved) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? componentIndex = null,}) {
  return _then(MealEntryComponentRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == componentIndex ? _self.componentIndex : componentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class MealEntryComponentUsualFoodLinked implements DailyLogEvent {
  const MealEntryComponentUsualFoodLinked(this.id, this.componentIndex, this.usualFoodId);
  

 final  String id;
 final  int componentIndex;
 final  String usualFoodId;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryComponentUsualFoodLinkedCopyWith<MealEntryComponentUsualFoodLinked> get copyWith => _$MealEntryComponentUsualFoodLinkedCopyWithImpl<MealEntryComponentUsualFoodLinked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryComponentUsualFoodLinked&&(identical(other.id, id) || other.id == id)&&(identical(other.componentIndex, componentIndex) || other.componentIndex == componentIndex)&&(identical(other.usualFoodId, usualFoodId) || other.usualFoodId == usualFoodId));
}


@override
int get hashCode => Object.hash(runtimeType,id,componentIndex,usualFoodId);

@override
String toString() {
  return 'DailyLogEvent.mealEntryComponentUsualFoodLinked(id: $id, componentIndex: $componentIndex, usualFoodId: $usualFoodId)';
}


}

/// @nodoc
abstract mixin class $MealEntryComponentUsualFoodLinkedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryComponentUsualFoodLinkedCopyWith(MealEntryComponentUsualFoodLinked value, $Res Function(MealEntryComponentUsualFoodLinked) _then) = _$MealEntryComponentUsualFoodLinkedCopyWithImpl;
@useResult
$Res call({
 String id, int componentIndex, String usualFoodId
});




}
/// @nodoc
class _$MealEntryComponentUsualFoodLinkedCopyWithImpl<$Res>
    implements $MealEntryComponentUsualFoodLinkedCopyWith<$Res> {
  _$MealEntryComponentUsualFoodLinkedCopyWithImpl(this._self, this._then);

  final MealEntryComponentUsualFoodLinked _self;
  final $Res Function(MealEntryComponentUsualFoodLinked) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? componentIndex = null,Object? usualFoodId = null,}) {
  return _then(MealEntryComponentUsualFoodLinked(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == componentIndex ? _self.componentIndex : componentIndex // ignore: cast_nullable_to_non_nullable
as int,null == usualFoodId ? _self.usualFoodId : usualFoodId // ignore: cast_nullable_to_non_nullable
as String,
  ));
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
  const WeightOnDayChanged(this.day, this.weight, this.weightUnit, this.dayStart);
  

 final  DateTime day;
 final  double? weight;
 final  WeightUnit weightUnit;
 final  TimeOfDay dayStart;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightOnDayChangedCopyWith<WeightOnDayChanged> get copyWith => _$WeightOnDayChangedCopyWithImpl<WeightOnDayChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightOnDayChanged&&(identical(other.day, day) || other.day == day)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit)&&(identical(other.dayStart, dayStart) || other.dayStart == dayStart));
}


@override
int get hashCode => Object.hash(runtimeType,day,weight,weightUnit,dayStart);

@override
String toString() {
  return 'DailyLogEvent.weightOnDayChanged(day: $day, weight: $weight, weightUnit: $weightUnit, dayStart: $dayStart)';
}


}

/// @nodoc
abstract mixin class $WeightOnDayChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $WeightOnDayChangedCopyWith(WeightOnDayChanged value, $Res Function(WeightOnDayChanged) _then) = _$WeightOnDayChangedCopyWithImpl;
@useResult
$Res call({
 DateTime day, double? weight, WeightUnit weightUnit, TimeOfDay dayStart
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
@pragma('vm:prefer-inline') $Res call({Object? day = null,Object? weight = freezed,Object? weightUnit = null,Object? dayStart = null,}) {
  return _then(WeightOnDayChanged(
null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as DateTime,freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,null == dayStart ? _self.dayStart : dayStart // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

/// @nodoc


class DailyLogStateRestored implements DailyLogEvent {
  const DailyLogStateRestored(this.state);
  

 final  DailyLogState state;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyLogStateRestoredCopyWith<DailyLogStateRestored> get copyWith => _$DailyLogStateRestoredCopyWithImpl<DailyLogStateRestored>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogStateRestored&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode => Object.hash(runtimeType,state);

@override
String toString() {
  return 'DailyLogEvent.stateRestored(state: $state)';
}


}

/// @nodoc
abstract mixin class $DailyLogStateRestoredCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $DailyLogStateRestoredCopyWith(DailyLogStateRestored value, $Res Function(DailyLogStateRestored) _then) = _$DailyLogStateRestoredCopyWithImpl;
@useResult
$Res call({
 DailyLogState state
});


$DailyLogStateCopyWith<$Res> get state;

}
/// @nodoc
class _$DailyLogStateRestoredCopyWithImpl<$Res>
    implements $DailyLogStateRestoredCopyWith<$Res> {
  _$DailyLogStateRestoredCopyWithImpl(this._self, this._then);

  final DailyLogStateRestored _self;
  final $Res Function(DailyLogStateRestored) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? state = null,}) {
  return _then(DailyLogStateRestored(
null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as DailyLogState,
  ));
}

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyLogStateCopyWith<$Res> get state {
  
  return $DailyLogStateCopyWith<$Res>(_self.state, (value) {
    return _then(_self.copyWith(state: value));
  });
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

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
 int get version; List<MealLogEntry> get mealEntries; List<WeightEntry> get weightEntries;/// The id of the entry logged most recently this session. Ephemeral: it is
/// not persisted, so a relaunch clears it, and it is ignored when comparing
/// state for cloud sync.
@JsonKey(includeFromJson: false, includeToJson: false) String? get justLoggedEntryId;
/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyLogStateCopyWith<DailyLogState> get copyWith => _$DailyLogStateCopyWithImpl<DailyLogState>(this as DailyLogState, _$identity);

  /// Serializes this DailyLogState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogState&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.mealEntries, mealEntries)&&const DeepCollectionEquality().equals(other.weightEntries, weightEntries)&&(identical(other.justLoggedEntryId, justLoggedEntryId) || other.justLoggedEntryId == justLoggedEntryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(mealEntries),const DeepCollectionEquality().hash(weightEntries),justLoggedEntryId);

@override
String toString() {
  return 'DailyLogState(version: $version, mealEntries: $mealEntries, weightEntries: $weightEntries, justLoggedEntryId: $justLoggedEntryId)';
}


}

/// @nodoc
abstract mixin class $DailyLogStateCopyWith<$Res>  {
  factory $DailyLogStateCopyWith(DailyLogState value, $Res Function(DailyLogState) _then) = _$DailyLogStateCopyWithImpl;
@useResult
$Res call({
 int version, List<MealLogEntry> mealEntries, List<WeightEntry> weightEntries,@JsonKey(includeFromJson: false, includeToJson: false) String? justLoggedEntryId
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
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? mealEntries = null,Object? weightEntries = null,Object? justLoggedEntryId = freezed,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,mealEntries: null == mealEntries ? _self.mealEntries : mealEntries // ignore: cast_nullable_to_non_nullable
as List<MealLogEntry>,weightEntries: null == weightEntries ? _self.weightEntries : weightEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntry>,justLoggedEntryId: freezed == justLoggedEntryId ? _self.justLoggedEntryId : justLoggedEntryId // ignore: cast_nullable_to_non_nullable
as String?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedEntryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
return $default(_that.version,_that.mealEntries,_that.weightEntries,_that.justLoggedEntryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedEntryId)  $default,) {final _that = this;
switch (_that) {
case _DailyLogState():
return $default(_that.version,_that.mealEntries,_that.weightEntries,_that.justLoggedEntryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<MealLogEntry> mealEntries,  List<WeightEntry> weightEntries, @JsonKey(includeFromJson: false, includeToJson: false)  String? justLoggedEntryId)?  $default,) {final _that = this;
switch (_that) {
case _DailyLogState() when $default != null:
return $default(_that.version,_that.mealEntries,_that.weightEntries,_that.justLoggedEntryId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _DailyLogState extends DailyLogState {
  const _DailyLogState({this.version = 2, final  List<MealLogEntry> mealEntries = const <MealLogEntry>[], final  List<WeightEntry> weightEntries = const <WeightEntry>[], @JsonKey(includeFromJson: false, includeToJson: false) this.justLoggedEntryId}): _mealEntries = mealEntries,_weightEntries = weightEntries,super._();
  factory _DailyLogState.fromJson(Map<String, dynamic> json) => _$DailyLogStateFromJson(json);

/// Schema version of the persisted state. Bump it and add a `fromJson`
/// case whenever the persisted shape changes in a way old stored data
/// can't be read as-is, so existing users are migrated instead of reset.
@override@JsonKey() final  int version;
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

/// The id of the entry logged most recently this session. Ephemeral: it is
/// not persisted, so a relaunch clears it, and it is ignored when comparing
/// state for cloud sync.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String? justLoggedEntryId;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyLogState&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._mealEntries, _mealEntries)&&const DeepCollectionEquality().equals(other._weightEntries, _weightEntries)&&(identical(other.justLoggedEntryId, justLoggedEntryId) || other.justLoggedEntryId == justLoggedEntryId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_mealEntries),const DeepCollectionEquality().hash(_weightEntries),justLoggedEntryId);

@override
String toString() {
  return 'DailyLogState(version: $version, mealEntries: $mealEntries, weightEntries: $weightEntries, justLoggedEntryId: $justLoggedEntryId)';
}


}

/// @nodoc
abstract mixin class _$DailyLogStateCopyWith<$Res> implements $DailyLogStateCopyWith<$Res> {
  factory _$DailyLogStateCopyWith(_DailyLogState value, $Res Function(_DailyLogState) _then) = __$DailyLogStateCopyWithImpl;
@override @useResult
$Res call({
 int version, List<MealLogEntry> mealEntries, List<WeightEntry> weightEntries,@JsonKey(includeFromJson: false, includeToJson: false) String? justLoggedEntryId
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
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? mealEntries = null,Object? weightEntries = null,Object? justLoggedEntryId = freezed,}) {
  return _then(_DailyLogState(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,mealEntries: null == mealEntries ? _self._mealEntries : mealEntries // ignore: cast_nullable_to_non_nullable
as List<MealLogEntry>,weightEntries: null == weightEntries ? _self._weightEntries : weightEntries // ignore: cast_nullable_to_non_nullable
as List<WeightEntry>,justLoggedEntryId: freezed == justLoggedEntryId ? _self.justLoggedEntryId : justLoggedEntryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
