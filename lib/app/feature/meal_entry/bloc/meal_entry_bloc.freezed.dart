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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MealEntryStarted value)?  started,TResult Function( MealEntryFoodAdded value)?  foodAdded,TResult Function( MealEntryFoodRemoved value)?  foodRemoved,TResult Function( MealEntryFoodNameChanged value)?  foodNameChanged,TResult Function( MealEntryFoodNutritionChanged value)?  foodNutritionChanged,TResult Function( MealEntryFoodQuantityChanged value)?  foodQuantityChanged,TResult Function( MealEntryFoodAddToUsualMealsToggled value)?  foodAddToUsualMealsToggled,TResult Function( MealEntryModeToggled value)?  entryModeToggled,TResult Function( MealEntryMealOfTheDayChanged value)?  mealOfTheDayChanged,TResult Function( MealEntryPhotosAdded value)?  photosAdded,TResult Function( MealEntryPhotoRemoved value)?  photoRemoved,TResult Function( MealEntryPhotosCleared value)?  photosCleared,TResult Function( MealEntryEstimateRequested value)?  estimateRequested,TResult Function( MealEntryMealNameChanged value)?  mealNameChanged,TResult Function( MealEntryDescriptionChanged value)?  descriptionChanged,TResult Function( MealEntryFoodPicked value)?  foodPicked,TResult Function( MealEntryFoodEntered value)?  foodEntered,TResult Function( MealEntryFoodSavedAsUsual value)?  foodSavedAsUsual,required TResult orElse(),}){
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
return photosAdded(_that);case MealEntryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared(_that);case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested(_that);case MealEntryMealNameChanged() when mealNameChanged != null:
return mealNameChanged(_that);case MealEntryDescriptionChanged() when descriptionChanged != null:
return descriptionChanged(_that);case MealEntryFoodPicked() when foodPicked != null:
return foodPicked(_that);case MealEntryFoodEntered() when foodEntered != null:
return foodEntered(_that);case MealEntryFoodSavedAsUsual() when foodSavedAsUsual != null:
return foodSavedAsUsual(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MealEntryStarted value)  started,required TResult Function( MealEntryFoodAdded value)  foodAdded,required TResult Function( MealEntryFoodRemoved value)  foodRemoved,required TResult Function( MealEntryFoodNameChanged value)  foodNameChanged,required TResult Function( MealEntryFoodNutritionChanged value)  foodNutritionChanged,required TResult Function( MealEntryFoodQuantityChanged value)  foodQuantityChanged,required TResult Function( MealEntryFoodAddToUsualMealsToggled value)  foodAddToUsualMealsToggled,required TResult Function( MealEntryModeToggled value)  entryModeToggled,required TResult Function( MealEntryMealOfTheDayChanged value)  mealOfTheDayChanged,required TResult Function( MealEntryPhotosAdded value)  photosAdded,required TResult Function( MealEntryPhotoRemoved value)  photoRemoved,required TResult Function( MealEntryPhotosCleared value)  photosCleared,required TResult Function( MealEntryEstimateRequested value)  estimateRequested,required TResult Function( MealEntryMealNameChanged value)  mealNameChanged,required TResult Function( MealEntryDescriptionChanged value)  descriptionChanged,required TResult Function( MealEntryFoodPicked value)  foodPicked,required TResult Function( MealEntryFoodEntered value)  foodEntered,required TResult Function( MealEntryFoodSavedAsUsual value)  foodSavedAsUsual,}){
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
return photosAdded(_that);case MealEntryPhotoRemoved():
return photoRemoved(_that);case MealEntryPhotosCleared():
return photosCleared(_that);case MealEntryEstimateRequested():
return estimateRequested(_that);case MealEntryMealNameChanged():
return mealNameChanged(_that);case MealEntryDescriptionChanged():
return descriptionChanged(_that);case MealEntryFoodPicked():
return foodPicked(_that);case MealEntryFoodEntered():
return foodEntered(_that);case MealEntryFoodSavedAsUsual():
return foodSavedAsUsual(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MealEntryStarted value)?  started,TResult? Function( MealEntryFoodAdded value)?  foodAdded,TResult? Function( MealEntryFoodRemoved value)?  foodRemoved,TResult? Function( MealEntryFoodNameChanged value)?  foodNameChanged,TResult? Function( MealEntryFoodNutritionChanged value)?  foodNutritionChanged,TResult? Function( MealEntryFoodQuantityChanged value)?  foodQuantityChanged,TResult? Function( MealEntryFoodAddToUsualMealsToggled value)?  foodAddToUsualMealsToggled,TResult? Function( MealEntryModeToggled value)?  entryModeToggled,TResult? Function( MealEntryMealOfTheDayChanged value)?  mealOfTheDayChanged,TResult? Function( MealEntryPhotosAdded value)?  photosAdded,TResult? Function( MealEntryPhotoRemoved value)?  photoRemoved,TResult? Function( MealEntryPhotosCleared value)?  photosCleared,TResult? Function( MealEntryEstimateRequested value)?  estimateRequested,TResult? Function( MealEntryMealNameChanged value)?  mealNameChanged,TResult? Function( MealEntryDescriptionChanged value)?  descriptionChanged,TResult? Function( MealEntryFoodPicked value)?  foodPicked,TResult? Function( MealEntryFoodEntered value)?  foodEntered,TResult? Function( MealEntryFoodSavedAsUsual value)?  foodSavedAsUsual,}){
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
return photosAdded(_that);case MealEntryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared(_that);case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested(_that);case MealEntryMealNameChanged() when mealNameChanged != null:
return mealNameChanged(_that);case MealEntryDescriptionChanged() when descriptionChanged != null:
return descriptionChanged(_that);case MealEntryFoodPicked() when foodPicked != null:
return foodPicked(_that);case MealEntryFoodEntered() when foodEntered != null:
return foodEntered(_that);case MealEntryFoodSavedAsUsual() when foodSavedAsUsual != null:
return foodSavedAsUsual(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay)?  started,TResult Function( bool addToUsualMeals)?  foodAdded,TResult Function( String id)?  foodRemoved,TResult Function( String id,  String name)?  foodNameChanged,TResult Function( String id,  Nutrition nutrition)?  foodNutritionChanged,TResult Function( String id,  double quantity)?  foodQuantityChanged,TResult Function( String id,  bool addToUsualMeals)?  foodAddToUsualMealsToggled,TResult Function( MealEntryMode mealEntryMode)?  entryModeToggled,TResult Function( MealOfTheDay mealOfTheDay)?  mealOfTheDayChanged,TResult Function( List<MealPhoto> photos)?  photosAdded,TResult Function( int index)?  photoRemoved,TResult Function()?  photosCleared,TResult Function()?  estimateRequested,TResult Function( String mealName)?  mealNameChanged,TResult Function( String description)?  descriptionChanged,TResult Function( UsualFood usualFood)?  foodPicked,TResult Function( String name,  Nutrition nutrition,  String? usualFoodId)?  foodEntered,TResult Function( String id,  String usualFoodId)?  foodSavedAsUsual,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded(_that.addToUsualMeals);case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that.id);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that.photos);case MealEntryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that.index);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared();case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested();case MealEntryMealNameChanged() when mealNameChanged != null:
return mealNameChanged(_that.mealName);case MealEntryDescriptionChanged() when descriptionChanged != null:
return descriptionChanged(_that.description);case MealEntryFoodPicked() when foodPicked != null:
return foodPicked(_that.usualFood);case MealEntryFoodEntered() when foodEntered != null:
return foodEntered(_that.name,_that.nutrition,_that.usualFoodId);case MealEntryFoodSavedAsUsual() when foodSavedAsUsual != null:
return foodSavedAsUsual(_that.id,_that.usualFoodId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay)  started,required TResult Function( bool addToUsualMeals)  foodAdded,required TResult Function( String id)  foodRemoved,required TResult Function( String id,  String name)  foodNameChanged,required TResult Function( String id,  Nutrition nutrition)  foodNutritionChanged,required TResult Function( String id,  double quantity)  foodQuantityChanged,required TResult Function( String id,  bool addToUsualMeals)  foodAddToUsualMealsToggled,required TResult Function( MealEntryMode mealEntryMode)  entryModeToggled,required TResult Function( MealOfTheDay mealOfTheDay)  mealOfTheDayChanged,required TResult Function( List<MealPhoto> photos)  photosAdded,required TResult Function( int index)  photoRemoved,required TResult Function()  photosCleared,required TResult Function()  estimateRequested,required TResult Function( String mealName)  mealNameChanged,required TResult Function( String description)  descriptionChanged,required TResult Function( UsualFood usualFood)  foodPicked,required TResult Function( String name,  Nutrition nutrition,  String? usualFoodId)  foodEntered,required TResult Function( String id,  String usualFoodId)  foodSavedAsUsual,}) {final _that = this;
switch (_that) {
case MealEntryStarted():
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay);case MealEntryFoodAdded():
return foodAdded(_that.addToUsualMeals);case MealEntryFoodRemoved():
return foodRemoved(_that.id);case MealEntryFoodNameChanged():
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged():
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged():
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled():
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled():
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged():
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded():
return photosAdded(_that.photos);case MealEntryPhotoRemoved():
return photoRemoved(_that.index);case MealEntryPhotosCleared():
return photosCleared();case MealEntryEstimateRequested():
return estimateRequested();case MealEntryMealNameChanged():
return mealNameChanged(_that.mealName);case MealEntryDescriptionChanged():
return descriptionChanged(_that.description);case MealEntryFoodPicked():
return foodPicked(_that.usualFood);case MealEntryFoodEntered():
return foodEntered(_that.name,_that.nutrition,_that.usualFoodId);case MealEntryFoodSavedAsUsual():
return foodSavedAsUsual(_that.id,_that.usualFoodId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<FoodDraft>? initialFoods,  List<MealPhoto> photos,  MealOfTheDay? mealOfTheDay)?  started,TResult? Function( bool addToUsualMeals)?  foodAdded,TResult? Function( String id)?  foodRemoved,TResult? Function( String id,  String name)?  foodNameChanged,TResult? Function( String id,  Nutrition nutrition)?  foodNutritionChanged,TResult? Function( String id,  double quantity)?  foodQuantityChanged,TResult? Function( String id,  bool addToUsualMeals)?  foodAddToUsualMealsToggled,TResult? Function( MealEntryMode mealEntryMode)?  entryModeToggled,TResult? Function( MealOfTheDay mealOfTheDay)?  mealOfTheDayChanged,TResult? Function( List<MealPhoto> photos)?  photosAdded,TResult? Function( int index)?  photoRemoved,TResult? Function()?  photosCleared,TResult? Function()?  estimateRequested,TResult? Function( String mealName)?  mealNameChanged,TResult? Function( String description)?  descriptionChanged,TResult? Function( UsualFood usualFood)?  foodPicked,TResult? Function( String name,  Nutrition nutrition,  String? usualFoodId)?  foodEntered,TResult? Function( String id,  String usualFoodId)?  foodSavedAsUsual,}) {final _that = this;
switch (_that) {
case MealEntryStarted() when started != null:
return started(_that.initialFoods,_that.photos,_that.mealOfTheDay);case MealEntryFoodAdded() when foodAdded != null:
return foodAdded(_that.addToUsualMeals);case MealEntryFoodRemoved() when foodRemoved != null:
return foodRemoved(_that.id);case MealEntryFoodNameChanged() when foodNameChanged != null:
return foodNameChanged(_that.id,_that.name);case MealEntryFoodNutritionChanged() when foodNutritionChanged != null:
return foodNutritionChanged(_that.id,_that.nutrition);case MealEntryFoodQuantityChanged() when foodQuantityChanged != null:
return foodQuantityChanged(_that.id,_that.quantity);case MealEntryFoodAddToUsualMealsToggled() when foodAddToUsualMealsToggled != null:
return foodAddToUsualMealsToggled(_that.id,_that.addToUsualMeals);case MealEntryModeToggled() when entryModeToggled != null:
return entryModeToggled(_that.mealEntryMode);case MealEntryMealOfTheDayChanged() when mealOfTheDayChanged != null:
return mealOfTheDayChanged(_that.mealOfTheDay);case MealEntryPhotosAdded() when photosAdded != null:
return photosAdded(_that.photos);case MealEntryPhotoRemoved() when photoRemoved != null:
return photoRemoved(_that.index);case MealEntryPhotosCleared() when photosCleared != null:
return photosCleared();case MealEntryEstimateRequested() when estimateRequested != null:
return estimateRequested();case MealEntryMealNameChanged() when mealNameChanged != null:
return mealNameChanged(_that.mealName);case MealEntryDescriptionChanged() when descriptionChanged != null:
return descriptionChanged(_that.description);case MealEntryFoodPicked() when foodPicked != null:
return foodPicked(_that.usualFood);case MealEntryFoodEntered() when foodEntered != null:
return foodEntered(_that.name,_that.nutrition,_that.usualFoodId);case MealEntryFoodSavedAsUsual() when foodSavedAsUsual != null:
return foodSavedAsUsual(_that.id,_that.usualFoodId);case _:
  return null;

}
}

}

