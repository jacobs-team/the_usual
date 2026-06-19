// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_entry_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MealEntryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MealEntryEvent()';
}


}

/// @nodoc
class $MealEntryEventCopyWith<$Res>  {
$MealEntryEventCopyWith(MealEntryEvent _, $Res Function(MealEntryEvent) __);
}


/// Adds pattern-matching-related methods to [MealEntryEvent].
extension MealEntryEventPatterns on MealEntryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealEntryStarted value)?  started,TResult Function( MealEntryFoodAdded value)?  foodAdded,TResult Function( MealEntryFoodRemoved value)?  foodRemoved,TResult Function( MealEntryFoodNameChanged value)?  foodNameChanged,TResult Function( MealEntryFoodNutritionChanged value)?  foodNutritionChanged,TResult Function( MealEntryFoodQuantityChanged value)?  foodQuantityChanged,TResult Function( MealEntryFoodAddToUsualMealsToggled value)?  foodAddToUsualMealsToggled,TResult Function( MealEntryModeToggled value)?  entryModeToggled,TResult Function( MealEntryMealOfTheDayChanged value)?  mealOfTheDayChanged,TResult Function( MealEntryPhotosAdded value)?  photosAdded,TResult Function( MealEntryPhotosCleared value)?  photosCleared,TResult Function( MealEntryEstimateRequested value)?  estimateRequested,TResult Function( MealEntryPhotoEstimateRequested value)?  photoEstimateRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded(_that);case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared(_that);case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested(_that);case MealEntryPhotoEstimateRequested() when photoEstimateRequested != null:
return photoEstimateRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealEntryStarted value)  started,required TResult Function( MealEntryFoodAdded value)  foodAdded,required TResult Function( MealEntryFoodRemoved value)  foodRemoved,required TResult Function( MealEntryFoodNameChanged value)  foodNameChanged,required TResult Function( MealEntryFoodNutritionChanged value)  foodNutritionChanged,required TResult Function( MealEntryFoodQuantityChanged value)  foodQuantityChanged,required TResult Function( MealEntryFoodAddToUsualMealsToggled value)  foodAddToUsualMealsToggled,required TResult Function( MealEntryModeToggled value)  entryModeToggled,required TResult Function( MealEntryMealOfTheDayChanged value)  mealOfTheDayChanged,required TResult Function( MealEntryPhotosAdded value)  photosAdded,required TResult Function( MealEntryPhotosCleared value)  photosCleared,required TResult Function( MealEntryEstimateRequested value)  estimateRequested,required TResult Function( MealEntryPhotoEstimateRequested value)  photoEstimateRequested,}){
final _that = this;
switch (_that) {
case MealEntryStarted():
return started(_that);case MealEntryFoodAdded():
return foodAdded(_that);case MealEntryFoodRemoved():
return foodRemoved(_that);case MealEntryFoodNameChanged():
return foodNameChanged(_that);case MealEntryFoodNutritionChanged():
return foodNutritionChanged(_that);case MealEntryFoodQuantityChanged():
return foodQuantityChanged(_that);case MealEntryFoodAddToUsualMealsToggled():
return foodAddToUsualMealsToggled(_that);case MealEntryModeToggled():
return entryModeToggled(_that);case MealEntryMealOfTheDayChanged():
return mealOfTheDayChanged(_that);case MealEntryPhotosAdded():
return photosAdded(_that);case MealEntryPhotosCleared():
return photosCleared(_that);case MealEntryEstimateRequested():
return estimateRequested(_that);case MealEntryPhotoEstimateRequested():
return photoEstimateRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealEntryStarted value)?  started,TResult? Function( MealEntryFoodAdded value)?  foodAdded,TResult? Function( MealEntryFoodRemoved value)?  foodRemoved,TResult? Function( MealEntryFoodNameChanged value)?  foodNameChanged,TResult? Function( MealEntryFoodNutritionChanged value)?  foodNutritionChanged,TResult? Function( MealEntryFoodQuantityChanged value)?  foodQuantityChanged,TResult? Function( MealEntryFoodAddToUsualMealsToggled value)?  foodAddToUsualMealsToggled,TResult? Function( MealEntryModeToggled value)?  entryModeToggled,TResult? Function( MealEntryMealOfTheDayChanged value)?  mealOfTheDayChanged,TResult? Function( MealEntryPhotosAdded value)?  photosAdded,TResult? Function( MealEntryPhotosCleared value)?  photosCleared,TResult? Function( MealEntryEstimateRequested value)?  estimateRequested,TResult? Function( MealEntryPhotoEstimateRequested value)?  photoEstimateRequested,}){
final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded(_that);case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared(_that);case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested(_that);case MealEntryPhotoEstimateRequested() when photoEstimateRequested != null:
return photoEstimateRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay,  bool autoEstimate)?  started,TResult Function()?  foodAdded,TResult Function( String id)?  foodRemoved,TResult Function( String id,  String name)?  foodNameChanged,TResult Function( String id,  Nutrition nutrition)?  foodNutritionChanged,TResult Function( String id,  double quantity)?  foodQuantityChanged,TResult Function( String id,  bool addToUsualMeals)?  foodAddToUsualMealsToggled,TResult Function( MealEntryMode mealEntryMode)?  entryModeToggled,TResult Function( MealOfTheDay mealOfTheDay)?  mealOfTheDayChanged,TResult Function( List<MealPhoto> photos)?  photosAdded,TResult Function()?  photosCleared,TResult Function()?  estimateRequested,TResult Function()?  photoEstimateRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay,_that.autoEstimate);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded();case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that.id);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that.photos);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared();case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested();case MealEntryPhotoEstimateRequested() when photoEstimateRequested != null:
return photoEstimateRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay,  bool autoEstimate)  started,required TResult Function()  foodAdded,required TResult Function( String id)  foodRemoved,required TResult Function( String id,  String name)  foodNameChanged,required TResult Function( String id,  Nutrition nutrition)  foodNutritionChanged,required TResult Function( String id,  double quantity)  foodQuantityChanged,required TResult Function( String id,  bool addToUsualMeals)  foodAddToUsualMealsToggled,required TResult Function( MealEntryMode mealEntryMode)  entryModeToggled,required TResult Function( MealOfTheDay mealOfTheDay)  mealOfTheDayChanged,required TResult Function( List<MealPhoto> photos)  photosAdded,required TResult Function()  photosCleared,required TResult Function()  estimateRequested,required TResult Function()  photoEstimateRequested,}) {final _that = this;
switch (_that) {
case MealEntryStarted():
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay,_that.autoEstimate);case MealEntryFoodAdded():
return foodAdded();case MealEntryFoodRemoved():
return foodRemoved(_that.id);case MealEntryFoodNameChanged():
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged():
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged():
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled():
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled():
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged():
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded():
return photosAdded(_that.photos);case MealEntryPhotosCleared():
return photosCleared();case MealEntryEstimateRequested():
return estimateRequested();case MealEntryPhotoEstimateRequested():
return photoEstimateRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay,  bool autoEstimate)?  started,TResult? Function()?  foodAdded,TResult? Function( String id)?  foodRemoved,TResult? Function( String id,  String name)?  foodNameChanged,TResult? Function( String id,  Nutrition nutrition)?  foodNutritionChanged,TResult? Function( String id,  double quantity)?  foodQuantityChanged,TResult? Function( String id,  bool addToUsualMeals)?  foodAddToUsualMealsToggled,TResult? Function( MealEntryMode mealEntryMode)?  entryModeToggled,TResult? Function( MealOfTheDay mealOfTheDay)?  mealOfTheDayChanged,TResult? Function( List<MealPhoto> photos)?  photosAdded,TResult? Function()?  photosCleared,TResult? Function()?  estimateRequested,TResult? Function()?  photoEstimateRequested,}) {final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay,_that.autoEstimate);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded();case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that.id);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that.photos);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared();case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested();case MealEntryPhotoEstimateRequested() when photoEstimateRequested != null:
return photoEstimateRequested();case _:
  return null;

}
}

}

