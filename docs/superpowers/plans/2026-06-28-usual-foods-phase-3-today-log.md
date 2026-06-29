# Usual Foods — Phase 3: Today-log composition (expand & tweak) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** In the Today log, a logged composed meal expands to an inline list of its component foods, each with a `+/−` stepper; nudging a component recalculates the meal total live, and a component's macros are editable by tapping it.

**Architecture:** Add component-level edit events to `DailyLogBloc` that mutate one `MealComponent` inside a `MealLogEntry` (by index) and recompute the entry's stored `nutrition` to `components.componentsTotal` (one serving). In the Today view, `LoggedEntryRow` branches: a composed entry (`components` non-empty) renders the Direction-B inline component list; a plain entry renders today's `ExpandableNutrition` unchanged.

**Tech Stack:** Dart/Flutter, `flutter_bloc`/`HydratedBloc`, `freezed`, `flutter_test`, `bloc_test`, `mocktail`.

## Key implementation decisions (baked in)

1. **Components are edited by INDEX** within the entry. The log never reorders a meal's components, so an index is a stable handle; `MealComponent` has no id.
2. **Editing any component recomputes `entry.nutrition = updatedComponents.componentsTotal`** in the same handler, so every existing total/summary path (which reads `entry.scaledNutrition = nutrition * quantity`, with `quantity == 1` for composed entries) stays correct with no other change.
3. **Scope is editing existing components' quantity and macros.** Adding/removing a component in the log is NOT in Phase 3 (that's an entry-form concern). Note it; don't build it.
4. **All "push the edit back to the usual" propagation is deferred to Phase 4** (the library phase), because composed components carry `usualFoodId: null` today (no links to propagate along). Concretely: for a **composed** logged entry, do NOT show the `UpdateUsualButton` ("Update usual meal to match" / "Save as usual") footer — syncing a composed meal's components to its usual is Phase 4 work. A **plain** (non-composed) entry keeps today's footer behavior exactly.
5. **Composed display does not change how logging works** — Phase 2a already logs composed entries; this phase only makes them expandable/editable in the day view.

## Global Constraints

- **Do NOT `git commit`/`git push`, and do NOT commit.** Work accumulates in the working tree on `main`; Jacob commits. Each task ends by leaving changes in the working tree.
- **Do NOT run `build_runner`.** A background watcher regenerates `.freezed.dart`/`.g.dart`. If a test fails to compile on a missing generated symbol, wait a few seconds and re-run; if still missing, report DONE_WITH_CONCERNS — never invoke codegen.
- **Use `fvm flutter`** for all Flutter CLI commands.
- **Barrel imports** (`package:the_usual/app/app.dart`, `package:the_usual/design_system/design_system.dart`). Views get blocs via `getIt<T>()`, not `context.read`.
- **`@freezed` events/states; exhaustive `switch` in `on<Event>`.** Async handlers try-catch (these handlers are synchronous state edits — no async).
- **`BlocSelector` over `BlocBuilder`;** select multiple values with a record.
- **Naming:** variables named after their full model type (`mealLogEntry`, `mealComponent`, `mealOfTheDay`).
- **Reuse design tokens** (`AppDesign.spacing`/`radius`), never hardcoded values. Reuse existing widgets: `QuantityStepper`, `NutritionFields`, `NutritionSummary`, `ExpandableNutrition`.
- **Tests:** matchers not raw asserts; `blocTest`; `mocktail`; `initHydratedStorage()` in HydratedBloc tests; locate widgets by type/key/icon, NOT UI strings; run with `--test-randomize-ordering-seed random`.
- **Phase 1/2a facts:** `MealComponent({required String name, Nutrition nutrition = const Nutrition(), double quantity = 1, String? usualFoodId})` with `scaledNutrition => nutrition * quantity`. `List<MealComponent>.componentsTotal` sums `scaledNutrition`. `MealLogEntry` has `components` (default `[]`); for a composed entry `quantity == 1` and `nutrition` is the components total (one serving).

---

## File Structure