/// @nodoc


class MealEntryStarted implements MealEntryEvent {
  const MealEntryStarted({final  List<FoodDraft>? initialFoods, final  List<MealPhoto> photos = const <MealPhoto>[], this.mealOfTheDay}): _initialFoods = initialFoods,_photos = photos;
  

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

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryStartedCopyWith<MealEntryStarted> get copyWith => _$MealEntryStartedCopyWithImpl<MealEntryStarted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryStarted&&const DeepCollectionEquality().equals(other._initialFoods, _initialFoods)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_initialFoods),const DeepCollectionEquality().hash(_photos),mealOfTheDay);

@override
String toString() {
  return 'MealEntryEvent.started(initialFoods: $initialFoods, photos: $photos, mealOfTheDay: $mealOfTheDay)';
}


}

/// @nodoc
abstract mixin class $MealEntryStartedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryStartedCopyWith(MealEntryStarted value, $Res Function(MealEntryStarted) _then) = _$MealEntryStartedCopyWithImpl;
@useResult
$Res call({
 List<FoodDraft>? initialFoods, List<MealPhoto> photos, MealOfTheDay? mealOfTheDay
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
@pragma('vm:prefer-inline') $Res call({Object? initialFoods = freezed,Object? photos = null,Object? mealOfTheDay = freezed,}) {
  return _then(MealEntryStarted(
initialFoods: freezed == initialFoods ? _self._initialFoods : initialFoods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,mealOfTheDay: freezed == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay?,
  ));
}


}

/// @nodoc


class MealEntryFoodAdded implements MealEntryEvent {
  const MealEntryFoodAdded({this.addToUsualMeals = false});
  

@JsonKey() final  bool addToUsualMeals;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodAddedCopyWith<MealEntryFoodAdded> get copyWith => _$MealEntryFoodAddedCopyWithImpl<MealEntryFoodAdded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodAdded&&(identical(other.addToUsualMeals, addToUsualMeals) || other.addToUsualMeals == addToUsualMeals));
}