/// @nodoc


class MealEntryStarted implements MealEntryEvent {
  const MealEntryStarted({final  List<FoodDraft>? initialFoods, final  List<MealPhoto> photos = const <MealPhoto>[], this.mealOfTheDay, this.autoEstimate = false}): _initialFoods = initialFoods,_photos = photos;
  

 final  List<FoodDraft>? _initialFoods;
 List<FoodDraft>? get initialFoods {
  final value = _initialFoods;
  if (value == null) return null;
  if (_initialFoods is EqualUnmodifiableListView) return _initialFoods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<MealPhoto> _photos;
@JsonKey() List<MealPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

 final  MealOfTheDay? mealOfTheDay;
@JsonKey() final  bool autoEstimate;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryStartedCopyWith<MealEntryStarted> get copyWith => _$MealEntryStartedCopyWithImpl<MealEntryStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryStarted&&const DeepCollectionEquality().equals(other._initialFoods, _initialFoods)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&(identical(other.autoEstimate, autoEstimate) || other.autoEstimate == autoEstimate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_initialFoods),const DeepCollectionEquality().hash(_photos),mealOfTheDay,autoEstimate);

@override
String toString() {
  return 'MealEntryEvent.started(initialFoods: $initialFoods, photos: $photos, mealOfTheDay: $mealOfTheDay, autoEstimate: $autoEstimate)';
}


}

