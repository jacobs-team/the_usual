# Workout Feature — Phase 1: Data & State Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the data models, persistence, and bloc state for the workout feature, with no UI yet.

**Architecture:** Mirror the meal feature exactly. New freezed models (`WorkoutSet`, `WorkoutGroup`, `UsualWorkout`, `WorkoutLogEntry`, `WorkoutReminder`) live in `lib/app/model`. A new `WorkoutLogBloc` (HydratedBloc) holds logged workouts, paralleling `DailyLogBloc`. The existing `UserSettingsBloc` is extended to own workout groups, usual workouts, the workout reminder, and the workout weight unit, paralleling how it owns usual meals.

**Tech Stack:** Flutter, freezed, json_serializable, injectable, hydrated_bloc, bloc_test, mocktail.

## Global Constraints

These apply to every task. Copied from project rules and the spec.

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`. Sections 1 and 2 are this phase.
- **Never run the code generator.** A `build_runner` watcher is always running and regenerates `*.freezed.dart`, `*.g.dart`, and `dependencies.config.dart` automatically. If generated files do not update after creating/editing an annotated class, ask Jacob whether the watcher is running. Do not invoke `build_runner`.
- **Never run the app.** Jacob runs it from VS Code.
- **Never commit or push.** At each commit step, stage nothing yourself beyond what is listed, and ask Jacob to commit with the suggested message. Do not run `git commit` or `git push`.
- **Use `fvm flutter`** for all Flutter CLI commands, never bare `flutter`.
- **Barrel files always.** Import via `package:the_usual/app/app.dart`, not direct file paths. Export every new public file through its barrel.
- **Models:** `@freezed` data classes. `@JsonSerializable(explicitToJson: true)` on the factory for any model that nests another model. A primitive-only model follows `Nutrition` (no `@JsonSerializable` annotation). Keep `fromJson` arrow-bodied so `toJson` generates.
- **Naming:** name every variable after the full model type it holds. A `WorkoutLogEntry` value is `workoutLogEntry`, never `entry`. A `WorkoutGroup` is `workoutGroup`, never `group`.
- **Persisted state:** version every persisted state and route by `version` in `fromJson`. Adding fields with defaults is safe. Where a new field should inherit an existing value rather than its bare default, migrate it. Confirm old stored JSON still reads.
- **Testing:** `blocTest` for blocs. Prefer `isA<State>().having(...)` over whole-state matches. Use matchers (`equals`, `isEmpty`, `isNull`, `isTrue`), never raw assertions. Call `initHydratedStorage()` in `setUp` for HydratedBloc tests. Run with random seed ordering.
- **Test command shape:** `fvm flutter test <path> --test-randomize-ordering-seed random`.
- **JSON keys are camelCase.** This project's `@JsonSerializable` uses no `fieldRename`, so json keys match Dart field names (`weightUnit`, `workoutWeightUnit`). Enums serialize by name (`'lb'`, `'kg'`).

---

### Task 1: WorkoutSet model

The building block: one set's weight, reps, and whether the weight is an estimate.

**Files:**
- Create: `lib/app/model/workout_set.dart`
- Create: `test/app/model/workout_set_test.dart`
- Modify: `lib/app/model/model.dart`

**Interfaces:**
- Produces: `WorkoutSet({double? weight, int? reps, bool weightAutoEstimated})` with `double get volume`, `WorkoutSet.fromJson`, `toJson()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/workout_set_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutSet, () {
    test('volume multiplies weight by reps', () {
      const workoutSet = WorkoutSet(weight: 135, reps: 8);

      expect(workoutSet.volume, equals(1080.0));
    });

    test('volume is zero when weight or reps is unset', () {
      expect(const WorkoutSet(reps: 8).volume, equals(0.0));
      expect(const WorkoutSet(weight: 135).volume, equals(0.0));
      expect(const WorkoutSet().volume, equals(0.0));
    });

    test('round-trips through json', () {
      const workoutSet = WorkoutSet(
        weight: 142.5,
        reps: 6,
        weightAutoEstimated: true,
      );

      expect(WorkoutSet.fromJson(workoutSet.toJson()), equals(workoutSet));
    });

    test('defaults weightAutoEstimated to false', () {
      expect(const WorkoutSet().weightAutoEstimated, isFalse);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/workout_set_test.dart`
Expected: FAIL — `WorkoutSet` is undefined / not exported.

- [ ] **Step 3: Write the model**

Create `lib/app/model/workout_set.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_set.freezed.dart';
part 'workout_set.g.dart';

/// {@template workout_set}
/// One set of an exercise: the weight lifted and the reps performed. A
/// bodyweight set carries an estimated weight once resolved, flagged by
/// [weightAutoEstimated]. Each value is null until supplied.
/// {@endtemplate}
@freezed
abstract class WorkoutSet with _$WorkoutSet {
  /// {@macro workout_set}
  const factory WorkoutSet({
    double? weight,
    int? reps,
    @Default(false) bool weightAutoEstimated,
  }) = _WorkoutSet;

  const WorkoutSet._();

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);

  /// The load this set contributes: weight times reps. An unset weight or rep
  /// count contributes zero.
  double get volume => (weight ?? 0) * (reps ?? 0);
}
```

The watcher generates `workout_set.freezed.dart` and `workout_set.g.dart`. If they do not appear, ask Jacob whether the watcher is running.

- [ ] **Step 4: Export from the model barrel**

In `lib/app/model/model.dart`, add (keep the list alphabetical near the other `w` exports):

```dart
export 'workout_set.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/model/workout_set_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 6: Request commit**

Stage `lib/app/model/workout_set.dart`, its generated parts, `lib/app/model/model.dart`, and `test/app/model/workout_set_test.dart`. Ask Jacob to commit. Suggested message:

```
feat(workout): add WorkoutSet model
```

---

### Task 2: WorkoutGroup model

A user-configurable training group (Push, Pull, Legs by default).

**Files:**
- Create: `lib/app/model/workout_group.dart`
- Create: `test/app/model/workout_group_test.dart`
- Modify: `lib/app/model/model.dart`

**Interfaces:**
- Produces: `WorkoutGroup({required String id, required String name, required int order})` with `WorkoutGroup.fromJson`, `toJson()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/workout_group_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutGroup, () {
    test('round-trips through json', () {
      const workoutGroup = WorkoutGroup(id: 'push', name: 'Push', order: 0);

      expect(
        WorkoutGroup.fromJson(workoutGroup.toJson()),
        equals(workoutGroup),
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/workout_group_test.dart`
Expected: FAIL — `WorkoutGroup` is undefined.

- [ ] **Step 3: Write the model**

Create `lib/app/model/workout_group.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'workout_group.freezed.dart';
part 'workout_group.g.dart';

/// {@template workout_group}
/// A user-configurable grouping of workouts, for example Push, Pull, or Legs.
/// The [id] is stable across renames so logged workouts stay linked.
/// {@endtemplate}
@freezed
abstract class WorkoutGroup with _$WorkoutGroup {
  /// {@macro workout_group}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutGroup({
    required String id,
    required String name,
    required int order,
  }) = _WorkoutGroup;

  factory WorkoutGroup.fromJson(Map<String, dynamic> json) =>
      _$WorkoutGroupFromJson(json);
}
```

- [ ] **Step 4: Export from the model barrel**

In `lib/app/model/model.dart`, add:

```dart
export 'workout_group.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/model/workout_group_test.dart`
Expected: PASS.

- [ ] **Step 6: Request commit**

Stage the new model, its generated parts, the barrel, and the test. Ask Jacob to commit. Suggested message:

```
feat(workout): add WorkoutGroup model
```

---

### Task 3: UsualWorkout model

A reusable workout template carrying a default set structure.

**Files:**
- Create: `lib/app/model/usual_workout.dart`
- Create: `test/app/model/usual_workout_test.dart`
- Modify: `lib/app/model/model.dart`

**Interfaces:**
- Consumes: `WorkoutSet` (Task 1).
- Produces: `UsualWorkout({required String id, required String name, List<WorkoutSet> sets})` with `UsualWorkout.fromJson`, `toJson()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/usual_workout_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(UsualWorkout, () {
    test('round-trips through json', () {
      const usualWorkout = UsualWorkout(
        id: 'usual-1',
        name: 'Bench Press',
        sets: [
          WorkoutSet(weight: 135, reps: 8),
          WorkoutSet(weight: 145, reps: 6),
        ],
      );

      expect(
        UsualWorkout.fromJson(usualWorkout.toJson()),
        equals(usualWorkout),
      );
    });

    test('defaults sets to empty when absent', () {
      final usualWorkout = UsualWorkout.fromJson(<String, dynamic>{
        'id': 'usual-2',
        'name': 'Squat',
      });

      expect(usualWorkout.sets, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/usual_workout_test.dart`
Expected: FAIL — `UsualWorkout` is undefined.

- [ ] **Step 3: Write the model**

Create `lib/app/model/usual_workout.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'usual_workout.freezed.dart';
part 'usual_workout.g.dart';

/// {@template usual_workout}
/// A workout in the user's usuals library, with a default set structure that
/// pre-fills a log so it can be adjusted.
/// {@endtemplate}
@freezed
abstract class UsualWorkout with _$UsualWorkout {
  /// {@macro usual_workout}
  @JsonSerializable(explicitToJson: true)
  const factory UsualWorkout({
    required String id,
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
  }) = _UsualWorkout;

  factory UsualWorkout.fromJson(Map<String, dynamic> json) =>
      _$UsualWorkoutFromJson(json);
}
```

- [ ] **Step 4: Export from the model barrel**

In `lib/app/model/model.dart`, add:

```dart
export 'usual_workout.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/model/usual_workout_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Request commit**

Stage the new model, generated parts, barrel, and test. Ask Jacob to commit. Suggested message:

```
feat(workout): add UsualWorkout model
```

---

### Task 4: WorkoutLogEntry model

A single logged exercise on a given day.

**Files:**
- Create: `lib/app/model/workout_log_entry.dart`
- Create: `test/app/model/workout_log_entry_test.dart`
- Modify: `lib/app/model/model.dart`

**Interfaces:**
- Consumes: `WorkoutSet` (Task 1).
- Produces: `WorkoutLogEntry({required String id, required DateTime loggedAt, required String workoutGroupId, required String name, List<WorkoutSet> sets, String? usualWorkoutId})` with `double get volume`, `WorkoutLogEntry.fromJson`, `toJson()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/workout_log_entry_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutLogEntry, () {
    test('volume sums the volume of every set', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Bench Press',
        sets: const [
          WorkoutSet(weight: 135, reps: 8), // 1080
          WorkoutSet(weight: 145, reps: 6), // 870
        ],
      );

      expect(workoutLogEntry.volume, equals(1950.0));
    });

    test('volume is zero with no sets', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Plank',
      );

      expect(workoutLogEntry.volume, equals(0.0));
    });

    test('round-trips through json', () {
      final workoutLogEntry = WorkoutLogEntry(
        id: 'w1',
        loggedAt: DateTime(2026, 6, 23, 18),
        workoutGroupId: 'push',
        name: 'Bench Press',
        usualWorkoutId: 'usual-1',
        sets: const [WorkoutSet(weight: 135, reps: 8)],
      );

      expect(
        WorkoutLogEntry.fromJson(workoutLogEntry.toJson()),
        equals(workoutLogEntry),
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/workout_log_entry_test.dart`
Expected: FAIL — `WorkoutLogEntry` is undefined.

- [ ] **Step 3: Write the model**

Create `lib/app/model/workout_log_entry.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'workout_log_entry.freezed.dart';
part 'workout_log_entry.g.dart';

/// {@template workout_log_entry}
/// A single exercise the user logged, at a point in time, with its sets.
/// {@endtemplate}
@freezed
abstract class WorkoutLogEntry with _$WorkoutLogEntry {
  /// {@macro workout_log_entry}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogEntry({
    required String id,
    required DateTime loggedAt,
    required String workoutGroupId,
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    String? usualWorkoutId,
  }) = _WorkoutLogEntry;

  const WorkoutLogEntry._();

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) =>
      _$WorkoutLogEntryFromJson(json);

  /// Total load across every set.
  double get volume =>
      sets.fold<double>(0, (total, workoutSet) => total + workoutSet.volume);
}
```

- [ ] **Step 4: Export from the model barrel**

In `lib/app/model/model.dart`, add:

```dart
export 'workout_log_entry.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/model/workout_log_entry_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 6: Request commit**

