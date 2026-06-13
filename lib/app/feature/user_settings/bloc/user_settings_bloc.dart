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
          state.copyWith(reminderStyle: event.style),
        ),
        SettingsMealCheckinScheduleModeChanged() => emit(
          state.copyWith(mealCheckinScheduleMode: event.mode),
        ),
        SettingsMealReminderToggled() => _onMealReminderToggled(event, emit),
        SettingsMealReminderTimeChanged() => _onMealReminderTimeChanged(
          event,
          emit,
        ),
        SettingsEndOfDayTimeChanged() => emit(
          state.copyWith(
            endOfDayReminder: state.endOfDayReminder.copyWith(
              time: event.time,
            ),
          ),
        ),
        SettingsWeightCheckinFrequencySelected() => emit(
          state.copyWith(weightCheckinFrequency: event.frequency),
        ),
        SettingsWeightTimeOfDaySelected() => emit(
          state.copyWith(weightTimeOfDay: event.timeOfDay),
        ),
        SettingsWeightUnitSelected() => emit(
          state.copyWith(weightUnit: event.unit),
        ),
        SettingsStartingWeightChanged() => emit(
          state.copyWith(startingWeight: event.weight),
        ),
        SettingsUsualAdded() => _onUsualAdded(event, emit),
        SettingsUsualRemoved() => _onUsualRemoved(event, emit),
        SettingsUsualCaloriesChanged() => _onUsualCaloriesChanged(event, emit),
      },
    );
  }

  static const _uuid = Uuid();

  void _onMealReminderToggled(
    SettingsMealReminderToggled event,
    Emitter<UserSettingsState> emit,
  ) {
    final reminder = state.mealReminders[event.meal];
    if (reminder == null) return;
    emit(
      state.copyWith(
        mealReminders: {
          ...state.mealReminders,
          event.meal: reminder.copyWith(enabled: event.enabled),
        },
      ),
    );
  }

  void _onMealReminderTimeChanged(
    SettingsMealReminderTimeChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final reminder = state.mealReminders[event.meal];
    if (reminder == null) return;
    emit(
      state.copyWith(
        mealReminders: {
          ...state.mealReminders,
          event.meal: reminder.copyWith(time: event.time),
        },
      ),
    );
  }

  void _onUsualAdded(
    SettingsUsualAdded event,
    Emitter<UserSettingsState> emit,
  ) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final items = state.usuals[event.meal] ?? <UsualMeal>[];
    final exists = items.any(
      (item) => item.name.toLowerCase() == name.toLowerCase(),
    );
    if (exists) return;

    emit(
      state.copyWith(
        usuals: {
          ...state.usuals,
          event.meal: [
            ...items,
            UsualMeal(id: _uuid.v4(), name: name, calories: event.calories),
          ],
        },
      ),
    );
  }

  void _onUsualRemoved(
    SettingsUsualRemoved event,
    Emitter<UserSettingsState> emit,
  ) {
    final items = state.usuals[event.meal] ?? <UsualMeal>[];
    final remainingItems = items
        .where((item) => item.id != event.id)
        .toList();

    emit(
      state.copyWith(
        usuals: {...state.usuals, event.meal: remainingItems},
      ),
    );
  }

  void _onUsualCaloriesChanged(
    SettingsUsualCaloriesChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final items = state.usuals[event.meal] ?? <UsualMeal>[];
    final updatedItems = [
      for (final item in items)
        if (item.id == event.id)
          item.copyWith(calories: event.calories)
        else
          item,
    ];

    emit(
      state.copyWith(
        usuals: {...state.usuals, event.meal: updatedItems},
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
