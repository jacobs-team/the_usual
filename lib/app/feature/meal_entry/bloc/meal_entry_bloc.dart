import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'meal_entry_bloc.freezed.dart';
part 'meal_entry_event.dart';
part 'meal_entry_state.dart';

/// {@template food_entry_bloc}
/// Owns one meal-entry surface's working state: the editable food rows, the
/// AI [MealEntryMode], the target [MealOfTheDay], any attached [MealPhoto]s,
/// and the estimation status. Created and disposed by the widget that shows the
/// surface, so several can be alive at once (onboarding shows one per meal).
/// Logging is the caller's job; this bloc only drafts and estimates.
/// {@endtemplate}
@injectable
class FoodEntryBloc extends Bloc<MealEntryEvent, MealEntryState> {
  /// {@macro food_entry_bloc}
  FoodEntryBloc(this._mealAiRepository, this._userSettingsBloc)
    : super(const MealEntryState()) {
    on<MealEntryEvent>(
      (event, emit) => switch (event) {
        MealEntryStarted() => _onStarted(event, emit),
        MealEntryFoodAdded() => emit(
          state.copyWith(
            foods: [
              ...state.foods,
              FoodDraft(id: _uuid.v4(), addToUsualMeals: event.addToUsualMeals),
            ],
          ),
        ),
        MealEntryFoodRemoved() => _onFoodRemoved(event, emit),
        MealEntryFoodNameChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(name: event.name),
            ),
          ),
        ),
        MealEntryFoodNutritionChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(nutrition: event.nutrition),
            ),
          ),
        ),
        MealEntryFoodQuantityChanged() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(quantity: event.quantity),
            ),
          ),
        ),
        MealEntryFoodAddToUsualMealsToggled() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) =>
                  foodDraft.copyWith(addToUsualMeals: event.addToUsualMeals),
            ),
          ),
        ),
        MealEntryModeToggled() => _onEntryModeToggled(event, emit),
        MealEntryMealOfTheDayChanged() => emit(
          state.copyWith(mealOfTheDay: event.mealOfTheDay),
        ),
        MealEntryPhotosAdded() => emit(
          state.copyWith(photos: [...state.photos, ...event.photos]),
        ),
        MealEntryPhotoRemoved() => _onPhotoRemoved(event, emit),
        MealEntryPhotosCleared() => emit(
          state.copyWith(photos: const []),
        ),
        MealEntryEstimateRequested() => _onEstimateRequested(event, emit),
        MealEntryMealNameChanged() => emit(
          state.copyWith(mealName: event.mealName),
        ),
        MealEntryDescriptionChanged() => emit(
          state.copyWith(description: event.description),
        ),
        MealEntryFoodPicked() => emit(
          state.copyWith(
            foods: [
              ...state.foods,
              FoodDraft(
                id: _uuid.v4(),
                name: event.usualFood.name,
                nutrition: event.usualFood.nutrition,
                usualFoodId: event.usualFood.id,
              ),
            ],
          ),
        ),
        MealEntryFoodSavedAsUsual() => emit(
          state.copyWith(
            foods: _mapFood(
              event.id,
              (foodDraft) => foodDraft.copyWith(usualFoodId: event.usualFoodId),
            ),
          ),
        ),
      },
    );
  }

  final MealAiRepository _mealAiRepository;
  final UserSettingsBloc _userSettingsBloc;

  static const _uuid = Uuid();

  /// Shown when an estimate is requested but no AI key is configured.
  static const _aiUnavailableMessage = 'Nutrition estimation needs an API key.';

  /// Shown when an estimate request reaches the AI but fails. Deliberately
  /// generic so backend error detail is never surfaced to the user.
  static const _estimateFailedMessage =
      'Could not estimate nutrition. Please try again.';

  /// Returns the food list with the row whose id is [id] transformed by
  /// [transform]; other rows are left as-is.
  List<FoodDraft> _mapFood(String id, FoodDraft Function(FoodDraft) transform) {
    return [
      for (final foodDraft in state.foods)
        if (foodDraft.id == id) transform(foodDraft) else foodDraft,
    ];
  }

  void _onStarted(
    MealEntryStarted event,
    Emitter<MealEntryState> emit,
  ) {
    final initialFoods = event.initialFoods;
    final foods = (initialFoods == null || initialFoods.isEmpty)
        ? [FoodDraft(id: _uuid.v4())]
        : initialFoods;
    emit(
      state.copyWith(
        foods: foods,
        photos: event.photos,
        mealEntryMode: _userSettingsBloc.state.mealEntryMode,
        mealOfTheDay: event.mealOfTheDay ?? state.mealOfTheDay,
        status: MealEntryStatus.idle,
        errorMessage: null,
      ),
    );
  }

  void _onFoodRemoved(
    MealEntryFoodRemoved event,
    Emitter<MealEntryState> emit,
  ) {
    final remaining = state.foods
        .where((foodDraft) => foodDraft.id != event.id)
        .toList();
    // The remove control only shows with more than one row, so this can't
    // empty the list from the UI; the guard is defensive.
    if (remaining.isEmpty) remaining.add(FoodDraft(id: _uuid.v4()));
    emit(state.copyWith(foods: remaining));
  }

  void _onPhotoRemoved(
    MealEntryPhotoRemoved event,
    Emitter<MealEntryState> emit,
  ) {
    if (event.index < 0 || event.index >= state.photos.length) return;
    final remaining = [...state.photos]..removeAt(event.index);
    emit(state.copyWith(photos: remaining));
  }

  void _onEntryModeToggled(
    MealEntryModeToggled event,
    Emitter<MealEntryState> emit,
  ) {
    _userSettingsBloc.add(
      UserSettingsEvent.mealEntryModeChanged(event.mealEntryMode),
    );
    emit(state.copyWith(mealEntryMode: event.mealEntryMode));
  }

  /// Estimates nutrition for the entry. Attached photos are added context
  /// (their count does not matter); the flow is chosen by the mode and what the
  /// user has entered, not by whether photos are present.
  ///
  /// In by-foods mode a typed description — or a photo with no foods listed —
  /// is itemized into fresh component foods and the meal is named when unnamed;
  /// when the user has listed foods, their names and quantities are kept and
  /// only each food's nutrition is filled in. The description is kept so it can
  /// be tweaked and re-run. In whole-meal mode a single row (or a photo) yields
  /// one combined item and several rows are each estimated in place.
  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    final isItemized = state.mealEntryMode == MealEntryMode.itemized;
    final description = state.description.trim();
    final photos = state.photos;
    final namedFoods = state.foods
        .where((foodDraft) => foodDraft.name.trim().isNotEmpty)
        .toList();

    final hasInput =
        namedFoods.isNotEmpty || photos.isNotEmpty || description.isNotEmpty;
    if (!hasInput) return;

    if (!_mealAiRepository.isConfigured) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: _aiUnavailableMessage,
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: MealEntryStatus.generating, errorMessage: null),
    );
    try {
      if (isItemized) {
        // Itemize into fresh foods when the user described or photographed a
        // meal without listing foods; otherwise fill the foods they listed in
        // place, keeping names and quantities. Photos are context either way.
        final itemizeFromInput =
            description.isNotEmpty || (namedFoods.isEmpty && photos.isNotEmpty);
        if (itemizeFromInput) {
          final composed = await _mealAiRepository.suggestComposedMeal(
            description: description.isEmpty ? null : description,
            photos: photos,
          );
          emit(
            state.copyWith(
              status: MealEntryStatus.idle,
              // Name the meal from the AI only when the user hasn't named it.
              mealName: state.mealName.trim().isEmpty
                  ? composed.name
                  : state.mealName,
              foods: _foodsFromSuggestions(
                composed.items,
                addToUsualMeals: false,
              ),
            ),
          );
        } else {
          await _estimateEachRow(
            namedFoods,
            emit,
            keepQuantity: true,
            photos: photos,
          );
        }
        return;
      }
      if (namedFoods.length <= 1) {
        final wholeDescription = namedFoods.isEmpty
            ? null
            : namedFoods.first.name.trim();
        final suggestion = await _mealAiRepository.suggestWholeMeal(
          description: wholeDescription,
          photos: photos,
        );
        emit(
          state.copyWith(
            status: MealEntryStatus.idle,
            foods: _foodsFromSuggestions(
              [suggestion],
              keepFirstName: wholeDescription,
              addToUsualMeals:
                  namedFoods.isNotEmpty && namedFoods.first.addToUsualMeals,
            ),
          ),
        );
        return;
      }
      await _estimateEachRow(namedFoods, emit, photos: photos);
    } on Object {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: _estimateFailedMessage,
        ),
      );
    }
  }

  /// Estimates each named row as its own whole-meal item, in parallel, filling
  /// nutrition in place while keeping every row and name; any [photos] are sent
  /// as context with each. The estimated quantity is applied too unless
  /// [keepQuantity] is set, in which case the user's own quantity is preserved
  /// (used in by-foods mode).
  Future<void> _estimateEachRow(
    List<FoodDraft> namedFoods,
    Emitter<MealEntryState> emit, {
    bool keepQuantity = false,
    List<MealPhoto> photos = const <MealPhoto>[],
  }) async {
    final estimates = await Future.wait([
      for (final foodDraft in namedFoods)
        _mealAiRepository.suggestWholeMeal(
          description: foodDraft.name.trim(),
          photos: photos,
        ),
    ]);
    final estimateById = <String, AiMealSuggestion>{
      for (final (index, foodDraft) in namedFoods.indexed)
        foodDraft.id: estimates[index],
    };
    emit(
      state.copyWith(
        status: MealEntryStatus.idle,
        foods: [
          for (final foodDraft in state.foods)
            if (estimateById[foodDraft.id] case final estimate?)
              foodDraft.copyWith(
                quantity: keepQuantity ? foodDraft.quantity : estimate.quantity,
                nutrition: estimate.nutrition,
              )
            else
              foodDraft,
        ],
      ),
    );
  }

  /// Builds rows from [suggestions]; when [keepFirstName] is set the first row
  /// keeps that name instead of the model's. Empty result leaves rows
  /// unchanged.
  List<FoodDraft> _foodsFromSuggestions(
    List<AiMealSuggestion> suggestions, {
    required bool addToUsualMeals,
    String? keepFirstName,
  }) {
    if (suggestions.isEmpty) return state.foods;
    return [
      for (final (index, suggestion) in suggestions.indexed)
        FoodDraft(
          id: _uuid.v4(),
          name: index == 0 && keepFirstName != null
              ? keepFirstName
              : suggestion.name,
          quantity: suggestion.quantity,
          nutrition: suggestion.nutrition,
          // Estimating replaces the rows but must not change the user's
          // save-as-usual choice; carry it over from the row they were editing.
          addToUsualMeals: addToUsualMeals,
        ),
    ];
  }
}
