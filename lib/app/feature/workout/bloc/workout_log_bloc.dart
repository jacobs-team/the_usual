import 'dart:math';

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
        WorkoutSampleDataSeeded() => _onSampleDataSeeded(emit),
      },
    );
  }

  static const _uuid = Uuid();

  // temporary sample exercises for seeding, grouped by their default
  // workout group. Each is (name, startWeight, endWeight) in lb; the weight is
  // interpolated from start to end across the seeded span so strength trends
  // up. Remove before ship along with the sampleDataSeeded event.
  static const _pushExercises = <(String, double, double)>[
    ('Bench Press', 135, 185),
    ('Overhead Press', 75, 105),
    ('Incline Dumbbell Press', 50, 72.5),
    ('Tricep Pushdown', 40, 60),
  ];
  static const _pullExercises = <(String, double, double)>[
    ('Deadlift', 185, 275),
    ('Barbell Row', 115, 155),
    ('Lat Pulldown', 100, 140),
    ('Bicep Curl', 25, 42.5),
  ];
  static const _legExercises = <(String, double, double)>[
    ('Squat', 155, 245),
    ('Leg Press', 200, 320),
    ('Romanian Deadlift', 135, 185),
    ('Leg Curl', 70, 100),
  ];

  /// The sample exercises built into a usual-workouts library, keyed by their
  /// default group id. Shares the seed pools so a seeded entry's
  /// [WorkoutLogEntry.name] (and the id it links via) matches a usual, the way
  /// [DailyLogBloc.sampleUsuals] backs the seeded meal history.
  static Map<String, List<UsualWorkout>> get sampleUsualWorkouts {
    List<UsualWorkout> toUsuals(List<(String, double, double)> pool) => [
      for (final exercise in pool)
        UsualWorkout(
          id: exercise.$1,
          name: exercise.$1,
          sets: [
            for (var setIndex = 0; setIndex < 3; setIndex++)
              WorkoutSet(weight: exercise.$2, reps: 8),
          ],
        ),
    ];
    return {
      'push': toUsuals(_pushExercises),
      'pull': toUsuals(_pullExercises),
      'legs': toUsuals(_legExercises),
    };
  }

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

  void _onSampleDataSeeded(Emitter<WorkoutLogState> emit) {
    // Seed roughly five months of a Push/Pull/Legs split. Each session logs its
    // group's main lifts at a weight interpolated from the lift's start to its
    // end across the whole span, so every exercise's estimated-1RM line trends
    // up. Sundays and Wednesdays are rest days, with the odd day skipped.
    const exercisesByGroup = {
      'push': _pushExercises,
      'pull': _pullExercises,
      'legs': _legExercises,
    };
    const groupRotation = ['push', 'pull', 'legs'];

    final now = clock.now();
    final startDate = DateTime(now.year, now.month - 4);
    final totalDays = now.difference(startDate).inDays;
    final random = Random(2026);
    final workoutEntries = <WorkoutLogEntry>[];

    var sessionIndex = 0;
    for (var offset = 0; offset <= totalDays; offset++) {
      final day = startDate.add(Duration(days: offset));
      final weekday = day.weekday;
      if (weekday == DateTime.sunday || weekday == DateTime.wednesday) continue;
      // Now and then a training day is missed, the way real logging lapses.
      if (random.nextDouble() < 0.12) continue;

      final groupId = groupRotation[sessionIndex % groupRotation.length];
      sessionIndex++;

      final progress = totalDays == 0 ? 1.0 : offset / totalDays;
      // Log the group's three main lifts this session.
      for (final exercise in exercisesByGroup[groupId]!.take(3)) {
        final (name, startWeight, endWeight) = exercise;
        final trend = startWeight + (endWeight - startWeight) * progress;
        // Round to the nearest 5 lb so the weights read like real plate jumps,
        // with a little session-to-session noise on top.
        final noise = (random.nextDouble() - 0.5) * 5;
        final weight = ((trend + noise) / 5).round() * 5.0;
        final sets = [
          for (var setIndex = 0; setIndex < 3; setIndex++)
            WorkoutSet(weight: weight, reps: 6 + random.nextInt(5)),
        ];
        workoutEntries.add(
          WorkoutLogEntry(
            id: _uuid.v4(),
            loggedAt: day.add(const Duration(hours: 18)),
            workoutGroupId: groupId,
            name: name,
            sets: sets,
            usualWorkoutId: name,
          ),
        );
      }
    }

    emit(state.copyWith(workoutEntries: workoutEntries));
  }

  @override
  WorkoutLogState fromJson(Map<String, dynamic> json) =>
      WorkoutLogState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WorkoutLogState state) => state.toJson();
}
