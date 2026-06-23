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
        SettingsStateRestored() => emit(event.settings),
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
        SettingsDayStartTimeChanged() => emit(
          state.copyWith(dayStartTime: event.dayStartTime),
        ),
        SettingsMealEntryModeChanged() => emit(
          state.copyWith(mealEntryMode: event.mealEntryMode),
        ),
        SettingsUsualMealAdded() => _onUsualMealAdded(event, emit),
        SettingsUsualMealRemoved() => _onUsualMealRemoved(event, emit),
        SettingsUsualMealNutritionChanged() => _onUsualMealNutritionChanged(
          event,
          emit,
        ),
        SettingsUsualMealNameChanged() => _onUsualMealNameChanged(event, emit),
        SettingsWorkoutGroupAdded() => _onWorkoutGroupAdded(event, emit),
        SettingsWorkoutGroupRenamed() => _onWorkoutGroupRenamed(event, emit),
        SettingsWorkoutGroupReordered() =>
          _onWorkoutGroupReordered(event, emit),
        SettingsWorkoutGroupRemoved() => _onWorkoutGroupRemoved(event, emit),
        SettingsUsualWorkoutAdded() => _onUsualWorkoutAdded(event, emit),
        SettingsUsualWorkoutRenamed() => _onUsualWorkoutRenamed(event, emit),
        SettingsUsualWorkoutSetsChanged() =>
          _onUsualWorkoutSetsChanged(event, emit),
        SettingsUsualWorkoutRemoved() => _onUsualWorkoutRemoved(event, emit),
        SettingsWorkoutWeightUnitSelected() => emit(
          state.copyWith(workoutWeightUnit: event.weightUnit),
        ),
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

  void _onWorkoutGroupAdded(
    SettingsWorkoutGroupAdded event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;
    final exists = state.workoutGroups.any(
      (workoutGroup) => workoutGroup.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    final nextOrder = state.workoutGroups.fold<int>(
      0,
      (maxOrder, workoutGroup) =>
          workoutGroup.order >= maxOrder ? workoutGroup.order + 1 : maxOrder,
    );
    emit(
      state.copyWith(
        workoutGroups: [
          ...state.workoutGroups,
          WorkoutGroup(id: _uuid.v4(), name: name, order: nextOrder),
        ],
      ),
    );
  }

  void _onWorkoutGroupRenamed(
    SettingsWorkoutGroupRenamed event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;
    final updatedGroups = [
      for (final workoutGroup in state.workoutGroups)
        if (workoutGroup.id == event.id)
          workoutGroup.copyWith(name: name)
        else
          workoutGroup,
    ];
    emit(state.copyWith(workoutGroups: updatedGroups));
  }

  void _onWorkoutGroupReordered(
    SettingsWorkoutGroupReordered event,
    Emitter<UserSettingsState> emit,
  ) {
    final groupsById = {
      for (final workoutGroup in state.workoutGroups)
        workoutGroup.id: workoutGroup,
    };
    final reordered = <WorkoutGroup>[];
    var order = 0;
    for (final id in event.orderedIds) {
      final workoutGroup = groupsById[id];
      if (workoutGroup != null) {
        reordered.add(workoutGroup.copyWith(order: order));
        order++;
      }
    }
    // Keep any group not named in the list, preserving it at the end.
    for (final workoutGroup in state.workoutGroups) {
      if (!event.orderedIds.contains(workoutGroup.id)) {
        reordered.add(workoutGroup.copyWith(order: order));
        order++;
      }
    }
    emit(state.copyWith(workoutGroups: reordered));
  }

  void _onUsualWorkoutAdded(
    SettingsUsualWorkoutAdded event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final usualWorkouts =
        state.usualWorkouts[event.workoutGroupId] ?? <UsualWorkout>[];
    final exists = usualWorkouts.any(
      (usualWorkout) => usualWorkout.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    emit(
      state.copyWith(
        usualWorkouts: {
          ...state.usualWorkouts,
          event.workoutGroupId: [
            ...usualWorkouts,
            UsualWorkout(id: _uuid.v4(), name: name, sets: event.sets),
          ],
        },
      ),
    );
  }

  void _onUsualWorkoutRenamed(
    SettingsUsualWorkoutRenamed event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;
    final usualWorkouts =
        state.usualWorkouts[event.workoutGroupId] ?? <UsualWorkout>[];
    final updatedUsualWorkouts = [
      for (final usualWorkout in usualWorkouts)
        if (usualWorkout.id == event.id)
          usualWorkout.copyWith(name: name)
        else
          usualWorkout,
    ];
    emit(
      state.copyWith(
        usualWorkouts: {
          ...state.usualWorkouts,
          event.workoutGroupId: updatedUsualWorkouts,
        },
      ),
    );
  }

  void _onUsualWorkoutSetsChanged(
    SettingsUsualWorkoutSetsChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final usualWorkouts =
        state.usualWorkouts[event.workoutGroupId] ?? <UsualWorkout>[];
    final updatedUsualWorkouts = [
      for (final usualWorkout in usualWorkouts)
        if (usualWorkout.id == event.id)
          usualWorkout.copyWith(sets: event.sets)
        else
          usualWorkout,
    ];
    emit(
      state.copyWith(
        usualWorkouts: {
          ...state.usualWorkouts,
          event.workoutGroupId: updatedUsualWorkouts,
        },
      ),
    );
  }

  void _onUsualWorkoutRemoved(
    SettingsUsualWorkoutRemoved event,
    Emitter<UserSettingsState> emit,
  ) {
    final usualWorkouts =
        state.usualWorkouts[event.workoutGroupId] ?? <UsualWorkout>[];
    final remainingUsualWorkouts = usualWorkouts
        .where((usualWorkout) => usualWorkout.id != event.id)
        .toList();
    emit(
      state.copyWith(
        usualWorkouts: {
          ...state.usualWorkouts,
          event.workoutGroupId: remainingUsualWorkouts,
        },
      ),
    );
  }

  void _onWorkoutGroupRemoved(
    SettingsWorkoutGroupRemoved event,
    Emitter<UserSettingsState> emit,
  ) {
    // Blocked while the group still has usuals. The Workouts UI also blocks
    // removal when logged workouts reference the group.
    final usualWorkouts =
        state.usualWorkouts[event.id] ?? const <UsualWorkout>[];
    if (usualWorkouts.isNotEmpty) return;

    final remainingGroups = state.workoutGroups
        .where((workoutGroup) => workoutGroup.id != event.id)
        .toList();
    final remainingUsualWorkouts = {...state.usualWorkouts}..remove(event.id);
    emit(
      state.copyWith(
        workoutGroups: remainingGroups,
        usualWorkouts: remainingUsualWorkouts,
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
