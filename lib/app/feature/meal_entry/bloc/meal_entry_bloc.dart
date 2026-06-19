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

  Future<void> _onEstimateRequested(
    MealEntryEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {}

  Future<void> _onPhotoEstimateRequested(
    MealEntryPhotoEstimateRequested event,
    Emitter<MealEntryState> emit,
  ) async {}

  Future<void> _runPhotoEstimate(Emitter<MealEntryState> emit) async {}
}