- Modify: `lib/app/feature/today/bloc/daily_log_event.dart` — two component-edit events.
- Modify: `lib/app/feature/today/bloc/daily_log_bloc.dart` — their handlers (mutate component by index, recompute entry nutrition).
- Modify: `lib/app/feature/today/widgets/logged_entry_row.dart` — branch composed vs plain; render the composed inline list and wire the events. If this file exceeds ~250 lines, extract the composed widget to `lib/app/feature/today/widgets/composed_logged_entry.dart`.
- Tests: `test/app/feature/today/bloc/daily_log_bloc_test.dart`, `test/app/feature/today/widgets/logged_entry_row_test.dart` (+ a new composed-entry widget test).

---

### Task 1: Component-level edit events on `DailyLogBloc`

**Files:**
- Modify: `lib/app/feature/today/bloc/daily_log_event.dart`
- Modify: `lib/app/feature/today/bloc/daily_log_bloc.dart`
- Test: `test/app/feature/today/bloc/daily_log_bloc_test.dart`

**Interfaces:**
- Consumes: `MealComponent`, `List<MealComponent>.componentsTotal`.
- Produces:
  - `DailyLogEvent.mealEntryComponentQuantityChanged(String id, int componentIndex, double quantity) = MealEntryComponentQuantityChanged`
  - `DailyLogEvent.mealEntryComponentNutritionChanged(String id, int componentIndex, Nutrition nutrition) = MealEntryComponentNutritionChanged`
  - Each handler replaces the component at `componentIndex` in the entry with `id`, then sets that entry's `nutrition` to the updated `components.componentsTotal`.

- [ ] **Step 1: Write the failing tests**

