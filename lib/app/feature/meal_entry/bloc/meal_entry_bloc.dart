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
              FoodDraft(id: _uuid.v4()),
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

  /// Estimates nutrition for the entry. With photos attached this estimates
  /// from the photos (sending any typed description as a hint). Otherwise a
  /// single named row is sent as a description the mode may split, and several
  /// named rows are already itemized by the user, so each is estimated on its
  /// own and filled in place keeping its name.
  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {
    if (state.photos.isNotEmpty) {
      await _runPhotoEstimate(emit);
      return;
    }
    final namedFoods = state.foods
        .where((foodDraft) => foodDraft.name.trim().isNotEmpty)
        .toList();
    if (namedFoods.isEmpty) return;
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
              keepFirstName: _nameToKeep(description, suggestions),
              addToUsualMeals: namedFoods.first.addToUsualMeals,
            ),
          ),
        );
        return;
      }
      await _estimateEachRow(namedFoods, emit);
    } on Object {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: _estimateFailedMessage,
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
      if (suggestions.isNotEmpty) {
        estimateById[foodDraft.id] = suggestions.first;
      }
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

  /// Estimates nutrition from the held photos, sending the first row's typed
  /// name as a hint when present. Reached from the Estimate action when photos
  /// are attached, and called directly by [_onStarted] for the auto-estimate
  /// on the share path.
  Future<void> _runPhotoEstimate(Emitter<MealEntryState> emit) async {
    if (state.photos.isEmpty) return;
    if (!_mealAiRepository.isConfigured) {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: _aiUnavailableMessage,
        ),
      );
      return;
    }
    final firstName = state.foods.isEmpty ? '' : state.foods.first.name.trim();
    final hasDescription = firstName.isNotEmpty;
    emit(
      state.copyWith(status: MealEntryStatus.generating, errorMessage: null),
    );
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
            keepFirstName: _nameToKeep(
              hasDescription ? firstName : null,
              suggestions,
            ),
            addToUsualMeals:
                state.foods.isNotEmpty && state.foods.first.addToUsualMeals,
          ),
        ),
      );
    } on Object {
      emit(
        state.copyWith(
          status: MealEntryStatus.failure,
          errorMessage: _estimateFailedMessage,
        ),
      );
    }
  }

  /// The typed [description] to preserve as the first row's name after an
  /// estimate, or null to let the AI name every row. The user's text is kept as
  /// long as it is non-empty, unless they asked to itemize and the AI actually
  /// returned more than one food to split the description into.
  String? _nameToKeep(String? description, List<AiMealSuggestion> suggestions) {
    if (description == null || description.isEmpty) return null;
    final splittingIntoItems =
        state.mealEntryMode == MealEntryMode.itemized && suggestions.length > 1;
    return splittingIntoItems ? null : description;
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
