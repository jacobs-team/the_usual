# Workout Logging Feature — Design

**Date:** 2026-06-23
**Status:** Approved for planning

## Summary

A workout logging feature that mirrors the existing meal logging feature in
structure, styling, and interaction. The user keeps a library of "usual
workouts" and logs them in a few taps, adjusting sets as needed. The core
difference from meals is the data shape: a workout is a named exercise with a
list of sets, each set carrying a weight and reps, instead of nutrition facts.

Everything reuses the existing design system and the established
bloc → state → UI patterns. Where meals use the fixed `MealOfTheDay` enum,
workouts use a user-configurable list of groups (Push / Pull / Legs by
default).

## Goals

- Log a usual workout in one tap, then adjust sets inline.
- Add a new workout through a sheet (name, sets, optional save-as-usual).
- Organize workouts into user-editable groups.
- Track per-set weight and reps; summarize by volume (sets × reps × weight).
- Estimate volume for bodyweight exercises using the user's body weight.
- Suggest exercise names from a photo of a gym machine.
- Remind the user to log on chosen days and times.
- Browse workout history by month, mirroring meal history.

## Non-goals (this spec)

- Cadence-style reminders (Apple-alarm style recurrence). Day-of-week + time
  only for now.
- Rest timers, supersets, RPE, tempo, or other advanced lifting metadata.
- AI estimation of sets/reps/weight for non-bodyweight exercises. Those are
  entered manually.

---

## Design parity with the meal feature

The workout feature must look and feel like a sibling of the meal feature, not
a new visual language. Every screen, widget, and interaction should match the
meal equivalent in design patterns, fonts, type scale, colors, spacing,
padding, radii, elevation, and motion. The whole point is that a user who
knows how to log a meal already knows how to log a workout.

This is a hard requirement that governs every section below, and it carries a
clear decision rule for anything this spec leaves unstated:

1. **Reuse the shared design system first.** Pull every token and component
   from `lib/design_system` and `lib/app/widgets` (for example
   `AppDesign.spacing`, `AppDesign.radius`, `SectionLabel`,
   `TheUsualTextField`, `GlassContainer`, `TheUsualBottomSheet`,
   `ExpandableNutrition` patterns). Do not introduce new colors, fonts, paddings,
   or one-off styles.
2. **When in doubt, mirror the meal feature.** For any styling or structural
   question not answered here, find the meal counterpart and match it exactly:
   the meal entry sheet for the workout entry sheet, `MealLogSection` for a
   workout group section, `LoggedEntryRow` / `ExpandableNutrition` for a logged
   workout row, the meal history layout for the workout history layout,
   `NutritionBar` for the volume summary bar. Copy the structure, swap only the
   data-specific fields.
3. **If no meal counterpart exists, ask.** Where the workout feature has no
   analog in the meal feature (for example group management, the bodyweight
   checkbox, or set rows), do not invent a style. Stop and ask the user for
   direction before building it.

During implementation and review, validate each workout screen against its
meal counterpart side by side and call out any divergence in tokens, type, or
spacing as a defect to fix, not a style choice.

---

## 1. Data models

New freezed models, following the same conventions as the meal models
(`@freezed`, `@JsonSerializable(explicitToJson: true)`, full-type variable
names per project rules).

### WorkoutSet

The building block, analogous to a single nutrition value being optional.

```dart
@freezed
abstract class WorkoutSet with _$WorkoutSet {
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutSet({
    double? weight,
    int? reps,
    @Default(false) bool weightAutoEstimated,
  }) = _WorkoutSet;

  const WorkoutSet._();

  /// Effective load for this set. Bodyweight sets carry an estimated weight
  /// once resolved; an unresolved or unestimated set contributes 0.
  double get volume => (weight ?? 0) * (reps ?? 0);
}
```

- `weight` is a `double` so plate increments like 2.5 work. Unit is the
  workout weight unit (see settings).
- `weightAutoEstimated` is provenance: `true` when `weight` came from the
  bodyweight estimate rather than a typed value. It exists so the UI can
  render estimates distinctly (grey, `~140 lb`) and so reopening a logged
  workout restores the "Bodyweight" checkbox and auto behavior. The estimated
  number is stored directly in `weight` so volume math and rendering never
  call AI.

### WorkoutLogEntry

Parallel to `MealLogEntry`. A single logged exercise on a given day.

