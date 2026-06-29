import 'dart:math';

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
        MealEntryComponentQuantityChanged() =>
          _onMealEntryComponentQuantityChanged(event, emit),
        MealEntryComponentNutritionChanged() =>
          _onMealEntryComponentNutritionChanged(event, emit),
        MealEntryUsualMealLinked() => _onMealEntryUsualMealLinked(event, emit),
        WeightLogged() => _onWeightLogged(event, emit),
        WeightOnDayChanged() => _onWeightOnDayChanged(event, emit),
        DailyLogStateRestored() => emit(event.state),
        SampleDataSeeded() => _onSampleDataSeeded(emit),
      },
    );
  }

  static const _uuid = Uuid();

  // temporary sample meals for seeding. Each is
  // (name, calories, protein, fat, carbs). Remove before ship along with the
  // SampleDataSeeded event.
  static const _breakfasts = [
    ('Scrambled eggs & toast', 350, 20, 16, 28),
    ('Oatmeal with banana', 320, 9, 6, 60),
    ('Greek yogurt & granola', 300, 20, 8, 38),
    ('Avocado toast', 380, 12, 20, 38),
    ('Protein shake', 260, 30, 5, 22),
    ('Bagel & cream cheese', 420, 13, 16, 55),
    ('Pancakes & syrup', 480, 12, 14, 78),
  ];
  static const _lunches = [
    ('Chicken & rice bowl', 620, 45, 16, 65),
    ('Turkey sandwich', 480, 28, 18, 50),
    ('Caesar salad w/ chicken', 430, 35, 24, 18),
    ('Burrito', 700, 32, 26, 80),
    ('Leftover pasta', 560, 22, 18, 78),
    ('Sushi rolls', 520, 24, 12, 78),
    ('Soup & sourdough', 400, 16, 12, 58),
  ];
  static const _dinners = [
    ('Salmon & veggies', 560, 40, 28, 24),
    ('Spaghetti bolognese', 720, 34, 24, 92),
    ('Steak & potatoes', 780, 48, 38, 52),
    ('Chicken stir fry', 600, 38, 20, 60),
    ('Tacos', 650, 30, 30, 62),
    ('Homemade pizza', 850, 34, 38, 92),
    ('Veggie curry & rice', 580, 16, 18, 88),
  ];
  static const _snacks = [
    ('Protein bar', 210, 20, 7, 24),
    ('Apple & peanut butter', 270, 7, 16, 28),
    ('Handful of almonds', 180, 6, 16, 6),
    ('Greek yogurt', 130, 15, 0, 12),
    ('Dark chocolate', 160, 2, 11, 16),
    ('Banana', 105, 1, 0, 27),
  ];

  /// The sample meals built into a usuals library, each keyed by the meal it
  /// belongs to. Shares the seed pools so a seeded entry's [MealLogEntry.name]
  /// (and the id it links via) matches a usual, letting the seeded history
  /// drive the quick-pick ordering.
  static Map<MealOfTheDay, List<UsualMeal>> get sampleUsuals {
    List<UsualMeal> toUsuals(List<(String, int, int, int, int)> pool) => [
      for (final sample in pool)
        UsualMeal(
          id: sample.$1,
          name: sample.$1,
          nutrition: Nutrition(
            calories: sample.$2,
            protein: sample.$3,
            fat: sample.$4,
            carbs: sample.$5,
          ),
        ),
    ];
    return {
      MealOfTheDay.breakfast: toUsuals(_breakfasts),
      MealOfTheDay.lunch: toUsuals(_lunches),
      MealOfTheDay.dinner: toUsuals(_dinners),
      MealOfTheDay.snacks: toUsuals(_snacks),
    };
  }

  void _onMealLogged(MealLogged event, Emitter<DailyLogState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final day = event.day;
    final dayStart = event.dayStart;
    final loggedAt = day != null && dayStart != null
        ? day.atDayStart(dayStart)
        : clock.now();

    final mealLogEntry = MealLogEntry(
      id: _uuid.v4(),
      loggedAt: loggedAt,
      mealOfTheDay: event.mealOfTheDay,
      name: name,
      nutrition: event.nutrition,
      quantity: event.quantity.asLoggedQuantity,
      usualMealId: event.usualMealId,
      photoPath: event.photoPath,
      components: event.components,
    );
    emit(
      state.copyWith(
        mealEntries: [...state.mealEntries, mealLogEntry],
        justLoggedEntryId: mealLogEntry.id,
      ),
    );
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
    final quantity = event.quantity.asLoggedQuantity;
    final updatedEntries = [
      for (final mealLogEntry in state.mealEntries)
        if (mealLogEntry.id == event.id)
          mealLogEntry.copyWith(quantity: quantity)
        else
          mealLogEntry,
    ];
    emit(state.copyWith(mealEntries: updatedEntries));
  }

  void _onMealEntryComponentQuantityChanged(
    MealEntryComponentQuantityChanged event,
    Emitter<DailyLogState> emit,
  ) {
    _editComponent(
      event.id,
      event.componentIndex,
      (mealComponent) => mealComponent.copyWith(quantity: event.quantity),
      emit,
    );
  }

  void _onMealEntryComponentNutritionChanged(
    MealEntryComponentNutritionChanged event,
    Emitter<DailyLogState> emit,
  ) {
    _editComponent(
      event.id,
      event.componentIndex,
      (mealComponent) => mealComponent.copyWith(nutrition: event.nutrition),
      emit,
    );
  }

  /// Replaces the component at [componentIndex] of the entry with [id] using
  /// [transform], then recomputes that entry's stored nutrition to the
  /// components' total so every summary stays in sync. A no-op if the entry or
  /// index is missing.
  void _editComponent(
    String id,
    int componentIndex,
    MealComponent Function(MealComponent) transform,
    Emitter<DailyLogState> emit,
  ) {
    final updatedEntries = [
      for (final mealLogEntry in state.mealEntries)
        if (mealLogEntry.id == id &&
            componentIndex >= 0 &&
            componentIndex < mealLogEntry.components.length)
          _withRecomputedTotal(mealLogEntry, componentIndex, transform)
        else
          mealLogEntry,
    ];
    emit(state.copyWith(mealEntries: updatedEntries));
  }

  MealLogEntry _withRecomputedTotal(
    MealLogEntry mealLogEntry,
    int componentIndex,
    MealComponent Function(MealComponent) transform,
  ) {
    final updatedComponents = [
      for (final (index, mealComponent) in mealLogEntry.components.indexed)
        if (index == componentIndex)
          transform(mealComponent)
        else
          mealComponent,
    ];
    return mealLogEntry.copyWith(
      components: updatedComponents,
      nutrition: updatedComponents.componentsTotal,
    );
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
    final dayStart = event.dayStart;
    final otherDayEntries = state.weightEntries
        .where(
          (weightEntry) => !DateUtils.isSameDay(
            weightEntry.loggedAt.logicalDay(dayStart),
            day,
          ),
        )
        .toList();

    final weight = event.weight;
    if (weight == null) {
      emit(state.copyWith(weightEntries: otherDayEntries));
      return;
    }

    final existingWeightEntry = state.weightOn(day, dayStart);
    final weightEntry =
        existingWeightEntry?.copyWith(
          weight: weight,
          weightUnit: event.weightUnit,
        ) ??
        WeightEntry(
          id: _uuid.v4(),
          // Stamp the entry at the logical day's start so it buckets back to
          // [day] rather than the calendar day midnight falls on.
          loggedAt: day.atDayStart(dayStart),
          weight: weight,
          weightUnit: event.weightUnit,
        );
    emit(state.copyWith(weightEntries: [...otherDayEntries, weightEntry]));
  }

  void _onSampleDataSeeded(Emitter<DailyLogState> emit) {
    // Each month trends between a start and end weight, and consecutive months
    // join up so the overall line drifts down, back up, then down again. The
    // month two back is deliberately sparse: fewer logged days and more
    // skipped meals, the way real logging tapers off.
    const monthPlans = [
      (
        monthsAgo: 4,
        startWeight: 178.0,
        endWeight: 173.0,
        logEveryDay: true,
        sparseMeals: false,
        weighInChance: 0.80,
      ),
      (
        monthsAgo: 3,
        startWeight: 173.0,
        endWeight: 170.0,
        logEveryDay: true,
        sparseMeals: false,
        weighInChance: 0.88,
      ),
      (
        monthsAgo: 2,
        startWeight: 170.0,
        endWeight: 172.5,
        logEveryDay: false,
        sparseMeals: true,
        weighInChance: 0.55,
      ),
      (
        monthsAgo: 1,
        startWeight: 172.5,
        endWeight: 167.0,
        logEveryDay: true,
        sparseMeals: false,
        weighInChance: 0.90,
      ),
      (
        monthsAgo: 0,
        startWeight: 167.0,
        endWeight: 164.5,
        logEveryDay: true,
        sparseMeals: false,
        weighInChance: 0.82,
      ),
    ];

    final now = clock.now();
    final random = Random(2026);
    final mealEntries = <MealLogEntry>[];
    final weightEntries = <WeightEntry>[];

    void maybeAddMeal(
      DateTime day,
      MealOfTheDay mealOfTheDay,
      List<(String, int, int, int, int)> pool,
      int hour,
      double skipChance,
    ) {
      if (random.nextDouble() < skipChance) return;
      final sample = pool[random.nextInt(pool.length)];
      // Mostly one, occasionally a fractional serving. Built by division so the
      // value is a double without a literal the formatter might rewrite to int.
      final quantity = (random.nextDouble() < 0.12 ? 3 : 2) / 2;
      // Now and then only the calorie count was entered, leaving macros blank.
      final macrosEntered = random.nextDouble() > 0.08;
      mealEntries.add(
        MealLogEntry(
          id: _uuid.v4(),
          loggedAt: day.add(Duration(hours: hour)),
          mealOfTheDay: mealOfTheDay,
          name: sample.$1,
          nutrition: Nutrition(
            calories: sample.$2,
            protein: macrosEntered ? sample.$3 : null,
            fat: macrosEntered ? sample.$4 : null,
            carbs: macrosEntered ? sample.$5 : null,
          ),
          quantity: quantity,
          usualMealId: sample.$1,
        ),
      );
    }

    for (final plan in monthPlans) {
      final monthStart = DateTime(now.year, now.month - plan.monthsAgo);
      final daysInMonth = DateTime(
        monthStart.year,
        monthStart.month + 1,
        0,
      ).day;
      final lastDay = plan.monthsAgo == 0 ? now.day : daysInMonth;
      final span = lastDay <= 1 ? 1 : lastDay - 1;

      for (var dayOfMonth = 1; dayOfMonth <= lastDay; dayOfMonth++) {
        // The sparse month logs only some days; full months log every day.
        final logsThisDay = plan.logEveryDay || random.nextDouble() < 0.66;
        if (!logsThisDay) continue;

        final day = DateTime(monthStart.year, monthStart.month, dayOfMonth);

        maybeAddMeal(
          day,
          MealOfTheDay.breakfast,
          _breakfasts,
          8,
          plan.sparseMeals ? 0.40 : 0.12,
        );
        maybeAddMeal(
          day,
          MealOfTheDay.lunch,
          _lunches,
          13,
          plan.sparseMeals ? 0.30 : 0.05,
        );
        maybeAddMeal(
          day,
          MealOfTheDay.dinner,
          _dinners,
          19,
          plan.sparseMeals ? 0.25 : 0.03,
        );
        maybeAddMeal(
          day,
          MealOfTheDay.snacks,
          _snacks,
          16,
          plan.sparseMeals ? 0.70 : 0.50,
        );

        if (random.nextDouble() < plan.weighInChance) {
          final progress = (dayOfMonth - 1) / span;
          final trend =
              plan.startWeight + (plan.endWeight - plan.startWeight) * progress;
          // A little daily noise on top of the trend so the line wavers.
          final noise = (random.nextDouble() - 0.5) * 1.6;
          final weight = ((trend + noise) * 10).round() / 10;
          weightEntries.add(
            WeightEntry(
              id: _uuid.v4(),
              loggedAt: day.add(const Duration(hours: 7)),
              weight: weight,
              weightUnit: WeightUnit.lb,
            ),
          );
        }
      }
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