@override
int get hashCode => Object.hash(runtimeType,addToUsualMeals);

@override
String toString() {
  return 'MealEntryEvent.foodAdded(addToUsualMeals: $addToUsualMeals)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodAddedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodAddedCopyWith(MealEntryFoodAdded value, $Res Function(MealEntryFoodAdded) _then) = _$MealEntryFoodAddedCopyWithImpl;
@useResult
$Res call({
 bool addToUsualMeals
});




}
/// @nodoc
class _$MealEntryFoodAddedCopyWithImpl<$Res>
    implements $MealEntryFoodAddedCopyWith<$Res> {
  _$MealEntryFoodAddedCopyWithImpl(this._self, this._then);

  final MealEntryFoodAdded _self;
  final $Res Function(MealEntryFoodAdded) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? addToUsualMeals = null,}) {
  return _then(MealEntryFoodAdded(
addToUsualMeals: null == addToUsualMeals ? _self.addToUsualMeals : addToUsualMeals // ignore: cast_nullable_to_non_nullable
as bool,
  ));
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


class MealEntryPhotoRemoved implements MealEntryEvent {
  const MealEntryPhotoRemoved(this.index);
  

 final  int index;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryPhotoRemovedCopyWith<MealEntryPhotoRemoved> get copyWith => _$MealEntryPhotoRemovedCopyWithImpl<MealEntryPhotoRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryPhotoRemoved&&(identical(other.index, index) || other.index == index));
}


