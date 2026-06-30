# Cross-Meal Logging via a Picker Sheet Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Return each Today meal section's quick-pick chips to that meal's own usuals, and add a "From another meal" picker sheet for cross-posting.

**Architecture:** Trim `orderedQuickPicks` to this-timing only and add a sibling `usualsFromOtherMeals` helper, both sharing a private logged-today-keys helper. A new `OtherMealUsualsSheet` widget renders the grouped other-meal usuals; `MealLogSection` opens it from a "From another meal" button shown only when there are such usuals.

**Tech Stack:** Flutter, Dart 3, `freezed` models, `flutter_bloc`, `flutter_test`.

## Global Constraints

- Use `fvm flutter` for all Flutter CLI commands, never bare `flutter`.
- Never run the app or `git commit`/`git push`. Stage changes and ask Jacob to commit with the suggested message.
- The code generator (build_runner) is always watching — do not run it. No new `freezed`/`json` annotations here, so no generation is needed.
- Always use barrel imports (`package:the_usual/app/app.dart`), not direct file imports.
- Feature-specific widgets go in the feature's `widgets/` folder and are exported from its barrel.
- Get bloc instances via `getIt<T>()` in views and widgets.
- Name variables after the full model type they hold (`usualMeal`, `mealOfTheDay`).
- Use matchers in tests (`equals()`, `isFalse`, `isTrue`), never raw assertions.
- Do not pass styling into reusable widgets; format on the model (`nutrition.summary`) and style at the call site.

---

### Task 1: Trim `orderedQuickPicks` and add `usualsFromOtherMeals`

**Files:**

- Modify: `lib/app/model/extensions/meal_log_entry_list_extensions.dart:38-133`
- Test: `test/app/model/extensions/meal_log_entry_list_extensions_test.dart`

**Interfaces:**

- Produces:
  - `List<UsualMeal> orderedQuickPicks({required MealOfTheDay mealOfTheDay, required Map<MealOfTheDay, List<UsualMeal>> usuals, required DateTime day})` — now returns only the `mealOfTheDay` usuals (most recent at this timing, then by frequency at this timing), with those logged today for `mealOfTheDay` dropped.
  - `Map<MealOfTheDay, List<UsualMeal>> usualsFromOtherMeals({required MealOfTheDay mealOfTheDay, required Map<MealOfTheDay, List<UsualMeal>> usuals, required DateTime day})` — usuals from every meal except `mealOfTheDay`, grouped by meal in `MealOfTheDay` order, library order within each, dropping those logged today for `mealOfTheDay`, omitting empty meals.
- Keeps: the existing private `_sortByLogActivity` top-level function (unchanged).

- [ ] **Step 1: Update the `orderedQuickPicks` tests and add `usualsFromOtherMeals` tests**

In `test/app/model/extensions/meal_log_entry_list_extensions_test.dart`, replace the entire existing `group('orderedQuickPicks', () { ... });` block with the following two groups:

