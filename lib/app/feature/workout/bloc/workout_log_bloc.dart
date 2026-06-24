import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'workout_log_bloc.freezed.dart';
part 'workout_log_bloc.g.dart';
part 'workout_log_event.dart';
part 'workout_log_state.dart';

/// {@template workout_log_bloc}
/// A [HydratedBloc] that owns every workout the user logs. The Workouts view
/// reads the current day; the workout history screen reads the full set.
/// {@endtemplate}
@lazySingleton
class WorkoutLogBloc extends HydratedBloc<WorkoutLogEvent, WorkoutLogState> {
  /// {@macro workout_log_bloc}
  WorkoutLogBloc() : super(const WorkoutLogState()) {
    on<WorkoutLogEvent>(
      (event, emit) => switch (event) {
        WorkoutLogged() => _onWorkoutLogged(event, emit),
        WorkoutRemoved() => emit(
          state.copyWith(
            workoutEntries: state.workoutEntries
                .where((workoutLogEntry) => workoutLogEntry.id != event.id)
                .toList(),
          ),
        ),
        WorkoutSetsChanged() => _onWorkoutSetsChanged(event, emit),
        WorkoutDurationChanged() => _onWorkoutDurationChanged(event, emit),
        WorkoutLogStateRestored() => emit(event.state),
      },
    );
  }

  static const _uuid = Uuid();

  void _onWorkoutLogged(WorkoutLogged event, Emitter<WorkoutLogState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final day = event.day;
    final dayStart = event.dayStart;
    final loggedAt = day != null && dayStart != null
        ? day.atDayStart(dayStart)
        : clock.now();

    final workoutLogEntry = WorkoutLogEntry(
      id: _uuid.v4(),
      loggedAt: loggedAt,
      workoutGroupId: event.workoutGroupId,
      name: name,
      type: event.type,
      sets: event.sets,
      duration: event.duration,
      usualWorkoutId: event.usualWorkoutId,
    );
    emit(
      state.copyWith(
        workoutEntries: [...state.workoutEntries, workoutLogEntry],
        justLoggedWorkoutId: workoutLogEntry.id,
      ),
    );
  }

  void _onWorkoutSetsChanged(
    WorkoutSetsChanged event,
    Emitter<WorkoutLogState> emit,
  ) {
    final updatedEntries = [
      for (final workoutLogEntry in state.workoutEntries)
        if (workoutLogEntry.id == event.id)
          workoutLogEntry.copyWith(sets: event.sets)
        else
          workoutLogEntry,
    ];
    emit(state.copyWith(workoutEntries: updatedEntries));
  }

  void _onWorkoutDurationChanged(
    WorkoutDurationChanged event,
    Emitter<WorkoutLogState> emit,
  ) {
    final updatedEntries = [
      for (final workoutLogEntry in state.workoutEntries)
        if (workoutLogEntry.id == event.id)
          workoutLogEntry.copyWith(duration: event.duration)
        else
          workoutLogEntry,
    ];
    emit(state.copyWith(workoutEntries: updatedEntries));
  }

  @override
  WorkoutLogState fromJson(Map<String, dynamic> json) =>
      WorkoutLogState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WorkoutLogState state) => state.toJson();
}