Stage the new model, generated parts, barrel, and test. Ask Jacob to commit. Suggested message:

```
feat(workout): add WorkoutLogEntry model
```

---

### Task 5: WorkoutReminder model

The reminder config: which days and what time. The mutation events come in Phase 6; this phase only needs the model so the settings state can hold it.

**Files:**
- Create: `lib/app/model/workout_reminder.dart`
- Create: `test/app/model/workout_reminder_test.dart`
- Modify: `lib/app/model/model.dart`

**Interfaces:**
- Consumes: `TimeOfDayConverter` (defined in `lib/app/model/meal_reminder.dart`, exported via the model barrel).
- Produces: `WorkoutReminder({bool enabled, Set<int> daysOfWeek, required TimeOfDay timeOfDay})` with `WorkoutReminder.fromJson`, `toJson()`.

- [ ] **Step 1: Write the failing test**

Create `test/app/model/workout_reminder_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutReminder, () {
    test('round-trips through json', () {
      const workoutReminder = WorkoutReminder(
        enabled: true,
        daysOfWeek: {1, 3, 5},
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      );

      expect(
        WorkoutReminder.fromJson(workoutReminder.toJson()),
        equals(workoutReminder),
      );
    });

    test('defaults to disabled with no days', () {
      const workoutReminder = WorkoutReminder(
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      );

      expect(workoutReminder.enabled, isFalse);
      expect(workoutReminder.daysOfWeek, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/workout_reminder_test.dart`
