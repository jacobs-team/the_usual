# Workout Feature — Phase 3: Day View & Logging Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Build the Workouts day view: a volume summary, one section per workout group with logged-workout rows and usual-workout quick picks, and a "New workout" entry sheet. Manual weights only (bodyweight estimation and the machine-photo feature are Phase 5; group editing is Phase 4).

**Architecture:** Mirror the meal day-view widget-for-widget, swapping the data model (sets of weight×reps instead of nutrition). New widgets are built bottom-up: set inputs → logged-row display → entry sheet → section → view. State reads come from `WorkoutLogBloc` (logged) and `UserSettingsBloc` (groups, usual workouts, weight unit, day start), via `BlocSelector`.

**Tech Stack:** Flutter, flutter_bloc, get_it, freezed models from Phase 1.

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, section 4-5.
- **Design parity (hard requirement):** every workout widget must match its meal counterpart in layout, tokens, spacing, radii, and interaction. Reuse `AppDesign.spacing/radius`, `SectionLabel`, `TheUsualTextField`, `DecoratedSliver`, `TheUsualBottomSheet`, `QuantityStepper`-style controls. Introduce NO new colors, fonts, or one-off styles. When a detail is unspecified, mirror the named meal file. The reference file for each task is named in the task; read it and follow its structure.
- **Out of scope this phase (do NOT build):** bodyweight checkbox / AI estimation / machine photo (Phase 5); inline group rename / add-group / "from another group" (Phase 4); workout history (Phase 7). Sections show read-only group names.
- Naming: variables named after their full model type (`workoutLogEntry`, `usualWorkout`, `workoutGroup`, `workoutSet`).
- Never run the app. Use `fvm flutter`/`fvm dart`, never bare. A `build_runner watch` is running but may lag; if generated output is stale after ~30s, a one-shot `fvm dart run build_runner build --delete-conflicting-outputs` is permitted (this automated run only).
- Barrels: import via `package:the_usual/app/app.dart`; export new widgets through their barrels (`lib/app/widgets/widgets.dart` for shared widgets, `lib/app/feature/workout/widgets/widgets.dart` for feature widgets — create the latter and export it from `workout.dart`).
- Do NOT commit (the controller commits per task). Leave changes in the working tree.
- Testing: full TDD, test first. Widget tests via `pumpPumpPumpItUP` (`test/helpers/pump_app.dart`); pass mocked blocs through `deps:` and verify dispatched events with `verify(() => bloc.add(...)).called(1)`. Locate widgets by type/key/icon, never by display string. Run with `--test-randomize-ordering-seed random`. The weight unit shown in inputs comes from `UserSettingsState.workoutWeightUnit`.

---

### Task 1: Workout set/volume formatting extensions

Pure model-level getters used by the row, section, and summary widgets. Mirrors `lib/app/model/extensions/meal_log_entry_list_extensions.dart`.

**Files:**
- Create: `lib/app/model/extensions/workout_set_list_extensions.dart`
- Modify: `lib/app/model/extensions/extensions.dart`
- Create: `test/app/model/extensions/workout_set_list_extensions_test.dart`

**Interfaces produced:**
- `extension WorkoutSetFormatting on WorkoutSet { String get label; }` — `"135×8"`; a null weight or reps shows `"—"`.
- `extension WorkoutSetListFormatting on List<WorkoutSet> { double get totalVolume; String get summary; }` — summary `"3 sets · 135×8, 145×6"`, empty → `"No sets"`.
- `extension WorkoutLogEntryListFormatting on List<WorkoutLogEntry> { double get totalVolume; }`

- [ ] **Step 1: Write the failing test**

