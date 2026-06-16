import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'user_settings_bloc.freezed.dart';
part 'user_settings_bloc.g.dart';
part 'user_settings_event.dart';
part 'user_settings_state.dart';

/// {@template user_settings_bloc}
/// A [HydratedBloc] that owns the user's settings. Onboarding edits a draft
/// [UserSettingsState] in its own state and commits it here on completion.
/// The settings screen edits this bloc directly.
/// {@endtemplate}
@lazySingleton
class UserSettingsBloc
    extends HydratedBloc<UserSettingsEvent, UserSettingsState> {
  /// {@macro user_settings_bloc}
  UserSettingsBloc() : super(const UserSettingsState()) {
    on<UserSettingsEvent>(
      (event, emit) => switch (event) {
        SettingsCommitted() => emit(event.settings),
        SettingsReminderStyleSelected() => emit(
          state.copyWith(reminderStyle: event.reminderStyle),
        ),
        SettingsMealCheckinScheduleModeChanged() => emit(
          state.copyWith(
            mealCheckinScheduleMode: event.mealCheckinScheduleMode,
          ),
        ),
        SettingsMealReminderToggled() => _onMealReminderToggled(event, emit),
        SettingsMealReminderTimeChanged() => _onMealReminderTimeChanged(
          event,
          emit,
        ),
        SettingsEndOfDayTimeChanged() => emit(
          state.copyWith(
            endOfDayReminder: state.endOfDayReminder.copyWith(
              timeOfDay: event.timeOfDay,
            ),
          ),
        ),
        SettingsWeightCheckinFrequencySelected() => emit(
          state.copyWith(weightCheckinFrequency: event.weightCheckinFrequency),
        ),
        SettingsWeightTimeOfDaySelected() => emit(
          state.copyWith(weightTimeOfDay: event.weightTimeOfDay),
        ),
        SettingsWeightUnitSelected() => emit(
          state.copyWith(weightUnit: event.weightUnit),
        ),
        SettingsStartingWeightChanged() => emit(
          state.copyWith(startingWeight: event.weight),
        ),
        SettingsCalorieGoalChanged() => emit(
          state.copyWith(calorieGoal: event.calorieGoal),
        ),
        SettingsWeightGoalChanged() => emit(
          state.copyWith(weightGoal: event.weightGoal),
        ),
        SettingsThemeModeSelected() => emit(
          state.copyWith(themeMode: event.themeMode),
        ),
        SettingsExpandNutritionByDefaultChanged() => emit(
          state.copyWith(
            expandNutritionByDefault: event.expandNutritionByDefault,
          ),
        ),
        SettingsSkipLoggedMealRemindersChanged() => emit(
          state.copyWith(
            skipLoggedMealReminders: event.skipLoggedMealReminders,
          ),
        ),
        SettingsUsualMealAdded() => _onUsualMealAdded(event, emit),
        SettingsUsualMealRemoved() => _onUsualMealRemoved(event, emit),
        SettingsUsualMealNutritionChanged() => _onUsualMealNutritionChanged(
          event,
          emit,
        ),
        SettingsUsualMealNameChanged() => _onUsualMealNameChanged(event, emit),
      },
    );
  }

  static const _uuid = Uuid();

  void _onMealReminderToggled(
    SettingsMealReminderToggled event,
    Emitter<UserSettingsState> emit,
  ) {
    final mealReminder = state.mealReminders[event.mealOfTheDay];
    if (mealReminder == null) return;
    emit(
      state.copyWith(
        mealReminders: {
          ...state.mealReminders,
          event.mealOfTheDay: mealReminder.copyWith(enabled: event.enabled),
        },
      ),
    );
  }

  void _onMealReminderTimeChanged(
    SettingsMealReminderTimeChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final mealReminder = state.mealReminders[event.mealOfTheDay];
    if (mealReminder == null) return;
    emit(
      state.copyWith(
        mealReminders: {
          ...state.mealReminders,
          event.mealOfTheDay: mealReminder.copyWith(
            timeOfDay: event.timeOfDay,
          ),
        },
      ),
    );
  }

  void _onUsualMealAdded(
    SettingsUsualMealAdded event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final usualMeals = state.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final exists = usualMeals.any(
      (usualMeal) => usualMeal.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    emit(
      state.copyWith(
        usuals: {
          ...state.usuals,
          event.mealOfTheDay: [
            ...usualMeals,
            UsualMeal(id: _uuid.v4(), name: name, nutrition: event.nutrition),
          ],
        },
      ),
    );
  }

  void _onUsualMealRemoved(
    SettingsUsualMealRemoved event,
    Emitter<UserSettingsState> emit,
  ) {
    final usualMeals = state.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final remainingUsualMeals = usualMeals
        .where((usualMeal) => usualMeal.id != event.id)
        .toList();

    emit(
      state.copyWith(
        usuals: {...state.usuals, event.mealOfTheDay: remainingUsualMeals},
      ),
    );
  }

  void _onUsualMealNutritionChanged(
    SettingsUsualMealNutritionChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final usualMeals = state.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final updatedUsualMeals = [
      for (final usualMeal in usualMeals)
        if (usualMeal.id == event.id)
          usualMeal.copyWith(nutrition: event.nutrition)
        else
          usualMeal,
    ];

    emit(
      state.copyWith(
        usuals: {...state.usuals, event.mealOfTheDay: updatedUsualMeals},
      ),
    );
  }

  void _onUsualMealNameChanged(
    SettingsUsualMealNameChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    if (event.name.trim().isEmpty) return;
    final usualMeals = state.usuals[event.mealOfTheDay] ?? <UsualMeal>[];
    final updatedUsualMeals = [
      for (final usualMeal in usualMeals)
        if (usualMeal.id == event.id)
          usualMeal.copyWith(name: event.name)
        else
          usualMeal,
    ];

    emit(
      state.copyWith(
        usuals: {...state.usuals, event.mealOfTheDay: updatedUsualMeals},
      ),
    );
  }

  @override
  UserSettingsState fromJson(Map<String, dynamic> json) {
    return UserSettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(UserSettingsState state) {
    return state.toJson();
  }
}