Expected: FAIL — `WorkoutReminder` is undefined.

- [ ] **Step 3: Write the model**

Create `lib/app/model/workout_reminder.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_usual/app/model/model.dart';

part 'workout_reminder.freezed.dart';
part 'workout_reminder.g.dart';

/// {@template workout_reminder}
/// The workout check-in reminder: whether it is on, which days of the week it
/// fires (1 = Monday … 7 = Sunday), and at what time.
/// {@endtemplate}
@freezed
abstract class WorkoutReminder with _$WorkoutReminder {
  /// {@macro workout_reminder}
  const factory WorkoutReminder({
    @Default(false) bool enabled,
    @Default(<int>{}) Set<int> daysOfWeek,
    @TimeOfDayConverter() required TimeOfDay timeOfDay,
  }) = _WorkoutReminder;

  factory WorkoutReminder.fromJson(Map<String, dynamic> json) =>
      _$WorkoutReminderFromJson(json);
}
```

- [ ] **Step 4: Export from the model barrel**

In `lib/app/model/model.dart`, add:

```dart
export 'workout_reminder.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/model/workout_reminder_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 6: Request commit**

Stage the new model, generated parts, barrel, and test. Ask Jacob to commit. Suggested message:

```
feat(workout): add WorkoutReminder model
```

---

### Task 6: WorkoutLogBloc

The HydratedBloc owning logged workouts, paralleling `DailyLogBloc`. The `usualWorkoutId` repair event and sample-data seeding are intentionally omitted (YAGNI): no legacy id problem exists for workouts, and seeding is added in Phase 7 (history) when it is needed.

**Files:**
- Create: `lib/app/feature/workout/bloc/workout_log_bloc.dart`
- Create: `lib/app/feature/workout/bloc/workout_log_event.dart`
- Create: `lib/app/feature/workout/bloc/workout_log_state.dart`
- Create: `lib/app/feature/workout/bloc/bloc.dart`
- Create: `lib/app/feature/workout/workout.dart`
- Modify: `lib/app/feature/feature.dart`
- Create: `test/app/feature/workout/bloc/workout_log_bloc_test.dart`

**Interfaces:**
- Consumes: `WorkoutSet`, `WorkoutLogEntry` (Tasks 1, 4); `logicalDay` / `atDayStart` extensions (existing, via `app.dart`).
- Produces:
  - `WorkoutLogState({int version, List<WorkoutLogEntry> workoutEntries, String? justLoggedWorkoutId})` with `entriesOn(DateTime day, TimeOfDay dayStart) -> List<WorkoutLogEntry>` and `volumeOn(DateTime day, TimeOfDay dayStart) -> double`.
  - `WorkoutLogEvent.workoutLogged(String workoutGroupId, String name, {List<WorkoutSet> sets, String? usualWorkoutId, DateTime? day, TimeOfDay? dayStart})`, `WorkoutLogEvent.workoutRemoved(String id)`, `WorkoutLogEvent.workoutSetsChanged(String id, List<WorkoutSet> sets)`, `WorkoutLogEvent.stateRestored(WorkoutLogState state)`.
  - `WorkoutLogBloc` registered `@lazySingleton`.

- [ ] **Step 1: Write the failing test**

Create `test/app/feature/workout/bloc/workout_log_bloc_test.dart`:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const dayStart = TimeOfDay(hour: 0, minute: 0);

  group(WorkoutLogBloc, () {
    setUp(initHydratedStorage);

    WorkoutLogEntry workoutLogEntry({
      required String id,
      required DateTime loggedAt,
      String workoutGroupId = 'push',
      List<WorkoutSet> sets = const [WorkoutSet(weight: 100, reps: 10)],
    }) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: loggedAt,
        workoutGroupId: workoutGroupId,
        name: id,
        sets: sets,
      );
    }

    test('initial state is the default WorkoutLogState', () {
      expect(WorkoutLogBloc().state, equals(const WorkoutLogState()));
    });

    group('workoutLogged', () {
      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'appends a workout entry and records it as just logged',
        build: WorkoutLogBloc.new,
        act: (bloc) => bloc.add(
          const WorkoutLogEvent.workoutLogged(
            'push',
            'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
            usualWorkoutId: 'usual-1',
          ),
        ),
        expect: () => [
          isA<WorkoutLogState>()
              .having((s) => s.workoutEntries, 'workoutEntries', hasLength(1))
              .having(
                (s) => s.workoutEntries.single.usualWorkoutId,
                'usualWorkoutId',
                'usual-1',
              )
              .having(
                (s) => s.justLoggedWorkoutId,
                'justLoggedWorkoutId',
                isNotNull,
              ),
        ],
      );

      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'ignores a blank name',
        build: WorkoutLogBloc.new,
        act: (bloc) =>
            bloc.add(const WorkoutLogEvent.workoutLogged('push', '  ')),
        expect: () => <WorkoutLogState>[],
      );

      blocTest<WorkoutLogBloc, WorkoutLogState>(
        'stamps loggedAt at the logical day start when a day is given',
        build: WorkoutLogBloc.new,
        act: (bloc) => bloc.add(
          WorkoutLogEvent.workoutLogged(
            'legs',
            'Squat',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
        verify: (bloc) {
          final workoutLogEntry = bloc.state.workoutEntries.single;
          expect(
            workoutLogEntry.loggedAt,
            equals(
              DateTime(2026, 6, 16).atDayStart(
                const TimeOfDay(hour: 4, minute: 0),
              ),
            ),
          );
        },
      );
    });

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'workoutRemoved drops the matching entry',
      build: WorkoutLogBloc.new,
      seed: () => WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          workoutLogEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(const WorkoutLogEvent.workoutRemoved('a')),
      expect: () => [
        isA<WorkoutLogState>().having(
          (s) => s.workoutEntries.single.id,
          'remaining entry id',
          'b',
        ),
      ],
    );

    blocTest<WorkoutLogBloc, WorkoutLogState>(
      'workoutSetsChanged replaces the sets of the matching entry only',
      build: WorkoutLogBloc.new,
      seed: () => WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
          workoutLogEntry(id: 'b', loggedAt: DateTime(2026, 6, 14)),
        ],
      ),
      act: (bloc) => bloc.add(
        const WorkoutLogEvent.workoutSetsChanged('a', [
          WorkoutSet(weight: 200, reps: 5),
        ]),
      ),
      expect: () => [
        isA<WorkoutLogState>()
            .having(
              (s) => s.workoutEntries.first.sets.single.weight,
              'updated weight',
              200,
            )
            .having(
              (s) => s.workoutEntries.last.sets.single.weight,
              'untouched weight',
              100,
            ),
      ],
    );

    test('toJson then fromJson round-trips the state', () {
      final bloc = WorkoutLogBloc();
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry(id: 'a', loggedAt: DateTime(2026, 6, 14)),
        ],
      );

      expect(bloc.fromJson(bloc.toJson(state)), equals(state));
    });
  });

  group(WorkoutLogState, () {
    WorkoutLogEntry workoutLogEntry(String id, DateTime loggedAt) {
      return WorkoutLogEntry(
        id: id,
        loggedAt: loggedAt,
        workoutGroupId: 'push',
        name: id,
        sets: const [WorkoutSet(weight: 100, reps: 10)], // volume 1000
      );
    }

    test('entriesOn returns only the entries on that logical day', () {
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry('a', DateTime(2026, 6, 14, 18)),
          workoutLogEntry('b', DateTime(2026, 6, 15, 18)),
        ],
      );

      final entries = state.entriesOn(DateTime(2026, 6, 14), dayStart);

      expect(entries.single.id, equals('a'));
    });

    test('volumeOn sums the volume of that day\'s entries', () {
      final state = WorkoutLogState(
        workoutEntries: [
          workoutLogEntry('a', DateTime(2026, 6, 14, 8)),
          workoutLogEntry('b', DateTime(2026, 6, 14, 18)),
          workoutLogEntry('c', DateTime(2026, 6, 15, 18)),
        ],
      );

      expect(state.volumeOn(DateTime(2026, 6, 14), dayStart), equals(2000.0));
    });

    test('fromJson reads a newer, unknown version with the current schema', () {
      final state = WorkoutLogState.fromJson(<String, dynamic>{
        'version': 99,
        'workoutEntries': <dynamic>[],
      });

      expect(state.version, equals(99));
      expect(state.workoutEntries, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/bloc/workout_log_bloc_test.dart`