/// @nodoc
abstract mixin class $MealEntryStartedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryStartedCopyWith(MealEntryStarted value, $Res Function(MealEntryStarted) _then) = _$MealEntryStartedCopyWithImpl;
@useResult
$Res call({
 List<FoodDraft>? initialFoods, List<MealPhoto> photos, MealOfTheDay? mealOfTheDay, bool autoEstimate
});




}
/// @nodoc
class _$MealEntryStartedCopyWithImpl<$Res>
    implements $MealEntryStartedCopyWith<$Res> {
  _$MealEntryStartedCopyWithImpl(this._self, this._then);

  final MealEntryStarted _self;
  final $Res Function(MealEntryStarted) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? initialFoods = freezed,Object? photos = null,Object? mealOfTheDay = freezed,Object? autoEstimate = null,}) {
  return _then(MealEntryStarted(
initialFoods: freezed == initialFoods ? _self._initialFoods : initialFoods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,mealOfTheDay: freezed == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay?,autoEstimate: null == autoEstimate ? _self.autoEstimate : autoEstimate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MealEntryFoodAdded implements MealEntryEvent {
  const MealEntryFoodAdded();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodAdded);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MealEntryEvent.foodAdded()';
}


}




/// @nodoc


class MealEntryFoodRemoved implements MealEntryEvent {
  const MealEntryFoodRemoved(this.id);
  

 final  String id;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodRemovedCopyWith<MealEntryFoodRemoved> get copyWith => _$MealEntryFoodRemovedCopyWithImpl<MealEntryFoodRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodRemoved&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'MealEntryEvent.foodRemoved(id: $id)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodRemovedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodRemovedCopyWith(MealEntryFoodRemoved value, $Res Function(MealEntryFoodRemoved) _then) = _$MealEntryFoodRemovedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$MealEntryFoodRemovedCopyWithImpl<$Res>
    implements $MealEntryFoodRemovedCopyWith<$Res> {
  _$MealEntryFoodRemovedCopyWithImpl(this._self, this._then);

  final MealEntryFoodRemoved _self;
  final $Res Function(MealEntryFoodRemoved) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(MealEntryFoodRemoved(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MealEntryFoodNameChanged implements MealEntryEvent {
  const MealEntryFoodNameChanged(this.id, this.name);
  

 final  String id;
 final  String name;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodNameChangedCopyWith<MealEntryFoodNameChanged> get copyWith => _$MealEntryFoodNameChangedCopyWithImpl<MealEntryFoodNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodNameChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'MealEntryEvent.foodNameChanged(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodNameChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodNameChangedCopyWith(MealEntryFoodNameChanged value, $Res Function(MealEntryFoodNameChanged) _then) = _$MealEntryFoodNameChangedCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$MealEntryFoodNameChangedCopyWithImpl<$Res>
    implements $MealEntryFoodNameChangedCopyWith<$Res> {
  _$MealEntryFoodNameChangedCopyWithImpl(this._self, this._then);

  final MealEntryFoodNameChanged _self;
  final $Res Function(MealEntryFoodNameChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(MealEntryFoodNameChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MealEntryFoodNutritionChanged implements MealEntryEvent {
  const MealEntryFoodNutritionChanged(this.id, this.nutrition);
  

 final  String id;
 final  Nutrition nutrition;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodNutritionChangedCopyWith<MealEntryFoodNutritionChanged> get copyWith => _$MealEntryFoodNutritionChangedCopyWithImpl<MealEntryFoodNutritionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodNutritionChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition));
}


@override
int get hashCode => Object.hash(runtimeType,id,nutrition);

@override
String toString() {
  return 'MealEntryEvent.foodNutritionChanged(id: $id, nutrition: $nutrition)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodNutritionChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodNutritionChangedCopyWith(MealEntryFoodNutritionChanged value, $Res Function(MealEntryFoodNutritionChanged) _then) = _$MealEntryFoodNutritionChangedCopyWithImpl;
@useResult
$Res call({
 String id, Nutrition nutrition
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealEntryFoodNutritionChangedCopyWithImpl<$Res>
    implements $MealEntryFoodNutritionChangedCopyWith<$Res> {
  _$MealEntryFoodNutritionChangedCopyWithImpl(this._self, this._then);

  final MealEntryFoodNutritionChanged _self;
  final $Res Function(MealEntryFoodNutritionChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nutrition = null,}) {
  return _then(MealEntryFoodNutritionChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,
  ));
}

/// Create a copy of MealEntryEvent
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


class MealEntryFoodQuantityChanged implements MealEntryEvent {
  const MealEntryFoodQuantityChanged(this.id, this.quantity);
  

 final  String id;
 final  double quantity;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodQuantityChangedCopyWith<MealEntryFoodQuantityChanged> get copyWith => _$MealEntryFoodQuantityChangedCopyWithImpl<MealEntryFoodQuantityChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodQuantityChanged&&(identical(other.id, id) || other.id == id)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}


@override
int get hashCode => Object.hash(runtimeType,id,quantity);

@override
String toString() {
  return 'MealEntryEvent.foodQuantityChanged(id: $id, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodQuantityChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodQuantityChangedCopyWith(MealEntryFoodQuantityChanged value, $Res Function(MealEntryFoodQuantityChanged) _then) = _$MealEntryFoodQuantityChangedCopyWithImpl;
@useResult
$Res call({
 String id, double quantity
});




}
/// @nodoc
class _$MealEntryFoodQuantityChangedCopyWithImpl<$Res>
    implements $MealEntryFoodQuantityChangedCopyWith<$Res> {
  _$MealEntryFoodQuantityChangedCopyWithImpl(this._self, this._then);

  final MealEntryFoodQuantityChanged _self;
  final $Res Function(MealEntryFoodQuantityChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? quantity = null,}) {
  return _then(MealEntryFoodQuantityChanged(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class MealEntryFoodAddToUsualMealsToggled implements MealEntryEvent {
  const MealEntryFoodAddToUsualMealsToggled(this.id, {required this.addToUsualMeals});
  

 final  String id;
 final  bool addToUsualMeals;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodAddToUsualMealsToggledCopyWith<MealEntryFoodAddToUsualMealsToggled> get copyWith => _$MealEntryFoodAddToUsualMealsToggledCopyWithImpl<MealEntryFoodAddToUsualMealsToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodAddToUsualMealsToggled&&(identical(other.id, id) || other.id == id)&&(identical(other.addToUsualMeals, addToUsualMeals) || other.addToUsualMeals == addToUsualMeals));
}


@override
int get hashCode => Object.hash(runtimeType,id,addToUsualMeals);

@override
String toString() {
  return 'MealEntryEvent.foodAddToUsualMealsToggled(id: $id, addToUsualMeals: $addToUsualMeals)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodAddToUsualMealsToggledCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodAddToUsualMealsToggledCopyWith(MealEntryFoodAddToUsualMealsToggled value, $Res Function(MealEntryFoodAddToUsualMealsToggled) _then) = _$MealEntryFoodAddToUsualMealsToggledCopyWithImpl;
@useResult
$Res call({
 String id, bool addToUsualMeals
});




}
/// @nodoc
class _$MealEntryFoodAddToUsualMealsToggledCopyWithImpl<$Res>
    implements $MealEntryFoodAddToUsualMealsToggledCopyWith<$Res> {
  _$MealEntryFoodAddToUsualMealsToggledCopyWithImpl(this._self, this._then);

  final MealEntryFoodAddToUsualMealsToggled _self;
  final $Res Function(MealEntryFoodAddToUsualMealsToggled) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? addToUsualMeals = null,}) {
  return _then(MealEntryFoodAddToUsualMealsToggled(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,addToUsualMeals: null == addToUsualMeals ? _self.addToUsualMeals : addToUsualMeals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class MealEntryModeToggled implements MealEntryEvent {
  const MealEntryModeToggled(this.mealEntryMode);
  

 final  MealEntryMode mealEntryMode;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryModeToggledCopyWith<MealEntryModeToggled> get copyWith => _$MealEntryModeToggledCopyWithImpl<MealEntryModeToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryModeToggled&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode));
}


@override
int get hashCode => Object.hash(runtimeType,mealEntryMode);

@override
String toString() {
  return 'MealEntryEvent.entryModeToggled(mealEntryMode: $mealEntryMode)';
}


}

/// @nodoc
abstract mixin class $MealEntryModeToggledCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryModeToggledCopyWith(MealEntryModeToggled value, $Res Function(MealEntryModeToggled) _then) = _$MealEntryModeToggledCopyWithImpl;
@useResult
$Res call({
 MealEntryMode mealEntryMode
});




}
/// @nodoc
class _$MealEntryModeToggledCopyWithImpl<$Res>
    implements $MealEntryModeToggledCopyWith<$Res> {
  _$MealEntryModeToggledCopyWithImpl(this._self, this._then);

  final MealEntryModeToggled _self;
  final $Res Function(MealEntryModeToggled) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealEntryMode = null,}) {
  return _then(MealEntryModeToggled(
null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,
  ));
}


}

/// @nodoc


class MealEntryMealOfTheDayChanged implements MealEntryEvent {
  const MealEntryMealOfTheDayChanged(this.mealOfTheDay);
  

 final  MealOfTheDay mealOfTheDay;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryMealOfTheDayChangedCopyWith<MealEntryMealOfTheDayChanged> get copyWith => _$MealEntryMealOfTheDayChangedCopyWithImpl<MealEntryMealOfTheDayChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryMealOfTheDayChanged&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay));
}


@override
int get hashCode => Object.hash(runtimeType,mealOfTheDay);

@override
String toString() {
  return 'MealEntryEvent.mealOfTheDayChanged(mealOfTheDay: $mealOfTheDay)';
}


}

/// @nodoc
abstract mixin class $MealEntryMealOfTheDayChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryMealOfTheDayChangedCopyWith(MealEntryMealOfTheDayChanged value, $Res Function(MealEntryMealOfTheDayChanged) _then) = _$MealEntryMealOfTheDayChangedCopyWithImpl;
@useResult
$Res call({
 MealOfTheDay mealOfTheDay
});




}
/// @nodoc
class _$MealEntryMealOfTheDayChangedCopyWithImpl<$Res>
    implements $MealEntryMealOfTheDayChangedCopyWith<$Res> {
  _$MealEntryMealOfTheDayChangedCopyWithImpl(this._self, this._then);

  final MealEntryMealOfTheDayChanged _self;
  final $Res Function(MealEntryMealOfTheDayChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealOfTheDay = null,}) {
  return _then(MealEntryMealOfTheDayChanged(
null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,
  ));
}


}

/// @nodoc


class MealEntryPhotosAdded implements MealEntryEvent {
  const MealEntryPhotosAdded(final  List<MealPhoto> photos): _photos = photos;
  

 final  List<MealPhoto> _photos;
 List<MealPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}


/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryPhotosAddedCopyWith<MealEntryPhotosAdded> get copyWith => _$MealEntryPhotosAddedCopyWithImpl<MealEntryPhotosAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryPhotosAdded&&const DeepCollectionEquality().equals(other._photos, _photos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_photos));

@override
String toString() {
  return 'MealEntryEvent.photosAdded(photos: $photos)';
}


}