Create `test/app/model/extensions/workout_set_list_extensions_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('WorkoutSetFormatting', () {
    test('label is weight×reps', () {
      expect(const WorkoutSet(weight: 135, reps: 8).label, equals('135×8'));
    });

    test('label trims a whole-number weight and shows — for missing values', () {
      expect(const WorkoutSet(weight: 142.5, reps: 6).label, equals('142.5×6'));
      expect(const WorkoutSet(reps: 8).label, equals('—×8'));
      expect(const WorkoutSet(weight: 100).label, equals('100×—'));
    });
  });

  group('WorkoutSetListFormatting', () {
    test('totalVolume sums set volumes', () {
      const sets = [WorkoutSet(weight: 135, reps: 8), WorkoutSet(weight: 145, reps: 6)];
      expect(sets.totalVolume, equals(1950.0));
    });

    test('summary lists count and each set', () {
      const sets = [WorkoutSet(weight: 135, reps: 8), WorkoutSet(weight: 145, reps: 6)];
      expect(sets.summary, equals('2 sets · 135×8, 145×6'));
    });

    test('summary uses singular for one set and a fallback when empty', () {
      expect(const [WorkoutSet(weight: 100, reps: 5)].summary, equals('1 set · 100×5'));
      expect(const <WorkoutSet>[].summary, equals('No sets'));
    });
  });

  group('WorkoutLogEntryListFormatting', () {
    test('totalVolume sums entry volumes', () {
      final entries = [
        WorkoutLogEntry(
          id: 'a',
          loggedAt: DateTime(2026, 6, 23),
          workoutGroupId: 'push',
          name: 'Bench',
          sets: const [WorkoutSet(weight: 100, reps: 10)], // 1000
        ),
        WorkoutLogEntry(
          id: 'b',
          loggedAt: DateTime(2026, 6, 23),
          workoutGroupId: 'push',
          name: 'OHP',
          sets: const [WorkoutSet(weight: 50, reps: 10)], // 500
        ),
      ];
      expect(entries.totalVolume, equals(1500.0));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/model/extensions/workout_set_list_extensions_test.dart`
Expected: FAIL — extensions undefined.

- [ ] **Step 3: Implement the extensions**

Create `lib/app/model/extensions/workout_set_list_extensions.dart`:

```dart
import 'package:the_usual/app/core/extensions/extensions.dart';
import 'package:the_usual/app/model/model.dart';

/// Display formatting for a single set.
extension WorkoutSetFormatting on WorkoutSet {
  /// A short "weight×reps" label, e.g. "135×8". A missing value reads "—".
  String get label {
    final weightLabel = weight == null ? '—' : weight!.trimmedDecimal;
    final repsLabel = reps?.toString() ?? '—';
    return '$weightLabel×$repsLabel';
  }
}

/// Aggregation and display formatting across a list of sets.
extension WorkoutSetListFormatting on List<WorkoutSet> {
  /// Total volume across these sets.
  double get totalVolume =>
      fold<double>(0, (total, workoutSet) => total + workoutSet.volume);

  /// A one-line summary, e.g. "3 sets · 135×8, 145×6". Empty reads "No sets".
  String get summary {
    if (isEmpty) return 'No sets';
    final unit = length == 1 ? 'set' : 'sets';
    final labels = map((workoutSet) => workoutSet.label).join(', ');
    return '$length $unit · $labels';
  }
}

/// Aggregation across a list of logged workouts.
extension WorkoutLogEntryListFormatting on List<WorkoutLogEntry> {
  /// Total volume across these logged workouts.
  double get totalVolume => fold<double>(
    0,
    (total, workoutLogEntry) => total + workoutLogEntry.volume,
  );
}
```

In `lib/app/model/extensions/extensions.dart`, add:

```dart
export 'workout_set_list_extensions.dart';
```

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/model/extensions/workout_set_list_extensions_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 5: Report.** Suggested commit: `feat(workout): add set/volume formatting extensions`.

---

### Task 2: SetFields input widget

A reusable editor for a list of sets: one row per set (weight field × reps field + remove), and an "Add set" button. Emits the full `List<WorkoutSet>` on every change. This is the workout analog of `NutritionFields` (`lib/app/widgets/inputs/nutrition_fields.dart`); the decimal weight field mirrors the formatter in `lib/app/widgets/inputs/weight_entry_field.dart`. Read both before implementing.

**Files:**
- Create: `lib/app/widgets/inputs/set_fields.dart`
- Modify: `lib/app/widgets/widgets.dart`
- Create: `test/app/widgets/set_fields_test.dart`

