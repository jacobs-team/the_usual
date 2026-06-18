import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'onboarding_bloc.freezed.dart';
part 'onboarding_bloc.g.dart';
part 'onboarding_event.dart';
part 'onboarding_state.dart';

/// {@template onboarding_bloc}
/// A [HydratedBloc] that manages progress through the onboarding flow.
/// {@endtemplate}
@lazySingleton
class OnboardingBloc extends HydratedBloc<OnboardingEvent, OnboardingState> {
  /// {@macro onboarding_bloc}
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingEvent>(
      (event, emit) => switch (event) {
        BackPressed() => emit(
          state.copyWith(step: _stepRelativeTo(state, -1)),
        ),
        ResetPressed() => emit(const OnboardingState()),
        SkipPressed() => _onSkipPressed(event, emit),
        ContinuePressed() => emit(
          state.copyWith(step: _stepRelativeTo(state, 1)),
        ),
        UsualMealAdded() => _onUsualMealAdded(event, emit),
        UsualMealRemoved() => _onUsualMealRemoved(event, emit),
        UsualMealNutritionChanged() => _onUsualMealNutritionChanged(
          event,
          emit,
        ),
        UsualMealNameChanged() => _onUsualMealNameChanged(event, emit),
        UsualsForMealReplaced() => _onUsualsForMealReplaced(event, emit),
        // TODO(onboarding): request OS notification permission when
        // ReminderStyle.notifications is picked, falling back to onAppOpen if
        // denied. Notification approach is an open item in docs/onboarding.
        ReminderStyleSelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              reminderStyle: event.reminderStyle,
            ),
          ),
        ),
        MealCheckinScheduleModeChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              mealCheckinScheduleMode: event.mealCheckinScheduleMode,
            ),
          ),
        ),
        MealReminderToggled() => _onMealReminderToggled(event, emit),
        MealReminderTimeChanged() => _onMealReminderTimeChanged(event, emit),
        EndOfDayTimeChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              endOfDayReminder: state.settings.endOfDayReminder.copyWith(
                timeOfDay: event.timeOfDay,
              ),
            ),
          ),
        ),
        SkipLoggedMealRemindersChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              skipLoggedMealReminders: event.skipLoggedMealReminders,
            ),
          ),
        ),
        WeightCheckinFrequencySelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              weightCheckinFrequency: event.weightCheckinFrequency,
            ),
          ),
        ),
        WeightTimeOfDaySelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              weightTimeOfDay: event.weightTimeOfDay,
            ),
          ),
        ),
        WeightUnitSelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(weightUnit: event.weightUnit),
          ),
        ),
        StartingWeightChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(startingWeight: event.weight),
          ),
        ),
        CalorieGoalChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(calorieGoal: event.calorieGoal),
          ),
        ),
        WeightGoalChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(weightGoal: event.weightGoal),
          ),
        ),
        FirstLogItemToggled() => _onFirstLogItemToggled(event, emit),
        FirstLogItemQuantityChanged() => _onFirstLogItemQuantityChanged(
          event,
          emit,
        ),
        SomethingElseLogged() => _onSomethingElseLogged(event, emit),
      },
    );
  }

  static const _uuid = Uuid();

  /// The step [offset] positions from the current one within [activeSteps],
  /// clamped to the valid range.
  OnboardingStep _stepRelativeTo(OnboardingState state, int offset) {
    final steps = state.activeSteps;
    final index = steps.indexOf(state.step);
    final next = (index + offset).clamp(0, steps.length - 1);
    return steps[next];
  }

  /// Skipping a step keeps its defaults, except where skipping signals
  /// opting out of the feature itself.
  void _onSkipPressed(SkipPressed event, Emitter<OnboardingState> emit) {
    final nextStep = _stepRelativeTo(state, 1);
    emit(switch (state.step) {
      // Didn't choose how to be reminded: fall back to the least intrusive
      // style that keeps the core loop alive, without an OS permission prompt.
      OnboardingStep.reminders => state.copyWith(
        settings: state.settings.copyWith(
          reminderStyle: ReminderStyle.onAppOpen,
        ),
        step: nextStep,
      ),
      // Didn't want to set up weigh-ins: turn weight check-ins off.
      OnboardingStep.weightTracking => state.copyWith(
        settings: state.settings.copyWith(
          weightCheckinFrequency: WeightCheckinFrequency.off,
          startingWeight: null,
        ),
        step: nextStep,
      ),
      _ => state.copyWith(step: nextStep),
    });
  }

  void _onUsualMealAdded(UsualMealAdded event, Emitter<OnboardingState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final usualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final exists = usualMeals.any(
      (usualMeal) => usualMeal.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: [
              ...usualMeals,
              UsualMeal(id: _uuid.v4(), name: name, nutrition: event.nutrition),
            ],
          },
        ),
      ),
    );
  }

  void _onUsualMealRemoved(
    UsualMealRemoved event,
    Emitter<OnboardingState> emit,
  ) {
    final usualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final remainingUsualMeals = usualMeals
        .where((usualMeal) => usualMeal.id != event.id)
        .toList();
    final remainingSelectedIds = state.firstLogSelectedIds
        .where((id) => id != event.id)
        .toList();

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: remainingUsualMeals,
          },
        ),
        firstLogSelectedIds: remainingSelectedIds,
      ),
    );
  }

  void _onUsualMealNutritionChanged(
    UsualMealNutritionChanged event,
    Emitter<OnboardingState> emit,
  ) {
    final usualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final updatedUsualMeals = [
      for (final usualMeal in usualMeals)
        if (usualMeal.id == event.id)
          usualMeal.copyWith(nutrition: event.nutrition)
        else
          usualMeal,
    ];

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: updatedUsualMeals,
          },
        ),
      ),
    );
  }

  void _onUsualMealNameChanged(
    UsualMealNameChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (event.name.trim().isEmpty) return;
    final usualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final updatedUsualMeals = [
      for (final usualMeal in usualMeals)
        if (usualMeal.id == event.id)
          usualMeal.copyWith(name: event.name)
        else
          usualMeal,
    ];

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: updatedUsualMeals,
          },
        ),
      ),
    );
  }

  /// Replaces a meal's usuals with the [event] entries, the editing surface in
  /// onboarding's build-usuals step. An existing usual whose name is unchanged
  /// keeps its id (so any first-log selection of it survives); a new or renamed
  /// entry gets a fresh id. Blank names are dropped.
  void _onUsualsForMealReplaced(
    UsualsForMealReplaced event,
    Emitter<OnboardingState> emit,
  ) {
    final existingUsualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final existingByName = {
      for (final usualMeal in existingUsualMeals)
        usualMeal.name.toLowerCase(): usualMeal,
    };

    final replacementUsualMeals = <UsualMeal>[];
    for (final entry in event.usualMeals) {
      final name = entry.name.trim();
      if (name.isEmpty) continue;
      final existing = existingByName[name.toLowerCase()];
      replacementUsualMeals.add(
        existing == null
            ? UsualMeal(id: _uuid.v4(), name: name, nutrition: entry.nutrition)
            : existing.copyWith(name: name, nutrition: entry.nutrition),
      );
    }

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: replacementUsualMeals,
          },
        ),
      ),
    );
  }

  void _onMealReminderToggled(
    MealReminderToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final mealReminder = state.settings.mealReminders[event.mealOfTheDay];
    if (mealReminder == null) return;
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          mealReminders: {
            ...state.settings.mealReminders,
            event.mealOfTheDay: mealReminder.copyWith(enabled: event.enabled),
          },
        ),
      ),
    );
  }

  void _onMealReminderTimeChanged(
    MealReminderTimeChanged event,
    Emitter<OnboardingState> emit,
  ) {
    final mealReminder = state.settings.mealReminders[event.mealOfTheDay];
    if (mealReminder == null) return;
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          mealReminders: {
            ...state.settings.mealReminders,
            event.mealOfTheDay: mealReminder.copyWith(
              timeOfDay: event.timeOfDay,
            ),
          },
        ),
      ),
    );
  }

  void _onFirstLogItemToggled(
    FirstLogItemToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final wasSelected = state.firstLogSelectedIds.contains(event.id);
    final selected = wasSelected
        ? state.firstLogSelectedIds.where((id) => id != event.id).toList()
        : [...state.firstLogSelectedIds, event.id];
    // Drop any quantity for an item that was just deselected so it resets to
    // one if reselected.
    final quantities = {...state.firstLogQuantities}..remove(event.id);
    emit(
      state.copyWith(
        firstLogSelectedIds: selected,
        firstLogQuantities: quantities,
      ),
    );
  }

  void _onFirstLogItemQuantityChanged(
    FirstLogItemQuantityChanged event,
    Emitter<OnboardingState> emit,
  ) {
    final quantity = event.quantity.asLoggedQuantity;
    emit(
      state.copyWith(
        firstLogQuantities: {...state.firstLogQuantities, event.id: quantity},
      ),
    );
  }

  void _onSomethingElseLogged(
    SomethingElseLogged event,
    Emitter<OnboardingState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final usualMeals =
        state.settings.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final usualMeal = UsualMeal(
      id: _uuid.v4(),
      name: name,
      nutrition: event.nutrition,
    );
    final quantity = event.quantity.asLoggedQuantity;
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.mealOfTheDay: [...usualMeals, usualMeal],
          },
        ),
        firstLogSelectedIds: [...state.firstLogSelectedIds, usualMeal.id],
        firstLogQuantities: {
          ...state.firstLogQuantities,
          usualMeal.id: quantity,
        },
      ),
    );
  }

  @override
  OnboardingState fromJson(Map<String, dynamic> json) {
    return OnboardingState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(OnboardingState state) {
    return state.toJson();
  }
}
