# Usual Foods — Phase 4c: Propagate edits + composed-entry usual sync — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Close the snapshot+propagate loop: editing a usual food's nutrition can optionally update the usual meals that use it ("fix once"), and a composed logged meal can be saved to / synced with its usual meal (the footer deferred from Phase 3).

**Architecture:** Two cross-entity `UserSettingsBloc` operations. (1) `usualFoodPropagatedToMeals(usualFoodId, nutrition)` rewrites every usual meal component whose `usualFoodId` matches and recomputes that meal's nutrition; the management screen prompts "also update the N meals using this?" after a food edit. (2) `usualMealComponentsChanged(mealOfTheDay, id, components, nutrition)` sets a usual meal's components+nutrition, used by a re-enabled composed-entry footer in the Today log (save-as-usual when unlinked, update-to-match when the composed entry diverges from its linked usual meal).

**Tech Stack:** Dart/Flutter, `flutter_bloc`, `freezed`, `flutter_test`, `bloc_test`, `mocktail`.

## Key implementation decisions (baked in)

1. **Propagation is opt-in via a `ConfirmDialog`** shown only when ≥1 usual meal uses the edited food (matched by component `usualFoodId`). Declining leaves meals untouched (pure snapshot). This is the spec's "snapshot + propagate prompt".
2. **Propagation updates the matched components' nutrition to the food's new nutrition and recomputes each affected meal's `nutrition = components.componentsTotal`.** It never touches logged history (`MealLogEntry`), only `UsualMeal` templates.
3. **The composed-entry footer mirrors the plain-entry footer's two states:** unlinked composed entry → "Save as usual" (`saveAsUsualMeal(..., components:)` then `mealEntryUsualMealLinked`); linked composed entry whose components/nutrition differ from the usual meal → "Update usual meal to match" (`usualMealComponentsChanged`). Use a structural diff (components list + nutrition) to decide "differs".
4. **Logged-history immutability holds:** none of this rewrites `MealLogEntry`s; propagation and footer act on `UsualMeal` templates only.

## Global Constraints

- **Do NOT `git commit`/`git push`, and do NOT commit.** Working tree on `main`; Jacob commits. Each task ends by leaving changes in the working tree.
- **Do NOT run `build_runner`.** Watcher regenerates `.freezed.dart`/`.g.dart`. If a test won't compile on a missing generated symbol, wait and re-run; else DONE_WITH_CONCERNS — never invoke codegen.
- **Use `fvm flutter`.** Barrel imports. Blocs via `getIt<T>()` in views. `@freezed` events; exhaustive `switch`. `BlocSelector` over `BlocBuilder`.
- **Naming:** `usualFood`, `usualMeal`, `mealComponent`, `mealLogEntry`, full type names.
- Reuse `ConfirmDialog`, `UpdateUsualButton`, `List<MealComponent>.componentsTotal`, design tokens. Tests: matchers; `blocTest`; `mocktail`; find widgets by type/key/icon; `--test-randomize-ordering-seed random`.
- **Facts:** `UsualMeal` has `id`, `name`, `nutrition`, `components` (List<MealComponent>). `MealComponent` has `name`, `nutrition`, `quantity`, `usualFoodId`. `UserSettingsState.usuals` is `Map<MealOfTheDay, List<UsualMeal>>`. `saveAsUsualMeal(MealOfTheDay, String name, Nutrition, {List<MealComponent> components}) → String`. The plain-entry footer in `logged_entry_row.dart` uses `UpdateUsualButton` + compares `usualMeal.nutrition != entry.nutrition`; composed entries currently render no footer (Phase 3 deferral). `MealLogEntry` for a composed entry has `quantity == 1` and `nutrition == components.componentsTotal`.

---

## File Structure

- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart` + `user_settings_bloc.dart` — `usualFoodPropagatedToMeals`, `usualMealComponentsChanged`, and a state helper `usualMealsUsingFood`.
- Modify: `lib/app/feature/user_settings/widgets/usual_food_list.dart` — the propagate prompt after a nutrition edit.
- Modify: `lib/app/feature/today/widgets/logged_entry_row.dart` — the composed-entry footer.
- Tests alongside.

---

### Task 1: Cross-entity bloc ops + `usualMealsUsingFood` helper

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart` + `user_settings_bloc.dart` + `user_settings_state.dart`
- Test: `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`, `user_settings_state_test.dart`

