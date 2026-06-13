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
mixin _$DailyLogEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealLogged value)?  mealLogged,TResult Function( MealEntryRemoved value)?  mealEntryRemoved,TResult Function( MealEntryCaloriesChanged value)?  mealEntryCaloriesChanged,TResult Function( WeightLogged value)?  weightLogged,TResult Function( TodayWeightChanged value)?  todayWeightChanged,TResult Function( WeightEntryRemoved value)?  weightEntryRemoved,TResult Function( SampleDataSeeded value)?  sampleDataSeeded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryCaloriesChanged() when mealEntryCaloriesChanged != null:
return mealEntryCaloriesChanged(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case TodayWeightChanged() when todayWeightChanged != null:
return todayWeightChanged(_that);case WeightEntryRemoved() when weightEntryRemoved != null:
return weightEntryRemoved(_that);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealLogged value)  mealLogged,required TResult Function( MealEntryRemoved value)  mealEntryRemoved,required TResult Function( MealEntryCaloriesChanged value)  mealEntryCaloriesChanged,required TResult Function( WeightLogged value)  weightLogged,required TResult Function( TodayWeightChanged value)  todayWeightChanged,required TResult Function( WeightEntryRemoved value)  weightEntryRemoved,required TResult Function( SampleDataSeeded value)  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that);case MealEntryRemoved():
return mealEntryRemoved(_that);case MealEntryCaloriesChanged():
return mealEntryCaloriesChanged(_that);case WeightLogged():
return weightLogged(_that);case TodayWeightChanged():
return todayWeightChanged(_that);case WeightEntryRemoved():
return weightEntryRemoved(_that);case SampleDataSeeded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealLogged value)?  mealLogged,TResult? Function( MealEntryRemoved value)?  mealEntryRemoved,TResult? Function( MealEntryCaloriesChanged value)?  mealEntryCaloriesChanged,TResult? Function( WeightLogged value)?  weightLogged,TResult? Function( TodayWeightChanged value)?  todayWeightChanged,TResult? Function( WeightEntryRemoved value)?  weightEntryRemoved,TResult? Function( SampleDataSeeded value)?  sampleDataSeeded,}){
final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that);case MealEntryCaloriesChanged() when mealEntryCaloriesChanged != null:
return mealEntryCaloriesChanged(_that);case WeightLogged() when weightLogged != null:
return weightLogged(_that);case TodayWeightChanged() when todayWeightChanged != null:
return todayWeightChanged(_that);case WeightEntryRemoved() when weightEntryRemoved != null:
return weightEntryRemoved(_that);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( MealOfTheDay mealOfTheDay,  String name,  int? calories,  String? usualMealId,  String? photoPath)?  mealLogged,TResult Function( String id)?  mealEntryRemoved,TResult Function( String id,  int? calories)?  mealEntryCaloriesChanged,TResult Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult Function( double? weight,  WeightUnit weightUnit)?  todayWeightChanged,TResult Function( String id)?  weightEntryRemoved,TResult Function()?  sampleDataSeeded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.calories,_that.usualMealId,_that.photoPath);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryCaloriesChanged() when mealEntryCaloriesChanged != null:
return mealEntryCaloriesChanged(_that.id,_that.calories);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case TodayWeightChanged() when todayWeightChanged != null:
return todayWeightChanged(_that.weight,_that.weightUnit);case WeightEntryRemoved() when weightEntryRemoved != null:
return weightEntryRemoved(_that.id);case SampleDataSeeded() when sampleDataSeeded != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( MealOfTheDay mealOfTheDay,  String name,  int? calories,  String? usualMealId,  String? photoPath)  mealLogged,required TResult Function( String id)  mealEntryRemoved,required TResult Function( String id,  int? calories)  mealEntryCaloriesChanged,required TResult Function( double weight,  WeightUnit weightUnit)  weightLogged,required TResult Function( double? weight,  WeightUnit weightUnit)  todayWeightChanged,required TResult Function( String id)  weightEntryRemoved,required TResult Function()  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged():
return mealLogged(_that.mealOfTheDay,_that.name,_that.calories,_that.usualMealId,_that.photoPath);case MealEntryRemoved():
return mealEntryRemoved(_that.id);case MealEntryCaloriesChanged():
return mealEntryCaloriesChanged(_that.id,_that.calories);case WeightLogged():
return weightLogged(_that.weight,_that.weightUnit);case TodayWeightChanged():
return todayWeightChanged(_that.weight,_that.weightUnit);case WeightEntryRemoved():
return weightEntryRemoved(_that.id);case SampleDataSeeded():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( MealOfTheDay mealOfTheDay,  String name,  int? calories,  String? usualMealId,  String? photoPath)?  mealLogged,TResult? Function( String id)?  mealEntryRemoved,TResult? Function( String id,  int? calories)?  mealEntryCaloriesChanged,TResult? Function( double weight,  WeightUnit weightUnit)?  weightLogged,TResult? Function( double? weight,  WeightUnit weightUnit)?  todayWeightChanged,TResult? Function( String id)?  weightEntryRemoved,TResult? Function()?  sampleDataSeeded,}) {final _that = this;
switch (_that) {
case MealLogged() when mealLogged != null:
return mealLogged(_that.mealOfTheDay,_that.name,_that.calories,_that.usualMealId,_that.photoPath);case MealEntryRemoved() when mealEntryRemoved != null:
return mealEntryRemoved(_that.id);case MealEntryCaloriesChanged() when mealEntryCaloriesChanged != null:
return mealEntryCaloriesChanged(_that.id,_that.calories);case WeightLogged() when weightLogged != null:
return weightLogged(_that.weight,_that.weightUnit);case TodayWeightChanged() when todayWeightChanged != null:
return todayWeightChanged(_that.weight,_that.weightUnit);case WeightEntryRemoved() when weightEntryRemoved != null:
return weightEntryRemoved(_that.id);case SampleDataSeeded() when sampleDataSeeded != null:
return sampleDataSeeded();case _:
  return null;

}
}

}

