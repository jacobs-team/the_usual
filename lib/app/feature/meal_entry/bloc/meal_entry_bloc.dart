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
            foods: [...state.foods, FoodDraft(id: _uuid.v4())],
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
        MealEntryPhotosCleared() => emit(
          state.copyWith(photos: const []),
        ),
        // Implemented in Task 5.
        MealEntryEstimateRequested() => _onEstimateRequested(event, emit),
        MealEntryPhotoEstimateRequested() => _onPhotoEstimateRequested(
          event,
          emit,
        ),
      },
    );
  }

  final MealAiRepository _mealAiRepository;
  final UserSettingsBloc _userSettingsBloc;

  static const _uuid = Uuid();

  /// Returns [state.foods] with the row whose id is [id] transformed by
  /// [transform]; other rows are left as-is.
  List<FoodDraft> _mapFood(String id, FoodDraft Function(FoodDraft) transform) {
    return [
      for (final foodDraft in state.foods)
        if (foodDraft.id == id) transform(foodDraft) else foodDraft,
    ];
  }

  Future<void> _onStarted(
    MealEntryStarted event,
    Emitter<MealEntryState> emit,
  ) async {
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
    if (event.autoEstimate && event.photos.isNotEmpty) {
      await _runPhotoEstimate(emit);
    }
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

  void _onEntryModeToggled(
    MealEntryModeToggled event,
    Emitter<MealEntryState> emit,
  ) {
    _userSettingsBloc.add(
      UserSettingsEvent.mealEntryModeChanged(event.mealEntryMode),
    );
    emit(state.copyWith(mealEntryMode: event.mealEntryMode));
  }

  /// Estimates nutrition from the rows. A single named row is sent as a
  /// description the mode may split; several named rows are already itemized by
  /// the user, so each is estimated on its own and filled in place keeping its
  /// name.
  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    final namedFoods = state.foods
        .where((foodDraft) => foodDraft.name.trim().isNotEmpty)
        .toList();
    if (namedFoods.isEmpty) return;

    emit(state.copyWith(status: MealEntryStatus.generating, errorMessage: null));
    try {
      if (namedFoods.length == 1) {
        final description = namedFoods.first.name.trim();
        final suggestions = await _mealAiRepository.suggestFromDescription(
          description,
          mode: state.mealEntryMode,
        );
        emit(
          state.copyWith(
            status: MealEntryStatus.idle,
            foods: _foodsFromSuggestions(
              suggestions,
              keepFirstName: state.mealEntryMode == MealEntryMode.wholeMeal
                  ? description
                  : null,
            ),
          ),
        );
        return;
      }
      await _estimateEachRow(namedFoods, emit);
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: 'Could not estimate nutrition: $error',
        ),
      );
    }
  }

  /// Estimates each named row as its own whole-meal item, in parallel, and
  /// fills nutrition and quantity in place while keeping every row and name.
  Future<void> _estimateEachRow(
    List<FoodDraft> namedFoods,
    Emitter<MealEntryState> emit,
  ) async {
    final estimates = await Future.wait([
      for (final foodDraft in namedFoods)
        _mealAiRepository.suggestFromDescription(
          foodDraft.name.trim(),
          mode: MealEntryMode.wholeMeal,
        ),
    ]);
    final estimateById = <String, AiMealSuggestion>{};
    for (final (index, foodDraft) in namedFoods.indexed) {
      final suggestions = estimates[index];
      if (suggestions.isNotEmpty) estimateById[foodDraft.id] = suggestions.first;
    }
    emit(
      state.copyWith(
        status: MealEntryStatus.idle,
        foods: [
          for (final foodDraft in state.foods)
            if (estimateById[foodDraft.id] case final estimate?)
              foodDraft.copyWith(
                quantity: estimate.quantity,
                nutrition: estimate.nutrition,
              )
            else
              foodDraft,
        ],
      ),
    );
  }

  /// Estimates from the held [MealEntryState.photos]. Any name typed in the
  /// first row is sent to sharpen the estimate, and kept over the model's name
  /// in whole-meal mode.
  Future<void> _onPhotoEstimateRequested(
    MealEntryPhotoEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    await _runPhotoEstimate(emit);
  }

  Future<void> _runPhotoEstimate(Emitter<MealEntryState> emit) async {
    if (state.photos.isEmpty) return;
    final firstName = state.foods.isEmpty ? '' : state.foods.first.name.trim();
    final hasDescription = firstName.isNotEmpty;
    emit(state.copyWith(status: MealEntryStatus.generating, errorMessage: null));
    try {
      final suggestions = await _mealAiRepository.suggestFromPhoto(
        state.photos,
        mode: state.mealEntryMode,
        description: hasDescription ? firstName : null,
      );
      emit(
        state.copyWith(
          status: MealEntryStatus.idle,
          foods: _foodsFromSuggestions(
            suggestions,
            keepFirstName: hasDescription &&
                    state.mealEntryMode == MealEntryMode.wholeMeal
                ? firstName
                : null,
          ),
        ),
      );
    } on Object catch (error) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: 'Could not estimate nutrition: $error',
        ),
      );
    }
  }

  /// Builds rows from [suggestions]; when [keepFirstName] is set the first row
  /// keeps that name instead of the model's. Empty result leaves rows unchanged.
  List<FoodDraft> _foodsFromSuggestions(
    List<AiMealSuggestion> suggestions, {
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
        ),
    ];
  }
}
