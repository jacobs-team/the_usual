part of 'meal_entry_bloc.dart';

@freezed
sealed class MealEntryEvent with _$MealEntryEvent {
  /// Seeds the surface. [initialFoods] become the rows (one empty row when
  /// null/empty); [photos] are held for a photo estimate; [mealOfTheDay] sets
  /// the target slot. When [autoEstimate] is true and photos are present, a
  /// photo estimate is kicked immediately (the share path).
  const factory MealEntryEvent.started({
    List<FoodDraft>? initialFoods,
    @Default(<MealPhoto>[]) List<MealPhoto> photos,
    MealOfTheDay? mealOfTheDay,
    @Default(false) bool autoEstimate,
  }) = MealEntryStarted;

  const factory MealEntryEvent.foodAdded() = MealEntryFoodAdded;
  const factory MealEntryEvent.foodRemoved(String id) = MealEntryFoodRemoved;
  const factory MealEntryEvent.foodNameChanged(String id, String name) =
      MealEntryFoodNameChanged;
  const factory MealEntryEvent.foodNutritionChanged(
    String id,
    Nutrition nutrition,
  ) = MealEntryFoodNutritionChanged;
  const factory MealEntryEvent.foodQuantityChanged(String id, double quantity) =
      MealEntryFoodQuantityChanged;
  const factory MealEntryEvent.foodAddToUsualMealsToggled(
    String id, {
    required bool addToUsualMeals,
  }) = MealEntryFoodAddToUsualMealsToggled;
  const factory MealEntryEvent.entryModeToggled(MealEntryMode mealEntryMode) =
      MealEntryModeToggled;
  const factory MealEntryEvent.mealOfTheDayChanged(MealOfTheDay mealOfTheDay) =
      MealEntryMealOfTheDayChanged;
  const factory MealEntryEvent.photosAdded(List<MealPhoto> photos) =
      MealEntryPhotosAdded;
  const factory MealEntryEvent.photoRemoved(int index) = MealEntryPhotoRemoved;
  const factory MealEntryEvent.photosCleared() = MealEntryPhotosCleared;
  const factory MealEntryEvent.estimateRequested() = MealEntryEstimateRequested;
}