```dart
@freezed
abstract class WorkoutLogEntry with _$WorkoutLogEntry {
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogEntry({
    required String id,                 // UUID v4
    required DateTime loggedAt,
    required String workoutGroupId,     // FK to WorkoutGroup
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
    String? usualWorkoutId,             // FK to UsualWorkout, nullable
  }) = _WorkoutLogEntry;

  const WorkoutLogEntry._();

  double get volume =>
      sets.fold(0, (total, workoutSet) => total + workoutSet.volume);
}
```

Entries reference their group by `workoutGroupId`, so renaming a group flows
through automatically without rewriting entries.

### UsualWorkout

Parallel to `UsualMeal`. A reusable template carrying a default set structure
so a tap logs something pre-filled and adjustable.

```dart
@freezed
abstract class UsualWorkout with _$UsualWorkout {
  @JsonSerializable(explicitToJson: true)
  const factory UsualWorkout({
    required String id,                 // UUID v4
    required String name,
    @Default(<WorkoutSet>[]) List<WorkoutSet> sets,
  }) = _UsualWorkout;
}
```

### WorkoutGroup

New, with no meal analog. Replaces the fixed `MealOfTheDay` enum because
groups are user-configurable.

```dart
@freezed
abstract class WorkoutGroup with _$WorkoutGroup {
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutGroup({
    required String id,                 // stable across renames
    required String name,
    required int order,
  }) = _WorkoutGroup;
}
```

Seeded defaults: Push, Pull, Legs (orders 0, 1, 2). The default groups use
stable const ids (`'push'`, `'pull'`, `'legs'`) so they can be expressed as a
const `@Default` list on the settings state; user-added groups get UUID ids.
The user can rename inline, add groups, reorder, and remove empty groups.
Renaming a default group keeps its const id, so logged entries stay linked.

---

## 2. State and persistence

### WorkoutLogBloc

New `HydratedBloc`, mirroring `DailyLogBloc`. Holds logged workouts; usuals and
groups live in settings (see below), the same split meals use.

State (`WorkoutLogState`):

```dart
@freezed
abstract class WorkoutLogState with _$WorkoutLogState {
  @JsonSerializable(explicitToJson: true)
  const factory WorkoutLogState({
    @Default(1) int version,
    @Default(<WorkoutLogEntry>[]) List<WorkoutLogEntry> workoutEntries,
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? justLoggedWorkoutId,
  }) = _WorkoutLogState;

  const WorkoutLogState._();

  // historyByMonth(TimeOfDay dayStart) -> List<WorkoutHistoryMonth>
  // entriesOn(DateTime day, TimeOfDay dayStart)
  // volumeOn(DateTime day, TimeOfDay dayStart)
}
```

Events (`WorkoutLogEvent`, freezed sealed union):

- `workoutLogged(workoutGroupId, name, sets, {usualWorkoutId, day, dayStart})`
- `workoutRemoved(id)`
- `workoutSetsChanged(id, sets)`
- `workoutUsualLinked(id, usualWorkoutId)`
- `stateRestored(state)` (cloud sync parity with meals)
- `sampleDataSeeded()` (dev only)

Versioned JSON from v1 using the project's documented migration pattern
(`fromJson` arrow-bodied, version routing in a delegated factory). Logical-day
handling reuses the existing `logicalDay(dayStart)` / `atDayStart(dayStart)`
extensions, identical to meals.

Registered `@lazySingleton` and wired into the hydrated bloc module, like
`DailyLogBloc`.

### UserSettingsBloc (extended)

Usual meals already live in `UserSettingsBloc`, so usual workouts, groups, the
workout reminder, and the workout weight unit join them rather than spawning a
second settings bloc. New state fields:

```dart
// Const list, valid because the seeded groups use const string ids.
@Default(<WorkoutGroup>[
  WorkoutGroup(id: 'push', name: 'Push', order: 0),
  WorkoutGroup(id: 'pull', name: 'Pull', order: 1),
  WorkoutGroup(id: 'legs', name: 'Legs', order: 2),
])
List<WorkoutGroup> workoutGroups,

@Default(<String, List<UsualWorkout>>{})
Map<String, List<UsualWorkout>> usualWorkouts,   // keyed by group id

@Default(WorkoutReminder(
  enabled: false,
  timeOfDay: TimeOfDay(hour: 18, minute: 0),
))
WorkoutReminder workoutReminder,

/// Defaults to [weightUnit] on first read via migration; falls back to lb.
@Default(WeightUnit.lb) WeightUnit workoutWeightUnit,
```

New events (mirroring the `usualMeal*` family):

- `workoutGroupAdded(name)`
- `workoutGroupRenamed(id, name)`
- `workoutGroupRemoved(id)` — no-op (or surfaced error) when the group still
  has usuals or logged entries (see Decision A)
