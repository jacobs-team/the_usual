import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:uuid/uuid.dart';

part 'daily_log_bloc.freezed.dart';
part 'daily_log_bloc.g.dart';
part 'daily_log_event.dart';
part 'daily_log_state.dart';

/// {@template daily_log_bloc}
/// A [HydratedBloc] that owns everything the user logs each day: meals eaten
/// and weigh-ins. Today reads the current day; the history screen will read
/// the full set.
/// {@endtemplate}
@lazySingleton
class DailyLogBloc extends HydratedBloc<DailyLogEvent, DailyLogState> {
  /// {@macro daily_log_bloc}
  DailyLogBloc() : super(const DailyLogState()) {
    on<DailyLogEvent>(
      (event, emit) => switch (event) {
        MealLogged() => _onMealLogged(event, emit),
        MealEntryRemoved() => emit(
          state.copyWith(
            mealEntries: state.mealEntries
                .where((mealLogEntry) => mealLogEntry.id != event.id)
                .toList(),
          ),
        ),
        MealEntryNutritionChanged() => _onMealEntryNutritionChanged(
          event,
          emit,
        ),
        MealEntryQuantityChanged() => _onMealEntryQuantityChanged(event, emit),
        MealEntryUsualMealLinked() => _onMealEntryUsualMealLinked(event, emit),
        WeightLogged() => _onWeightLogged(event, emit),
        WeightOnDayChanged() => _onWeightOnDayChanged(event, emit),
        SampleDataSeeded() => _onSampleDataSeeded(emit),
      },
    );
  }

  static const _uuid = Uuid();

  void _onMealLogged(MealLogged event, Emitter<DailyLogState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final mealLogEntry = MealLogEntry(
      id: _uuid.v4(),
      loggedAt: clock.now(),
      mealOfTheDay: event.mealOfTheDay,
      name: name,
      nutrition: event.nutrition,
      quantity: event.quantity,
      usualMealId: event.usualMealId,
      photoPath: event.photoPath,
    );
    emit(state.copyWith(mealEntries: [...state.mealEntries, mealLogEntry]));
  }

  void _onMealEntryNutritionChanged(
    MealEntryNutritionChanged event,
    Emitter<DailyLogState> emit,
  ) {
    final updatedEntries = [
      for (final mealLogEntry in state.mealEntries)
        if (mealLogEntry.id == event.id)
          mealLogEntry.copyWith(nutrition: event.nutrition)
        else
          mealLogEntry,
    ];
    emit(state.copyWith(mealEntries: updatedEntries));
  }

  void _onMealEntryQuantityChanged(
    MealEntryQuantityChanged event,
    Emitter<DailyLogState> emit,
  ) {
    final quantity = event.quantity < 1 ? 1 : event.quantity;
    final updatedEntries = [
      for (final mealLogEntry in state.mealEntries)
        if (mealLogEntry.id == event.id)
          mealLogEntry.copyWith(quantity: quantity)
        else
          mealLogEntry,
    ];
    emit(state.copyWith(mealEntries: updatedEntries));
  }

  void _onMealEntryUsualMealLinked(
    MealEntryUsualMealLinked event,
    Emitter<DailyLogState> emit,
  ) {
    final updatedEntries = [
      for (final mealLogEntry in state.mealEntries)
        if (mealLogEntry.id == event.id)
          mealLogEntry.copyWith(usualMealId: event.usualMealId)
        else
          mealLogEntry,
    ];
    emit(state.copyWith(mealEntries: updatedEntries));
  }

  void _onWeightLogged(WeightLogged event, Emitter<DailyLogState> emit) {
    final weightEntry = WeightEntry(
      id: _uuid.v4(),
      loggedAt: clock.now(),
      weight: event.weight,
      weightUnit: event.weightUnit,
    );
    emit(state.copyWith(weightEntries: [...state.weightEntries, weightEntry]));
  }