**Interfaces:**
- Produces:
  - `int UserSettingsState.usualMealsUsingFood(String usualFoodId)` — count of usual meals across all timings with at least one component whose `usualFoodId` matches.
  - `UserSettingsEvent.usualFoodPropagatedToMeals(String usualFoodId, Nutrition nutrition) = SettingsUsualFoodPropagatedToMeals` — for every usual meal, replace each matching component's `nutrition` with `nutrition`, and set the meal's `nutrition` to the updated `components.componentsTotal`. Meals without a match are untouched.
  - `UserSettingsEvent.usualMealComponentsChanged(MealOfTheDay mealOfTheDay, String id, List<MealComponent> components, Nutrition nutrition) = SettingsUsualMealComponentsChanged` — sets that usual meal's `components` and `nutrition`.

- [ ] **Step 1: Write the failing tests**

In `user_settings_state_test.dart`:

```dart
    test('usualMealsUsingFood counts meals with a matching component link', () {
      const state = UserSettingsState(
        usuals: {
          MealOfTheDay.lunch: [
            UsualMeal(id: 'm1', name: 'Bowl', components: [
              MealComponent(name: 'Chicken, 1 oz', usualFoodId: 'f1', quantity: 4),
              MealComponent(name: 'Rice, 100 g', usualFoodId: 'f2'),
            ]),
          ],
          MealOfTheDay.dinner: [
            UsualMeal(id: 'm2', name: 'Plate', components: [
              MealComponent(name: 'Chicken, 1 oz', usualFoodId: 'f1', quantity: 2),
            ]),
            UsualMeal(id: 'm3', name: 'Salad'),
          ],
        },
      );
      expect(state.usualMealsUsingFood('f1'), equals(2));
      expect(state.usualMealsUsingFood('f2'), equals(1));
      expect(state.usualMealsUsingFood('f9'), equals(0));
    });
```

In `user_settings_bloc_test.dart`:

```dart
    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualFoodPropagatedToMeals updates matching components and recomputes meal totals',
      build: () => UserSettingsBloc(),
      seed: () => const UserSettingsState(
        usuals: {
          MealOfTheDay.lunch: [
            UsualMeal(id: 'm1', name: 'Bowl', nutrition: Nutrition(calories: 293), components: [
              MealComponent(name: 'Chicken, 1 oz', nutrition: Nutrition(calories: 22, protein: 5), quantity: 4, usualFoodId: 'f1'),
              MealComponent(name: 'Rice, 100 g', nutrition: Nutrition(calories: 205, carbs: 45), usualFoodId: 'f2'),
            ]),
          ],
        },
      ),
      act: (bloc) => bloc.add(const UserSettingsEvent.usualFoodPropagatedToMeals('f1', Nutrition(calories: 30, protein: 6))),
      verify: (bloc) {
        final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!.single;
        expect(usualMeal.components.first.nutrition.calories, equals(30));
        // recomputed total: 30*4 + 205 = 325 cal, 6*4 = 24 protein, 45 carbs.
        expect(usualMeal.nutrition.calories, equals(325));
        expect(usualMeal.nutrition.protein, equals(24));
        expect(usualMeal.nutrition.carbs, equals(45));
      },
    );

    blocTest<UserSettingsBloc, UserSettingsState>(
      'usualMealComponentsChanged sets components and nutrition',
      build: () => UserSettingsBloc(),
      seed: () => const UserSettingsState(
        usuals: {MealOfTheDay.lunch: [UsualMeal(id: 'm1', name: 'Bowl')]},
      ),
      act: (bloc) => bloc.add(const UserSettingsEvent.usualMealComponentsChanged(
        MealOfTheDay.lunch, 'm1',
        [MealComponent(name: 'Chicken, 1 oz', nutrition: Nutrition(calories: 22), quantity: 3, usualFoodId: 'f1')],
        Nutrition(calories: 66),
      )),
      verify: (bloc) {
        final usualMeal = bloc.state.usuals[MealOfTheDay.lunch]!.single;
        expect(usualMeal.components, hasLength(1));
        expect(usualMeal.nutrition.calories, equals(66));
      },
    );
```

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/user_settings/bloc/`
Expected: FAIL — helper/events undefined.

- [ ] **Step 3: Add the helper, events, switch cases, and handlers**

In `user_settings_state.dart`:

```dart
  /// The number of usual meals (across all timings) with at least one component
  /// linked to the usual food [usualFoodId].
  int usualMealsUsingFood(String usualFoodId) {
    var count = 0;
    for (final usualMeals in usuals.values) {
      for (final usualMeal in usualMeals) {
        if (usualMeal.components.any((c) => c.usualFoodId == usualFoodId)) {
          count++;
        }
      }
    }
    return count;
  }
