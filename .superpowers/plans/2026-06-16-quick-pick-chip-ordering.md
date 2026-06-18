# Quick-Pick Chip Ordering & Layout Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** On the Today view, order meal quick-pick chips by recency then frequency then cross-timing, and lay them out in three rows that scroll horizontally once full.

**Architecture:** A pure `orderedQuickPicks` extension on `List<MealLogEntry>` computes the filtered, tiered chip list from log history plus the usuals map. `today_view.dart` calls it per timing (inside the existing `BlocSelector` builders) and passes the ordered list into `MealLogSection`, which renders it as columns-of-three inside a horizontal scroll view.

**Tech Stack:** Flutter, Dart 3, `freezed` models, `flutter_bloc`, `flutter_test`.

## Global Constraints

- Use `fvm flutter` for all Flutter CLI commands, never bare `flutter`.
- Never run the app or `git commit`/`git push`. Stage changes and ask Jacob to commit with the suggested message.
- The code generator (build_runner) is always watching in the background — do not run it. These changes add no new `freezed`/`json` annotations, so no generation is needed.
- Always use barrel imports (`package:the_usual/app/app.dart`), not direct file imports.
- Name variables after the full model type they hold (`usualMeal`, `mealOfTheDay`, `mealLogEntry`), never short forms.
- Use matchers in tests (`equals()`, `isFalse`, etc.), never raw assertions.
- Get bloc instances via `getIt<T>()` in views.

---

### Task 1: `orderedQuickPicks` ordering helper

**Files:**
- Modify: `lib/app/model/extensions/meal_log_entry_list_extensions.dart`
- Test: `test/app/model/extensions/meal_log_entry_list_extensions_test.dart`

**Interfaces:**
- Consumes: `MealLogEntry` (fields `loggedAt`, `mealOfTheDay`, `name`, `usualMealId`), `UsualMeal` (fields `id`, `name`), `MealOfTheDay`, all from `package:the_usual/app/app.dart`.
- Produces: `List<UsualMeal> orderedQuickPicks({required MealOfTheDay mealOfTheDay, required Map<MealOfTheDay, List<UsualMeal>> usuals, required DateTime day})` as an extension method on `List<MealLogEntry>`. Returns usuals filtered (those logged today for `mealOfTheDay` removed) and ordered: most-recent this-timing usual, then this-timing usuals by log count at this timing, then other-timing usuals by overall log count.

- [ ] **Step 1: Write the failing tests**

Add this group inside the existing `main()` in `test/app/model/extensions/meal_log_entry_list_extensions_test.dart`, after the closing `}` of the existing `group('MealLogEntryListFormatting', ...)` body but before `main`'s closing brace:

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

    test('orders most recent, then by frequency, then other timings', () {
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
        logEntry(
          id: '5',
          loggedAt: DateTime(2026, 6, 9),
          mealOfTheDay: MealOfTheDay.dinner,
          usualMealId: 'pizza',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.map((usualMeal) => usualMeal.id).toList(),
        equals(['eggs', 'oatmeal', 'coffee', 'pizza']),
      );
    });

    test('drops a usual already logged today for this timing by id', () {
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

      expect(
        picks.any((usualMeal) => usualMeal.id == 'eggs'),
        isFalse,
      );
    });

    test('drops a usual already logged today for this timing by name', () {
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

      expect(
        picks.any((usualMeal) => usualMeal.id == 'oatmeal'),
        isFalse,
      );
    });

    test('includes other-timing usuals as cross-post options', () {
      final picks = <MealLogEntry>[].orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.any((usualMeal) => usualMeal.id == 'pizza'),
        isTrue,
      );
    });

    test('hides a cross-posted usual once logged today for this timing', () {
      final entries = [
        logEntry(
          id: '1',
          loggedAt: DateTime(2026, 6, 16, 8),
          mealOfTheDay: MealOfTheDay.breakfast,
          name: 'Pizza',
          usualMealId: 'pizza',
        ),
      ];

      final picks = entries.orderedQuickPicks(
        mealOfTheDay: MealOfTheDay.breakfast,
        usuals: usuals,
        day: day,
      );

      expect(
        picks.any((usualMeal) => usualMeal.id == 'pizza'),
        isFalse,
      );
    });
  });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: FAIL — `The method 'orderedQuickPicks' isn't defined for the type 'List<MealLogEntry>'`.

- [ ] **Step 3: Implement `orderedQuickPicks`**