@override
int get hashCode => Object.hash(runtimeType,index);

@override
String toString() {
  return 'MealEntryEvent.photoRemoved(index: $index)';
}


}

/// @nodoc
abstract mixin class $MealEntryPhotoRemovedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryPhotoRemovedCopyWith(MealEntryPhotoRemoved value, $Res Function(MealEntryPhotoRemoved) _then) = _$MealEntryPhotoRemovedCopyWithImpl;
@useResult
$Res call({
 int index
});




}
/// @nodoc
class _$MealEntryPhotoRemovedCopyWithImpl<$Res>
    implements $MealEntryPhotoRemovedCopyWith<$Res> {
  _$MealEntryPhotoRemovedCopyWithImpl(this._self, this._then);

  final MealEntryPhotoRemoved _self;
  final $Res Function(MealEntryPhotoRemoved) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? index = null,}) {
  return _then(MealEntryPhotoRemoved(
null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
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


class MealEntryMealNameChanged implements MealEntryEvent {
  const MealEntryMealNameChanged(this.mealName);
  

 final  String mealName;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryMealNameChangedCopyWith<MealEntryMealNameChanged> get copyWith => _$MealEntryMealNameChangedCopyWithImpl<MealEntryMealNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryMealNameChanged&&(identical(other.mealName, mealName) || other.mealName == mealName));
}


@override
int get hashCode => Object.hash(runtimeType,mealName);

@override
String toString() {
  return 'MealEntryEvent.mealNameChanged(mealName: $mealName)';
}


}

/// @nodoc
abstract mixin class $MealEntryMealNameChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryMealNameChangedCopyWith(MealEntryMealNameChanged value, $Res Function(MealEntryMealNameChanged) _then) = _$MealEntryMealNameChangedCopyWithImpl;
@useResult
$Res call({
 String mealName
});




}
/// @nodoc
class _$MealEntryMealNameChangedCopyWithImpl<$Res>
    implements $MealEntryMealNameChangedCopyWith<$Res> {
  _$MealEntryMealNameChangedCopyWithImpl(this._self, this._then);

  final MealEntryMealNameChanged _self;
  final $Res Function(MealEntryMealNameChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? mealName = null,}) {
  return _then(MealEntryMealNameChanged(
null == mealName ? _self.mealName : mealName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MealEntryDescriptionChanged implements MealEntryEvent {
  const MealEntryDescriptionChanged(this.description);
  

 final  String description;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryDescriptionChangedCopyWith<MealEntryDescriptionChanged> get copyWith => _$MealEntryDescriptionChangedCopyWithImpl<MealEntryDescriptionChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryDescriptionChanged&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,description);

@override
String toString() {
  return 'MealEntryEvent.descriptionChanged(description: $description)';
}


}

/// @nodoc
abstract mixin class $MealEntryDescriptionChangedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryDescriptionChangedCopyWith(MealEntryDescriptionChanged value, $Res Function(MealEntryDescriptionChanged) _then) = _$MealEntryDescriptionChangedCopyWithImpl;
@useResult
$Res call({
 String description
});




}
/// @nodoc
class _$MealEntryDescriptionChangedCopyWithImpl<$Res>
    implements $MealEntryDescriptionChangedCopyWith<$Res> {
  _$MealEntryDescriptionChangedCopyWithImpl(this._self, this._then);

  final MealEntryDescriptionChanged _self;
  final $Res Function(MealEntryDescriptionChanged) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? description = null,}) {
  return _then(MealEntryDescriptionChanged(
null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MealEntryFoodPicked implements MealEntryEvent {
  const MealEntryFoodPicked(this.usualFood);
  

 final  UsualFood usualFood;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodPickedCopyWith<MealEntryFoodPicked> get copyWith => _$MealEntryFoodPickedCopyWithImpl<MealEntryFoodPicked>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodPicked&&(identical(other.usualFood, usualFood) || other.usualFood == usualFood));
}


@override
int get hashCode => Object.hash(runtimeType,usualFood);

@override
String toString() {
  return 'MealEntryEvent.foodPicked(usualFood: $usualFood)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodPickedCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodPickedCopyWith(MealEntryFoodPicked value, $Res Function(MealEntryFoodPicked) _then) = _$MealEntryFoodPickedCopyWithImpl;
@useResult
$Res call({
 UsualFood usualFood
});


$UsualFoodCopyWith<$Res> get usualFood;

}
/// @nodoc
class _$MealEntryFoodPickedCopyWithImpl<$Res>
    implements $MealEntryFoodPickedCopyWith<$Res> {
  _$MealEntryFoodPickedCopyWithImpl(this._self, this._then);

  final MealEntryFoodPicked _self;
  final $Res Function(MealEntryFoodPicked) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? usualFood = null,}) {
  return _then(MealEntryFoodPicked(
null == usualFood ? _self.usualFood : usualFood // ignore: cast_nullable_to_non_nullable
as UsualFood,
  ));
}

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UsualFoodCopyWith<$Res> get usualFood {
  
  return $UsualFoodCopyWith<$Res>(_self.usualFood, (value) {
    return _then(_self.copyWith(usualFood: value));
  });
}
}

