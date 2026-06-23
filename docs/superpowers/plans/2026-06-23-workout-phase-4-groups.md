# Workout Feature — Phase 4: Group Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Checkbox (`- [ ]`) steps.

**Goal:** Let the user manage workout groups from the Workouts view: rename a group inline, add a new group, and delete a group (blocked while it still has usuals or logged workouts).

**Architecture:** Extend `WorkoutLogSection` with an editable group name and a delete affordance driven by callbacks. `WorkoutsView` wires those callbacks to `UserSettingsBloc` events (`workoutGroupRenamed`, `workoutGroupRemoved`) and adds an "Add group" action that prompts for a name and dispatches `workoutGroupAdded`. Deletion eligibility (no usuals AND no logged workouts referencing the group) is computed in the view, which has both blocs.

**Tech Stack:** Flutter, flutter_bloc, get_it; bloc events from Phase 1.

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, sections 1, 4, and Resolved decision A (delete blocked when non-empty).
- **No meal counterpart exists** for group CRUD (meals use a fixed enum). The behavior is specified by the user; reuse existing components for styling: editable names use a dense `TheUsualTextField` exactly as usual-meal names do (`ExpandableNutrition` / usual meal editing); the add-group prompt uses an `AlertDialog` (mirror `EnableNotificationsInSettingsDialog`) containing a `TheUsualTextField`; the blocked-delete notice uses a `SnackBar` via `ScaffoldMessenger`. Introduce no new colors/fonts/one-off styles.
- **Out of scope:** group reordering UI (the `workoutGroupReordered` event exists for later; do not build drag-reorder now). Bodyweight/AI (Phase 5), reminders + weight-unit settings UI (Phase 6), history (Phase 7).
- Deletion is blocked when the group has any usual workouts OR any logged workouts (all-time, not just today). The bloc already refuses to remove a group with usuals; the view additionally checks logged entries and shows the notice.
- Naming: full model-type variable names (`workoutGroup`). Widgets get blocs via `getIt<T>()`. Don't extract single-caller helpers that take `BuildContext` — inline them in the closure.
- Never run the app. `fvm flutter`/`fvm dart` only. A `build_runner watch` runs; one-shot build permitted if it lags (this run only). Do NOT commit (controller commits). Tests locate by type/key/icon, verify dispatched events; run with `--test-randomize-ordering-seed random`. Full TDD.

---

### Task 1: Editable group name + delete affordance in WorkoutLogSection

**Files:**
- Modify: `lib/app/feature/workout/widgets/workout_log_section.dart`
- Modify: `test/app/feature/workout/widgets/workout_log_section_test.dart`

**Interface change:** add to `WorkoutLogSection`:
```dart
    required this.onRenamed,            // ValueChanged<String> — commit a new group name
    required this.onDeleteRequested,    // VoidCallback — view decides delete vs. blocked notice
```

**Behavior:**
- Replace the header `Text(workoutGroup.name)` with a private `_EditableGroupName` (a `StatefulWidget` in the same file — single-use, so keep it private here per the file-size rule): a dense, border-light `TheUsualTextField` seeded with `workoutGroup.name`, that calls `onRenamed(value.trim())` on submit / editing-complete when the trimmed value is non-empty and changed. Mirror the name-sync controller lifecycle used by `ExpandableNutrition` (sync the controller when `workoutGroup.name` changes externally without disturbing an in-progress edit).
- Add a trailing delete `IconButton(Icons.delete_outline)` in the header row that calls `onDeleteRequested`. (The icon is always tappable; the view decides whether to delete or show the blocked notice — this realizes the "tap shows a message" behavior.)
- Keep the existing volume summary, logged rows, quick picks, and New-workout button unchanged. The header row now holds: editable name (expanded) + volume (when entries exist) + delete button.

**Tests** (add to `workout_log_section_test.dart`, mirroring its existing setup): 
1. editing the group name field and submitting calls `onRenamed` with the new value (pump the section with a capturing `onRenamed`; enter text into the name field located by a `Key('group-name-${workoutGroup.id}')` you assign; submit; assert captured value).
2. tapping the delete icon (`find.byIcon(Icons.delete_outline)`) calls `onDeleteRequested`.