In `lib/app/model/extensions/meal_log_entry_list_extensions.dart`, add this method inside the `extension MealLogEntryListFormatting on List<MealLogEntry>` block (after `breakdownOn`, before the extension's closing `}`):

```dart
  /// The user's usuals ordered for [mealOfTheDay]'s quick-pick chips: the most
  /// recently logged usual for this timing first, then this timing's usuals by
  /// how often they've been logged here, then usuals from other timings as
  /// cross-post options. Usuals already logged on [day] for [mealOfTheDay] are
  /// dropped, matched by name or linked id so a renamed usual stays hidden.
  List<UsualMeal> orderedQuickPicks({
    required MealOfTheDay mealOfTheDay,
    required Map<MealOfTheDay, List<UsualMeal>> usuals,
    required DateTime day,
  }) {
    final loggedTodayNames = <String>{};
    final loggedTodayIds = <String>{};
    final countAtTiming = <String, int>{};
    final lastLoggedAtTiming = <String, DateTime>{};
    final countOverall = <String, int>{};
    final lastLoggedOverall = <String, DateTime>{};

    for (final mealLogEntry in this) {
      final usualMealId = mealLogEntry.usualMealId;
      if (usualMealId != null) {
        countOverall.update(
          usualMealId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
        final lastOverall = lastLoggedOverall[usualMealId];
        if (lastOverall == null || mealLogEntry.loggedAt.isAfter(lastOverall)) {
          lastLoggedOverall[usualMealId] = mealLogEntry.loggedAt;
        }
        if (mealLogEntry.mealOfTheDay == mealOfTheDay) {
          countAtTiming.update(
            usualMealId,
            (count) => count + 1,
            ifAbsent: () => 1,
          );
          final lastAtTiming = lastLoggedAtTiming[usualMealId];
          if (lastAtTiming == null ||
              mealLogEntry.loggedAt.isAfter(lastAtTiming)) {
            lastLoggedAtTiming[usualMealId] = mealLogEntry.loggedAt;
          }
        }
      }

      final loggedTodayForThisMeal =
          mealLogEntry.mealOfTheDay == mealOfTheDay &&
          DateUtils.isSameDay(mealLogEntry.loggedAt, day);
      if (loggedTodayForThisMeal) {
        loggedTodayNames.add(mealLogEntry.name.toLowerCase());
        if (usualMealId != null) loggedTodayIds.add(usualMealId);
      }
    }

    bool isVisible(UsualMeal usualMeal) {
      final loggedByName = loggedTodayNames.contains(
        usualMeal.name.toLowerCase(),
      );
      final loggedById = loggedTodayIds.contains(usualMeal.id);
      return !loggedByName && !loggedById;
    }

    final thisTimingUsuals = (usuals[mealOfTheDay] ?? <UsualMeal>[])
        .where(isVisible)
        .toList();

    final otherTimingUsuals = <UsualMeal>[];
    for (final timing in MealOfTheDay.values) {
      if (timing == mealOfTheDay) continue;
      for (final usualMeal in usuals[timing] ?? <UsualMeal>[]) {
        if (isVisible(usualMeal)) otherTimingUsuals.add(usualMeal);
      }
    }

    UsualMeal? mostRecent;
    for (final usualMeal in thisTimingUsuals) {
      final loggedAt = lastLoggedAtTiming[usualMeal.id];
      if (loggedAt == null) continue;
      final currentBest = mostRecent == null
          ? null
          : lastLoggedAtTiming[mostRecent.id];
      if (currentBest == null || loggedAt.isAfter(currentBest)) {
        mostRecent = usualMeal;
      }
    }

    final remainingThisTiming = thisTimingUsuals
        .where((usualMeal) => usualMeal.id != mostRecent?.id)
        .toList();
    _sortByLogActivity(remainingThisTiming, countAtTiming, lastLoggedAtTiming);
    _sortByLogActivity(otherTimingUsuals, countOverall, lastLoggedOverall);

    return [
      if (mostRecent != null) mostRecent,
      ...remainingThisTiming,
      ...otherTimingUsuals,
    ];
  }
```

Then add this private top-level function at the bottom of the same file (outside the extension), and add the `UsualMeal`/`MealOfTheDay` import via the existing `package:the_usual/app/model/model.dart` import already at the top of the file:

```dart
/// Sorts [usualMeals] in place by log [counts] descending, breaking ties by
/// most recent in [lastLogged], then by their original order in the list.
void _sortByLogActivity(
  List<UsualMeal> usualMeals,
  Map<String, int> counts,
  Map<String, DateTime> lastLogged,
) {
  final originalIndex = {
    for (final (index, usualMeal) in usualMeals.indexed) usualMeal.id: index,
  };
  usualMeals.sort((a, b) {
    final countComparison = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
    if (countComparison != 0) return countComparison;

    final lastA = lastLogged[a.id];
    final lastB = lastLogged[b.id];
    if (lastA != null && lastB != null && lastA != lastB) {
      return lastB.compareTo(lastA);
    }
    if (lastA == null && lastB != null) return 1;
    if (lastA != null && lastB == null) return -1;

    return originalIndex[a.id]!.compareTo(originalIndex[b.id]!);
  });
}
```

Note: the file already imports `package:flutter/material.dart` (for `DateUtils`) and `package:the_usual/app/model/model.dart` (which exports `UsualMeal` and `MealOfTheDay`), so no new imports are needed.

- [ ] **Step 4: Run the tests to verify they pass**

Run: `fvm flutter test test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: PASS — all five `orderedQuickPicks` tests plus the existing tests pass.

- [ ] **Step 5: Analyze the changed files**

Run: `fvm flutter analyze lib/app/model/extensions/meal_log_entry_list_extensions.dart test/app/model/extensions/meal_log_entry_list_extensions_test.dart`
Expected: No errors (info/warning-level lints may be ignored per project rules).

- [ ] **Step 6: Stage and request commit**

Stage the two files. Do not commit. Tell Jacob the change and suggest:

```
feat: add orderedQuickPicks for tiered meal chip ordering
```

---

### Task 2: Wire ordering into Today view and render three-row column layout

**Files:**
- Modify: `lib/app/feature/today/view/today_view.dart:150-161`
- Modify: `lib/app/feature/today/widgets/meal_log_section.dart`

**Interfaces:**
- Consumes: `List<MealLogEntry>.orderedQuickPicks(...)` from Task 1.
- Produces: `MealLogSection` now takes `required List<UsualMeal> quickPicks` (already filtered and ordered) instead of `required List<UsualMeal> usualMeals`. It no longer filters or orders internally.

- [ ] **Step 1: Change `MealLogSection`'s parameter to the pre-ordered list**

In `lib/app/feature/today/widgets/meal_log_section.dart`, replace the constructor field `usualMeals` and its doc with `quickPicks`:

Replace:
```dart
    required this.mealLogEntries,
    required this.usualMeals,
    required this.isCurrent,
```
with:
```dart
    required this.mealLogEntries,
    required this.quickPicks,
    required this.isCurrent,
```

Replace:
```dart
  /// The user's usual meals for this meal.
  final List<UsualMeal> usualMeals;
```
with:
```dart
  /// The user's usuals offered as quick picks for this meal, already filtered
  /// and ordered (most recent, then most logged here, then other timings).
  final List<UsualMeal> quickPicks;
```

- [ ] **Step 2: Remove the in-widget filtering and the TODO**

In the same file's `build`, delete this block entirely (lines that compute `loggedNames`, `loggedUsualMealIds`, the `TODO(today)` comment, and `quickPicks`):

```dart
    final loggedNames = mealLogEntries
        .map((mealLogEntry) => mealLogEntry.name.toLowerCase())
        .toSet();
    final loggedUsualMealIds = mealLogEntries
        .map((mealLogEntry) => mealLogEntry.usualMealId)
        .whereType<String>()
        .toSet();
    // TODO(today): order quick picks with the most recently logged usual meal
    // first, then by how often each has been logged. Compute this from log
    // history in the bloc/state, not here — it shouldn't recompute on every
    // build.
    final quickPicks = usualMeals.where((usualMeal) {
      // A logged entry keeps its original name, so after a rename match on the
      // linked id too, otherwise the renamed usual reappears as a quick pick.
      final alreadyLoggedByName = loggedNames.contains(
        usualMeal.name.toLowerCase(),
      );
      final alreadyLoggedById = loggedUsualMealIds.contains(usualMeal.id);
      return !alreadyLoggedByName && !alreadyLoggedById;
    }).toList();
```

The line `final nutrition = mealLogEntries.totalNutrition;` directly above it stays.

- [ ] **Step 3: Swap the `Wrap` for the column-fill layout**

In the same file, replace this block:

```dart
                    if (quickPicks.isNotEmpty) ...[
                      SizedBox(height: AppDesign.spacing.md),
                      Wrap(
                        spacing: AppDesign.spacing.sm,
                        runSpacing: AppDesign.spacing.sm,
                        children: [
                          for (final usualMeal in quickPicks)
                            _QuickPickChip(
                              label: '+ ${usualMeal.name}',
                              onPressed: () => getIt<DailyLogBloc>().add(
                                DailyLogEvent.mealLogged(
                                  mealOfTheDay,
                                  usualMeal.name,
                                  nutrition: usualMeal.nutrition,
                                  usualMealId: usualMeal.id,
                                  photoPath: usualMeal.photoPath,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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
```

- [ ] **Step 4: Add the `_QuickPickColumns` widget**

In the same file, add this private widget class above the existing `_QuickPickChip` class:

```dart
/// Lays the quick picks into columns of up to three chips, filling top to
/// bottom then spilling rightward in a horizontal scroll view. Tapping a chip
/// logs that usual under [mealOfTheDay] — the section it sits in — so a usual
/// from another timing cross-posts to this meal.
class _QuickPickColumns extends StatelessWidget {
  const _QuickPickColumns({required this.mealOfTheDay, required this.quickPicks});

  /// The meal a tapped chip logs under.
  final MealOfTheDay mealOfTheDay;

  /// The usuals to offer, already filtered and ordered.
  final List<UsualMeal> quickPicks;

  static const _rowsPerColumn = 3;

  @override
  Widget build(BuildContext context) {
    final columns = <List<UsualMeal>>[];
    for (var start = 0; start < quickPicks.length; start += _rowsPerColumn) {
      final end = (start + _rowsPerColumn).clamp(0, quickPicks.length);
      columns.add(quickPicks.sublist(start, end));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (columnIndex, column) in columns.indexed) ...[
            if (columnIndex > 0) SizedBox(width: AppDesign.spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (rowIndex, usualMeal) in column.indexed) ...[
                  if (rowIndex > 0) SizedBox(height: AppDesign.spacing.sm),
                  _QuickPickChip(
                    label: '+ ${usualMeal.name}',
                    onPressed: () => getIt<DailyLogBloc>().add(
                      DailyLogEvent.mealLogged(
                        mealOfTheDay,
                        usualMeal.name,
                        nutrition: usualMeal.nutrition,
                        usualMealId: usualMeal.id,
                        photoPath: usualMeal.photoPath,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
```

- [ ] **Step 5: Pass the ordered picks from `today_view.dart`**

In `lib/app/feature/today/view/today_view.dart`, replace this argument in the `MealLogSection` constructor (around line 156):

```dart
                            usualMeals:
                                usualMeals[mealOfTheDay] ?? <UsualMeal>[],
```

with:

```dart
                            quickPicks: mealEntries.orderedQuickPicks(
                              mealOfTheDay: mealOfTheDay,
                              usuals: usualMeals,
                              day: today,
                            ),
```

`mealEntries`, `usualMeals` (the full map), and `today` are all already in scope in that builder.

- [ ] **Step 6: Analyze the changed files**

Run: `fvm flutter analyze lib/app/feature/today/view/today_view.dart lib/app/feature/today/widgets/meal_log_section.dart`
Expected: No errors.

- [ ] **Step 7: Run the full test suite for regressions**

Run: `fvm flutter test`
Expected: PASS — no existing tests reference the removed `usualMeals` parameter of `MealLogSection`. If any do, update them to pass `quickPicks` (an already-ordered `List<UsualMeal>`).

- [ ] **Step 8: Manual verification (ask Jacob to run the app)**

Ask Jacob to run the app from VS Code and confirm on the Today view:
- Each meal section shows chips ordered: most-recently-logged-for-that-meal first, then most-logged, then usuals from other meals.
- Tapping a chip from another timing logs it under the current section.
- A logged usual's chip disappears from that section.
- With more than three chips, they fill three rows then scroll horizontally.

- [ ] **Step 9: Stage and request commit**

Stage the two files. Do not commit. Tell Jacob the change and suggest:

```
feat: order today quick-pick chips and scroll them in three rows
```

---

## Self-Review

**Spec coverage:**
- Ordering tiers (recent → frequent → other timings) → Task 1 `orderedQuickPicks` + test "orders most recent, then by frequency, then other timings".
- Already-logged-today filter, by name and id, including rename resolution → Task 1 tests for id and name.
- Cross-timing inclusion and cross-post hide-after-log → Task 1 tests "includes other-timing usuals" and "hides a cross-posted usual once logged".
- Cross-post tapping logs to the section's timing → Task 2 `_QuickPickColumns` passes `mealOfTheDay`.
- Three-row column-fill horizontal scroll → Task 2 Step 4 `_QuickPickColumns`.
- Compute outside the per-section build → Task 2 Step 5 computes in the `today_view` `BlocSelector` builder.
- Scope limited to Today view → no onboarding/settings tasks. Confirmed.

**Placeholder scan:** No TBD/TODO/"handle edge cases" left; every code step shows full code. The original in-widget `TODO(today)` is explicitly deleted in Task 2 Step 2.

**Type consistency:** `orderedQuickPicks` signature is identical in Task 1's Produces block, its implementation, and the Task 2 Step 5 call site. `MealLogSection.quickPicks` (`List<UsualMeal>`) matches between Task 2 Steps 1, 3, and 5. `_QuickPickColumns({mealOfTheDay, quickPicks})` matches between its definition (Step 4) and use (Step 3).
