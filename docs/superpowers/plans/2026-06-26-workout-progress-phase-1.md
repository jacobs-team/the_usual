# Workout Progress — Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the workout History screen with a Progress screen whose Exercises lens shows per-exercise estimated-1RM strength charts and whose Days lens keeps the existing day journal (volume chart removed).

**Architecture:** A pure e1RM metric on the model feeds a per-exercise rollup on `WorkoutLogState`. A hand-rolled `CustomPaint` line chart (mirroring the existing weight chart) renders one exercise's e1RM over time. A new `ProgressView` hosts a `SegmentedButton` toggling an Exercises lens (exercise list → detail chart) and a Days lens (the old day-list, volume chart stripped). The existing `Routes.workoutHistory` is repointed to `ProgressView`; the month volume chart is deleted.

**Tech Stack:** Flutter, freezed, `flutter_bloc`/`HydratedBloc`, `getIt`, `go_router`, `CustomPaint`. Tests: `flutter_test`, `bloc_test`, `mocktail`.

## Global Constraints

- Use `fvm flutter` for all Flutter CLI commands.
- Never run the code generator or the app — the developer runs both. If generated files are stale, ask the developer.
- Never `git commit`/`git push` — stage nothing; the commit steps below describe what to stage and a message, but the developer runs the commit.
- Always use barrel files over direct imports.
- `@freezed` for data classes/states/events; exhaustive `switch` in handlers.
- Feature widgets live in the feature's `widgets/` folder; get blocs via `getIt<T>()` in views.
- Name variables after the full model type (`workoutLogEntry`, not `entry`).
- Tests: use matchers (`equals()`, `isNull`, …) not raw asserts; locate widgets by type/key/icon, not by UI string; `initHydratedStorage()` in `HydratedBloc` setup; random seed ordering.
- e1RM formula is Epley with reps capped at 12; above 12 fall back to raw weight; a single rep is the raw weight. Apply one formula everywhere.

---

## File Structure

- `lib/app/model/workout_set.dart` — add `estimatedOneRepMax` getter (Task 1).
- `lib/app/model/extensions/workout_set_list_extensions.dart` — add best-e1RM set/value across a list of sets (Task 2).
- `lib/app/feature/workout/bloc/workout_log_state.dart` — add `ExerciseStrengthPoint`/`ExerciseStrengthSeries` typedefs and `strengthProgress` (Task 3).
- `lib/app/feature/workout/widgets/exercise_strength_chart.dart` — the per-exercise e1RM line chart (Task 4).
- `lib/app/feature/workout/widgets/exercise_sparkline.dart` — tiny line for list rows (Task 5).
- `lib/app/feature/workout/view/exercise_progress_detail_view.dart` — one exercise's chart + session list (Task 6).
- `lib/app/feature/workout/widgets/exercises_lens.dart` — the exercise list (Task 7).
- `lib/app/feature/workout/widgets/workout_days_lens.dart` — the day journal, moved from the old history view, volume chart removed (Task 8).
- `lib/app/feature/workout/view/progress_view.dart` — the screen with the segmented control (Task 9).
- Deletions (Task 9): `workout_volume_chart.dart` + its test; `workout_history_view.dart` (its UI moves to Task 8).
- Barrels updated: `widgets/widgets.dart`, `view/view.dart`.

---

### Task 1: e1RM getter on `WorkoutSet`

**Files:**
- Modify: `lib/app/model/workout_set.dart`
- Test: `test/app/model/workout_set_test.dart` (create if absent; otherwise add to its `group`)

**Interfaces:**
- Produces: `double WorkoutSet.estimatedOneRepMax` — Epley estimate; `0` when weight or reps is null/non-positive; raw weight when reps == 1 or reps > 12.

- [ ] **Step 1: Write the failing test**

Add to `test/app/model/workout_set_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group(WorkoutSet, () {
    test('estimatedOneRepMax uses Epley for 2..12 reps', () {
      // 100 * (1 + 8/30) = 126.666...
      expect(
        const WorkoutSet(weight: 100, reps: 8).estimatedOneRepMax,
        closeTo(126.6667, 0.001),
      );
    });

    test('estimatedOneRepMax returns raw weight for a single rep', () {
      expect(
        const WorkoutSet(weight: 140, reps: 1).estimatedOneRepMax,
        equals(140),
      );
    });

    test('estimatedOneRepMax falls back to raw weight above 12 reps', () {
      expect(
        const WorkoutSet(weight: 60, reps: 20).estimatedOneRepMax,
        equals(60),
      );
    });

    test('estimatedOneRepMax is 0 when weight or reps is missing', () {
      expect(const WorkoutSet(reps: 8).estimatedOneRepMax, equals(0));
      expect(const WorkoutSet(weight: 100).estimatedOneRepMax, equals(0));
      expect(const WorkoutSet().estimatedOneRepMax, equals(0));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/workout_set_test.dart`
Expected: FAIL — `estimatedOneRepMax` is not defined on `WorkoutSet`.

- [ ] **Step 3: Add the getter**

In `lib/app/model/workout_set.dart`, add below the existing `volume` getter:

```dart
  /// An Epley estimate of the one-rep max this set implies: `weight × (1 +
  /// reps/30)`. A single rep is just the weight, and above 12 reps the estimate
  /// is unreliable so it falls back to the raw weight. Returns 0 when weight or
  /// reps is missing, so an incomplete set contributes nothing.
  double get estimatedOneRepMax {
    final weight = this.weight;
    final reps = this.reps;
    if (weight == null || reps == null || reps <= 0) return 0;
    if (reps == 1 || reps > 12) return weight;
    return weight * (1 + reps / 30);
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/model/workout_set_test.dart`
Expected: PASS (4 tests).

- [ ] **Step 5: Commit**

Stage `lib/app/model/workout_set.dart` and `test/app/model/workout_set_test.dart`.
Message: `feat(workout): add Epley estimated 1RM to WorkoutSet`

---

### Task 2: Best-e1RM across a list of sets

**Files:**
- Modify: `lib/app/model/extensions/workout_set_list_extensions.dart`
- Test: `test/app/model/extensions/workout_set_list_extensions_test.dart` (add to existing file if present; else create)

**Interfaces:**
- Consumes: `WorkoutSet.estimatedOneRepMax` (Task 1).
- Produces, on `extension WorkoutSetListFormatting on List<WorkoutSet>`:
  - `WorkoutSet? get topEstimatedOneRepMaxSet` — the set with the highest e1RM, or `null` when no set has a computable e1RM.
  - `double get bestEstimatedOneRepMax` — that set's e1RM, or `0` when none.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('WorkoutSetListFormatting e1RM', () {
    test('topEstimatedOneRepMaxSet picks the highest-estimate set', () {
      // 100x8 -> 126.7 ; 110x5 -> 128.3 (winner) ; 120x1 -> 120
      const sets = [
        WorkoutSet(weight: 100, reps: 8),
        WorkoutSet(weight: 110, reps: 5),
        WorkoutSet(weight: 120, reps: 1),
      ];
      expect(
        sets.topEstimatedOneRepMaxSet,
        equals(const WorkoutSet(weight: 110, reps: 5)),
      );
      expect(sets.bestEstimatedOneRepMax, closeTo(128.333, 0.01));
    });

    test('ignores sets with no computable estimate', () {
      const sets = [WorkoutSet(reps: 8), WorkoutSet(weight: 80, reps: 6)];
      expect(
        sets.topEstimatedOneRepMaxSet,
        equals(const WorkoutSet(weight: 80, reps: 6)),
      );
    });

    test('returns null/0 when no set has weight and reps', () {
      const sets = [WorkoutSet(weight: 80), WorkoutSet(reps: 5)];
      expect(sets.topEstimatedOneRepMaxSet, isNull);
      expect(sets.bestEstimatedOneRepMax, equals(0));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/extensions/workout_set_list_extensions_test.dart`
Expected: FAIL — `topEstimatedOneRepMaxSet` not defined.

- [ ] **Step 3: Add the methods**

In `lib/app/model/extensions/workout_set_list_extensions.dart`, inside `extension WorkoutSetListFormatting on List<WorkoutSet>`, add:

```dart
  /// The set with the highest [WorkoutSet.estimatedOneRepMax], or null when no
  /// set has both a weight and reps to estimate from.
  WorkoutSet? get topEstimatedOneRepMaxSet {
    WorkoutSet? best;
    var bestEstimate = 0.0;
    for (final workoutSet in this) {
      final estimate = workoutSet.estimatedOneRepMax;
      if (estimate > bestEstimate) {
        bestEstimate = estimate;
        best = workoutSet;
      }
    }
    return best;
  }

  /// The highest estimated one-rep max across these sets, or 0 when none can be
  /// estimated.
  double get bestEstimatedOneRepMax =>
      topEstimatedOneRepMaxSet?.estimatedOneRepMax ?? 0;
```

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/model/extensions/workout_set_list_extensions_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

Stage the extension file and its test.
Message: `feat(workout): best estimated 1RM across a list of sets`

---

### Task 3: Per-exercise strength rollup on `WorkoutLogState`

**Files:**
- Modify: `lib/app/feature/workout/bloc/workout_log_state.dart`
- Test: `test/app/feature/workout/bloc/workout_log_bloc_test.dart` (add a `strengthProgress` group)

**Interfaces:**
- Consumes: `List<WorkoutSet>.topEstimatedOneRepMaxSet` / `.bestEstimatedOneRepMax` (Task 2); existing `DateTime.logicalDay(TimeOfDay)`.
- Produces (top-level typedefs in `workout_log_state.dart`):
  - `ExerciseStrengthPoint = ({DateTime sessionDay, double estimatedOneRepMax, WorkoutSet topSet})`
  - `ExerciseStrengthSeries = ({String name, List<ExerciseStrengthPoint> points})` (points oldest-first)
- Produces, on `WorkoutLogState`:
  - `List<ExerciseStrengthSeries> strengthProgress(TimeOfDay dayStart)` — one series per strength exercise that has ≥2 session points, most-recently-trained series first.

**Grouping rules (implement exactly):**
- Only `WorkoutType.strength` entries are considered.
- An exercise's identity key is: the canonical name for its `usualWorkoutId` when it has one, else its own `name.toLowerCase()`. The canonical name for a `usualWorkoutId` is the lowercased `name` of that id's most-recently-logged entry. (So renamed usuals stay one series, and ad-hoc entries group by name.)
- A series' display `name` is the original-case `name` of the group's most-recently-logged entry.
- A "session" is a logical day. Across all of the exercise's entries on that day, flatten every set; the day's point is the strongest set (`topEstimatedOneRepMaxSet`). Days with no computable set are skipped.

- [ ] **Step 1: Write the failing test**

Add to `test/app/feature/workout/bloc/workout_log_bloc_test.dart`, inside `group(WorkoutLogBloc, ...)`:

```dart
    group('strengthProgress', () {
      WorkoutLogEntry strengthEntry({
        required String id,
        required DateTime loggedAt,
        required String name,
        String? usualWorkoutId,
        List<WorkoutSet> sets = const [WorkoutSet(weight: 100, reps: 8)],
      }) {
        return WorkoutLogEntry(
          id: id,
          loggedAt: loggedAt,
          workoutGroupId: 'push',
          name: name,
          sets: sets,
          usualWorkoutId: usualWorkoutId,
        );
      }

      test('one series per exercise with >=2 sessions, oldest point first', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1, 9),
              name: 'Bench Press',
              sets: const [WorkoutSet(weight: 100, reps: 8)],
            ),
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8, 9),
              name: 'Bench Press',
              sets: const [WorkoutSet(weight: 105, reps: 8)],
            ),
          ],
        );

        final progress = state.strengthProgress(const TimeOfDay(hour: 0, minute: 0));

        expect(progress, hasLength(1));
        expect(progress.single.name, equals('Bench Press'));
        expect(progress.single.points, hasLength(2));
        expect(
          progress.single.points.first.sessionDay,
          equals(DateTime(2026, 6, 1)),
        );
        expect(
          progress.single.points.last.estimatedOneRepMax,
          closeTo(133.0, 0.5),
        );
      });

      test('drops exercises with fewer than two sessions', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1),
              name: 'Squat',
            ),
          ],
        );
        expect(
          state.strengthProgress(const TimeOfDay(hour: 0, minute: 0)),
          isEmpty,
        );
      });

      test('groups renamed usuals by usualWorkoutId into one series', () {
        final state = WorkoutLogState(
          workoutEntries: [
            strengthEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1),
              name: 'Bench',
              usualWorkoutId: 'u1',
            ),
            strengthEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8),
              name: 'Bench Press',
              usualWorkoutId: 'u1',
            ),
          ],
        );

        final progress = state.strengthProgress(const TimeOfDay(hour: 0, minute: 0));
        expect(progress, hasLength(1));
        // Display name comes from the most recent entry.
        expect(progress.single.name, equals('Bench Press'));
        expect(progress.single.points, hasLength(2));
      });

      test('excludes cardio entries', () {
        final state = WorkoutLogState(
          workoutEntries: [
            WorkoutLogEntry(
              id: '1',
              loggedAt: DateTime(2026, 6, 1),
              workoutGroupId: 'cardio',
              name: 'Run',
              type: WorkoutType.cardio,
              duration: const Duration(minutes: 30),
            ),
            WorkoutLogEntry(
              id: '2',
              loggedAt: DateTime(2026, 6, 8),
              workoutGroupId: 'cardio',
              name: 'Run',
              type: WorkoutType.cardio,
              duration: const Duration(minutes: 35),
            ),
          ],
        );
        expect(
          state.strengthProgress(const TimeOfDay(hour: 0, minute: 0)),
          isEmpty,
        );
      });
    });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/bloc/workout_log_bloc_test.dart --plain-name strengthProgress`
Expected: FAIL — `strengthProgress` not defined.

- [ ] **Step 3: Add typedefs and method**

In `lib/app/feature/workout/bloc/workout_log_state.dart`, add the typedefs next to `WorkoutHistoryMonth` (top of file, after the existing typedefs):

```dart
/// One session's strength data point for an exercise: the logical day trained,
/// the best estimated one-rep max across that day's sets, and the set that
/// achieved it.
typedef ExerciseStrengthPoint = ({
  DateTime sessionDay,
  double estimatedOneRepMax,
  WorkoutSet topSet,
});

/// One strength exercise's progress over time: its display name and its session
/// points, oldest first.
typedef ExerciseStrengthSeries = ({
  String name,
  List<ExerciseStrengthPoint> points,
});
```

Add this method to the `WorkoutLogState` class body (next to `historyByMonth`):

```dart
  /// Every strength exercise's estimated-1RM progress, one [ExerciseStrength
  /// Series] per exercise that has at least two logged sessions, most recently
  /// trained first. Exercises are grouped by name (case-insensitive), with
  /// entries sharing a [WorkoutLogEntry.usualWorkoutId] treated as one exercise
  /// even if renamed. Each session is a logical day; its point is the strongest
  /// set across that day's entries for the exercise.
  List<ExerciseStrengthSeries> strengthProgress(TimeOfDay dayStart) {
    final strengthEntries = workoutEntries
        .where((workoutLogEntry) => workoutLogEntry.type == WorkoutType.strength)
        .toList();

    // The lowercased name of each usual's most-recently-logged entry, used to
    // keep renamed usuals in one group.
    final canonicalNameByUsualId = <String, String>{};
    final canonicalLoggedAtByUsualId = <String, DateTime>{};
    for (final workoutLogEntry in strengthEntries) {
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId == null) continue;
      final seenAt = canonicalLoggedAtByUsualId[usualWorkoutId];
      if (seenAt == null || workoutLogEntry.loggedAt.isAfter(seenAt)) {
        canonicalLoggedAtByUsualId[usualWorkoutId] = workoutLogEntry.loggedAt;
        canonicalNameByUsualId[usualWorkoutId] =
            workoutLogEntry.name.toLowerCase();
      }
    }

    String keyFor(WorkoutLogEntry workoutLogEntry) {
      final usualWorkoutId = workoutLogEntry.usualWorkoutId;
      if (usualWorkoutId != null) {
        return canonicalNameByUsualId[usualWorkoutId] ??
            workoutLogEntry.name.toLowerCase();
      }
      return workoutLogEntry.name.toLowerCase();
    }

    final entriesByKey = <String, List<WorkoutLogEntry>>{};
    for (final workoutLogEntry in strengthEntries) {
      entriesByKey
          .putIfAbsent(keyFor(workoutLogEntry), () => <WorkoutLogEntry>[])
          .add(workoutLogEntry);
    }

    final series = <ExerciseStrengthSeries>[];
    for (final groupEntries in entriesByKey.values) {
      // Display name and group recency from the most recent entry.
      final mostRecentEntry = groupEntries.reduce(
        (a, b) => a.loggedAt.isAfter(b.loggedAt) ? a : b,
      );

      final setsByDay = <DateTime, List<WorkoutSet>>{};
      for (final workoutLogEntry in groupEntries) {
        final day = workoutLogEntry.loggedAt.logicalDay(dayStart);
        setsByDay.putIfAbsent(day, () => <WorkoutSet>[])
          ..addAll(workoutLogEntry.sets);
      }

      final points = <ExerciseStrengthPoint>[];
      for (final day in setsByDay.keys.toList()..sort((a, b) => a.compareTo(b))) {
        final topSet = setsByDay[day]!.topEstimatedOneRepMaxSet;
        if (topSet == null) continue;
        points.add((
          sessionDay: day,
          estimatedOneRepMax: topSet.estimatedOneRepMax,
          topSet: topSet,
        ));
      }

      if (points.length < 2) continue;
      series.add((name: mostRecentEntry.name, points: points));
    }

    series.sort(
      (a, b) => b.points.last.sessionDay.compareTo(a.points.last.sessionDay),
    );
    return series;
  }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/feature/workout/bloc/workout_log_bloc_test.dart --plain-name strengthProgress`
Expected: PASS (4 tests).

- [ ] **Step 5: Commit**

Stage `workout_log_state.dart` and the bloc test.
Message: `feat(workout): per-exercise estimated-1RM progress rollup`

---

### Task 4: `ExerciseStrengthChart` widget

**Files:**
- Create: `lib/app/feature/workout/widgets/exercise_strength_chart.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart` (export)
- Test: `test/app/feature/workout/widgets/exercise_strength_chart_test.dart`

**Interfaces:**
- Consumes: `ExerciseStrengthPoint` (Task 3), `WeightUnit`, `num.trimmedDecimal`.
- Produces: `ExerciseStrengthChart({required List<ExerciseStrengthPoint> points, required WeightUnit weightUnit, required ValueChanged<ExerciseStrengthPoint> onPointSelected, Key? key})`. Renders nothing when `points.length < 2`. Header label `STRENGTH`, net change from first to last e1RM. A line over the points, dot on the latest, tap selects the nearest point.

This mirrors `MonthWeightChart` ([lib/app/feature/history/widgets/month_weight_chart.dart](lib/app/feature/history/widgets/month_weight_chart.dart)) — same dark `colorScheme.primary` card, `_sectionLabelStyle`, `verticalInset`, `yFor` scaling, and `shouldRepaint` shape. Reuse that structure.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseStrengthChart, () {
    List<ExerciseStrengthPoint> points(List<double> estimates) => [
      for (var i = 0; i < estimates.length; i++)
        (
          sessionDay: DateTime(2026, 6, i + 1),
          estimatedOneRepMax: estimates[i],
          topSet: WorkoutSet(weight: estimates[i], reps: 1),
        ),
    ];

    Future<void> pumpChart(
      WidgetTester tester, {
      required List<ExerciseStrengthPoint> data,
      ValueChanged<ExerciseStrengthPoint>? onPointSelected,
    }) async {
      await tester.pumpPumpPumpItUP(
        SizedBox(
          width: 360,
          height: 300,
          child: ExerciseStrengthChart(
            points: data,
            weightUnit: WeightUnit.lb,
            onPointSelected: onPointSelected ?? (_) {},
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('renders a CustomPaint for 2+ points', (tester) async {
      await pumpChart(tester, data: points([120, 130]));
      expect(
        find.descendant(
          of: find.byType(ExerciseStrengthChart),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders nothing for fewer than 2 points', (tester) async {
      await pumpChart(tester, data: points([120]));
      expect(
        find.descendant(
          of: find.byType(ExerciseStrengthChart),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });

    testWidgets('tapping selects a point', (tester) async {
      ExerciseStrengthPoint? selected;
      await pumpChart(
        tester,
        data: points([120, 130, 140]),
        onPointSelected: (point) => selected = point,
      );
      await tester.tap(
        find.descendant(
          of: find.byType(ExerciseStrengthChart),
          matching: find.byType(GestureDetector),
        ).first,
      );
      await tester.pump();
      expect(selected, isNotNull);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/widgets/exercise_strength_chart_test.dart`
Expected: FAIL — `ExerciseStrengthChart` not defined.

- [ ] **Step 3: Implement the widget**

Create `lib/app/feature/workout/widgets/exercise_strength_chart.dart`:

```dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercise_strength_chart}
/// One exercise's estimated one-rep max over time, drawn as a line on a dark
/// card with the net change from the first session to the latest. Tapping the
/// chart selects the nearest session and reports it. Renders nothing with fewer
/// than two sessions, since a line needs at least two points.
/// {@endtemplate}
class ExerciseStrengthChart extends StatelessWidget {
  /// {@macro exercise_strength_chart}
  const ExerciseStrengthChart({
    required this.points,
    required this.weightUnit,
    required this.onPointSelected,
    super.key,
  });

  /// The exercise's session points, oldest first.
  final List<ExerciseStrengthPoint> points;

  /// The unit shown in the header net-change label.
  final WeightUnit weightUnit;

  /// Called with the session nearest a tap.
  final ValueChanged<ExerciseStrengthPoint> onPointSelected;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mutedForeground = colorScheme.onPrimary.withValues(alpha: 0.7);

    final estimates = [
      for (final point in points) point.estimatedOneRepMax,
    ];
    final rawChange = estimates.last - estimates.first;
    final change = (rawChange * 10).round() / 10;
    final String netChange;
    if (change == 0) {
      netChange = 'No change';
    } else {
      final arrow = change < 0 ? '▼' : '▲';
      netChange = '$arrow ${change.abs().trimmedDecimal} ${weightUnit.name}';
    }

    return Padding(
      padding: EdgeInsets.only(bottom: AppDesign.spacing.lg),
      child: Container(
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(AppDesign.radius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'STRENGTH',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: mutedForeground,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  netChange,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDesign.spacing.md),
            SizedBox(
              height: 84,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final step = points.length == 1
                          ? constraints.maxWidth
                          : constraints.maxWidth / (points.length - 1);
                      final index = (details.localPosition.dx / step)
                          .round()
                          .clamp(0, points.length - 1);
                      onPointSelected(points[index]);
                    },
                    child: CustomPaint(
                      painter: _StrengthLinePainter(
                        estimates: estimates,
                        lineColor: colorScheme.inversePrimary,
                        dotColor: colorScheme.onPrimary,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: AppDesign.spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  estimates.first.trimmedDecimal,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: mutedForeground,
                  ),
                ),
                Text(
                  '${estimates.last.trimmedDecimal} ${weightUnit.name}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Paints the e1RM values as a single line, evenly spaced across the width and
/// scaled to their range, with a dot on the latest point.
class _StrengthLinePainter extends CustomPainter {
  const _StrengthLinePainter({
    required this.estimates,
    required this.lineColor,
    required this.dotColor,
  });

  final List<double> estimates;
  final Color lineColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (estimates.length < 2) return;

    final minEstimate = estimates.reduce(min);
    final maxEstimate = estimates.reduce(max);
    final range = maxEstimate - minEstimate;
    const verticalInset = 6.0;
    final usableHeight = size.height - verticalInset * 2;

    double yFor(double estimate) {
      if (range == 0) return size.height / 2;
      final normalized = (estimate - minEstimate) / range;
      return verticalInset + (1 - normalized) * usableHeight;
    }

    final horizontalStep = size.width / (estimates.length - 1);
    final dataPoints = [
      for (var index = 0; index < estimates.length; index++)
        Offset(index * horizontalStep, yFor(estimates[index])),
    ];

    final linePath = Path()..moveTo(dataPoints.first.dx, dataPoints.first.dy);
    for (final point in dataPoints.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(linePath, linePaint)
      ..drawCircle(dataPoints.last, 3, Paint()..color = dotColor);
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(_StrengthLinePainter oldDelegate) =>
      oldDelegate.estimates != estimates ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.dotColor != dotColor;
  // coverage:ignore-end
}
```

- [ ] **Step 4: Export and run the test**

Add to `lib/app/feature/workout/widgets/widgets.dart`:

```dart
export 'exercise_strength_chart.dart';
```

Run: `fvm flutter test test/app/feature/workout/widgets/exercise_strength_chart_test.dart`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

Stage the widget, the barrel, and the test.
Message: `feat(workout): exercise estimated-1RM line chart`

---

### Task 5: `ExerciseSparkline` widget

**Files:**
- Create: `lib/app/feature/workout/widgets/exercise_sparkline.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart` (export)
- Test: `test/app/feature/workout/widgets/exercise_sparkline_test.dart`

**Interfaces:**
- Produces: `ExerciseSparkline({required List<double> values, Color? color, Key? key})` — a compact line with no labels or axis; renders nothing for fewer than 2 values.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseSparkline, () {
    testWidgets('paints for 2+ values', (tester) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox(
          width: 80,
          height: 24,
          child: ExerciseSparkline(values: [120, 130, 128, 140]),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(ExerciseSparkline),
          matching: find.byType(CustomPaint),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders nothing for fewer than 2 values', (tester) async {
      await tester.pumpPumpPumpItUP(
        const SizedBox(
          width: 80,
          height: 24,
          child: ExerciseSparkline(values: [120]),
        ),
      );
      expect(
        find.descendant(
          of: find.byType(ExerciseSparkline),
          matching: find.byType(CustomPaint),
        ),
        findsNothing,
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/widgets/exercise_sparkline_test.dart`
Expected: FAIL — `ExerciseSparkline` not defined.

- [ ] **Step 3: Implement the widget**

Create `lib/app/feature/workout/widgets/exercise_sparkline.dart`:

```dart
import 'dart:math';

import 'package:flutter/material.dart';

/// {@template exercise_sparkline}
/// A compact, label-free line of values for an exercise-list row. Renders
/// nothing for fewer than two values.
/// {@endtemplate}
class ExerciseSparkline extends StatelessWidget {
  /// {@macro exercise_sparkline}
  const ExerciseSparkline({required this.values, this.color, super.key});

  /// The values to plot, oldest first.
  final List<double> values;

  /// The line color; defaults to the theme's primary.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) return const SizedBox.shrink();
    return CustomPaint(
      painter: _SparklinePainter(
        values: values,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final minValue = values.reduce(min);
    final maxValue = values.reduce(max);
    final range = maxValue - minValue;
    const inset = 2.0;
    final usableHeight = size.height - inset * 2;

    double yFor(double value) {
      if (range == 0) return size.height / 2;
      return inset + (1 - (value - minValue) / range) * usableHeight;
    }

    final step = size.width / (values.length - 1);
    final path = Path()..moveTo(0, yFor(values.first));
    for (var index = 1; index < values.length; index++) {
      path.lineTo(index * step, yFor(values[index]));
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
  // coverage:ignore-end
}
```

- [ ] **Step 4: Export and run the test**

Add to `lib/app/feature/workout/widgets/widgets.dart`:

```dart
export 'exercise_sparkline.dart';
```

Run: `fvm flutter test test/app/feature/workout/widgets/exercise_sparkline_test.dart`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

Stage the widget, the barrel, and the test.
Message: `feat(workout): exercise progress sparkline`

---

### Task 6: `ExerciseProgressDetailView`

**Files:**
- Create: `lib/app/feature/workout/view/exercise_progress_detail_view.dart`
- Modify: `lib/app/feature/workout/view/view.dart` (export)
- Test: `test/app/feature/workout/view/exercise_progress_detail_view_test.dart`

**Interfaces:**
- Consumes: `WorkoutLogBloc` + `WorkoutLogState.strengthProgress` (Task 3), `UserSettingsBloc` (`workoutWeightUnit`, `dayStartTime`), `ExerciseStrengthChart` (Task 4), `List<WorkoutSet>.summary`/`WorkoutSet.label`, `num.trimmedDecimal`, `TheUsualAppBar`, `SectionLabel`.
- Produces: `ExerciseProgressDetailView({required String exerciseName, Key? key})`. Finds the series whose `name` equals `exerciseName` from the current state, shows the chart plus a reverse-chronological session list. A selected point (from a chart tap) shows its date and top set above the list; defaults to the latest point.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExerciseProgressDetailView, () {
    setUp(initHydratedStorage);
    tearDown(getIt.reset);

    testWidgets('shows the strength chart for the named exercise', (
      tester,
    ) async {
      final workoutLogBloc = WorkoutLogBloc();
      for (final entry in [
        WorkoutLogEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 1),
          workoutGroupId: 'push',
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 100, reps: 8)],
        ),
        WorkoutLogEntry(
          id: '2',
          loggedAt: DateTime(2026, 6, 8),
          workoutGroupId: 'push',
          name: 'Bench Press',
          sets: const [WorkoutSet(weight: 110, reps: 8)],
        ),
      ]) {
        workoutLogBloc.add(
          WorkoutLogEvent.workoutLogged(
            entry.workoutGroupId,
            entry.name,
            sets: entry.sets,
          ),
        );
      }

      getIt
        ..registerSingleton<WorkoutLogBloc>(workoutLogBloc)
        ..registerSingleton<UserSettingsBloc>(UserSettingsBloc());

      await tester.pumpAppView(
        const ExerciseProgressDetailView(exerciseName: 'Bench Press'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseStrengthChart), findsOneWidget);
    });
  });
}
```

> Note: if `pumpAppView` is not the project helper for a full-screen view, use the helper the other view tests in `test/app/feature/workout/view/` use (check `workouts_view_test.dart`). The two logged entries land on the same logical day via `workoutLogged` (which stamps `loggedAt` = now), so prefer constructing state directly if the helper supports injecting a populated `WorkoutLogBloc` — adjust to match the sibling test's established pattern.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/view/exercise_progress_detail_view_test.dart`
Expected: FAIL — `ExerciseProgressDetailView` not defined.

- [ ] **Step 3: Implement the view**

Create `lib/app/feature/workout/view/exercise_progress_detail_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercise_progress_detail_view}
/// One exercise's strength progress: its estimated-1RM chart over all sessions
/// and a reverse-chronological list of those sessions. Tapping a chart point
/// surfaces that session's top set above the list.
/// {@endtemplate}
class ExerciseProgressDetailView extends StatefulWidget {
  /// {@macro exercise_progress_detail_view}
  const ExerciseProgressDetailView({required this.exerciseName, super.key});

  /// The display name of the exercise to chart, matched against
  /// [ExerciseStrengthSeries.name].
  final String exerciseName;

  @override
  State<ExerciseProgressDetailView> createState() =>
      _ExerciseProgressDetailViewState();
}

class _ExerciseProgressDetailViewState
    extends State<ExerciseProgressDetailView> {
  ExerciseStrengthPoint? _selectedPoint;

  @override
  Widget build(BuildContext context) {
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final weightUnit = getIt<UserSettingsBloc>().state.workoutWeightUnit;

    return Scaffold(
      appBar: TheUsualAppBar(title: widget.exerciseName),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<WorkoutLogBloc, WorkoutLogState>(
          bloc: getIt<WorkoutLogBloc>(),
          builder: (context, state) {
            final series = state
                .strengthProgress(dayStart)
                .where((s) => s.name == widget.exerciseName)
                .firstOrNull;

            if (series == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.xl),
                  child: Text(
                    'Not enough sessions yet to chart this exercise.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            }

            final selectedPoint = _selectedPoint ?? series.points.last;
            final localizations = MaterialLocalizations.of(context);
            final sessionsNewestFirst = series.points.reversed.toList();

            return ListView(
              padding: EdgeInsets.fromLTRB(
                AppDesign.spacing.lg,
                AppDesign.spacing.sm,
                AppDesign.spacing.lg,
                AppDesign.spacing.xl,
              ),
              children: [
                ExerciseStrengthChart(
                  points: series.points,
                  weightUnit: weightUnit,
                  onPointSelected: (point) =>
                      setState(() => _selectedPoint = point),
                ),
                Text(
                  '${localizations.formatMediumDate(selectedPoint.sessionDay)} · '
                  '${selectedPoint.topSet.label} · '
                  '${selectedPoint.estimatedOneRepMax.trimmedDecimal} '
                  '${weightUnit.name} est. max',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: AppDesign.spacing.lg),
                const SectionLabel('SESSIONS'),
                for (final point in sessionsNewestFirst)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(DateFormat.yMMMd().format(point.sessionDay)),
                    subtitle: Text(point.topSet.label),
                    trailing: Text(
                      '${point.estimatedOneRepMax.trimmedDecimal} '
                      '${weightUnit.name}',
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Export and run the test**

Add to `lib/app/feature/workout/view/view.dart`:

```dart
export 'exercise_progress_detail_view.dart';
```

Run: `fvm flutter test test/app/feature/workout/view/exercise_progress_detail_view_test.dart`
Expected: PASS. If the test helper differs, align it with the sibling pattern noted in Step 1 before moving on.

- [ ] **Step 5: Commit**

Stage the view, the barrel, and the test.
Message: `feat(workout): per-exercise progress detail screen`

---

### Task 7: `ExercisesLens` widget

**Files:**
- Create: `lib/app/feature/workout/widgets/exercises_lens.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart` (export)
- Test: `test/app/feature/workout/widgets/exercises_lens_test.dart`

**Interfaces:**
- Consumes: `WorkoutLogBloc`/`strengthProgress`, `UserSettingsBloc` (`workoutWeightUnit`, `dayStartTime`), `ExerciseSparkline` (Task 5), `ExerciseProgressDetailView` (Task 6), `num.trimmedDecimal`.
- Produces: `ExercisesLens({Key? key})` — a list of strength exercises (name + sparkline + latest est. max), most recently trained first; tapping a row pushes `ExerciseProgressDetailView`. Shows an empty-state message when there are no qualifying exercises. (The Overall strength card is Phase 2 and is intentionally absent here.)

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ExercisesLens, () {
    setUp(initHydratedStorage);
    tearDown(getIt.reset);

    testWidgets('lists a row with a sparkline per qualifying exercise', (
      tester,
    ) async {
      final workoutLogBloc = WorkoutLogBloc();
      getIt
        ..registerSingleton<WorkoutLogBloc>(workoutLogBloc)
        ..registerSingleton<UserSettingsBloc>(UserSettingsBloc());
      // Two sessions of one exercise -> one qualifying series.
      workoutLogBloc
        ..add(
          const WorkoutLogEvent.workoutLogged(
            'push',
            'Bench Press',
            sets: [WorkoutSet(weight: 100, reps: 8)],
          ),
        )
        ..add(
          const WorkoutLogEvent.workoutLogged(
            'push',
            'Bench Press',
            sets: [WorkoutSet(weight: 110, reps: 8)],
          ),
        );
      await tester.pump();

      await tester.pumpAppView(const ExercisesLens());
      await tester.pumpAndSettle();

      // Sparkline only renders with >=2 points; if both sessions share a
      // logical day this collapses — assert on row presence instead.
      expect(find.byType(ExerciseSparkline), findsWidgets);
    });

    testWidgets('shows an empty state with no qualifying exercises', (
      tester,
    ) async {
      getIt
        ..registerSingleton<WorkoutLogBloc>(WorkoutLogBloc())
        ..registerSingleton<UserSettingsBloc>(UserSettingsBloc());

      await tester.pumpAppView(const ExercisesLens());
      await tester.pumpAndSettle();

      expect(find.byType(ExerciseSparkline), findsNothing);
    });
  });
}
```

> Note: `workoutLogged` stamps `loggedAt` with the current time, so both test sessions may land on one logical day and collapse to a single point (no qualifying series). If the sibling view tests inject a pre-populated `WorkoutLogBloc` state with distinct `loggedAt` days, follow that pattern so the two sessions are on different days. Match whatever `workouts_view_test.dart` does.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/widgets/exercises_lens_test.dart`
Expected: FAIL — `ExercisesLens` not defined.

- [ ] **Step 3: Implement the widget**

Create `lib/app/feature/workout/widgets/exercises_lens.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template exercises_lens}
/// The Progress screen's Exercises lens: a list of strength exercises, each
/// showing its estimated-1RM sparkline and latest estimate, most recently
/// trained first. Tapping a row opens that exercise's progress detail.
/// {@endtemplate}
class ExercisesLens extends StatelessWidget {
  /// {@macro exercises_lens}
  const ExercisesLens({super.key});

  @override
  Widget build(BuildContext context) {
    final dayStart = getIt<UserSettingsBloc>().state.dayStartTime;
    final weightUnit = getIt<UserSettingsBloc>().state.workoutWeightUnit;

    return BlocBuilder<WorkoutLogBloc, WorkoutLogState>(
      bloc: getIt<WorkoutLogBloc>(),
      builder: (context, state) {
        final progress = state.strengthProgress(dayStart);
        if (progress.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(AppDesign.spacing.xl),
              child: Text(
                'Log a strength exercise on two or more days and its progress '
                'shows up here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            AppDesign.spacing.lg,
            AppDesign.spacing.sm,
            AppDesign.spacing.lg,
            AppDesign.spacing.xl,
          ),
          itemCount: progress.length,
          itemBuilder: (context, index) {
            final series = progress[index];
            final latest = series.points.last.estimatedOneRepMax;
            return Card(
              margin: EdgeInsets.only(bottom: AppDesign.spacing.sm),
              child: ListTile(
                title: Text(series.name),
                subtitle: SizedBox(
                  height: 24,
                  child: ExerciseSparkline(
                    values: [
                      for (final point in series.points)
                        point.estimatedOneRepMax,
                    ],
                  ),
                ),
                trailing: Text(
                  '${latest.trimmedDecimal} ${weightUnit.name}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        ExerciseProgressDetailView(exerciseName: series.name),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
```

- [ ] **Step 4: Export and run the test**

Add to `lib/app/feature/workout/widgets/widgets.dart`:

```dart
export 'exercises_lens.dart';
```

Run: `fvm flutter test test/app/feature/workout/widgets/exercises_lens_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

Stage the widget, the barrel, and the test.
Message: `feat(workout): exercises lens listing strength progress`

---

### Task 8: `WorkoutDaysLens` (move the day journal off the old history view)

**Files:**
- Create: `lib/app/feature/workout/widgets/workout_days_lens.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart` (export)
- Modify/rename test: `test/app/feature/workout/view/workout_history_view_test.dart` → `test/app/feature/workout/widgets/workout_days_lens_test.dart`

**Interfaces:**
- Consumes: `WorkoutLogBloc`/`historyByMonth`, `UserSettingsBloc` (`workoutWeightUnit`, `workoutGroups`, `dayStartTime`), `LoggedWorkoutRow`, `SectionLabel`.
- Produces: `WorkoutDaysLens({Key? key})` — the month-paged day list, **with no volume chart**, and no `Scaffold`/`AppBar` of its own (it is embedded in `ProgressView`).

This is a move-and-trim of the existing [workout_history_view.dart](lib/app/feature/workout/view/workout_history_view.dart). Carry over the state class and the private widgets `_WorkoutMonthSelector`, `_WorkoutMonthChip`, `_WorkoutHistoryDayCard` verbatim, with these changes:

- [ ] **Step 1: Create the widget by moving the day-list code**

Copy the full contents of `workout_history_view.dart` into the new `workout_days_lens.dart`. Then apply:

1. Rename the public widget `WorkoutHistoryView` → `WorkoutDaysLens` and its state `_WorkoutHistoryViewState` → `_WorkoutDaysLensState`.
2. Remove the `Scaffold` and `TheUsualAppBar`: the `build` returns the inner `Column` (month selector + `Expanded` `PageView`) wrapped in `SafeArea(bottom: false, child: ...)` directly, not a `Scaffold`. Keep the empty-state `Center` for `history.isEmpty`.
3. In the month page's first list item (`itemIndex == 0`), delete the `WorkoutVolumeChart(...)` widget and its surrounding `Column` children, leaving only the month-year `SectionLabel`. The first item becomes:

```dart
if (itemIndex == 0) {
  return Padding(
    padding: EdgeInsets.only(bottom: AppDesign.spacing.sm),
    child: SectionLabel(
      localizations
          .formatMonthYear(workoutHistoryMonth.month)
          .toUpperCase(),
    ),
  );
}
```

4. The `scrollToDay` callback and `onDayTapped` wiring existed only to jump from the volume bar to a day. With the chart gone, remove `scrollToDay`, the `_monthScrollControllers` map, and the `ItemScrollController` usage; replace `ScrollablePositionedList.builder` with a plain `ListView.builder` (same `itemCount`, `padding`, and `itemBuilder`). The `_dayExpansionControllers` map and `_WorkoutHistoryDayCard.controller` can stay (harmless) or be removed; removing them is cleaner — drop the `controller` param and the map if you do.
5. Keep the `scrollable_positioned_list` import only if still used; remove it otherwise.

- [ ] **Step 2: Export it**

Add to `lib/app/feature/workout/widgets/widgets.dart`:

```dart
export 'workout_days_lens.dart';
```

- [ ] **Step 3: Move and adjust the test**

Rename `test/app/feature/workout/view/workout_history_view_test.dart` to `test/app/feature/workout/widgets/workout_days_lens_test.dart`. Update it to pump `WorkoutDaysLens` instead of `WorkoutHistoryView`, fix the relative `helpers` import depth (`../../../../helpers/helpers.dart`), and delete any assertion that depended on the volume chart. Add one assertion that the volume chart is gone:

```dart
expect(find.byType(WorkoutVolumeChart), findsNothing);
```

(Keep this assertion only until Task 9 deletes `WorkoutVolumeChart`; at that point the symbol no longer exists, so replace it then with an assertion that day cards render, e.g. `find.byType(Card)` / `find.byType(ExpansionTile)`.)

- [ ] **Step 4: Run the test**

Run: `fvm flutter test test/app/feature/workout/widgets/workout_days_lens_test.dart`
Expected: PASS.

- [ ] **Step 5: Commit**

Stage the new widget, the barrel, the moved test, and the deleted old test.
Message: `refactor(workout): extract day journal into WorkoutDaysLens, drop volume chart from it`

---

### Task 9: `ProgressView` screen + wiring + removals

**Files:**
- Create: `lib/app/feature/workout/view/progress_view.dart`
- Modify: `lib/app/feature/workout/view/view.dart` (export `progress_view.dart`; remove `workout_history_view.dart` export)
- Modify: `lib/app/navigation/app_router.dart` (point `Routes.workoutHistory` at `ProgressView`)
- Delete: `lib/app/feature/workout/view/workout_history_view.dart`
- Delete: `lib/app/feature/workout/widgets/workout_volume_chart.dart` + remove its export from `widgets.dart`
- Delete: `test/app/feature/workout/widgets/workout_volume_chart_test.dart`
- Test: `test/app/feature/workout/view/progress_view_test.dart`

**Interfaces:**
- Consumes: `ExercisesLens` (Task 7), `WorkoutDaysLens` (Task 8), `TheUsualAppBar`.
- Produces: `ProgressView({Key? key})` — `TheUsualAppBar(title: 'Progress')`, a `SegmentedButton` toggling Exercises/Days, and an `IndexedStack` showing the selected lens.

- [ ] **Step 1: Write the failing test**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(ProgressView, () {
    setUp(initHydratedStorage);
    tearDown(getIt.reset);

    testWidgets('defaults to the Exercises lens and can switch to Days', (
      tester,
    ) async {
      getIt
        ..registerSingleton<WorkoutLogBloc>(WorkoutLogBloc())
        ..registerSingleton<UserSettingsBloc>(UserSettingsBloc());

      await tester.pumpAppView(const ProgressView());
      await tester.pumpAndSettle();

      expect(find.byType(ExercisesLens), findsOneWidget);

      // Switch to Days via the segmented control (locate by icon, not text).
      await tester.tap(find.byIcon(Icons.calendar_month_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(WorkoutDaysLens), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/view/progress_view_test.dart`
Expected: FAIL — `ProgressView` not defined.

- [ ] **Step 3: Implement the screen**

Create `lib/app/feature/workout/view/progress_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The two lenses on workout history the Progress screen toggles between.
enum _ProgressLens { exercises, days }

/// {@template progress_view}
/// Workout progress and history. A segmented control toggles the Exercises lens
/// (per-exercise estimated-1RM charts) and the Days lens (the day-by-day
/// journal).
/// {@endtemplate}
class ProgressView extends StatefulWidget {
  /// {@macro progress_view}
  const ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  _ProgressLens _lens = _ProgressLens.exercises;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TheUsualAppBar(title: 'Progress'),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDesign.spacing.lg,
                vertical: AppDesign.spacing.md,
              ),
              child: SegmentedButton<_ProgressLens>(
                segments: const [
                  ButtonSegment(
                    value: _ProgressLens.exercises,
                    label: Text('Exercises'),
                    icon: Icon(Icons.show_chart),
                  ),
                  ButtonSegment(
                    value: _ProgressLens.days,
                    label: Text('Days'),
                    icon: Icon(Icons.calendar_month_outlined),
                  ),
                ],
                selected: {_lens},
                onSelectionChanged: (selection) =>
                    setState(() => _lens = selection.first),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _lens.index,
                children: const [ExercisesLens(), WorkoutDaysLens()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Wire the route and remove the old screen + volume chart**

In `lib/app/feature/workout/view/view.dart`: add `export 'progress_view.dart';` and remove the `workout_history_view.dart` export.

In `lib/app/navigation/app_router.dart`, change the `Routes.workoutHistory` route body:

```dart
    GoRoute(
      path: Routes.workoutHistory,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: ProgressView());
      },
    ),
```

Delete `lib/app/feature/workout/view/workout_history_view.dart`.

Delete `lib/app/feature/workout/widgets/workout_volume_chart.dart` and remove its `export 'workout_volume_chart.dart';` line from `lib/app/feature/workout/widgets/widgets.dart`.

Delete `test/app/feature/workout/widgets/workout_volume_chart_test.dart`.

In `test/app/feature/workout/widgets/workout_days_lens_test.dart`, replace the temporary `find.byType(WorkoutVolumeChart)` assertion (added in Task 8) with day-card assertions, e.g.:

```dart
expect(find.byType(ExpansionTile), findsWidgets);
```

- [ ] **Step 5: Run the targeted tests**

Run: `fvm flutter test test/app/feature/workout/view/progress_view_test.dart test/app/feature/workout/widgets/workout_days_lens_test.dart`
Expected: PASS.

- [ ] **Step 6: Run the full suite and analyzer**

Run: `fvm flutter test`
Expected: PASS — no references to the deleted `WorkoutVolumeChart` or `WorkoutHistoryView` remain. If a test or file still imports them, update or remove it.

Run: `fvm flutter analyze`
Expected: No errors. (Pre-existing info/warning-level lints are out of scope.)

- [ ] **Step 7: Commit**

Stage the new view, the barrels, the router change, the deletions, and the tests.
Message: `feat(workout): Progress screen replacing workout history; remove volume chart`

---

## Self-Review

**Spec coverage:**
- Strength metric = Epley e1RM, reps capped at 12, raw weight above 12, single rep = raw weight → Task 1. ✓
- Best set per session via highest e1RM → Tasks 2–3. ✓
- Exercise identity by lowercased name, merged across `usualWorkoutId` → Task 3 (grouping rules + tests). ✓
- Cardio excluded → Task 3 (`WorkoutType.strength` filter + test). ✓
- Per-exercise chart styled like the weight chart, net change, endpoint labels, tap-to-reveal top set → Tasks 4 + 6. ✓
- Progress screen, segmented control Exercises/Days → Task 9. ✓
- Exercises lens: list + sparkline + latest, → detail → Tasks 5–7. ✓
- Days lens = old day journal minus volume chart → Task 8. ✓
- Remove volume chart; repoint `Routes.workoutHistory`; retire `WorkoutHistoryView` → Tasks 8–9. ✓
- Overall strength combined index → **Phase 2, intentionally not in this plan.** Noted in Task 7 that the card is absent.
- Persisted state unchanged → no migration task needed (no state-shape change). ✓

**Placeholder scan:** No TBD/TODO. The two "Note" callouts (Tasks 6, 7) flag a real test-harness uncertainty — how sibling view tests inject populated bloc state so two sessions land on different logical days — and direct the implementer to the established pattern in `workouts_view_test.dart` rather than leaving work undefined.

**Type consistency:** `estimatedOneRepMax` (double), `topEstimatedOneRepMaxSet` (WorkoutSet?), `bestEstimatedOneRepMax` (double), `ExerciseStrengthPoint`/`ExerciseStrengthSeries`, and `strengthProgress(TimeOfDay)` are used with identical names/signatures across Tasks 1–9. `ExerciseStrengthChart`, `ExerciseSparkline`, `ExerciseProgressDetailView`, `ExercisesLens`, `WorkoutDaysLens`, `ProgressView` names are consistent between their defining task and their consumers.