```

In `user_settings_event.dart`:

```dart
  const factory UserSettingsEvent.usualFoodPropagatedToMeals(
    String usualFoodId,
    Nutrition nutrition,
  ) = SettingsUsualFoodPropagatedToMeals;
  const factory UserSettingsEvent.usualMealComponentsChanged(
    MealOfTheDay mealOfTheDay,
    String id,
    List<MealComponent> components,
    Nutrition nutrition,
  ) = SettingsUsualMealComponentsChanged;
```

In `user_settings_bloc.dart`, add the two switch cases and handlers:

```dart
  void _onUsualFoodPropagatedToMeals(
    SettingsUsualFoodPropagatedToMeals event,
    Emitter<UserSettingsState> emit,
  ) {
    final updatedUsuals = <MealOfTheDay, List<UsualMeal>>{};
    for (final entry in state.usuals.entries) {
      updatedUsuals[entry.key] = [
        for (final usualMeal in entry.value)
          if (usualMeal.components.any((c) => c.usualFoodId == event.usualFoodId))
            _withPropagatedFood(usualMeal, event.usualFoodId, event.nutrition)
          else
            usualMeal,
      ];
    }
    emit(state.copyWith(usuals: updatedUsuals));
  }

  UsualMeal _withPropagatedFood(
    UsualMeal usualMeal,
    String usualFoodId,
    Nutrition nutrition,
  ) {
    final updatedComponents = [
      for (final mealComponent in usualMeal.components)
        if (mealComponent.usualFoodId == usualFoodId)
          mealComponent.copyWith(nutrition: nutrition)
        else
          mealComponent,
    ];
    return usualMeal.copyWith(
      components: updatedComponents,
      nutrition: updatedComponents.componentsTotal,
    );
  }

  void _onUsualMealComponentsChanged(
    SettingsUsualMealComponentsChanged event,
    Emitter<UserSettingsState> emit,
  ) {
    final usualMeals = state.usuals[event.mealOfTheDay] ?? const <UsualMeal>[];
    final updated = [
      for (final usualMeal in usualMeals)
        if (usualMeal.id == event.id)
          usualMeal.copyWith(components: event.components, nutrition: event.nutrition)
        else
          usualMeal,
    ];
    emit(state.copyWith(
      usuals: {...state.usuals, event.mealOfTheDay: updated},
    ));
  }
```

Wire both into the exhaustive switch (`SettingsUsualFoodPropagatedToMeals() => _onUsualFoodPropagatedToMeals(event, emit)`, `SettingsUsualMealComponentsChanged() => _onUsualMealComponentsChanged(event, emit)`).

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/user_settings/bloc/`
Expected: PASS (all, incl. pre-existing).

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 2: Propagate prompt in the usual-foods management screen

**Files:**
- Modify: `lib/app/feature/user_settings/widgets/usual_food_list.dart`
- Test: `test/app/feature/user_settings/view/usual_foods_view_test.dart`