```dart
  group('orderedQuickPicks', () {
    UsualMeal usual(String id, String name) => UsualMeal(id: id, name: name);

    MealLogEntry logEntry({
      required String id,
      required DateTime loggedAt,
      required MealOfTheDay mealOfTheDay,
      String? name,
      String? usualMealId,
    }) {
      return MealLogEntry(
        id: id,
        loggedAt: loggedAt,
        mealOfTheDay: mealOfTheDay,
        name: name ?? id,
        usualMealId: usualMealId,
      );
    }

    final usuals = <MealOfTheDay, List<UsualMeal>>{
      MealOfTheDay.breakfast: [
        usual('eggs', 'Eggs'),
        usual('oatmeal', 'Oatmeal'),
        usual('coffee', 'Coffee'),
      ],
      MealOfTheDay.dinner: [usual('pizza', 'Pizza')],
    };

    final day = DateTime(2026, 6, 16);

    test('orders the meal\'s own usuals: most recent, then by frequency', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 15),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'eggs',
        ),
        logEntry(
          id: '2',
          loggedAt: DateTime(2026, 6, 10),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
        logEntry(
          id: '3',
          loggedAt: DateTime(2026, 6, 11),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
        logEntry(
          id: '4',
          loggedAt: DateTime(2026, 6, 12),
          mealOfTheDay: MealOfTheDay.breakfast,
          usualMealId: 'oatmeal',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.map((usualMeal) => usualMeal.id).toList(),
        equals(['eggs', 'oatmeal', 'coffee']),
      );
    });

    test('excludes usuals that belong to other meals', () {
      final picks = <MealLogEntry>[].orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.any((usualMeal) => usualMeal.id == 'pizza'),
        isFalse,
      );
      expect(
        picks.map((usualMeal) => usualMeal.id).toList(),
        equals(['eggs', 'oatmeal', 'coffee']),
      );
    });

    test('drops a usual already logged today for this meal by id', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'Renamed Eggs',
          usualMealId: 'eggs',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(picks.any((usualMeal) => usualMeal.id == 'eggs'), isFalse);
    });

    test('drops a usual already logged today for this meal by name', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'oatmeal',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(picks.any((usualMeal) => usualMeal.id == 'oatmeal'), isFalse);
    });
  });

  group('usualsFromOtherMeals', () {
    UsualMeal usual(String id, String name) => UsualMeal(id: id, name: name);

    MealLogEntry logEntry({
      required String id,
      required DateTime loggedAt,
      required MealOfTheDay mealOfTheDay,
      String? name,
      String? usualMealId,
    }) {
      return MealLogEntry(
        id: id,
        loggedAt: loggedAt,
        mealOfTheDay: mealOfTheDay,
        name: name ?? id,
        usualMealId: usualMealId,
      );
    }

    final usuals = <MealOfTheDay, List<UsualMeal>>{
      MealOfTheDay.breakfast: [usual('eggs', 'Eggs'), usual('coffee', 'Coffee')],
      MealOfTheDay.lunch: [usual('salad', 'Salad'), usual('sandwich', 'Sandwich')],
      MealOfTheDay.dinner: [usual('pizza', 'Pizza')],
    };

    final day = DateTime(2026, 6, 16);

    test('groups other meals, excludes the current meal, keeps library order', () {
      final grouped = <MealLogEntry>[].usualsFromOtherMeals(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(grouped.containsKey(MealOfTheDay.breakfast), isFalse);
      expect(
        grouped[MealOfTheDay.lunch]!.map((usualMeal) => usualMeal.id).toList(),
        equals(['salad', 'sandwich']),
      );
      expect(
        grouped[MealOfTheDay.dinner]!.map((usualMeal) => usualMeal.id).toList(),
        equals(['pizza']),
      );
    });

    test('drops usuals logged today for the current meal and omits emptied meals', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'Pizza',
          usualMealId: 'pizza',
        ),
      ];

      final grouped = entries.usualsFromOtherMeals(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(grouped.containsKey(MealOfTheDay.dinner), isFalse);
      expect(
        grouped[MealOfTheDay.lunch]!.map((usualMeal) => usualMeal.id).toList(),
        equals(['salad', 'sandwich']),
      );
    });
  });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: FAIL — `usualsFromOtherMeals` isn't defined, and `excludes usuals that belong to other meals` fails because `orderedQuickPicks` still appends the `pizza` cross-post.

- [ ] **Step 3: Replace `orderedQuickPicks` with the trimmed version plus `usualsFromOtherMeals` and the shared helper**

In `lib/app/model/extensions/meal_log_entry_list_extensions.dart`, replace the whole current `orderedQuickPicks` method and its doc comment (lines 38-133, from `/// The user's usuals ordered for` through its closing `}` just before the extension's closing brace) with:

```dart
  /// The user's usuals for [mealOfTheDay]'s quick-pick chips: the most recently
  /// logged usual for this meal first, then this meal's usuals by how often
  /// they've been logged here. Usuals already logged on [day] for [mealOfTheDay]
  /// are dropped, matched by name or linked id so a renamed usual stays hidden.
  List<UsualMeal> orderedQuickPicks({
    required MealOfTheDay mealOfTheDay,
    required Map<MealOfTheDay, List<UsualMeal>> usuals,
    required DateTime day,
  }) {
    final loggedToday = _loggedTodayKeys(mealOfTheDay, day);
    final countAtTiming = <String, int>{};
    final lastLoggedAtTiming = <String, DateTime>{};

    for (final mealLogEntry in this) {
      final usualMealId = mealLogEntry.usualMealId;
      if (usualMealId == null) continue;
      if (mealLogEntry.mealOfTheDay != mealOfTheDay) continue;
      countAtTiming.update(usualMealId, (count) => count + 1, ifAbsent: () => 1);
      final lastAtTiming = lastLoggedAtTiming[usualMealId];
      if (lastAtTiming == null ||
          mealLogEntry.loggedAt.isAfter(lastAtTiming)) {
        lastLoggedAtTiming[usualMealId] = mealLogEntry.loggedAt;
      }
    }

    bool isVisible(UsualMeal usualMeal) =>
        !loggedToday.names.contains(usualMeal.name.toLowerCase()) &&
        !loggedToday.ids.contains(usualMeal.id);

    final thisMealUsuals = (usuals[mealOfTheDay] ?? <UsualMeal>[])
        .where(isVisible)
        .toList();

    UsualMeal? mostRecent;
    for (final usualMeal in thisMealUsuals) {
      final loggedAt = lastLoggedAtTiming[usualMeal.id];
      if (loggedAt == null) continue;
      final currentBest = mostRecent == null
          ? null
          : lastLoggedAtTiming[mostRecent.id];
      if (currentBest == null || loggedAt.isAfter(currentBest)) {
        mostRecent = usualMeal;
      }
    }

    final remaining = thisMealUsuals
        .where((usualMeal) => usualMeal.id != mostRecent?.id)
        .toList();
    _sortByLogActivity(remaining, countAtTiming, lastLoggedAtTiming);

    return [if (mostRecent != null) mostRecent, ...remaining];
  }

  /// The user's usuals from meals other than [mealOfTheDay], grouped by their
  /// own meal in [MealOfTheDay] order and kept in library order within each.
  /// Usuals already logged on [day] for [mealOfTheDay] are dropped, and meals
  /// left with no usuals are omitted. Backs the "from another meal" picker.
  Map<MealOfTheDay, List<UsualMeal>> usualsFromOtherMeals({
    required MealOfTheDay mealOfTheDay,
    required Map<MealOfTheDay, List<UsualMeal>> usuals,
    required DateTime day,
  }) {
    final loggedToday = _loggedTodayKeys(mealOfTheDay, day);

    bool isVisible(UsualMeal usualMeal) =>
        !loggedToday.names.contains(usualMeal.name.toLowerCase()) &&
        !loggedToday.ids.contains(usualMeal.id);

    final grouped = <MealOfTheDay, List<UsualMeal>>{};
    for (final timing in MealOfTheDay.values) {
      if (timing == mealOfTheDay) continue;
      final visible = (usuals[timing] ?? <UsualMeal>[])
          .where(isVisible)
          .toList();
      if (visible.isNotEmpty) grouped[timing] = visible;
    }
    return grouped;
  }

  /// The lowercased names and linked ids of entries logged on [day] for
  /// [mealOfTheDay], used to hide usuals already logged in that section today.
  ({Set<String> names, Set<String> ids}) _loggedTodayKeys(
    MealOfTheDay mealOfTheDay,
    DateTime day,
  ) {
    final names = <String>{};
    final ids = <String>{};
    for (final mealLogEntry in this) {
      if (mealLogEntry.mealOfTheDay != mealOfTheDay) continue;
      if (!DateUtils.isSameDay(mealLogEntry.loggedAt, day)) continue;
      names.add(mealLogEntry.name.toLowerCase());
      final usualMealId = mealLogEntry.usualMealId;
      if (usualMealId != null) ids.add(usualMealId);
    }
    return (names: names, ids: ids);
  }
```

The `_sortByLogActivity` top-level function below the extension stays unchanged.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: PASS — both groups (six tests total) and the existing `totalNutrition`/`breakdownOn` tests pass.

- [ ] **Step 5: Analyze the changed files**

Run: `fvm flutter analyze lib/app/model/extensions/meal_log_entry_list_extensions.dart test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: No errors (the pre-existing `use_null_aware_elements` info on the `if (mostRecent != null)` line may remain and is left per project rules).

- [ ] **Step 6: Stage and request commit**

Stage the two files. Do not commit. Tell Jacob the change and suggest:

```
feat: scope quick picks to their meal, add usualsFromOtherMeals
```

---

### Task 2: `OtherMealUsualsSheet` picker widget

**Files:**

- Create: `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`
- Modify: `lib/app/feature/today/widgets/widgets.dart`

**Interfaces:**

- Consumes: `usualsFromOtherMeals`'s return type — `Map<MealOfTheDay, List<UsualMeal>>`.
- Produces: `OtherMealUsualsSheet({required MealOfTheDay mealOfTheDay, required Map<MealOfTheDay, List<UsualMeal>> usualsByMeal})` — a bottom-sheet body that logs a tapped usual under `mealOfTheDay` and pops.

- [ ] **Step 1: Create the picker sheet widget**

Create `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template other_meal_usuals_sheet}
/// Bottom sheet for logging a usual that belongs to another meal into the
/// current one. Lists [usualsByMeal] grouped by their own meal; tapping a usual
/// logs it under [mealOfTheDay] and closes the sheet.
/// {@endtemplate}
class OtherMealUsualsSheet extends StatelessWidget {
  /// {@macro other_meal_usuals_sheet}
  const OtherMealUsualsSheet({
    required this.mealOfTheDay,
    required this.usualsByMeal,
    super.key,
  });