- [ ] **Step 1:** Write the two failing tests (capturing callbacks). The existing `pumpSection` helper must pass the new required `onRenamed`/`onDeleteRequested` — update it with no-op defaults and override in the new tests.
- [ ] **Step 2:** Run `fvm flutter test test/app/feature/workout/widgets/workout_log_section_test.dart` — expect FAIL (params/behavior missing).
- [ ] **Step 3:** Implement `_EditableGroupName` + the delete button + the two new params. Assign `Key('group-name-${workoutGroup.id}')` to the name field.
- [ ] **Step 4:** Run the test with random seed — expect PASS (existing section tests still pass).
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): editable group name and delete affordance in WorkoutLogSection`.

---

### Task 2: Wire group management into WorkoutsView (rename, delete-with-guard, add group)

**Files:**
- Modify: `lib/app/feature/workout/view/workouts_view.dart`
- Modify: `test/app/feature/workout/view/workouts_view_test.dart`

**Behavior:**
- For each `WorkoutLogSection`, pass:
  - `onRenamed: (name) => getIt<UserSettingsBloc>().add(UserSettingsEvent.workoutGroupRenamed(workoutGroup.id, name))`.
  - `onDeleteRequested:` a closure that computes deletability and acts:
    ```
    final hasUsuals = (usualWorkouts[group.id] ?? const []).isNotEmpty;
    final hasLogged = getIt<WorkoutLogBloc>().state.workoutEntries
        .any((workoutLogEntry) => workoutLogEntry.workoutGroupId == group.id);
    if (hasUsuals || hasLogged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empty this group before deleting it.')),
      );
      return;
    }
    getIt<UserSettingsBloc>().add(UserSettingsEvent.workoutGroupRemoved(group.id));
    ```
    Inline this in the section's `onDeleteRequested` (do not extract a `BuildContext`-taking helper).
- Add an "Add group" affordance after the last section (a `SliverToBoxAdapter` with a `TextButton.icon(Icons.add, 'Add group')`), whose `onPressed` shows an `AlertDialog` (mirror `EnableNotificationsInSettingsDialog`) containing a `TheUsualTextField` for the name and an "Add" `FilledButton`; on a non-empty submitted name, dispatch `UserSettingsEvent.workoutGroupAdded(name)`. Place it before the bottom home-indicator padding sliver.

**Tests** (add to `workouts_view_test.dart`):
1. renaming a group's name field dispatches `workoutGroupRenamed` — `verify(() => userSettingsBloc.add(UserSettingsEvent.workoutGroupRenamed('push', 'Press Day'))).called(1)` after entering text in `Key('group-name-push')` and submitting.
2. tapping delete on an empty group (mock `WorkoutLogBloc` state with no entries, settings with no usuals for it) dispatches `workoutGroupRemoved`.
3. tapping delete on a non-empty group (settings `usualWorkouts: {'push': [a usual]}`) does NOT dispatch `workoutGroupRemoved` and shows a `SnackBar` (`find.byType(SnackBar)` after `pump`).
4. the "Add group" button opens a dialog and submitting a name dispatches `workoutGroupAdded` — tap `find.byIcon(Icons.add)`/the add-group button, enter text, tap Add, `verify(... workoutGroupAdded('Arms')).called(1)`.

Use `registerFallbackValue` for the new event types as needed.

- [ ] **Step 1:** Write the four failing tests.
- [ ] **Step 2:** Run `fvm flutter test test/app/feature/workout/view/workouts_view_test.dart` — expect FAIL.
- [ ] **Step 3:** Implement the wiring + Add-group dialog in `WorkoutsView`.
- [ ] **Step 4:** Run the view test, then the FULL suite (`fvm flutter test --test-randomize-ordering-seed random`); fix any fallout. Report.
- [ ] **Step 5:** Report. Suggested commit: `feat(workout): manage groups (rename, add, guarded delete) from the Workouts view`.

---

## Self-Review

**Spec coverage:** inline rename (Tasks 1-2), add group (Task 2), delete blocked when non-empty with a notice (Tasks 1-2; bloc backstops on usuals, view guards on usuals + logged). ✓

**Deferred:** group reordering UI (YAGNI — event exists, not requested); workout weight-unit settings control (Phase 6); these are noted, not dropped.

**Placeholder scan:** concrete code/behavior + exact tests for both tasks. No "TBD".

**Type consistency:** `onRenamed` is `ValueChanged<String>`, `onDeleteRequested` is `VoidCallback`; both dispatched to `UserSettingsEvent.workoutGroup*` which take `(String id, ...)`. The delete guard reads `getIt<WorkoutLogBloc>().state.workoutEntries` (all-time) and `usualWorkouts[id]`.