/// @nodoc
abstract mixin class $MealEntryPhotosAddedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryPhotosAddedCopyWith(MealEntryPhotosAdded value, $Res Function(MealEntryPhotosAdded) _then) = _$MealEntryPhotosAddedCopyWithImpl;
@useResult
$Res call({
 List<MealPhoto> photos
});




}
/// @nodoc
class _$MealEntryPhotosAddedCopyWithImpl<$Res>
    implements $MealEntryPhotosAddedCopyWith<$Res> {
  _$MealEntryPhotosAddedCopyWithImpl(this._self, this._then);

  final MealEntryPhotosAdded _self;
  final $Res Function(MealEntryPhotosAdded) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? photos = null,}) {
  return _then(MealEntryPhotosAdded(
null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,
  ));
}


}

/// @nodoc


class MealEntryPhotosCleared implements MealEntryEvent {
  const MealEntryPhotosCleared();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryPhotosCleared);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MealEntryEvent.photosCleared()';
}


}




/// @nodoc


class MealEntryEstimateRequested implements MealEntryEvent {
  const MealEntryEstimateRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryEstimateRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MealEntryEvent.estimateRequested()';
}


}




/// @nodoc


class MealEntryPhotoEstimateRequested implements MealEntryEvent {
  const MealEntryPhotoEstimateRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryPhotoEstimateRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MealEntryEvent.photoEstimateRequested()';
}


}