**Interfaces:**
- Consumes: `UserSettingsState.usualMealsUsingFood`, `UserSettingsEvent.usualFoodNutritionChanged`, `UserSettingsEvent.usualFoodPropagatedToMeals`, `ConfirmDialog`.
- Produces: after a food's nutrition edit, if `usualMealsUsingFood(id) > 0`, a `ConfirmDialog` asks whether to also update those meals; confirming dispatches `usualFoodPropagatedToMeals(id, nutrition)`.

- [ ] **Step 1: Write the failing widget test**

In `usual_foods_view_test.dart`, with a mocked `UserSettingsBloc` whose state has a food `f1` used by 2 meals (`usualMealsUsingFood('f1')` returns 2): edit `f1`'s nutrition, confirm the dialog appears, tap confirm, and verify `usualFoodPropagatedToMeals('f1', ...)` is dispatched. Also a case where the food is used by 0 meals → NO dialog, only `usualFoodNutritionChanged`. (Stub `usualMealsUsingFood` on the mock or seed real state; find the dialog's confirm by the `ConfirmDialog`'s confirm button.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/user_settings/view/usual_foods_view_test.dart`
Expected: FAIL — no propagate prompt.

- [ ] **Step 3: Add the prompt to the nutrition-edit handler**

In `usual_food_list.dart`, change the `ExpandableNutrition.onChanged` for each food so that after dispatching `usualFoodNutritionChanged(id, nutrition)` it checks the count and prompts:

```dart
onChanged: (nutrition) async {
  final settingsBloc = getIt<UserSettingsBloc>();
  settingsBloc.add(UserSettingsEvent.usualFoodNutritionChanged(usualFood.id, nutrition));
  final mealsUsing = settingsBloc.state.usualMealsUsingFood(usualFood.id);
  if (mealsUsing == 0) return;
  final confirmed = await ConfirmDialog.show(
    context,
    title: 'Update meals too?',
    message: 'This food is used in $mealsUsing usual '
        '${mealsUsing == 1 ? 'meal' : 'meals'}. Update '
        '${mealsUsing == 1 ? 'it' : 'them'} to match the new nutrition?',
    confirmLabel: 'Update',
  );
  if (!confirmed) return;
  settingsBloc.add(UserSettingsEvent.usualFoodPropagatedToMeals(usualFood.id, nutrition));
},
```

Guard the `context` use across the await with a `context.mounted` check per the project's existing pattern (mirror how `usual_meal_list.dart` handles `await ConfirmDialog.show` in its `onRemoved`). Note: `onChanged` fires per keystroke; the dialog will appear on each edit — acceptable for now, but if that's too chatty, the implementer may debounce or move the prompt to a focus-loss/commit; keep the simple per-edit version unless the test reveals a problem. (If a simpler trigger is clearly better, raise it.)

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/user_settings/view/usual_foods_view_test.dart`
Expected: PASS.

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 3: Composed-entry "update usual" footer in the Today log

**Files:**
- Modify: `lib/app/feature/today/widgets/logged_entry_row.dart` (the composed branch / `_ComposedLoggedEntry`)
- Test: `test/app/feature/today/widgets/logged_entry_row_test.dart`

**Interfaces:**
- Consumes: `UserSettingsBloc` (`saveAsUsualMeal(..., components:)`, `usualMealComponentsChanged`), `DailyLogBloc.mealEntryUsualMealLinked`, `UpdateUsualButton`, the linked `UsualMeal` lookup the plain path already uses.
- Produces: the composed entry shows an `UpdateUsualButton`: when NOT linked → "Save as usual" (saves the composed meal incl. components, links the entry); when linked and the entry's components/nutrition differ from the usual meal → "Update usual meal to match" (`usualMealComponentsChanged`). No footer when linked and identical.

- [ ] **Step 1: Write the failing widget tests**

In `logged_entry_row_test.dart`:

```dart
    testWidgets('an unlinked composed entry offers Save as usual', (tester) async {
      // composed MealLogEntry with usualMealId == null, expandedByDefault: true
      expect(find.byType(UpdateUsualButton), findsOneWidget);
      // tapping it calls saveAsUsualMeal with components and links the entry
    });

    testWidgets('a linked composed entry that differs offers Update usual meal to match', (tester) async {
      // composed entry linked to a usual meal whose components differ
      // tap -> verify usualMealComponentsChanged dispatched
    });

    testWidgets('a linked composed entry identical to its usual shows no footer', (tester) async {
      expect(find.byType(UpdateUsualButton), findsNothing);
    });