  /// The meal a tapped usual is logged under.
  final MealOfTheDay mealOfTheDay;

  /// Usuals from other meals, grouped by their own meal.
  final Map<MealOfTheDay, List<UsualMeal>> usualsByMeal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDesign.spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Log to ${mealOfTheDay.label}',
              style: theme.textTheme.titleMedium,
            ),
            for (final group in usualsByMeal.entries) ...[
              SizedBox(height: AppDesign.spacing.md),
              Text(
                group.key.label.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              for (final usualMeal in group.value)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(usualMeal.name),
                  subtitle: usualMeal.nutrition.isEmpty
                      ? null
                      : Text(usualMeal.nutrition.summary),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealLogged(
                        mealOfTheDay,
                        usualMeal.name,
                        nutrition: usualMeal.nutrition,
                        usualMealId: usualMeal.id,
                        photoPath: usualMeal.photoPath,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Export it from the today widgets barrel**

In `lib/app/feature/today/widgets/widgets.dart`, add the export (keep alphabetical-ish with the others):

```dart
export 'cross_meal_picker_sheet.dart';
export 'logged_entry_row.dart';
export 'meal_log_section.dart';
export 'nutrition_bar.dart';
```

- [ ] **Step 3: Analyze the new file**

Run: `fvm flutter analyze lib/app/feature/today/widgets/cross_meal_picker_sheet.dart lib/app/feature/today/widgets/widgets.dart`
Expected: No errors.

- [ ] **Step 4: Stage and request commit**

Stage the two files. Do not commit. Suggest:

```
feat: add OtherMealUsualsSheet cross-meal picker
```

---

### Task 3: Wire the section and view

**Files:**

- Modify: `lib/app/feature/today/widgets/meal_log_section.dart`
- Modify: `lib/app/feature/today/view/today_view.dart:150-161`

**Interfaces:**

- Consumes: `usualsFromOtherMeals` (Task 1) and `OtherMealUsualsSheet` (Task 2).
- Produces: `MealLogSection` gains `required Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals`.

- [ ] **Step 1: Add the `otherMealUsuals` field to `MealLogSection`**

In `lib/app/feature/today/widgets/meal_log_section.dart`, add the constructor parameter after `quickPicks`:

```dart
    required this.mealLogEntries,
    required this.quickPicks,
    required this.otherMealUsuals,
    required this.isCurrent,
```

And add the field after the `quickPicks` field, updating the now-stale `quickPicks` doc (it no longer includes other timings):

```dart
  /// The user's usuals offered as quick picks for this meal, already filtered
  /// and ordered (most recent, then most logged here).
  final List<UsualMeal> quickPicks;

  /// Usuals from other meals, grouped by their own meal, for the "from another
  /// meal" picker. Empty when there are none to cross-post.
  final Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals;
```

- [ ] **Step 2: Fix the now-stale `_QuickPickColumns` doc comment**

In the same file, the chips no longer cross-post. Replace the `_QuickPickColumns` doc comment:

```dart
/// Lays the quick picks into columns of up to three chips, filling top to
/// bottom then spilling rightward in a horizontal scroll view. Tapping a chip
/// logs that usual under [mealOfTheDay] — the section it sits in — so a usual
/// from another timing cross-posts to this meal.
```

with:

```dart
/// Lays the quick picks into columns of up to three chips, filling top to
/// bottom then spilling rightward in a horizontal scroll view. Tapping a chip
/// logs that usual under [mealOfTheDay].
```

- [ ] **Step 3: Add the "From another meal" button**

In the same file, replace this block (the chips plus the spacing before "I ate Something New"):

```dart
                    if (quickPicks.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.md),
                      _QuickPickColumns(
                        mealOfTheDay: mealOfTheDay,
                        quickPicks: quickPicks,
                      ),
                    ],
                    SizedBox(height: AppDesign.spacing.sm),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final results =
                              await showModalBottomSheet<List<FoodEntryResult>>(
```

with:

```dart
                    if (quickPicks.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.md),
                      _QuickPickColumns(
                        mealOfTheDay: mealOfTheDay,
                        quickPicks: quickPicks,
                      ),
                    ],
                    SizedBox(height: AppDesign.spacing.sm),
                    if (otherMealUsuals.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            showDragHandle: true,
                            builder: (_) => OtherMealUsualsSheet(
                              mealOfTheDay: mealOfTheDay,
                              usualsByMeal: otherMealUsuals,
                            ),
                          ),
                          icon: const Icon(Icons.restaurant_menu),
                          label: const Text('From another meal'),
                        ),
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () async {
                          final results =
                              await showModalBottomSheet<List<FoodEntryResult>>(
```

(The rest of the "I ate Something New" button — its `showModalBottomSheet` body, `icon`, and `label` — is unchanged.)

- [ ] **Step 4: Pass `otherMealUsuals` from `today_view.dart`**

In `lib/app/feature/today/view/today_view.dart`, the `MealLogSection` constructor currently passes `quickPicks`. Add `otherMealUsuals` right after it:

```dart
                            quickPicks: mealEntries.orderedQuickPicks(
                              mealOfTheDay: mealOfTheDay,
                              usuals: usualMeals,
                              day: today,
                            ),
                            otherMealUsuals: mealEntries.usualsFromOtherMeals(
                              mealOfTheDay: mealOfTheDay,
                              usuals: usualMeals,
                              day: today,
                            ),
```

- [ ] **Step 5: Analyze the changed files**

Run: `fvm flutter analyze lib/app/feature/today/widgets/meal_log_section.dart lib/app/feature/today/view/today_view.dart`
Expected: No errors.

- [ ] **Step 6: Run the full test suite for regressions**

Run: `fvm flutter test`
Expected: No new failures versus the baseline (the pre-existing `RenderFlex` overflow failures in `dev_tools_view_test` / `build_usuals_view_test` etc. are unrelated to this work). No test references the removed cross-post behavior.

- [ ] **Step 7: Manual verification (ask Jacob to run the app)**

Ask Jacob to load sample history from Dev Tools, then on Today confirm:

- Each meal section's chips are only that meal's usuals, ordered most-recent-here then by frequency, in the three-row horizontal scroll.
- A "From another meal" button appears under the chips (when other meals have usuals); tapping it opens the "Log to {meal}" sheet grouped by meal.
- Tapping a usual in the sheet logs it into the current section and closes the sheet.
- A usual already logged in this section today doesn't appear as a chip or in the picker for that section.

- [ ] **Step 8: Stage and request commit**

Stage the two files. Do not commit. Suggest:

```
feat: add "from another meal" button to Today meal sections
```

---

## Self-Review

**Spec coverage:**

- Chips this-meal only, recency→frequency, filter kept, layout unchanged → Task 1 (`orderedQuickPicks` trim) + Task 3 keeps `_QuickPickColumns`.
- `usualsFromOtherMeals` grouping/order/filter/omit-empty → Task 1 + its tests.
- "From another meal" button shown only when non-empty, opens sheet → Task 3 Step 3.
- `OtherMealUsualsSheet` logs to current section and closes; grouped, library order, log-and-close → Task 2.
- Data computed in `today_view` `BlocSelector` builders → Task 3 Step 4.
- Files: extension, section, view, new sheet + barrel → Tasks 1-3.

**Placeholder scan:** No TBD/TODO/vague steps; every code step shows full code. The stale cross-post doc on `_QuickPickColumns` is explicitly fixed in Task 3 Step 2.

**Type consistency:** `usualsFromOtherMeals` returns `Map<MealOfTheDay, List<UsualMeal>>` in Task 1, consumed as `otherMealUsuals` (same type) by `MealLogSection` (Task 3) and as `usualsByMeal` by `OtherMealUsualsSheet` (Task 2). `orderedQuickPicks` signature is unchanged from its existing call site. `OtherMealUsualsSheet({mealOfTheDay, usualsByMeal})` matches between definition (Task 2) and use (Task 3 Step 3).