**Interface produced:**
```dart
class SetFields extends StatefulWidget {
  const SetFields({
    required this.initial,                       // List<WorkoutSet>
    required this.onChanged,                      // ValueChanged<List<WorkoutSet>>
    required this.weightUnit,                     // WeightUnit (for the suffix)
    this.dense = false,
    super.key,
  });
}
```

**Behavior:**
- Renders one row per set in `initial`. Each row: a weight `TheUsualTextField` (decimal, `inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}\.?\d{0,1}'))]`, `keyboardType: const TextInputType.numberWithOptions(decimal: true)`, `suffixText: ' ${weightUnit.name}'`, dense), a "×" separator, a reps `TheUsualTextField` (or `MacroField(unit: 'reps')` style; digits-only, maxDigits 3), and a remove `IconButton(Icons.close)` (enabled only when more than one row).
- An "Add set" `TextButton.icon(Icons.add, 'Add set')` appends a new empty `WorkoutSet`. A new appended set should copy the previous set's weight (lifters repeat weight across sets) but leave reps as-is from the previous set too; if there is no previous set, append `const WorkoutSet()`.
- Parse on each keystroke: weight via `double.tryParse`, reps via `int.tryParse`; rebuild the `List<WorkoutSet>` (preserving each row's `weightAutoEstimated` as `false` this phase) and call `onChanged`.
- Manage one pair of controllers per row; dispose them. Mirror `NutritionFields`' controller lifecycle.

**Tests** (`test/app/widgets/set_fields_test.dart`): use `pumpPumpPumpItUP`. Cover:
1. renders one row per initial set (find weight fields by a `Key('set-weight-$index')` you assign; assert count).
2. typing a weight and reps emits an updated `List<WorkoutSet>` via `onChanged` (capture the last emitted value in the test).
3. "Add set" (tap `find.byIcon(Icons.add)`) emits a list with one more set.
4. the remove icon on a row emits a list with one fewer set, and is absent when only one row remains.

Write concrete tests with a capturing callback, e.g.:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';
import '../../helpers/helpers.dart';

void main() {
  group(SetFields, () {
    testWidgets('emits an added set when Add set is tapped', (tester) async {
      List<WorkoutSet>? emitted;
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [WorkoutSet(weight: 135, reps: 8)],
          weightUnit: WeightUnit.lb,
          onChanged: (sets) => emitted = sets,
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(emitted, isNotNull);
      expect(emitted, hasLength(2));
    });

    testWidgets('removes a row and hides remove when one remains', (tester) async {
      List<WorkoutSet>? emitted;
      await tester.pumpPumpPumpItUP(
        SetFields(
          initial: const [WorkoutSet(weight: 135, reps: 8), WorkoutSet(weight: 145, reps: 6)],
          weightUnit: WeightUnit.lb,
          onChanged: (sets) => emitted = sets,
        ),
      );

      expect(find.byIcon(Icons.close), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();
      expect(emitted, hasLength(1));
      await tester.pump();
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });
}
```

Add a `'set-weight-$index'` / `'set-reps-$index'` Key to each field and a test that typing emits parsed values. Implement, export from `widgets.dart`, and make all tests pass with `--test-randomize-ordering-seed random`.

- [ ] **Step 1:** Write the failing tests (above + a typing-emits-parsed-values test).
- [ ] **Step 2:** Run `fvm flutter test test/app/widgets/set_fields_test.dart` — expect FAIL (undefined).
- [ ] **Step 3:** Implement `SetFields` mirroring `NutritionFields`' controller lifecycle and the decimal weight formatter from `weight_entry_field.dart`. Export from `lib/app/widgets/widgets.dart` under the `inputs/` group.
- [ ] **Step 4:** Run the test with random seed — expect PASS.
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): add SetFields input widget`.

---

### Task 3: ExpandableWorkout display widget

A collapsed/expandable logged-workout row. Mirror `lib/app/widgets/display/expandable_nutrition.dart` exactly, swapping nutrition→sets and `NutritionFields`→`SetFields`, and dropping the quantity controls. Read the reference file first.

**Files:**
- Create: `lib/app/widgets/display/expandable_workout.dart`
- Modify: `lib/app/widgets/widgets.dart`
- Create: `test/app/widgets/expandable_workout_test.dart`

**Interface produced:**
```dart
class ExpandableWorkout extends StatefulWidget {
  const ExpandableWorkout({
    required this.name,
    required this.sets,                  // List<WorkoutSet>
    required this.weightUnit,            // WeightUnit
    required this.expandedByDefault,
    required this.onChanged,             // ValueChanged<List<WorkoutSet>>
    required this.onRemoved,             // VoidCallback
    this.onNameChanged,                  // ValueChanged<String>?
    this.expandedFooter,                 // Widget?
    super.key,
  });
}
```

**Behavior (mirror ExpandableNutrition):**
- Collapsed: leading name (read-only `Text(name)` when `onNameChanged == null`, else an editable `TheUsualTextField` synced to `name`), and when collapsed a trailing `Text(sets.summary)` (use the Task 1 getter; style with the ambient text theme, do not accept a style param). Trailing delete `IconButton(Icons.delete_forever_outlined)` calling `onRemoved`.
- Expanded (`ExpansionTile`, `controlAffinity: ListTileControlAffinity.leading`): a `SectionLabel('SETS')`, then `SetFields(initial: sets, weightUnit: weightUnit, onChanged: onChanged, dense: true)`, then `if (expandedFooter != null) expandedFooter!`.
- Same `expandedByDefault` auto-expand/collapse and `name`-sync behavior as `ExpandableNutrition` (copy that state logic verbatim, adapting field names).

**Tests** (`test/app/widgets/expandable_workout_test.dart`): cover (1) collapsed shows the sets summary text via the summary getter (assert a `Text` whose data equals `sets.summary` — this asserts the getter's output, acceptable since it's derived, not a UI copy string); (2) tapping delete calls `onRemoved`; (3) when `expandedByDefault` is true, `SetFields` is shown (`find.byType(SetFields)` findsOneWidget); (4) editing in `SetFields` propagates through `onChanged`. Write concrete tests mirroring `expandable_nutrition_test.dart`.

- [ ] **Step 1-5:** Standard TDD cycle (failing tests → run fail → implement mirroring ExpandableNutrition → export from `widgets.dart` → run pass with random seed → report). Suggested commit: `feat(workout): add ExpandableWorkout row widget`.

---

### Task 4: WorkoutEntrySheet

The "New workout" bottom sheet: name + sets + optional save-as-usual, returning a result. Mirror `lib/app/widgets/inputs/food_entry_sheet.dart` (its sheet chrome via `TheUsualBottomSheet` and confirm/disable logic), but for a single exercise (no multi-item add, no AI, no meal selector). Read the reference first.

**Files:**
- Create: `lib/app/widgets/inputs/workout_entry_sheet.dart`
- Modify: `lib/app/widgets/widgets.dart`
- Create: `test/app/widgets/workout_entry_sheet_test.dart`

**Interface produced:**
```dart
typedef WorkoutEntryResult = ({String name, List<WorkoutSet> sets, bool addToUsuals});

class WorkoutEntrySheet extends StatefulWidget {
  const WorkoutEntrySheet({
    required this.title,
    required this.confirmLabel,
    required this.weightUnit,
    this.showAddToUsuals = false,
    this.initialName,
    this.initialSets,            // defaults to a single empty set
    super.key,
  });
}
```

**Behavior:**
- Returns a `TheUsualBottomSheet(title: title, child: Column(...))` (mirror FoodEntrySheet's use of the sheet chrome).
- Body: a name `TheUsualTextField` (autofocus, hint like 'e.g. Bench Press'); a `SectionLabel('SETS')` + `SetFields` seeded with `initialSets ?? const [WorkoutSet()]`; an optional "Save as usual" `Checkbox` row when `showAddToUsuals`; a confirm `FilledButton(confirmLabel)` disabled until the name is non-empty.
- On confirm: `Navigator.of(context).pop((name: name.trim(), sets: currentSets, addToUsuals: saveAsUsual))`.

**Tests** (`test/app/widgets/workout_entry_sheet_test.dart`): (1) confirm button disabled until a name is entered (find the `FilledButton`, check `onPressed == null` then non-null after entering text); (2) confirming pops with a `WorkoutEntryResult` carrying the typed name and the sets (pump it inside a host that captures the pop result via `Navigator.push` then reads the returned future, mirroring `food_entry_sheet_test.dart`'s pop-shape tests); (3) the save-as-usual checkbox appears only when `showAddToUsuals` is true.

- [ ] **Step 1-5:** Standard TDD cycle, mirroring `food_entry_sheet_test.dart` for the pop-shape test harness. Export from `widgets.dart`. Suggested commit: `feat(workout): add WorkoutEntrySheet`.

---

### Task 5: VolumeBar

A compact day-volume summary, the analog of `NutritionBar` but without a goal (just the total). Read `lib/app/feature/today/widgets/nutrition_bar.dart` for the container styling to match.

**Files:**
- Create: `lib/app/feature/workout/widgets/volume_bar.dart`
- Create: `lib/app/feature/workout/widgets/widgets.dart`
- Modify: `lib/app/feature/workout/workout.dart`
- Create: `test/app/feature/workout/widgets/volume_bar_test.dart`

**Interface produced:**
```dart
class VolumeBar extends StatelessWidget {
  const VolumeBar({required this.volume, required this.weightUnit, super.key});
  final double volume;
  final WeightUnit weightUnit;
}
```

**Behavior:** a styled container (match `NutritionBar`'s surface/border/radius/padding tokens) showing the day's total volume, e.g. `'${volume.trimmedDecimal} ${weightUnit.name} · volume'` in a `Text` styled from the theme. Keep it a single row; no segments, no goal.

**Tests:** (1) renders (`find.byType(VolumeBar)` findsOneWidget after pump); (2) shows a `Text` whose data contains the trimmed volume value (assert against `volume.trimmedDecimal`, derived not copy). Pump with `pumpPumpPumpItUP`.

- [ ] **Step 1-5:** Standard TDD cycle. Create the feature `widgets/` barrel and export it from `workout.dart`. Suggested commit: `feat(workout): add VolumeBar`.

---

### Task 6: LoggedWorkoutRow + WorkoutLogSection

The per-group section: header (group name + section volume), logged rows wired to the bloc, usual-workout quick picks, and the "New workout" button. Mirror `lib/app/feature/today/widgets/logged_entry_row.dart` and `meal_log_section.dart`. Read both first.

**Files:**
- Create: `lib/app/feature/workout/widgets/logged_workout_row.dart`
- Create: `lib/app/feature/workout/widgets/workout_log_section.dart`
- Modify: `lib/app/feature/workout/widgets/widgets.dart`
- Create: `test/app/feature/workout/widgets/workout_log_section_test.dart`

**Interfaces produced:**
```dart
class LoggedWorkoutRow extends StatelessWidget {
  const LoggedWorkoutRow({
    required this.workoutLogEntry,
    required this.weightUnit,
    required this.expandedByDefault,
    super.key,
  });
}

class WorkoutLogSection extends StatelessWidget {
  const WorkoutLogSection({
    required this.workoutGroup,                 // WorkoutGroup
    required this.workoutLogEntries,            // List<WorkoutLogEntry> for this group, this day
    required this.quickPicks,                   // List<UsualWorkout> not yet logged today
    required this.weightUnit,                   // WeightUnit
    required this.expandedByDefault,            // bool
    this.justLoggedWorkoutId,
    this.logDays,                               // List<DateTime>? (null => log to now)
    this.dayStart,                              // TimeOfDay?
    super.key,
  });
}
```

**LoggedWorkoutRow behavior:** renders `ExpandableWorkout` wired to `getIt<WorkoutLogBloc>()`:
- `onChanged: (sets) => add(WorkoutLogEvent.workoutSetsChanged(workoutLogEntry.id, sets))`
- `onRemoved: () => add(WorkoutLogEvent.workoutRemoved(workoutLogEntry.id))`
- `expandedByDefault: expandedByDefault`
- (No name editing this phase: pass `onNameChanged: null`. No footer.)

**WorkoutLogSection behavior (mirror MealLogSection):**
- `DecoratedSliver` (`surfaceContainerLowest`, `outline` border, radius `md`) — do NOT add the "current meal" highlight (workouts have no current-group concept this phase).
- Header `SliverToBoxAdapter`: `Text(workoutGroup.name)` + when entries exist, a `Text('${workoutLogEntries.totalVolume.trimmedDecimal} ${weightUnit.name}')`.
- `SliverList.builder` of `LoggedWorkoutRow` keyed by entry id; `expandedByDefault: expandedByDefault || entry.id == justLoggedWorkoutId`.
- Quick-pick chips for each `quickPick` (mirror MealLogSection's `_QuickPickChip` with `'+ ${usualWorkout.name}'`), tapping logs it via the `_logOntoTargetDays` helper below; the chip's remove dispatches `UserSettingsEvent.usualWorkoutRemoved(workoutGroup.id, usualWorkout.id)`.
- A "New workout" `TextButton.icon(Icons.add, 'New workout')` opening `TheUsualBottomSheet.show<WorkoutEntryResult>(context, builder: (_) => WorkoutEntrySheet(title: 'New workout', confirmLabel: 'Log', weightUnit: weightUnit, showAddToUsuals: true))`; on a non-null result, if `addToUsuals` dispatch `UserSettingsEvent.usualWorkoutAdded(workoutGroup.id, result.name, result.sets)`, then log via `_logOntoTargetDays(result.name, result.sets)`.
- `_logOntoTargetDays(String name, List<WorkoutSet> sets, {String? usualWorkoutId})`: mirror MealLogSection's helper — when `logDays == null`, `add(WorkoutLogEvent.workoutLogged(workoutGroup.id, name, sets: sets, usualWorkoutId: usualWorkoutId))`; else loop the days adding with `day:` and `dayStart:`.

**Tests** (`test/app/feature/workout/widgets/workout_log_section_test.dart`): mirror `meal_log_section_test.dart` setup (Mock `WorkoutLogBloc` + `UserSettingsBloc`, `registerFallbackValue`, pump inside a `CustomScrollView`, large physical size). Cover:
1. renders a logged row per entry (`find.byType(LoggedWorkoutRow)` count).
2. a quick-pick chip logs its usual when tapped — `verify(() => workoutLogBloc.add(const WorkoutLogEvent.workoutLogged('push', 'Bench Press', sets: [...], usualWorkoutId: 'u'))).called(1)`.
3. the section header volume appears when entries exist.

(You will need a `MockWorkoutLogBloc`; Task 7 adds it to `mocks.dart`/`pump_app.dart`. For this task, add `MockWorkoutLogBloc` to `test/helpers/mocks.dart` now and register it in `pump_app.dart` so the section can resolve `getIt<WorkoutLogBloc>()` — see Task 7's snippet; if you do it here, Task 7 only wires the view.)

- [ ] **Step 1:** Add `MockWorkoutLogBloc extends MockBloc<WorkoutLogEvent, WorkoutLogState>` to `test/helpers/mocks.dart`, and register it in `pump_app.dart` (a `MockWorkoutLogBloc` with `state => const WorkoutLogState()` and empty stream, plus a `WorkoutLogBloc` override branch in `_registerOverride`). Write the failing section tests.
- [ ] **Step 2:** Run `fvm flutter test test/app/feature/workout/widgets/workout_log_section_test.dart` — expect FAIL.
- [ ] **Step 3:** Implement `LoggedWorkoutRow` then `WorkoutLogSection`, export both from the feature widgets barrel.
- [ ] **Step 4:** Run the test with random seed — expect PASS.
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): add LoggedWorkoutRow and WorkoutLogSection`.

---

### Task 7: WorkoutsView body assembly

Replace the Phase 2 placeholder body with the real day view: date pill app bar (mirror TodayView), VolumeBar (day total), one WorkoutLogSection per group ordered by `WorkoutGroup.order`. Mirror `today_view.dart`.

**Files:**
- Modify: `lib/app/feature/workout/view/workouts_view.dart`
- Modify: `test/app/feature/workout/view/workouts_view_test.dart`
- Verify/finish: `test/helpers/mocks.dart`, `test/helpers/pump_app.dart` (if Task 6 didn't already add `MockWorkoutLogBloc`).

**Behavior (mirror TodayView):**
- Convert `WorkoutsView` to a `StatefulWidget` with the same `_selectedRange` date-pill mechanism as TodayView (copy the date-pill `ActionChip` titleWidget and `_selectedRange` logic; the app bar keeps `historyRoute` unset this phase).
- Body: a nested `BlocSelector` — outer on `UserSettingsBloc` for `(workoutGroups, usualWorkouts, workoutWeightUnit, expandNutritionByDefault, dayStartTime)`, inner on `WorkoutLogBloc` for `(workoutEntries, justLoggedWorkoutId)`.
- Compute the day's entries with `workoutLogState.entriesOn(day, dayStart)` and group them by `workoutGroupId`. Compute each group's quick picks = `usualWorkouts[group.id]` whose name is not already logged in that group today (mirror how meals filter quick picks by not-yet-logged). Day volume = `dayEntries.totalVolume`.
- `CustomScrollView` slivers: a `VolumeBar` (in a `SliverToBoxAdapter` with padding), then a `WorkoutLogSection` per group sorted by `order`, then bottom padding (mirror TodayView's home-indicator padding).
- Logging day targets: mirror TodayView — `logDays`/`dayStart` derived from `_selectedRange` and `dayStartTime`.

**Tests** (`test/app/feature/workout/view/workouts_view_test.dart`): replace the placeholder test. With `UserSettingsBloc` mocked to return the default three groups and a `WorkoutLogBloc` with one logged entry, assert (1) `find.byType(WorkoutLogSection)` findsNWidgets(3) (one per default group); (2) `find.byType(VolumeBar)` findsOneWidget; (3) the date pill (`find.byType(ActionChip)` or its key) is present. Use `deps: [workoutLogBloc, userSettingsBloc]`.

- [ ] **Step 1:** Ensure `MockWorkoutLogBloc` is in `mocks.dart` and registered in `pump_app.dart` (if not done in Task 6). Write the failing view tests.
- [ ] **Step 2:** Run `fvm flutter test test/app/feature/workout/view/workouts_view_test.dart` — expect FAIL.
- [ ] **Step 3:** Implement the `WorkoutsView` body mirroring `today_view.dart`.
- [ ] **Step 4:** Run the view test, then the FULL suite (`fvm flutter test --test-randomize-ordering-seed random`). Fix any fallout (e.g. `app_test.dart` now rendering real sections needs the `WorkoutLogBloc` mock — that's why it's registered in `pump_app.dart`). Report fallout.
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): assemble the Workouts day view`.

---

## Self-Review

**Spec coverage (sections 4-5):** volume summary bar (Task 5), per-group sections with logged rows + quick picks + New workout button (Task 6), entry sheet with name + sets + save-as-usual (Task 4), logged-row expand/edit/delete (Task 3), set inputs (Task 2), formatting (Task 1), view assembly with date navigation (Task 7). ✓

**Deferred (noted, in scope for later phases):** bodyweight checkbox / AI / machine photo (Phase 5); inline group rename, add group, "from another group" (Phase 4); workout history + the Workouts app-bar history action (Phase 7).

**Placeholder scan:** Tasks 1-2-5 carry complete code; Tasks 3-4-6-7 specify exact interfaces, behavior, named reference files to mirror, and concrete test expectations. No "TBD"/"similar to".

**Type consistency:** `List<WorkoutSet>` flows through `SetFields.onChanged` → `ExpandableWorkout.onChanged` → `WorkoutLogEvent.workoutSetsChanged`; `WeightUnit` threads from `settings.workoutWeightUnit` → view → section → row → `SetFields`/`ExpandableWorkout`/`VolumeBar`; `workoutGroup.id` is the `workoutGroupId` on logged events and the `usualWorkouts` key.