```

(Mirror the plain-entry footer tests' harness — how they mock `UserSettingsBloc`/`DailyLogBloc` and seed a linked `UsualMeal`.)

- [ ] **Step 2: Run to verify failure**

Run: `fvm flutter test test/app/feature/today/widgets/logged_entry_row_test.dart`
Expected: FAIL — composed entries render no footer.

- [ ] **Step 3: Add the footer to the composed branch**

In `_ComposedLoggedEntry` (or the composed branch of `LoggedEntryRow`), add a `BlocSelector<UserSettingsBloc, UserSettingsState, UsualMeal?>` that looks up the linked usual meal (reuse the plain path's `_linkedUsualMeal` logic), and render an `UpdateUsualButton` as the last child of the expanded tile:
- `usualMeal == null` → label "Save as usual", onPressed: `final id = getIt<UserSettingsBloc>().saveAsUsualMeal(mealLogEntry.mealOfTheDay, mealLogEntry.name, mealLogEntry.nutrition, components: mealLogEntry.components); getIt<DailyLogBloc>().add(DailyLogEvent.mealEntryUsualMealLinked(mealLogEntry.id, id));`
- linked and differs (`usualMeal.components != mealLogEntry.components || usualMeal.nutrition != mealLogEntry.nutrition`) → label "Update usual meal to match", onPressed: `getIt<UserSettingsBloc>().add(UserSettingsEvent.usualMealComponentsChanged(mealLogEntry.mealOfTheDay, usualMeal.id, mealLogEntry.components, mealLogEntry.nutrition));`
- linked and identical → no footer (null).

Freezed value equality makes `usualMeal.components != mealLogEntry.components` a correct structural compare.

- [ ] **Step 4: Run to verify pass**

Run: `fvm flutter test test/app/feature/today/widgets/logged_entry_row_test.dart`
Expected: PASS (composed footer states + plain entries unchanged).

- [ ] **Step 5: Leave changes in the working tree (no commit)**

---

### Task 4: Full-suite green + analyzer

- [ ] **Step 1: Run the affected suites with a random seed**

Run:
```bash
fvm flutter test test/app/feature/user_settings test/app/feature/today --test-randomize-ordering-seed random
```
Expected: PASS apart from the known-unrelated pre-existing `usual_meal_list_test.dart` "edits and removes" failure (developer's ConfirmDialog WIP) — confirm it's the same one. Fix genuine fallout.

- [ ] **Step 2: Analyzer clean on touched dirs**

Run: `fvm flutter analyze lib/app/feature/user_settings lib/app/feature/today`
Expected: No errors.

- [ ] **Step 3: Leave changes in the working tree (no commit)**

---

## Self-Review

**Spec coverage (Phase 4c — the snapshot+propagate loop closed):**
- "Edit a usual food → also update the N meals using it?" propagate prompt → Tasks 1, 2. ✓
- Composed logged meal saved-to / synced-with its usual meal (Phase 3 footer deferral closed) → Tasks 1, 3. ✓
- Logged history never rewritten by propagation/footer (templates only) → Key Decisions + Task 1 (acts on `usuals`, not `mealEntries`). ✓

**Placeholder scan:** Task 1 carries complete helper/event/handler code. Tasks 2–3 specify the prompt and footer with exact event wiring, reused widgets (`ConfirmDialog`, `UpdateUsualButton`), the differs-comparison, and concrete test cases.

**Type consistency:** `usualMealsUsingFood(String) → int`, `usualFoodPropagatedToMeals(String usualFoodId, Nutrition)`, `usualMealComponentsChanged(MealOfTheDay, String id, List<MealComponent>, Nutrition)`, `saveAsUsualMeal(..., components:)`, `componentsTotal` — names consistent across state, events, handlers, screen, and footer.