- `workoutGroupReordered(orderedIds)`
- `usualWorkoutAdded(workoutGroupId, name, sets)`
- `usualWorkoutRenamed(workoutGroupId, id, name)`
- `usualWorkoutSetsChanged(workoutGroupId, id, sets)`
- `usualWorkoutRemoved(workoutGroupId, id)`
- `workoutWeightUnitSelected(weightUnit)`
- `workoutReminderChanged(...)` (enabled, days, time)

Adding fields with defaults reads old stored JSON cleanly. Bump
`UserSettingsState` to the next version and, in the migration, default
`workoutWeightUnit` to the existing `weightUnit` so a returning user inherits
their body-weight unit.

### Resolved body weight

A getter resolves the user's current body weight in priority order:

1. Latest weight log (`DailyLogBloc.state.latestWeight`), most current.
2. `UserSettingsState.startingWeight` (which onboarding already populates).

Returns null when neither exists. This value, paired with
`workoutWeightUnit`, gates and feeds bodyweight estimation. Note the weight
log and the workout weight unit may differ in unit; convert when estimating.

---

## 3. Navigation restructure

Bottom navigation changes from **Today / History** to **Today / Workouts**.
History stops being a bottom tab and becomes an app bar action (history icon or charts icon)
on both the Today view and the Workouts view.

- `StatefulShellRoute` branches become Today (branch 0) and Workouts
  (branch 1).
- `AppRouter.destinations` becomes Today and Workouts.
- Routes: keep `/today`, add `/workouts`. Meal history (`/history`) and workout
  history (`/workouts/history`) become standalone routes pushed from their
  respective app bar icons rather than shell branches.

The existing meal `HistoryView` widget is not modified. Only its entry point
changes: it moves from a bottom-tab branch to a route pushed from the Today app
bar's history icon. `NavigationWrapper` is unchanged structurally; it just
renders the new destinations.

---

## 4. Workouts day view

`WorkoutsView`, parallel to `TodayView`.

- App bar (`TheUsualAppBar`): date pill that opens the date picker, a history
  icon action, and the existing settings affordance.
- A volume summary bar at the top, the analog of `NutritionBar`: today's total
  volume across all groups.
- One section per `WorkoutGroup`, ordered by `order`. Each section is the
  workout analog of `MealLogSection`:
  - Logged `WorkoutLogEntry` rows for that group.
  - Group volume in the section header (analog of per-meal nutrition summary).
  - Dashed quick-pick chips for usual workouts in that group not yet logged
    today; tapping logs instantly with the usual's set template and opens the
    row expanded for adjustment.
  - A "New workout" button opening the entry sheet for that group.
  - The group name is editable inline in the header.
- An "Add group" affordance at the bottom of the list creates a new group.

Reuses `DecoratedSliver`, `SectionLabel`, dashed-border quick picks, and the
current-section highlight pattern from meals where it makes sense.

---

## 5. Workout entry sheet and logged row

### Entry sheet

Parallel to `FoodEntrySheet` / `FoodEntryForm`, opened via
`TheUsualBottomSheet.show`. Contents:

- A name field with a camera button beside it. Snapping a machine calls Claude
  and returns candidate exercise names as tappable chips below the field;
  tapping a chip fills the name. (See section 6.), ask the user and ideate about how we can allow the user to enter multiple rows of data with these chips.
- A "Bodyweight" checkbox at the exercise level. When checked, the set weight
  fields switch to a greyed `auto` estimate that the user can still tap to
  override per set. The checkbox is disabled when no body weight is on record;
  tapping the disabled checkbox shows: "Add your body weight to estimate
  bodyweight sets. Log it on the Today view or set a starting weight in
  Settings." An info icon carries a tooltip explaining estimation.
- A list of per-set rows, each `[weight] × [reps]`, with an "Add set" button.
- A "Save as a usual" checkbox. When checked, the workout is added to the
  group's usuals via `UserSettingsBloc` in addition to being logged.
- A confirm ("Log") button, disabled until there's a name and at least one set.

On confirm, any set left on auto is resolved once via the bodyweight estimate
(section 6) before the `workoutLogged` event is dispatched.

### Logged row

Parallel to `ExpandableNutrition`.

- Collapsed: name plus a set summary, for example
  "3 sets · 135×8, 145×6, 155×5". Bodyweight estimates render with a `~`.
- Expanded: editable per-set rows with add/remove, the bodyweight state, and a
  delete button.
- Edits fire `workoutSetsChanged` immediately. A just-logged entry opens
  expanded (driven by `justLoggedWorkoutId`), same as meals.