/// @nodoc


class MealLogged with DiagnosticableTreeMixin implements DailyLogEvent {
  const MealLogged(this.mealOfTheDay, this.name, {this.calories, this.usualMealId, this.photoPath});
  

 final  MealOfTheDay mealOfTheDay;
 final  String name;
 final  int? calories;
 final  String? usualMealId;
 final  String? photoPath;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealLoggedCopyWith<MealLogged> get copyWith => _$MealLoggedCopyWithImpl<MealLogged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.mealLogged'))
    ..add(DiagnosticsProperty('mealOfTheDay', mealOfTheDay))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('calories', calories))..add(DiagnosticsProperty('usualMealId', usualMealId))..add(DiagnosticsProperty('photoPath', photoPath));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealLogged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.name, name) || other.name == name)&&(identical(other.calories, calories) || other.calories == calories)&&(identical(other.usualMealId, usualMealId) || other.usualMealId == usualMealId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay,name,calories,usualMealId,photoPath);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DailyLogEvent.mealLogged(mealOfTheDay: $mealOfTheDay, name: $name, calories: $calories, usualMealId: $usualMealId, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $MealLoggedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealLoggedCopyWith(MealLogged value, $Res Function(MealLogged) _then) = _$MealLoggedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay, String name, int? calories, String? usualMealId, String? photoPath
});




}
/// @nodoc
class _$MealLoggedCopyWithImpl<$Res>
    implements $MealLoggedCopyWith<$Res> {
  _$MealLoggedCopyWithImpl(this._self, this._then);

  final MealLogged _self;
  final $Res Function(MealLogged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,Object? name = null,Object? calories = freezed,Object? usualMealId = freezed,Object? photoPath = freezed,}) {
  return _then(MealLogged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,calories: freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,usualMealId: freezed == usualMealId ? _self.usualMealId : usualMealId // ignore: cast_nullable_to_non_nullable
as String?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class MealEntryRemoved with DiagnosticableTreeMixin implements DailyLogEvent {
  const MealEntryRemoved(this.id);
  

 final  String id;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryRemovedCopyWith<MealEntryRemoved> get copyWith => _$MealEntryRemovedCopyWithImpl<MealEntryRemoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.mealEntryRemoved'))
    ..add(DiagnosticsProperty('id', id));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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


class MealEntryCaloriesChanged with DiagnosticableTreeMixin implements DailyLogEvent {
  const MealEntryCaloriesChanged(this.id, this.calories);
  

 final  String id;
 final  int? calories;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryCaloriesChangedCopyWith<MealEntryCaloriesChanged> get copyWith => _$MealEntryCaloriesChangedCopyWithImpl<MealEntryCaloriesChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.mealEntryCaloriesChanged'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('calories', calories));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryCaloriesChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.calories, calories) || other.calories == calories));
}


@override
int get hashCode => Object.hash(runtimeType,id,calories);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DailyLogEvent.mealEntryCaloriesChanged(id: $id, calories: $calories)';
}


}

/// @nodoc
abstract mixin class $MealEntryCaloriesChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $MealEntryCaloriesChangedCopyWith(MealEntryCaloriesChanged value, $Res Function(MealEntryCaloriesChanged) _then) = _$MealEntryCaloriesChangedCopyWithImpl;
@useResult
$Res call({
 String id, int? calories
});




}
/// @nodoc
class _$MealEntryCaloriesChangedCopyWithImpl<$Res>
    implements $MealEntryCaloriesChangedCopyWith<$Res> {
  _$MealEntryCaloriesChangedCopyWithImpl(this._self, this._then);

  final MealEntryCaloriesChanged _self;
  final $Res Function(MealEntryCaloriesChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? calories = freezed,}) {
  return _then(MealEntryCaloriesChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,freezed == calories ? _self.calories : calories // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class WeightLogged with DiagnosticableTreeMixin implements DailyLogEvent {
  const WeightLogged(this.weight, this.weightUnit);
  

 final  double weight;
 final  WeightUnit weightUnit;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightLoggedCopyWith<WeightLogged> get copyWith => _$WeightLoggedCopyWithImpl<WeightLogged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.weightLogged'))
    ..add(DiagnosticsProperty('weight', weight))..add(DiagnosticsProperty('weightUnit', weightUnit));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightLogged&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weight,weightUnit);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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


class TodayWeightChanged with DiagnosticableTreeMixin implements DailyLogEvent {
  const TodayWeightChanged(this.weight, this.weightUnit);
  

 final  double? weight;
 final  WeightUnit weightUnit;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodayWeightChangedCopyWith<TodayWeightChanged> get copyWith => _$TodayWeightChangedCopyWithImpl<TodayWeightChanged>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.todayWeightChanged'))
    ..add(DiagnosticsProperty('weight', weight))..add(DiagnosticsProperty('weightUnit', weightUnit));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodayWeightChanged&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.weightUnit, weightUnit) || other.weightUnit == weightUnit));
}