Add to `daily_log_bloc_test.dart` (mirror the existing `DailyLogBloc` test harness — it builds `DailyLogBloc()` directly and uses `initHydratedStorage()` in `setUp`; confirm by reading the file's top). Seed a composed entry, then change a component's quantity and assert both the component and the recomputed entry total:

```dart
    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryComponentQuantityChanged updates the component and recomputes the entry total',
      build: () => DailyLogBloc(),
      seed: () => DailyLogState(
        mealEntries: [
          MealLogEntry(
            id: 'entry-1',
            loggedAt: DateTime(2026, 6, 28, 12),
            mealOfTheDay: MealOfTheDay.lunch,
            name: 'Chicken & rice bowl',
            nutrition: const Nutrition(calories: 293, protein: 20, carbs: 45),
            components: const [
              MealComponent(name: 'Chicken, 1 oz', nutrition: Nutrition(calories: 22, protein: 5), quantity: 4),
              MealComponent(name: 'Rice, 100 g', nutrition: Nutrition(calories: 205, carbs: 45)),
            ],
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        const DailyLogEvent.mealEntryComponentQuantityChanged('entry-1', 0, 3),
      ),
      verify: (bloc) {
        final mealLogEntry = bloc.state.mealEntries.single;
        expect(mealLogEntry.components.first.quantity, equals(3));
        // 22*3 + 205 = 271 calories, 5*3 = 15 protein, 45 carbs.
        expect(mealLogEntry.nutrition.calories, equals(271));
        expect(mealLogEntry.nutrition.protein, equals(15));
        expect(mealLogEntry.nutrition.carbs, equals(45));
      },
    );

    blocTest<DailyLogBloc, DailyLogState>(
      'mealEntryComponentNutritionChanged updates the component and recomputes the entry total',
      build: () => DailyLogBloc(),
      seed: () => DailyLogState(
        mealEntries: [
          MealLogEntry(
            id: 'entry-1',
            loggedAt: DateTime(2026, 6, 28, 12),
            mealOfTheDay: MealOfTheDay.lunch,
            name: 'Bowl',
            nutrition: const Nutrition(calories: 22),
            components: const [
              MealComponent(name: 'Chicken, 1 oz', nutrition: Nutrition(calories: 22), quantity: 1),
            ],
          ),
        ],
      ),
      act: (bloc) => bloc.add(
        const DailyLogEvent.mealEntryComponentNutritionChanged(
          'entry-1', 0, Nutrition(calories: 30, protein: 6),
        ),
      ),
      verify: (bloc) {
        final mealLogEntry = bloc.state.mealEntries.single;
        expect(mealLogEntry.components.first.nutrition.calories, equals(30));
        expect(mealLogEntry.nutrition.calories, equals(30));
        expect(mealLogEntry.nutrition.protein, equals(6));
      },
    );
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart`
Expected: FAIL — the two events don't exist.

- [ ] **Step 3: Add the events**

In `daily_log_event.dart`, after `mealEntryQuantityChanged`:

```dart
  const factory DailyLogEvent.mealEntryComponentQuantityChanged(
    String id,
    int componentIndex,
    double quantity,
  ) = MealEntryComponentQuantityChanged;
  const factory DailyLogEvent.mealEntryComponentNutritionChanged(
    String id,
    int componentIndex,
    Nutrition nutrition,
  ) = MealEntryComponentNutritionChanged;
```

- [ ] **Step 4: Add the switch cases and handlers**

In `daily_log_bloc.dart`, add the two cases to the exhaustive switch:

```dart
        MealEntryComponentQuantityChanged() =>
          _onMealEntryComponentQuantityChanged(event, emit),
        MealEntryComponentNutritionChanged() =>
          _onMealEntryComponentNutritionChanged(event, emit),
```

Add the handlers (place near `_onMealEntryQuantityChanged`). Use one shared private helper that maps the entry, replaces the component, and recomputes the total — so the two handlers don't duplicate the recompute logic:

```dart
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
        if (index == componentIndex) transform(mealComponent) else mealComponent,
    ];
    return mealLogEntry.copyWith(
      components: updatedComponents,
      nutrition: updatedComponents.componentsTotal,
    );
  }
```

- [ ] **Step 5: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart`
Expected: PASS, all pre-existing tests included.

- [ ] **Step 6: Leave changes in the working tree (no commit)**

---

### Task 2: Direction-B inline component list in the Today log

**Files:**
- Modify: `lib/app/feature/today/widgets/logged_entry_row.dart` (branch composed vs plain). If the file exceeds ~250 lines after this, extract the composed widget to `lib/app/feature/today/widgets/composed_logged_entry.dart` and export it via the today widgets barrel.
- Test: `test/app/feature/today/widgets/logged_entry_row_test.dart` (+ composed cases)

**Interfaces:**
- Consumes: `DailyLogBloc` events from Task 1 (`mealEntryComponentQuantityChanged`, `mealEntryComponentNutritionChanged`), plus the existing `mealEntryRemoved`. `MealComponent`, `componentsTotal`, `QuantityStepper`, `NutritionFields`, `NutritionSummary`, `ExpandableNutrition`.
- Produces: a composed logged entry renders an `ExpansionTile`-style row: collapsed shows the meal name + `NutritionSummary(entry.nutrition)`; expanded shows one row per component (component name, a `NutritionSummary` of that component's `scaledNutrition`, and a dense `QuantityStepper` bound to `mealEntryComponentQuantityChanged(entry.id, index, …)`), with each component's `NutritionFields` revealed on tap bound to `mealEntryComponentNutritionChanged(entry.id, index, …)`. A trailing delete control removes the whole entry (`mealEntryRemoved`). No `UpdateUsualButton` footer for composed entries.

- [ ] **Step 1: Write the failing widget tests**

In `logged_entry_row_test.dart` (mirror its harness — it pumps `LoggedEntryRow` with a mocked `DailyLogBloc`/`UserSettingsBloc` via `getIt`; read the file first). Add:

```dart
    testWidgets('a composed entry shows a stepper per component', (tester) async {
      // pump LoggedEntryRow with a composed MealLogEntry of 2 components,
      // expandedByDefault: true
      expect(find.byType(QuantityStepper), findsNWidgets(2));
    });

    testWidgets('stepping a component dispatches a component quantity change', (tester) async {
      // tap the increment button of the first component's QuantityStepper
      verify(() => dailyLogBloc.add(
        any(that: isA<MealEntryComponentQuantityChanged>()
            .having((e) => e.componentIndex, 'componentIndex', 0)),
      )).called(1);
    });

    testWidgets('a plain entry still renders the single nutrition row', (tester) async {
      // pump LoggedEntryRow with a non-composed entry (components empty)
      expect(find.byType(ExpandableNutrition), findsOneWidget);
      expect(find.byType(QuantityStepper), findsOneWidget); // the meal-level stepper
    });
```

(Use the exact mock/getIt setup the existing tests in this file use. Find the increment button the way the file already taps steppers, or by the stepper's `Icons.add` within the first component row.)

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/widgets/logged_entry_row_test.dart`
Expected: FAIL — composed entries currently render via `ExpandableNutrition` (no per-component steppers).

- [ ] **Step 3: Branch composed vs plain in `LoggedEntryRow`**

In `logged_entry_row.dart`, at the top of the composed `builder`, branch on `mealLogEntry.components.isNotEmpty`:
- **Plain** (`components` empty): the existing `ExpandableNutrition(...)` with its `expandedFooter` (UpdateUsualButton) logic — UNCHANGED.
- **Composed**: render the new composed widget (a private `_ComposedLoggedEntry`, or `composed_logged_entry.dart` if the file grows past ~250 lines). It is an `ExpansionTile` whose title is the meal name + (when collapsed) `NutritionSummary(mealLogEntry.nutrition)`, a trailing delete `IconButton` → `mealEntryRemoved(mealLogEntry.id)`, and children = one `_ComposedComponentRow` per component.

`_ComposedComponentRow` (private widget, keyed by index): a row with the component name and `NutritionSummary(mealComponent.scaledNutrition)`, a dense `QuantityStepper(quantity: mealComponent.quantity, onChanged: (q) => bloc.add(mealEntryComponentQuantityChanged(entryId, index, q)))`, and a tap target that toggles a dense `NutritionFields(initial: mealComponent.nutrition, onChanged: (n) => bloc.add(mealEntryComponentNutritionChanged(entryId, index, n)))`. Reuse `ExpandableNutrition` if it cleanly models "name + summary + stepper + fields" for a single component with no footer; otherwise build the small expander with an `ExpansionTile`. Get the bloc via `getIt<DailyLogBloc>()` (consistent with the existing `LoggedEntryRow`).

Do NOT render the `UpdateUsualButton` for composed entries (Phase 4 will handle usual sync).

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/widgets/logged_entry_row_test.dart`
Expected: PASS (composed + plain cases).

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 3: Full-suite green + analyzer

**Files:** none beyond fixing fallout.

- [ ] **Step 1: Run the today + widgets suites with a random seed**

Run:
```bash
fvm flutter test test/app/feature/today test/app/widgets --test-randomize-ordering-seed random
```
Expected: PASS. Fix any fallout (e.g. a meal_log_section/today_view test that pumped a composed entry and now finds a different widget tree). Note: a pre-existing unrelated failure in `usual_meal_list_test.dart` (developer's ConfirmDialog WIP) may persist — confirm it is the same failure and unrelated; do not fix it here.

- [ ] **Step 2: Analyzer clean on touched dirs**

Run: `fvm flutter analyze lib/app/feature/today`
Expected: No errors (fix errors only, not info/warnings).

- [ ] **Step 3: Leave changes in the working tree (no commit)**

---

## Self-Review

**Spec coverage (Phase 3 slice):**
- Direction-B inline component list in the expanded logged meal → Task 2. ✓
- Live recalc when a component's quantity changes → Tasks 1 (recompute) + 2 (stepper wiring). ✓
- Per-component macro editing → Tasks 1 + 2. ✓
- Deferred by design (NOT gaps): the "update usual food / also update N meals" propagate prompt and any component→usual sync (Phase 4 — needs `usualFoodId` links that are null today); adding/removing components in the log (entry-form concern). Stated in Key Decisions.

**Placeholder scan:** Task 1 carries complete event/handler code. Task 2 specifies the widget structure with exact event wiring, reused widgets, and the composed/plain branch condition, plus concrete test cases that pin the observable behavior (stepper count, dispatched event, plain-entry fallback); the visual reference is `design/mockups/usual_foods_designs.html` (Direction B column).

**Type consistency:** `mealEntryComponentQuantityChanged(String id, int componentIndex, double quantity)` and `mealEntryComponentNutritionChanged(String id, int componentIndex, Nutrition nutrition)` are used identically in events, handlers, and widget wiring; `componentsTotal` recompute is the single shared helper; `components.isNotEmpty` is the composed/plain branch everywhere.
