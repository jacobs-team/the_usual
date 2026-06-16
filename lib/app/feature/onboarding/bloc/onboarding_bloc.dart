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
          state.copyWith(activeStepIndex: state.activeStepIndex - 1),
        ),
        ResetPressed() => emit(const OnboardingState()),
        SkipPressed() => _onSkipPressed(event, emit),
        ContinuePressed() => emit(
          state.copyWith(activeStepIndex: state.activeStepIndex + 1),
        ),
        UsualMealAdded() => _onUsualMealAdded(event, emit),
        UsualMealRemoved() => _onUsualMealRemoved(event, emit),
        UsualMealNutritionChanged() => _onUsualMealNutritionChanged(
          event,
          emit,
        ),
        UsualMealNameChanged() => _onUsualMealNameChanged(event, emit),
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

  /// Skipping a step keeps its defaults, except where skipping signals
  /// opting out of the feature itself.
  void _onSkipPressed(SkipPressed event, Emitter<OnboardingState> emit) {
    emit(switch (state.step) {
      // Didn't choose how to be reminded: fall back to the least intrusive
      // style that keeps the core loop alive, without an OS permission prompt.
      OnboardingStep.reminderStyle => state.copyWith(
        settings: state.settings.copyWith(
          reminderStyle: ReminderStyle.onAppOpen,
        ),
        activeStepIndex: state.activeStepIndex + 1,
      ),
      // Didn't want to set up weigh-ins: turn weight check-ins off.
      OnboardingStep.weightTracking => state.copyWith(
        settings: state.settings.copyWith(
          weightCheckinFrequency: WeightCheckinFrequency.off,
          startingWeight: null,
        ),
        activeStepIndex: state.activeStepIndex + 1,
      ),
      _ => state.copyWith(activeStepIndex: state.activeStepIndex + 1),
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
    final quantity = event.quantity < 1 ? 1 : event.quantity;
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
    final quantity = event.quantity < 1 ? 1 : event.quantity;
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