Expected: FAIL — `WorkoutLogBloc` is undefined.

- [ ] **Step 3: Write the state**

Create `lib/app/feature/workout/bloc/workout_log_state.dart`:

```dart
part of 'workout_log_bloc.dart';

/// {@template workout_log_state}
/// Every workout logged across all days.
/// {@endtemplate}
@freezed
abstract class WorkoutLogState with _$WorkoutLogState {
  /// {@macro workout_log_state}
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(1) int version,
    @Default(<WorkoutLogEntry>[]) List<WorkoutLogEntry> workoutEntries,

    /// The id of the workout logged most recently this session, so the
    /// Workouts view can open it for a quick adjustment. Ephemeral: not
    /// persisted, so a relaunch opens nothing.
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? justLoggedWorkoutId,
  }) = _WorkoutLogState;

  const WorkoutLogState._();

  /// The version written by the current app.
  static const _currentVersion = 1;

  factory WorkoutLogState.fromJson(Map<String, dynamic> json) =>
      WorkoutLogState._fromVersionedJson(json);

  factory WorkoutLogState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      // No migrations yet. v0 is unversioned data written before this field
      // existed; it has the current shape and reads straight through. When the
      // shape changes, bump [_currentVersion] and add a case that migrates
      // older versions up before this case.
      case 0:
      case _currentVersion:
        return _$WorkoutLogStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's logged workouts.
        return _$WorkoutLogStateFromJson(json);
    }
  }

  /// The workouts logged on the logical [day] (rolling over at [dayStart]).
  List<WorkoutLogEntry> entriesOn(DateTime day, TimeOfDay dayStart) => [
    for (final workoutLogEntry in workoutEntries)
      if (DateUtils.isSameDay(
        workoutLogEntry.loggedAt.logicalDay(dayStart),
        day,
      ))
        workoutLogEntry,
  ];

  /// Total volume across the workouts logged on the logical [day].
  double volumeOn(DateTime day, TimeOfDay dayStart) => entriesOn(day, dayStart)
      .fold<double>(0, (total, workoutLogEntry) => total + workoutLogEntry.volume);
}
```

