# Workout Feature — Phase 7: History & Volume Chart Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Checkbox (`- [ ]`) steps.

**Goal:** A workout history screen mirroring the meal history — month selector, per-day cards listing that day's workouts by group with the day's volume, and a volume trends chart — reached from the Workouts tab's app-bar history action.

**Architecture:** Add `historyByMonth` + `WorkoutHistoryDay`/`WorkoutHistoryMonth` typedefs to `WorkoutLogState` (mirror `DailyLogState.historyByMonth`, dropping weight). A `WorkoutVolumeChart` simplifies `MonthTrendsChart` to single per-day volume bars + an average line. `WorkoutHistoryView` mirrors `HistoryView` without the weight section. `/workouts/history` is a top-level pushed route (parity with `/history`), wired to the Workouts app bar's `historyRoute`.

**Tech Stack:** Flutter, flutter_bloc, get_it, scrollable_positioned_list, CustomPainter.

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, section 8.
- **Design parity:** mirror `lib/app/feature/history/view/history_view.dart` and `month_trends_chart.dart` structure/tokens. Reuse `SectionLabel`, `TheUsualAppBar`, `Card`/`ExpansionTile`, `LoggedWorkoutRow`, the month-selector pattern. No new colors/fonts. Workouts have NO weigh-in, so drop the weight line/section/weigh-in entirely.
- **Do NOT modify the meal `HistoryView`** or `MonthTrendsChart`; build separate workout widgets.
- **Out of scope:** a workout sample-data seeder (history renders from real logged workouts — YAGNI); a per-group "add to a past day" affordance in history (the Workouts day view's date pill already logs to past days). Note these as deferred.
- `/workouts/history` is a TOP-LEVEL route (sibling of `/history`), pushed over the shell with a back button — NOT nested inside the shell branch (matches meal history behavior).
- Naming: full model-type variable names. Widgets read blocs via `getIt<T>()`. Never run the app. `fvm flutter`/`fvm dart` only; one-shot build permitted if the watcher lags (this run only). Do NOT commit (controller commits). Full TDD; tests locate by type/key/icon, mock `WorkoutLogBloc`/`UserSettingsBloc` with seeded `historyByMonth` fixtures, no display-string asserts. Run with `--test-randomize-ordering-seed random`.

---

### Task 1: historyByMonth + typedefs on WorkoutLogState

**Files:**
- Modify: `lib/app/feature/workout/bloc/workout_log_state.dart`
- Modify: `test/app/feature/workout/bloc/workout_log_bloc_test.dart`

**Interfaces produced** (in `workout_log_state.dart`, top-level, mirroring the meal typedefs):
```dart
typedef WorkoutHistoryDay = ({
  DateTime day,
  double volume,
  List<WorkoutLogEntry> workoutEntries,
});

typedef WorkoutHistoryMonth = ({
  DateTime month,
  double averageVolume,
  List<WorkoutHistoryDay> days,   // newest day first
});
```
and a method on `WorkoutLogState`:
```dart
List<WorkoutHistoryMonth> historyByMonth(TimeOfDay dayStart);
```

**Behavior (mirror `DailyLogState.historyByMonth`):** bucket `workoutEntries` by `loggedAt.logicalDay(dayStart)`; each `WorkoutHistoryDay` has `volume: dayEntries.totalVolume` (the Phase 3 list extension) and its entries; group days into months (oldest month first, days newest-first within); `averageVolume = (sum of day volumes) / days.length`.

**Tests** (add a `historyByMonth` group to the existing `WorkoutLogState` tests): (1) empty when nothing logged; (2) rolls entries up by month with per-day volume and month average — e.g. two entries on the same day in May and one in June produce two months, May's day volume = sum of its entries, June average = its single day's volume; oldest month first.

- [ ] **Step 1-5:** TDD cycle (failing tests → run fail → implement → run pass with random seed → report). Touches a freezed `part` file but adds only typedefs + a method (no new fields), so no schema/codegen change is required. Commit: `feat(workout): add historyByMonth to WorkoutLogState`.

---

### Task 2: WorkoutVolumeChart

A simplified `MonthTrendsChart`: one bar per day sized by that day's total volume, a solid average reference line, and tap-to-scroll-to-day. Read `lib/app/feature/history/widgets/month_trends_chart.dart` (the `_CalorieBars` widget + `_CalorieBarsPainter` + the tap `GestureDetector`) and adapt: single-color bars (NO macro stacking), NO weight line, NO goal line.

**Files:**
- Create: `lib/app/feature/workout/widgets/workout_volume_chart.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart`
- Create: `test/app/feature/workout/widgets/workout_volume_chart_test.dart`

**Interface produced:**
```dart
class WorkoutVolumeChart extends StatelessWidget {
  const WorkoutVolumeChart({
    required this.monthHistory,            // WorkoutHistoryMonth
    required this.weightUnit,              // WeightUnit (axis/label unit)
    required this.onDayTapped,             // ValueChanged<WorkoutHistoryDay>
    super.key,
  });
}
```

**Behavior:**
- A titled container matching `MonthTrendsChart`'s card styling (`colorScheme.primary` navy card, padding/radius tokens). A short label like "VOLUME" (`SectionLabel`-style spaced caps) and the unit.
- A `CustomPaint` (height ~84 like the meal chart) drawing one bar per `monthHistory.days` (chart expects oldest-first along the x-axis — reverse `days` since they're stored newest-first, matching how the meal chart orders days oldest-first). Bar height ∝ `day.volume` over the max day volume (or the average-scaled axis like the meal chart). Single fill color (`colorScheme.inversePrimary`). A solid average line at `monthHistory.averageVolume`. Use the same `_barGap` (3) and bar-rect/rounded-top approach.
- Wrap in a `GestureDetector` (`HitTestBehavior.opaque`) computing the tapped day index from `localPosition.dx` (mirror the meal chart's tap math) and calling `onDayTapped(day)`.
- Render nothing (or an empty `SizedBox`) when there are fewer than 2 days with volume (mirror the meal chart's "needs ≥2 days" guard), so an empty/sparse month doesn't draw a degenerate chart.

**Tests** (`workout_volume_chart_test.dart`, mirror `month_trends_chart_test.dart` with workout fixtures — build helper `WorkoutHistoryDay`/`WorkoutHistoryMonth` records): (1) renders a `CustomPaint`/`GestureDetector` for a month with ≥2 days of volume; (2) tapping the chart calls `onDayTapped` with a day; (3) renders nothing for a month with <2 volume days.

- [ ] **Step 1-5:** TDD cycle. Export from the feature widgets barrel. Commit: `feat(workout): add WorkoutVolumeChart`.

---

### Task 3: WorkoutHistoryView + route + Workouts app-bar wiring

Mirror `lib/app/feature/history/view/history_view.dart`, dropping all weight/weigh-in UI. Read it first.

**Files:**
- Create: `lib/app/feature/workout/view/workout_history_view.dart`
- Modify: `lib/app/feature/workout/view/view.dart` (barrel)
- Modify: `lib/app/navigation/routes.dart` (add `workoutHistory`)
- Modify: `lib/app/navigation/app_router.dart` (add the top-level route)
- Modify: `lib/app/feature/workout/view/workouts_view.dart` (set `historyRoute`)
- Create: `test/app/feature/workout/view/workout_history_view_test.dart`

**Behavior (mirror HistoryView):**
- `Scaffold` + `TheUsualAppBar(title: 'History')` (no `historyRoute` on this screen). A `BlocBuilder<WorkoutLogBloc, WorkoutLogState>`; `history = state.historyByMonth(dayStart)` where `dayStart = getIt<UserSettingsBloc>().state.dayStartTime`.
- Empty state: a centered message when `history.isEmpty`.
- A month-selector strip (mirror `_MonthSelector` but WITHOUT the latest-weigh-in subtitle — just the month abbreviation chip) + a `PageView` of months, each a `ScrollablePositionedList` whose first item is the `WorkoutVolumeChart` (wired `onDayTapped` to scroll+expand that day, mirror HistoryView's `scrollToDay`) + a month `SectionLabel`, then one `_WorkoutHistoryDayCard` per day.
- `_WorkoutHistoryDayCard` (private in the view file): a `Card`/`ExpansionTile` titled with the formatted date; subtitle shows the day's volume (`'${historyDay.volume.trimmedDecimal} ${weightUnit.name}'`); expanded shows the day's workouts grouped by `WorkoutGroup` (read groups + order from `getIt<UserSettingsBloc>().state.workoutGroups`), each group with a `SectionLabel(group.name)` and its `LoggedWorkoutRow`s (`expandedByDefault: false`, `weightUnit:` from `workoutWeightUnit`). Workouts whose `workoutGroupId` matches no current group fall under a trailing "Other" label (so deleted-group history still shows). No "add to past day" button.
- Route: add `static const String workoutHistory = '/workouts/history';` to `routes.dart`; add a top-level `GoRoute(path: Routes.workoutHistory, pageBuilder: (_, __) => const NoTransitionPage(child: WorkoutHistoryView()))` as a sibling of the `/history` route in `app_router.dart`. In `workouts_view.dart`, set the app bar `historyRoute: Routes.workoutHistory`.

**Tests** (`workout_history_view_test.dart`, mirror `history_view_test.dart`): mock `WorkoutLogBloc` with seeded entries across two months and a `UserSettingsBloc` with default groups. (1) empty state renders when no entries; (2) with entries, `find.byType(WorkoutVolumeChart)` is present and `LoggedWorkoutRow` is initially absent (collapsed); (3) tapping the chart scrolls to and expands a day so `LoggedWorkoutRow` appears (mirror the meal "tap a bar" test, tapping the chart's `GestureDetector`). Use a tall test window like the meal history test.

- [ ] **Step 1:** Write the failing view tests (+ add `WorkoutHistoryView` to the barrel so they resolve). **Step 2:** run them (FAIL). **Step 3:** implement the view, route, and app-bar wiring. **Step 4:** run the view test, then the FULL suite (`fvm flutter test --test-randomize-ordering-seed random`); fix fallout (e.g. the Workouts app bar now has a history action — any WorkoutsView test asserting no history icon must update). **Step 5:** report. Commit: `feat(workout): add WorkoutHistoryView reached from the Workouts app bar`.

---

## Self-Review

**Spec coverage (section 8):** month-grouped day cards listing a day's workouts by group + day volume (Task 3); a volume trends chart, the analog of the calorie bars (Task 2); `historyByMonth` data source (Task 1); reached from the Workouts app-bar history action (Task 3). ✓

**Deferred (noted):** workout sample-data seeder (YAGNI — real logged data renders); "add to a past day" affordance in history (date pill on the day view covers it).

**Placeholder scan:** concrete typedefs/behavior + tests for Task 1; precise interfaces, mirror references, and concrete tests for Tasks 2-3. No "TBD".

**Type consistency:** `historyByMonth` returns `List<WorkoutHistoryMonth>`; `WorkoutHistoryDay.volume` is `double` (from `List<WorkoutLogEntry>.totalVolume`); `WorkoutVolumeChart` consumes a `WorkoutHistoryMonth` and emits `WorkoutHistoryDay` via `onDayTapped`; `weightUnit` is `workoutWeightUnit`; `Routes.workoutHistory` is pushed by the Workouts app bar's `historyRoute` (a `String?`).