/// @nodoc


class MealEntryFoodEntered implements MealEntryEvent {
  const MealEntryFoodEntered({required this.name, required this.nutrition, this.usualFoodId});
  

 final  String name;
 final  Nutrition nutrition;
 final  String? usualFoodId;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodEnteredCopyWith<MealEntryFoodEntered> get copyWith => _$MealEntryFoodEnteredCopyWithImpl<MealEntryFoodEntered>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodEntered&&(identical(other.name, name) || other.name == name)&&(identical(other.nutrition, nutrition) || other.nutrition == nutrition)&&(identical(other.usualFoodId, usualFoodId) || other.usualFoodId == usualFoodId));
}


@override
int get hashCode => Object.hash(runtimeType,name,nutrition,usualFoodId);

@override
String toString() {
  return 'MealEntryEvent.foodEntered(name: $name, nutrition: $nutrition, usualFoodId: $usualFoodId)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodEnteredCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodEnteredCopyWith(MealEntryFoodEntered value, $Res Function(MealEntryFoodEntered) _then) = _$MealEntryFoodEnteredCopyWithImpl;
@useResult
$Res call({
 String name, Nutrition nutrition, String? usualFoodId
});


$NutritionCopyWith<$Res> get nutrition;

}
/// @nodoc
class _$MealEntryFoodEnteredCopyWithImpl<$Res>
    implements $MealEntryFoodEnteredCopyWith<$Res> {
  _$MealEntryFoodEnteredCopyWithImpl(this._self, this._then);

  final MealEntryFoodEntered _self;
  final $Res Function(MealEntryFoodEntered) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? nutrition = null,Object? usualFoodId = freezed,}) {
  return _then(MealEntryFoodEntered(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nutrition: null == nutrition ? _self.nutrition : nutrition // ignore: cast_nullable_to_non_nullable
as Nutrition,usualFoodId: freezed == usualFoodId ? _self.usualFoodId : usualFoodId // ignore: cast_nullable_to_non_nullable
as String?,
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


class MealEntryFoodSavedAsUsual implements MealEntryEvent {
  const MealEntryFoodSavedAsUsual(this.id, this.usualFoodId);
  

 final  String id;
 final  String usualFoodId;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryFoodSavedAsUsualCopyWith<MealEntryFoodSavedAsUsual> get copyWith => _$MealEntryFoodSavedAsUsualCopyWithImpl<MealEntryFoodSavedAsUsual>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryFoodSavedAsUsual&&(identical(other.id, id) || other.id == id)&&(identical(other.usualFoodId, usualFoodId) || other.usualFoodId == usualFoodId));
}


@override
int get hashCode => Object.hash(runtimeType,id,usualFoodId);

@override
String toString() {
  return 'MealEntryEvent.foodSavedAsUsual(id: $id, usualFoodId: $usualFoodId)';
}


}

/// @nodoc
abstract mixin class $MealEntryFoodSavedAsUsualCopyWith<$Res> implements $MealEntryEventCopyWith<$Res> {
  factory $MealEntryFoodSavedAsUsualCopyWith(MealEntryFoodSavedAsUsual value, $Res Function(MealEntryFoodSavedAsUsual) _then) = _$MealEntryFoodSavedAsUsualCopyWithImpl;
@useResult
$Res call({
 String id, String usualFoodId
});




}
/// @nodoc
class _$MealEntryFoodSavedAsUsualCopyWithImpl<$Res>
    implements $MealEntryFoodSavedAsUsualCopyWith<$Res> {
  _$MealEntryFoodSavedAsUsualCopyWithImpl(this._self, this._then);

  final MealEntryFoodSavedAsUsual _self;
  final $Res Function(MealEntryFoodSavedAsUsual) _then;

/// Create a copy of MealEntryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? usualFoodId = null,}) {
  return _then(MealEntryFoodSavedAsUsual(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,null == usualFoodId ? _self.usualFoodId : usualFoodId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MealEntryState {

 List<FoodDraft> get foods; MealEntryMode get mealEntryMode; MealOfTheDay get mealOfTheDay; List<MealPhoto> get photos; MealEntryStatus get status; String get mealName;/// Free-text meal description used in by-foods mode to itemize a meal into
/// its component foods. Separate from [mealName]; cleared once the AI has
/// turned it into food rows.
 String get description; String? get errorMessage;
/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MealEntryStateCopyWith<MealEntryState> get copyWith => _$MealEntryStateCopyWithImpl<MealEntryState>(this as MealEntryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MealEntryState&&const DeepCollectionEquality().equals(other.foods, foods)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&const DeepCollectionEquality().equals(other.photos, photos)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealName, mealName) || other.mealName == mealName)&&(identical(other.description, description) || other.description == description)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(foods),mealEntryMode,mealOfTheDay,const DeepCollectionEquality().hash(photos),status,mealName,description,errorMessage);

@override
String toString() {
  return 'MealEntryState(foods: $foods, mealEntryMode: $mealEntryMode, mealOfTheDay: $mealOfTheDay, photos: $photos, status: $status, mealName: $mealName, description: $description, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $MealEntryStateCopyWith<$Res>  {
  factory $MealEntryStateCopyWith(MealEntryState value, $Res Function(MealEntryState) _then) = _$MealEntryStateCopyWithImpl;
@useResult
$Res call({
 List<FoodDraft> foods, MealEntryMode mealEntryMode, MealOfTheDay mealOfTheDay, List<MealPhoto> photos, MealEntryStatus status, String mealName, String description, String? errorMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? foods = null,Object? mealEntryMode = null,Object? mealOfTheDay = null,Object? photos = null,Object? status = null,Object? mealName = null,Object? description = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
foods: null == foods ? _self.foods : foods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealEntryStatus,mealName: null == mealName ? _self.mealName : mealName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String mealName,  String description,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.mealName,_that.description,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String mealName,  String description,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _MealEntryState():
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.mealName,_that.description,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<FoodDraft> foods,  MealEntryMode mealEntryMode,  MealOfTheDay mealOfTheDay,  List<MealPhoto> photos,  MealEntryStatus status,  String mealName,  String description,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _MealEntryState() when $default != null:
return $default(_that.foods,_that.mealEntryMode,_that.mealOfTheDay,_that.photos,_that.status,_that.mealName,_that.description,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _MealEntryState extends MealEntryState {
  const _MealEntryState({final  List<FoodDraft> foods = const <FoodDraft>[], this.mealEntryMode = MealEntryMode.wholeMeal, this.mealOfTheDay = MealOfTheDay.breakfast, final  List<MealPhoto> photos = const <MealPhoto>[], this.status = MealEntryStatus.idle, this.mealName = '', this.description = '', this.errorMessage}): _foods = foods,_photos = photos,super._();
  

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
@override@JsonKey() final  String mealName;
/// Free-text meal description used in by-foods mode to itemize a meal into
/// its component foods. Separate from [mealName]; cleared once the AI has
/// turned it into food rows.
@override@JsonKey() final  String description;
@override final  String? errorMessage;

/// Create a copy of MealEntryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MealEntryStateCopyWith<_MealEntryState> get copyWith => __$MealEntryStateCopyWithImpl<_MealEntryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MealEntryState&&const DeepCollectionEquality().equals(other._foods, _foods)&&(identical(other.mealEntryMode, mealEntryMode) || other.mealEntryMode == mealEntryMode)&&(identical(other.mealOfTheDay, mealOfTheDay) || other.mealOfTheDay == mealOfTheDay)&&const DeepCollectionEquality().equals(other._photos, _photos)&&(identical(other.status, status) || other.status == status)&&(identical(other.mealName, mealName) || other.mealName == mealName)&&(identical(other.description, description) || other.description == description)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_foods),mealEntryMode,mealOfTheDay,const DeepCollectionEquality().hash(_photos),status,mealName,description,errorMessage);

@override
String toString() {
  return 'MealEntryState(foods: $foods, mealEntryMode: $mealEntryMode, mealOfTheDay: $mealOfTheDay, photos: $photos, status: $status, mealName: $mealName, description: $description, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$MealEntryStateCopyWith<$Res> implements $MealEntryStateCopyWith<$Res> {
  factory _$MealEntryStateCopyWith(_MealEntryState value, $Res Function(_MealEntryState) _then) = __$MealEntryStateCopyWithImpl;
@override @useResult
$Res call({
 List<FoodDraft> foods, MealEntryMode mealEntryMode, MealOfTheDay mealOfTheDay, List<MealPhoto> photos, MealEntryStatus status, String mealName, String description, String? errorMessage
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
@override @pragma('vm:prefer-inline') $Res call({Object? foods = null,Object? mealEntryMode = null,Object? mealOfTheDay = null,Object? photos = null,Object? status = null,Object? mealName = null,Object? description = null,Object? errorMessage = freezed,}) {
  return _then(_MealEntryState(
foods: null == foods ? _self._foods : foods // ignore: cast_nullable_to_non_nullable
as List<FoodDraft>,mealEntryMode: null == mealEntryMode ? _self.mealEntryMode : mealEntryMode // ignore: cast_nullable_to_non_nullable
as MealEntryMode,mealOfTheDay: null == mealOfTheDay ? _self.mealOfTheDay : mealOfTheDay // ignore: cast_nullable_to_non_nullable
as MealOfTheDay,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<MealPhoto>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as MealEntryStatus,mealName: null == mealName ? _self.mealName : mealName // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