- [ ] **Step 4: Write the events**

Create `lib/app/feature/workout/bloc/workout_log_event.dart`:

```dart
part of 'workout_log_bloc.dart';

@Freezed()
sealed class WorkoutLogEvent with _$WorkoutLogEvent {
  const factory WorkoutLogEvent.workoutLogged(
    String workoutGroupId,
    String name, {
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    String? usualWorkoutId,
    DateTime? day,
    TimeOfDay? dayStart,
  }) = WorkoutLogged;
  const factory WorkoutLogEvent.workoutRemoved(String id) = WorkoutRemoved;
  const factory WorkoutLogEvent.workoutSetsChanged(
    String id,
    List<WorkoutSet> sets,
  ) = WorkoutSetsChanged;

  /// Replaces the entire log with state downloaded from the cloud on sign-in.
  const factory WorkoutLogEvent.stateRestored(WorkoutLogState state) =
      WorkoutLogStateRestored;
}
```

- [ ] **Step 5: Write the bloc**

Create `lib/app/feature/workout/bloc/workout_log_bloc.dart`:

```dart
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
      sets: event.sets,
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

  @override
  WorkoutLogState fromJson(Map<String, dynamic> json) =>
      WorkoutLogState.fromJson(json);

  @override
  Map<String, dynamic> toJson(WorkoutLogState state) => state.toJson();
}
```

- [ ] **Step 6: Create the barrels and wire the feature**

Create `lib/app/feature/workout/bloc/bloc.dart`:

```dart
export 'workout_log_bloc.dart';
```

Create `lib/app/feature/workout/workout.dart`:

```dart
export 'bloc/bloc.dart';
```

In `lib/app/feature/feature.dart`, add (keep alphabetical, after `user_settings`):

```dart
export 'workout/workout.dart';
```

The injectable watcher regenerates `dependencies.config.dart` to register `WorkoutLogBloc`. If `getIt<WorkoutLogBloc>()` is not resolvable, ask Jacob whether the watcher is running.

- [ ] **Step 7: Run test to verify it passes**

Run: `fvm flutter test test/app/feature/workout/bloc/workout_log_bloc_test.dart --test-randomize-ordering-seed random`
Expected: PASS (all groups).

- [ ] **Step 8: Request commit**

Stage the whole `lib/app/feature/workout/` directory (including generated parts), `lib/app/feature/feature.dart`, and the test. Ask Jacob to commit. Suggested message:

```
feat(workout): add WorkoutLogBloc with logged-workout state
```

---

### Task 7: Extend UserSettingsState with workout fields and migration

Add the workout groups (seeded Push/Pull/Legs), usual workouts, workout reminder, and workout weight unit to settings, with a migration that defaults the workout weight unit to the existing body-weight unit.

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_state.dart`
- Modify: `test/app/feature/user_settings/bloc/user_settings_state_test.dart`

**Interfaces:**
- Consumes: `WorkoutGroup`, `UsualWorkout`, `WorkoutReminder` (Tasks 2, 3, 5).
- Produces: new `UserSettingsState` fields `List<WorkoutGroup> workoutGroups`, `Map<String, List<UsualWorkout>> usualWorkouts`, `WorkoutReminder workoutReminder`, `WeightUnit workoutWeightUnit`; `_currentVersion` is now `2`.

- [ ] **Step 1: Write the failing tests**

Open `test/app/feature/user_settings/bloc/user_settings_state_test.dart`. Add these tests inside the existing top-level `group(UserSettingsState, ...)` (matching the file's current structure):

```dart
group('workout defaults', () {
  test('seeds Push, Pull, Legs as the default workout groups', () {
    const state = UserSettingsState();

    expect(
      state.workoutGroups.map((workoutGroup) => workoutGroup.id).toList(),
      equals(['push', 'pull', 'legs']),
    );
    expect(
      state.workoutGroups.map((workoutGroup) => workoutGroup.name).toList(),
      equals(['Push', 'Pull', 'Legs']),
    );
  });

  test('usualWorkouts and the workout reminder start empty/disabled', () {
    const state = UserSettingsState();

    expect(state.usualWorkouts, isEmpty);
    expect(state.workoutReminder.enabled, isFalse);
  });
});