@override
int get hashCode => Object.hash(runtimeType,weight,weightUnit);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DailyLogEvent.todayWeightChanged(weight: $weight, weightUnit: $weightUnit)';
}


}

/// @nodoc
abstract mixin class $TodayWeightChangedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $TodayWeightChangedCopyWith(TodayWeightChanged value, $Res Function(TodayWeightChanged) _then) = _$TodayWeightChangedCopyWithImpl;
@useResult
$Res call({
 double? weight, WeightUnit weightUnit
});




}
/// @nodoc
class _$TodayWeightChangedCopyWithImpl<$Res>
    implements $TodayWeightChangedCopyWith<$Res> {
  _$TodayWeightChangedCopyWithImpl(this._self, this._then);

  final TodayWeightChanged _self;
  final $Res Function(TodayWeightChanged) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? weight = freezed,Object? weightUnit = null,}) {
  return _then(TodayWeightChanged(
freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double?,null == weightUnit ? _self.weightUnit : weightUnit // ignore: cast_nullable_to_non_nullable
as WeightUnit,
  ));
}


}

/// @nodoc


class WeightEntryRemoved with DiagnosticableTreeMixin implements DailyLogEvent {
  const WeightEntryRemoved(this.id);
  

 final  String id;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeightEntryRemovedCopyWith<WeightEntryRemoved> get copyWith => _$WeightEntryRemovedCopyWithImpl<WeightEntryRemoved>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.weightEntryRemoved'))
    ..add(DiagnosticsProperty('id', id));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeightEntryRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DailyLogEvent.weightEntryRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $WeightEntryRemovedCopyWith<$Res> implements $DailyLogEventCopyWith<$Res> {
  factory $WeightEntryRemovedCopyWith(WeightEntryRemoved value, $Res Function(WeightEntryRemoved) _then) = _$WeightEntryRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$WeightEntryRemovedCopyWithImpl<$Res>
    implements $WeightEntryRemovedCopyWith<$Res> {
  _$WeightEntryRemovedCopyWithImpl(this._self, this._then);

  final WeightEntryRemoved _self;
  final $Res Function(WeightEntryRemoved) _then;

/// Create a copy of DailyLogEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(WeightEntryRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SampleDataSeeded with DiagnosticableTreeMixin implements DailyLogEvent {
  const SampleDataSeeded();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogEvent.sampleDataSeeded'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleDataSeeded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'DailyLogEvent.sampleDataSeeded()';
}


}





/// @nodoc
mixin _$DailyLogState implements DiagnosticableTreeMixin {

 List<MealLogEntry> get mealEntries; List<WeightEntry> get weightEntries;
/// Create a copy of DailyLogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyLogStateCopyWith<DailyLogState> get copyWith => _$DailyLogStateCopyWithImpl<DailyLogState>(this as DailyLogState, _$identity);

  /// Serializes this DailyLogState to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogState'))
    ..add(DiagnosticsProperty('mealEntries', mealEntries))..add(DiagnosticsProperty('weightEntries', weightEntries));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyLogState&&const DeepCollectionEquality().equals(other.mealEntries, mealEntries)&&const DeepCollectionEquality().equals(other.weightEntries, weightEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mealEntries),const DeepCollectionEquality().hash(weightEntries));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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
class _DailyLogState extends DailyLogState with DiagnosticableTreeMixin {
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
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'DailyLogState'))
    ..add(DiagnosticsProperty('mealEntries', mealEntries))..add(DiagnosticsProperty('weightEntries', weightEntries));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyLogState&&const DeepCollectionEquality().equals(other._mealEntries, _mealEntries)&&const DeepCollectionEquality().equals(other._weightEntries, _weightEntries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mealEntries),const DeepCollectionEquality().hash(_weightEntries));

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
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