Reuses `TheUsualTextField` (dense, numeric) and a stepper-style control where
it fits.

---

## 6. AI features

Both reuse the existing `MealAiClient` (Genkit + Anthropic, `claude-sonnet-4-6`,
temperature 0) and are gated on `isConfigured`, disappearing cleanly when no
API key is set. A new `WorkoutAiRepository` owns the prompts and schemas, and a
new `WorkoutEntryBloc` owns the entry form state (name, sets, photo, the
name-suggestion request status, the bodyweight resolve status).

### Machine-photo name suggestions

```dart
Future<List<String>> suggestNamesFromPhoto(List<MealPhoto> photos);
```

Prompt: given a photo of a gym machine, return a short list of likely exercise
names performable on it, shortest clear names, constrained to a JSON string
array schema. Reuses `pickMealPhotos` and the downscaling already in place.

### Bodyweight load estimation

```dart
Future<double?> estimateBodyweightLoad({
  required String exerciseName,
  required double bodyWeight,
  required WeightUnit unit,
});
```

Prompt: estimate the effective weight lifted per rep of `exerciseName` by a
person of the given body weight, returning a single number in the given unit
(for example, a push-up at 200 lb body weight resolves near 140 lb). Resolved
once at log time per auto set and stored in `WorkoutSet.weight` with
`weightAutoEstimated: true`. Volume scales with reps automatically, so editing
reps needs no re-estimation. If AI is unavailable, auto sets keep
`weight: null` and contribute 0 volume; the bodyweight checkbox is already
gated on a body weight existing, so this path is rare.

---

## 7. Reminders

New `WorkoutReminder` model:

```dart
@freezed
abstract class WorkoutReminder with _$WorkoutReminder {
  const factory WorkoutReminder({
    @Default(false) bool enabled,
    @Default(<int>{}) Set<int> daysOfWeek,   // 1 = Monday … 7 = Sunday
    @TimeOfDayConverter() required TimeOfDay timeOfDay,
  }) = _WorkoutReminder;
}
```

Configured in a workout section in settings: toggle on, pick which days, pick a
time. Copy along the lines of "Did you work out today? Tap to log it."
Scheduled through the existing `NotificationService`. Cadence-style recurrence
is out of scope here and noted for later.

---

## 8. History

`WorkoutHistoryView`, parallel to `HistoryView`, reached from the Workouts app
bar history icon.

- Month selector strip and per-month paged list, reusing the meal history
  layout.
- Day cards listing that day's workouts grouped by `WorkoutGroup`, with the
  day's total volume.
- A trends chart showing volume over time, the volume analog of the calorie
  bars (a `WorkoutMonthTrendsChart` modeled on `MonthTrendsChart`).

Data comes from a `historyByMonth(dayStart)` getter on `WorkoutLogState`,
mirroring the meal `historyByMonth` and its `HistoryMonth` / `HistoryDay`
typedefs (as `WorkoutHistoryMonth` / `WorkoutHistoryDay`).

---

## Resolved decisions

- **Naming.** `WorkoutLogEntry` (mirrors `MealLogEntry`), `UsualWorkout`
  (mirrors `UsualMeal`), plus `WorkoutGroup` and `WorkoutSet`.
- **A. Deleting a non-empty group is blocked.** A group with usuals or logged
  entries cannot be removed; the user must clear it first.
- **B. Workout weight unit is its own setting** (`workoutWeightUnit`),
  defaulting to the body-weight tracking `weightUnit` via migration.
- **C. Bodyweight volume is estimated** via AI, opt-in through the
  exercise-level "Bodyweight" checkbox, which only unlocks once a body weight
  is on record (weight log first, then settings starting weight). The estimate
  is a snapshot stored in `WorkoutSet.weight`, flagged by `weightAutoEstimated`.

---

## Build phasing

Suggested implementation order, each independently shippable:

1. **Data + state.** Models, `WorkoutLogBloc`, `UserSettingsBloc` extensions,
   migrations, DI wiring, seeded default groups.
2. **Nav restructure.** Today / Workouts tabs, history moved to app bar
   actions.
3. **Day view + logging.** `WorkoutsView`, sections, quick picks, entry sheet,
   logged rows, volume summary. Manual weights only.
4. **Groups management.** Inline rename, add, reorder, blocked delete.
5. **Bodyweight estimation + machine photo.** `WorkoutAiRepository`,
   `WorkoutEntryBloc` AI paths, the checkbox gating.
6. **Reminders.** `WorkoutReminder`, settings section, scheduling.
7. **History.** `WorkoutHistoryView` and the volume trends chart.