  void _onWeightOnDayChanged(
    WeightOnDayChanged event,
    Emitter<DailyLogState> emit,
  ) {
    final day = event.day;
    final otherDayEntries = state.weightEntries
        .where((weightEntry) => !DateUtils.isSameDay(weightEntry.loggedAt, day))
        .toList();

    final weight = event.weight;
    if (weight == null) {
      emit(state.copyWith(weightEntries: otherDayEntries));
      return;
    }

    final existingWeightEntry = state.weightOn(day);
    final weightEntry =
        existingWeightEntry?.copyWith(
          weight: weight,
          weightUnit: event.weightUnit,
        ) ??
        WeightEntry(
          id: _uuid.v4(),
          loggedAt: day,
          weight: weight,
          weightUnit: event.weightUnit,
        );
    emit(state.copyWith(weightEntries: [...otherDayEntries, weightEntry]));
  }

  // TODO(dev): temporary sample data for the history screen. Remove before
  // ship along with the SampleDataSeeded event.
  void _onSampleDataSeeded(Emitter<DailyLogState> emit) {
    // Each sample is (name, calories, protein, fat, carbs).
    const breakfasts = [
      ('Eggs & toast', 350, 18, 14, 30),
      ('Oatmeal', 300, 10, 6, 54),
      ('Greek yogurt bowl', 320, 22, 8, 38),
      ('Smoothie', 280, 12, 4, 50),
    ];
    const lunches = [
      ('Chicken bowl', 600, 45, 18, 55),
      ('Sandwich', 450, 25, 16, 48),
      ('Salad', 380, 20, 22, 24),
      ('Leftovers', 520, 30, 20, 50),
    ];
    const dinners = [
      ('Pasta', 700, 26, 20, 100),
      ('Tacos', 620, 32, 28, 58),
      ('Stir fry', 560, 30, 18, 62),
      ('Pizza', 820, 34, 36, 88),
    ];
    const snacks = [
      ('Protein bar', 200, 20, 7, 22),
      ('Almonds', 180, 6, 15, 6),
      ('Apple', 95, 0, 0, 25),
    ];
    const daysAgoSamples = [0, 1, 3, 8, 16, 27, 41, 58, 74, 92];

    final now = clock.now();
    final mealEntries = <MealLogEntry>[];
    final weightEntries = <WeightEntry>[];

    for (var i = 0; i < daysAgoSamples.length; i++) {
      final day = DateUtils.dateOnly(
        now.subtract(Duration(days: daysAgoSamples[i])),
      );

      void addMeal(
        MealOfTheDay mealOfTheDay,
        (String, int, int, int, int) record,
        int hour,
      ) {
        mealEntries.add(
          MealLogEntry(
            id: _uuid.v4(),
            loggedAt: day.add(Duration(hours: hour)),
            mealOfTheDay: mealOfTheDay,
            name: record.$1,
            nutrition: Nutrition(
              calories: record.$2,
              protein: record.$3,
              fat: record.$4,
              carbs: record.$5,
            ),
          ),
        );
      }

      addMeal(MealOfTheDay.breakfast, breakfasts[i % breakfasts.length], 8);
      addMeal(MealOfTheDay.lunch, lunches[i % lunches.length], 13);
      addMeal(MealOfTheDay.dinner, dinners[i % dinners.length], 19);
      if (i.isEven) {
        addMeal(MealOfTheDay.snacks, snacks[i % snacks.length], 16);
      }

      weightEntries.add(
        WeightEntry(
          id: _uuid.v4(),
          loggedAt: day.add(const Duration(hours: 7)),
          // Older days are heavier, trending down toward today.
          weight: 165 + daysAgoSamples[i] * 0.08,
          weightUnit: WeightUnit.lb,
        ),
      );
    }

    emit(
      state.copyWith(mealEntries: mealEntries, weightEntries: weightEntries),
    );
  }

  @override
  DailyLogState fromJson(Map<String, dynamic> json) {
    return DailyLogState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(DailyLogState state) {
    return state.toJson();
  }
}