group('workout weight unit migration', () {
  test('v1 data inherits the body-weight unit and bumps to v2', () {
    final state = UserSettingsState.fromJson(<String, dynamic>{
      'version': 1,
      'weightUnit': 'kg',
    });

    expect(state.workoutWeightUnit, equals(WeightUnit.kg));
    expect(state.version, equals(2));
  });

  test('current-version data reads workoutWeightUnit as stored', () {
    final state = UserSettingsState.fromJson(<String, dynamic>{
      'version': 2,
      'weightUnit': 'kg',
      'workoutWeightUnit': 'lb',
    });

    expect(state.workoutWeightUnit, equals(WeightUnit.lb));
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_state_test.dart`
Expected: FAIL — `workoutGroups` / `workoutWeightUnit` are undefined.

- [ ] **Step 3: Add the fields**

In `lib/app/feature/user_settings/bloc/user_settings_state.dart`, add these fields to the `UserSettingsState` factory, after the existing `usuals` field:

```dart
    /// The user's workout groups, for example Push / Pull / Legs. Ordered by
    /// [WorkoutGroup.order]. Seeded with three defaults that use stable const
    /// ids so they can be a const default and stay linked to logged workouts
    /// across renames.
    @Default(<WorkoutGroup>[
      WorkoutGroup(id: 'push', name: 'Push', order: 0),
      WorkoutGroup(id: 'pull', name: 'Pull', order: 1),
      WorkoutGroup(id: 'legs', name: 'Legs', order: 2),
    ])
    List<WorkoutGroup> workoutGroups,

    /// The user's usual workouts, keyed by [WorkoutGroup.id].
    @Default(<String, List<UsualWorkout>>{})
    Map<String, List<UsualWorkout>> usualWorkouts,

    /// The workout check-in reminder.
    @Default(
      WorkoutReminder(
        enabled: false,
        timeOfDay: TimeOfDay(hour: 18, minute: 0),
      ),
    )
    WorkoutReminder workoutReminder,

    /// The unit workout weights are entered and shown in. Defaults to the
    /// body-weight [weightUnit] for returning users via migration.
    @Default(WeightUnit.lb) WeightUnit workoutWeightUnit,
```

- [ ] **Step 4: Bump the version and migrate**

In the same file, change `_currentVersion`:

```dart
  /// The version written by the current app.
  static const _currentVersion = 2;
```

Replace the body of `_fromVersionedJson` with the migration that defaults `workoutWeightUnit` to the stored `weightUnit` for pre-v2 data:

```dart
  factory UserSettingsState._fromVersionedJson(Map<String, dynamic> json) {
    // The `onAppOpen` reminder style was removed; map data still carrying it to
    // no reminders so the dropped value decodes instead of resetting settings.
    final reminderMigrated = json['reminderStyle'] == 'onAppOpen'
        ? {...json, 'reminderStyle': 'none'}
        : json;
    final version = reminderMigrated['version'] as int? ?? 0;
    switch (version) {
      case 0:
      case 1:
        // v1 and earlier predate workout settings. Inherit the workout weight
        // unit from the existing body-weight unit instead of the bare lb
        // default, then read with the current schema (other new keys fall back
        // to their defaults).
        return _$UserSettingsStateFromJson({
          ...reminderMigrated,
          'version': _currentVersion,
          if (!reminderMigrated.containsKey('workoutWeightUnit'))
            'workoutWeightUnit': reminderMigrated['weightUnit'] ?? 'lb',
        });
      case _currentVersion:
        return _$UserSettingsStateFromJson(reminderMigrated);
      default:
        // A newer, unknown version, e.g. after the user downgrades the app.
        // Read it with the current schema as a best effort rather than
        // discarding the user's settings.
        return _$UserSettingsStateFromJson(reminderMigrated);
    }
  }
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_state_test.dart --test-randomize-ordering-seed random`
Expected: PASS, including the existing state tests.

- [ ] **Step 6: Run the full settings suite to confirm no regression**

Run: `fvm flutter test test/app/feature/user_settings/ --test-randomize-ordering-seed random`
Expected: PASS. The existing `initial state is the default UserSettingsState` test still passes because the new fields have defaults.

- [ ] **Step 7: Request commit**

Stage `lib/app/feature/user_settings/bloc/user_settings_state.dart`, its regenerated parts, and the state test. Ask Jacob to commit. Suggested message:

```
feat(workout): add workout fields to user settings with v2 migration
```

---

### Task 8: Workout group settings events and handlers

Add, rename, reorder, and remove (blocked when the group still has usuals) workout groups.

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart`
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`
- Modify: `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`

**Interfaces:**
- Consumes: `WorkoutGroup`, `UsualWorkout`, the settings fields from Task 7.
- Produces events: `workoutGroupAdded(String name)`, `workoutGroupRenamed(String id, String name)`, `workoutGroupReordered(List<String> orderedIds)`, `workoutGroupRemoved(String id)`.

- [ ] **Step 1: Write the failing tests**

In `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`, add inside the existing `group(UserSettingsBloc, ...)`:

```dart
group('workout groups', () {
  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupAdded appends a new group after the defaults',
    build: UserSettingsBloc.new,
    act: (bloc) =>
        bloc.add(const UserSettingsEvent.workoutGroupAdded('Arms')),
    expect: () => [
      isA<UserSettingsState>()
          .having((s) => s.workoutGroups, 'workoutGroups', hasLength(4))
          .having(
            (s) => s.workoutGroups.last.name,
            'new group name',
            'Arms',
          )
          .having(
            (s) => s.workoutGroups.last.order,
            'new group order',
            3,
          ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupAdded ignores a duplicate name (case-insensitive)',
    build: UserSettingsBloc.new,
    act: (bloc) =>
        bloc.add(const UserSettingsEvent.workoutGroupAdded('push')),
    expect: () => <UserSettingsState>[],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupRenamed renames the matching group',
    build: UserSettingsBloc.new,
    act: (bloc) => bloc.add(
      const UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'),
    ),
    expect: () => [
      isA<UserSettingsState>().having(
        (s) => s.workoutGroups.first.name,
        'renamed group',
        'Press Day',
      ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupReordered reorders and reassigns order indices',
    build: UserSettingsBloc.new,
    act: (bloc) => bloc.add(
      const UserSettingsEvent.workoutGroupReordered(['legs', 'push', 'pull']),
    ),
    expect: () => [
      isA<UserSettingsState>()
          .having(
            (s) => s.workoutGroups.map((g) => g.id).toList(),
            'order of ids',
            ['legs', 'push', 'pull'],
          )
          .having(
            (s) => s.workoutGroups.map((g) => g.order).toList(),
            'reassigned orders',
            [0, 1, 2],
          ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupRemoved removes an empty group',
    build: UserSettingsBloc.new,
    act: (bloc) =>
        bloc.add(const UserSettingsEvent.workoutGroupRemoved('legs')),
    expect: () => [
      isA<UserSettingsState>().having(
        (s) => s.workoutGroups.map((g) => g.id).toList(),
        'remaining ids',
        ['push', 'pull'],
      ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'workoutGroupRemoved is a no-op when the group still has usuals',
    build: UserSettingsBloc.new,
    seed: () => const UserSettingsState(
      usualWorkouts: {
        'legs': [UsualWorkout(id: 'u1', name: 'Squat')],
      },
    ),
    act: (bloc) =>
        bloc.add(const UserSettingsEvent.workoutGroupRemoved('legs')),
    expect: () => <UserSettingsState>[],
  );
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`
Expected: FAIL — the new event constructors are undefined.

- [ ] **Step 3: Add the events**

In `lib/app/feature/user_settings/bloc/user_settings_event.dart`, add before the closing brace:

```dart
  const factory UserSettingsEvent.workoutGroupAdded(String name) =
      SettingsWorkoutGroupAdded;
  const factory UserSettingsEvent.workoutGroupRenamed(String id, String name) =
      SettingsWorkoutGroupRenamed;
  const factory UserSettingsEvent.workoutGroupReordered(
    List<String> orderedIds,
  ) = SettingsWorkoutGroupReordered;
  const factory UserSettingsEvent.workoutGroupRemoved(String id) =
      SettingsWorkoutGroupRemoved;
```

- [ ] **Step 4: Handle the events**

In `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`, add these cases to the `switch (event)` (after `SettingsUsualMealNameChanged()`):

```dart
        SettingsWorkoutGroupAdded() => _onWorkoutGroupAdded(event, emit),
        SettingsWorkoutGroupRenamed() => _onWorkoutGroupRenamed(event, emit),
        SettingsWorkoutGroupReordered() =>
          _onWorkoutGroupReordered(event, emit),
        SettingsWorkoutGroupRemoved() => _onWorkoutGroupRemoved(event, emit),
```

Add these handler methods to the class (after `_onUsualMealNameChanged`):

```dart
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
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_bloc_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 6: Request commit**

Stage the event file, bloc file, regenerated parts, and the test. Ask Jacob to commit. Suggested message:

```
feat(workout): manage workout groups in user settings
```

---

### Task 9: Usual workout and workout weight unit settings events

Add, rename, change sets of, and remove usual workouts, plus select the workout weight unit.

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart`
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`
- Modify: `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`

**Interfaces:**
- Consumes: `UsualWorkout`, `WorkoutSet`, settings fields from Task 7.
- Produces events: `usualWorkoutAdded(String workoutGroupId, String name, List<WorkoutSet> sets)`, `usualWorkoutRenamed(String workoutGroupId, String id, String name)`, `usualWorkoutSetsChanged(String workoutGroupId, String id, List<WorkoutSet> sets)`, `usualWorkoutRemoved(String workoutGroupId, String id)`, `workoutWeightUnitSelected(WeightUnit weightUnit)`.

- [ ] **Step 1: Write the failing tests**

In `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`, add inside `group(UserSettingsBloc, ...)`:

```dart
group('usual workouts', () {
  blocTest<UserSettingsBloc, UserSettingsState>(
    'usualWorkoutAdded adds a usual under its group',
    build: UserSettingsBloc.new,
    act: (bloc) => bloc.add(
      const UserSettingsEvent.usualWorkoutAdded('push', 'Bench Press', [
        WorkoutSet(weight: 135, reps: 8),
      ]),
    ),
    expect: () => [
      isA<UserSettingsState>()
          .having(
            (s) => s.usualWorkouts['push'], 'push usuals', hasLength(1),
          )
          .having(
            (s) => s.usualWorkouts['push']!.single.name,
            'usual name',
            'Bench Press',
          ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'usualWorkoutAdded ignores a duplicate name within the group',
    build: UserSettingsBloc.new,
    seed: () => const UserSettingsState(
      usualWorkouts: {
        'push': [UsualWorkout(id: 'u1', name: 'Bench Press')],
      },
    ),
    act: (bloc) => bloc.add(
      const UserSettingsEvent.usualWorkoutAdded('push', 'bench press', []),
    ),
    expect: () => <UserSettingsState>[],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'usualWorkoutRenamed renames the matching usual',
    build: UserSettingsBloc.new,
    seed: () => const UserSettingsState(
      usualWorkouts: {
        'push': [UsualWorkout(id: 'u1', name: 'Bench Press')],
      },
    ),
    act: (bloc) => bloc.add(
      const UserSettingsEvent.usualWorkoutRenamed('push', 'u1', 'Incline Press'),
    ),
    expect: () => [
      isA<UserSettingsState>().having(
        (s) => s.usualWorkouts['push']!.single.name,
        'renamed usual',
        'Incline Press',
      ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'usualWorkoutSetsChanged replaces the usual\'s sets',
    build: UserSettingsBloc.new,
    seed: () => const UserSettingsState(
      usualWorkouts: {
        'push': [
          UsualWorkout(
            id: 'u1',
            name: 'Bench Press',
            sets: [WorkoutSet(weight: 135, reps: 8)],
          ),
        ],
      },
    ),
    act: (bloc) => bloc.add(
      const UserSettingsEvent.usualWorkoutSetsChanged('push', 'u1', [
        WorkoutSet(weight: 155, reps: 5),
      ]),
    ),
    expect: () => [
      isA<UserSettingsState>().having(
        (s) => s.usualWorkouts['push']!.single.sets.single.weight,
        'updated set weight',
        155,
      ),
    ],
  );

  blocTest<UserSettingsBloc, UserSettingsState>(
    'usualWorkoutRemoved drops the matching usual',
    build: UserSettingsBloc.new,
    seed: () => const UserSettingsState(
      usualWorkouts: {
        'push': [
          UsualWorkout(id: 'u1', name: 'Bench Press'),
          UsualWorkout(id: 'u2', name: 'Overhead Press'),
        ],
      },
    ),
    act: (bloc) =>
        bloc.add(const UserSettingsEvent.usualWorkoutRemoved('push', 'u1')),
    expect: () => [
      isA<UserSettingsState>().having(
        (s) => s.usualWorkouts['push']!.single.id,
        'remaining usual id',
        'u2',
      ),
    ],
  );
});

blocTest<UserSettingsBloc, UserSettingsState>(
  'workoutWeightUnitSelected stores the chosen unit',
  build: UserSettingsBloc.new,
  act: (bloc) => bloc.add(
    const UserSettingsEvent.workoutWeightUnitSelected(WeightUnit.kg),
  ),
  expect: () => [
    isA<UserSettingsState>().having(
      (s) => s.workoutWeightUnit,
      'workoutWeightUnit',
      WeightUnit.kg,
    ),
  ],
);
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`
Expected: FAIL — the new event constructors are undefined.

- [ ] **Step 3: Add the events**

In `lib/app/feature/user_settings/bloc/user_settings_event.dart`, add before the closing brace:

```dart
  const factory UserSettingsEvent.usualWorkoutAdded(
    String workoutGroupId,
    String name,
    List<WorkoutSet> sets,
  ) = SettingsUsualWorkoutAdded;
  const factory UserSettingsEvent.usualWorkoutRenamed(
    String workoutGroupId,
    String id,
    String name,
  ) = SettingsUsualWorkoutRenamed;
  const factory UserSettingsEvent.usualWorkoutSetsChanged(
    String workoutGroupId,
    String id,
    List<WorkoutSet> sets,
  ) = SettingsUsualWorkoutSetsChanged;
  const factory UserSettingsEvent.usualWorkoutRemoved(
    String workoutGroupId,
    String id,
  ) = SettingsUsualWorkoutRemoved;
  const factory UserSettingsEvent.workoutWeightUnitSelected(
    WeightUnit weightUnit,
  ) = SettingsWorkoutWeightUnitSelected;
```

- [ ] **Step 4: Handle the events**

In `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`, add these cases to the `switch (event)` (after the group cases from Task 8):

```dart
        SettingsUsualWorkoutAdded() => _onUsualWorkoutAdded(event, emit),
        SettingsUsualWorkoutRenamed() => _onUsualWorkoutRenamed(event, emit),
        SettingsUsualWorkoutSetsChanged() =>
          _onUsualWorkoutSetsChanged(event, emit),
        SettingsUsualWorkoutRemoved() => _onUsualWorkoutRemoved(event, emit),
        SettingsWorkoutWeightUnitSelected() => emit(
          state.copyWith(workoutWeightUnit: event.weightUnit),
        ),
```

Add these handler methods to the class:

```dart
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
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/user_settings_bloc_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 6: Run the full settings and workout suites**

Run: `fvm flutter test test/app/feature/user_settings/ test/app/feature/workout/ test/app/model/ --test-randomize-ordering-seed random`
Expected: PASS. This confirms Phase 1 is internally consistent.

- [ ] **Step 7: Request commit**

Stage the event file, bloc file, regenerated parts, and the test. Ask Jacob to commit. Suggested message:

```
feat(workout): manage usual workouts and workout weight unit in settings
```

---

## Self-Review

**Spec coverage (sections 1-2):**
- WorkoutSet (weight, reps, weightAutoEstimated, volume) — Task 1. ✓
- WorkoutLogEntry (id, loggedAt, workoutGroupId, name, sets, usualWorkoutId, volume) — Task 4. ✓
- UsualWorkout (id, name, sets) — Task 3. ✓
- WorkoutGroup (id, name, order), seeded Push/Pull/Legs with const ids — Task 2, Task 7. ✓
- WorkoutLogBloc (HydratedBloc, versioned, events workoutLogged/Removed/SetsChanged/stateRestored, entriesOn/volumeOn) — Task 6. ✓
- UserSettingsBloc extensions (workoutGroups, usualWorkouts, workoutReminder, workoutWeightUnit) with v2 migration defaulting the unit — Tasks 7, 8, 9. ✓
- WorkoutReminder model (enabled, daysOfWeek, timeOfDay) — Task 5. ✓ Its mutation events are deferred to Phase 6 (reminders), and seeding/`historyByMonth` to Phase 7 (history); both noted in the spec phasing.

**Deferred deliberately (with rationale in-plan):**
- `usualWorkoutId` repair event and `sampleDataSeeded` on WorkoutLogBloc — YAGNI / Phase 7.
- Resolved body-weight getter — Phase 5 (it reads `DailyLogBloc`, a cross-bloc concern used only by bodyweight estimation).
- Workout group deletion blocked on logged entries — enforced in the Phase 4 UI; the bloc backstops on usuals here.

**Placeholder scan:** None. Every step has complete code or an exact command.

**Type consistency:** `workoutGroupId` is a `String` everywhere (entry field, log event, settings events, `usualWorkouts` key). `sets` is `List<WorkoutSet>` everywhere. `workoutWeightUnit` is `WeightUnit`. Group ids `'push'`/`'pull'`/`'legs'` match between the seeded defaults (Task 7) and the tests in Tasks 8-9.
