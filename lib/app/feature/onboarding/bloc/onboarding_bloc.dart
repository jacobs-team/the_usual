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
        UsualAdded() => _onUsualAdded(event, emit),
        UsualRemoved() => _onUsualRemoved(event, emit),
        // TODO(onboarding): request OS notification permission when
        // ReminderStyle.notifications is picked, falling back to onAppOpen if
        // denied. Notification approach is an open item in docs/onboarding.
        ReminderStyleSelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(reminderStyle: event.style),
          ),
        ),
        MealCheckinScheduleModeChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              mealCheckinScheduleMode: event.mode,
            ),
          ),
        ),
        MealReminderToggled() => _onMealReminderToggled(event, emit),
        MealReminderTimeChanged() => _onMealReminderTimeChanged(event, emit),
        EndOfDayTimeChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              endOfDayReminder: state.settings.endOfDayReminder.copyWith(
                time: event.time,
              ),
            ),
          ),
        ),
        WeightCheckinFrequencySelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(
              weightCheckinFrequency: event.frequency,
            ),
          ),
        ),
        WeightTimeOfDaySelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(weightTimeOfDay: event.timeOfDay),
          ),
        ),
        WeightUnitSelected() => emit(
          state.copyWith(
            settings: state.settings.copyWith(weightUnit: event.unit),
          ),
        ),
        StartingWeightChanged() => emit(
          state.copyWith(
            settings: state.settings.copyWith(startingWeight: event.weight),
          ),
        ),
        FirstLogItemToggled() => _onFirstLogItemToggled(event, emit),
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

  void _onUsualAdded(UsualAdded event, Emitter<OnboardingState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final items = state.settings.usuals[event.meal] ?? <UsualMeal>[];
    final exists = items.any(
      (item) => item.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.meal: [...items, UsualMeal(id: _uuid.v4(), name: name)],
          },
        ),
      ),
    );
  }

  void _onUsualRemoved(UsualRemoved event, Emitter<OnboardingState> emit) {
    final items = state.settings.usuals[event.meal] ?? <UsualMeal>[];
    final remainingItems = items
        .where((item) => item.id != event.id)
        .toList();
    final remainingSelectedIds = state.firstLogSelectedIds
        .where((id) => id != event.id)
        .toList();

    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {...state.settings.usuals, event.meal: remainingItems},
        ),
        firstLogSelectedIds: remainingSelectedIds,
      ),
    );
  }

  void _onMealReminderToggled(
    MealReminderToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final reminder = state.settings.mealReminders[event.meal];
    if (reminder == null) return;
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          mealReminders: {
            ...state.settings.mealReminders,
            event.meal: reminder.copyWith(enabled: event.enabled),
          },
        ),
      ),
    );
  }

  void _onMealReminderTimeChanged(
    MealReminderTimeChanged event,
    Emitter<OnboardingState> emit,
  ) {
    final reminder = state.settings.mealReminders[event.meal];
    if (reminder == null) return;
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          mealReminders: {
            ...state.settings.mealReminders,
            event.meal: reminder.copyWith(time: event.time),
          },
        ),
      ),
    );
  }

  void _onFirstLogItemToggled(
    FirstLogItemToggled event,
    Emitter<OnboardingState> emit,
  ) {
    final selected = state.firstLogSelectedIds.contains(event.id)
        ? state.firstLogSelectedIds.where((id) => id != event.id).toList()
        : [...state.firstLogSelectedIds, event.id];
    emit(state.copyWith(firstLogSelectedIds: selected));
  }

  void _onSomethingElseLogged(
    SomethingElseLogged event,
    Emitter<OnboardingState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final items = state.settings.usuals[event.meal] ?? <UsualMeal>[];
    final item = UsualMeal(id: _uuid.v4(), name: name);
    emit(
      state.copyWith(
        settings: state.settings.copyWith(
          usuals: {
            ...state.settings.usuals,
            event.meal: [...items, item],
          },
        ),
        firstLogSelectedIds: [...state.firstLogSelectedIds, item.id],
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