/// @nodoc
mixin _$MealEntryState {

 List<FoodDraft> get foods; MealEntryMode get mealEntryMode; MealOfTheDay get mealOfTheDay; List<MealPhoto> get photos; MealEntryStatus get status; String? get errorMessage;
/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryStateCopyWith<MealEntryState> get copyWith => _$MealEntryStateCopyWithImpl<MealEntryState>(this as MealEntryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryState&&const DeepCollectionEquality().equals(other.foods, foods)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(foods),mealEntryMode,mealOfTheDay,const DeepCollectionEquality().hash(photos),status,errorMessage);

@override
String toString() {
  return 'MealEntryState(foods: $foods, mealEntryMode: $mealEntryMode, mealOfTheDay: $mealOfTheDay, photos: $photos, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MealEntryStateCopyWith<$Res>  {
  factory $MealEntryStateCopyWith(MealEntryState value, $Res Function(MealEntryState) _then) = _$MealEntryStateCopyWithImpl;
@useResult
$Res call({
 List<FoodDraft> foods, MealEntryMode mealEntryMode, MealOfTheDay mealOfTheDay, List<MealPhoto> photos, MealEntryStatus status, String? errorMessage
});




}
/// @nodoc
class _$MealEntryStateCopyWithImpl<$Res>
    implements $MealEntryStateCopyWith<$Res> {
  _$MealEntryStateCopyWithImpl(this._self, this._then);

  final MealEntryState _self;
  final $Res Function(MealEntryState) _then;

/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foods = null,Object? mealEntryMode = null,Object? mealOfTheDay = null,Object? photos = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
foods: null == foods ? _self.foods : foods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealEntryStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MealEntryState].
extension MealEntryStatePatterns on MealEntryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MealEntryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MealEntryState value)  $default,){
final _that = this;
switch (_that) {
case _MealEntryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MealEntryState value)?  $default,){
final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MealEntryState():
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MealEntryState extends MealEntryState {
  const _MealEntryState({final  List<FoodDraft> foods = const <FoodDraft>[], this.mealEntryMode = MealEntryMode.wholeMeal, this.mealOfTheDay = MealOfTheDay.breakfast, final  List<MealPhoto> photos = const <MealPhoto>[], this.status = MealEntryStatus.idle, this.errorMessage}): _foods = foods,_photos = photos,super._();
  

 final  List<FoodDraft> _foods;
@override@JsonKey() List<FoodDraft> get foods {
  if (_foods is EqualUnmodifiableListView) return _foods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foods);
}

@override@JsonKey() final  MealEntryMode mealEntryMode;
@override@JsonKey() final  MealOfTheDay mealOfTheDay;
 final  List<MealPhoto> _photos;
@override@JsonKey() List<MealPhoto> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

@override@JsonKey() final  MealEntryStatus status;
@override final  String? errorMessage;

/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealEntryStateCopyWith<_MealEntryState> get copyWith => __$MealEntryStateCopyWithImpl<_MealEntryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealEntryState&&const DeepCollectionEquality().equals(other._foods, _foods)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_foods),mealEntryMode,mealOfTheDay,const DeepCollectionEquality().hash(_photos),status,errorMessage);

@override
String toString() {
  return 'MealEntryState(foods: $foods, mealEntryMode: $mealEntryMode, mealOfTheDay: $mealOfTheDay, photos: $photos, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MealEntryStateCopyWith<$Res> implements $MealEntryStateCopyWith<$Res> {
  factory _$MealEntryStateCopyWith(_MealEntryState value, $Res Function(_MealEntryState) _then) = __$MealEntryStateCopyWithImpl;
@override @useResult
$Res call({
 List<FoodDraft> foods, MealEntryMode mealEntryMode, MealOfTheDay mealOfTheDay, List<MealPhoto> photos, MealEntryStatus status, String? errorMessage
});




}
/// @nodoc
class __$MealEntryStateCopyWithImpl<$Res>
    implements _$MealEntryStateCopyWith<$Res> {
  __$MealEntryStateCopyWithImpl(this._self, this._then);

  final _MealEntryState _self;
  final $Res Function(_MealEntryState) _then;

/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foods = null,Object? mealEntryMode = null,Object? mealOfTheDay = null,Object? photos = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_MealEntryState(
foods: null == foods ? _self._foods : foods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealEntryStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
