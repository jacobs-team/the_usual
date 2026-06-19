# Today Date Navigation + Multi-Day Logging Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the Today view's static "Today" app-bar title into a date pill that opens the native date-range picker, so the user can view and edit any day's log, and bulk-log a meal or weigh-in across every day in a selected range.

**Architecture:** A nullable `DateTimeRange? _selectedRange` held in `TodayView`'s state (`null` = the live today view). From it the view derives the displayed day, the list of days each log writes to, and whether the current-meal highlight shows. The single-day logging plumbing that History already uses (`mealLogged(day:, dayStart:)`, `weightOnDayChanged(day:)`) is widened from one day to a list of days at the widget layer; no new BLoC events or persisted state.

**Tech Stack:** Flutter, flutter_bloc, freezed, `intl` (`DateFormat`), `mocktail` + `bloc_test`, `fvm flutter` for all CLI.

## Global Constraints

- Use `fvm flutter` for every Flutter CLI command.
- Always use barrel files (`package:the_usual/app/app.dart`) over direct imports.
- The freezed/json_serializable/injectable code generator runs in the background (watch mode). Do not invoke it; if it is not running, ask the developer.
- Do not run the app. Ask the developer to run it for manual verification.
- Tests: use matchers (`equals`, `isNull`, `isTrue`, etc.), never raw assertions. Prefer `isA<...>().having` over whole-state matches. Locate widgets by type/key/icon, not by UI strings. Run tests with random seed ordering: `--test-randomize-ordering-seed random`.
- Do not run `git commit` / `git push`. Where a step says "Commit", stage nothing and instead tell the developer exactly what changed with a suggested message; the developer commits.
- Naming: variables hold the full model-type name (`mealOfTheDay`, not `meal`).
- This feature touches NO persisted shape (`_selectedRange` is ephemeral view state). No migration needed.

---

## File Structure

- `lib/app/core/extensions/day_boundary.dart` — add a `DateTimeRange` extension that enumerates the inclusive logical days a range spans.
- `lib/app/widgets/display/the_usual_app_bar.dart` — add an optional title-widget slot.
- `lib/app/feature/today/widgets/meal_log_section.dart` — `day` → `logDays` (list), loop the logging dispatch.
- `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart` — `day` → `logDays` (list), loop the dispatch.
- `lib/app/widgets/inputs/weight_entry_field.dart` — `day` → `days` (list); read from first, write to each.
- `lib/app/feature/history/widgets/history_meal_sheet.dart` — pass `logDays: [day]`.
- `lib/app/feature/history/view/history_view.dart` — pass `days: [historyDay.day]`.
- `lib/app/feature/today/view/today_view.dart` — selected-range state, derived day/logDays/highlight, the date pill + picker, wiring.
- Test files mirror each of the above under `test/`.

---

## Task 1: `DateTimeRange.logicalDays` extension

Enumerate the inclusive calendar days a range spans, each as a date-only
`DateTime`, so the Today view can fan a log out across a multi-day range.

**Files:**
- Modify: `lib/app/core/extensions/day_boundary.dart`
- Test: `test/app/core/extensions/day_boundary_test.dart` (create if absent; otherwise add the group)

**Interfaces:**
- Produces: `extension LogicalDaysInRange on DateTimeRange { List<DateTime> get logicalDays; }` — returns date-only `DateTime`s from `start` to `end` inclusive; a single-day range (start and end on the same calendar day) returns one element.

- [ ] **Step 1: Write the failing test**

Create/append `test/app/core/extensions/day_boundary_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

void main() {
  group('DateTimeRange.logicalDays', () {
    test('returns one date-only day for a single-day range', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 17, 9),
        end: DateTime(2026, 6, 17, 22),
      );

      expect(range.logicalDays, equals([DateTime(2026, 6, 17)]));
    });

    test('returns every day from start to end inclusive', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 15),
        end: DateTime(2026, 6, 18),
      );

      expect(
        range.logicalDays,
        equals([
          DateTime(2026, 6, 15),
          DateTime(2026, 6, 16),
          DateTime(2026, 6, 17),
          DateTime(2026, 6, 18),
        ]),
      );
    });

    test('crosses a month boundary correctly', () {
      final range = DateTimeRange(
        start: DateTime(2026, 6, 30),
        end: DateTime(2026, 7, 2),
      );

      expect(
        range.logicalDays,
        equals([
          DateTime(2026, 6, 30),
          DateTime(2026, 7, 1),
          DateTime(2026, 7, 2),
        ]),
      );
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/core/extensions/day_boundary_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `logicalDays` is not defined on `DateTimeRange`.

- [ ] **Step 3: Add the extension**

Append to `lib/app/core/extensions/day_boundary.dart`:

```dart
/// Calendar-day expansion of a date range.
extension LogicalDaysInRange on DateTimeRange {
  /// Every day this range covers, from [start] to [end] inclusive, each
  /// returned date-only (midnight) so it can key a day bucket or stamp an
  /// entry. A range whose [start] and [end] fall on the same day yields one.
  List<DateTime> get logicalDays {
    final firstDay = DateUtils.dateOnly(start);
    final lastDay = DateUtils.dateOnly(end);
    final dayCount = lastDay.difference(firstDay).inDays;
    return [
      for (var offset = 0; offset <= dayCount; offset++)
        DateTime(firstDay.year, firstDay.month, firstDay.day + offset),
    ];
  }
}
```

(`DateTime(y, m, day + offset)` normalizes overflow across month boundaries, so DST does not skew the count the way adding `Duration(days:)` can.)

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/core/extensions/day_boundary_test.dart --test-randomize-ordering-seed random`
Expected: PASS (3 tests).

- [ ] **Step 5: Commit**

Tell the developer to commit. Changed: `lib/app/core/extensions/day_boundary.dart`, `test/app/core/extensions/day_boundary_test.dart`.
Suggested message: `feat: add DateTimeRange.logicalDays for multi-day expansion`

---

## Task 2: Fan meal logging across a list of days

Widen `MealLogSection` and `OtherMealUsualsSheet` from a single optional `day`
to an optional `logDays` list, dispatching one `mealLogged` per day. `null`
keeps the live-today behavior (`day: null` → `clock.now()`).

**Files:**
- Modify: `lib/app/feature/today/widgets/meal_log_section.dart`
- Modify: `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`
- Modify: `lib/app/feature/history/widgets/history_meal_sheet.dart:50-71`
- Test: `test/app/feature/today/widgets/meal_log_section_test.dart`
- Test: `test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart`

**Interfaces:**
- Consumes: `DateTimeRange.logicalDays` (Task 1) — used by callers, not here.
- Produces:
  - `MealLogSection({..., List<DateTime>? logDays, TimeOfDay? dayStart, ...})` — `logDays` null logs live to today; non-null logs one entry per listed day stamped via `dayStart`.
  - `OtherMealUsualsSheet({..., List<DateTime>? logDays, TimeOfDay? dayStart})` — same semantics.

- [ ] **Step 1: Update the `MealLogSection` tests to the new API and add a multi-day test**

In `test/app/feature/today/widgets/meal_log_section_test.dart`:

Change the `pumpSection` signature and the widget call from `DateTime? day` to `List<DateTime>? logDays`:

```dart
    Future<void> pumpSection(
      WidgetTester tester, {
      List<MealLogEntry> mealLogEntries = const [],
      List<UsualMeal> quickPicks = const [],
      Map<MealOfTheDay, List<UsualMeal>> otherMealUsuals = const {},
      bool isCurrent = false,
      bool nutritionExpandedByDefault = false,
      List<DateTime>? logDays,
      TimeOfDay? dayStart,
    }) {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        CustomScrollView(
          slivers: [
            MealLogSection(
              mealOfTheDay: MealOfTheDay.breakfast,
              mealLogEntries: mealLogEntries,
              quickPicks: quickPicks,
              otherMealUsuals: otherMealUsuals,
              isCurrent: isCurrent,
              nutritionExpandedByDefault: nutritionExpandedByDefault,
              logDays: logDays,
              dayStart: dayStart,
            ),
          ],
        ),
      );
    }
```

In the existing `'forwards day and dayStart when logging a quick pick'` test, change the pump args from `day: DateTime(2026, 6, 16),` to `logDays: [DateTime(2026, 6, 16)],` (leave the `verify(... day: DateTime(2026, 6, 16), dayStart: ...)` block unchanged — one day still produces one event).

Add a new test after it:

```dart
    testWidgets('logs a quick pick onto every day in a multi-day range', (
      tester,
    ) async {
      await pumpSection(
        tester,
        quickPicks: const [
          UsualMeal(
            id: 'u',
            name: 'Oatmeal',
            nutrition: Nutrition(calories: 300),
          ),
        ],
        logDays: [DateTime(2026, 6, 15), DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(find.text('+ Oatmeal'));

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: const Nutrition(calories: 300),
            usualMealId: 'u',
            day: DateTime(2026, 6, 15),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.breakfast,
            'Oatmeal',
            nutrition: const Nutrition(calories: 300),
            usualMealId: 'u',
            day: DateTime(2026, 6, 16),
            dayStart: const TimeOfDay(hour: 4, minute: 0),
          ),
        ),
      ).called(1);
    });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `MealLogSection` has no `logDays` parameter.

- [ ] **Step 3: Rewrite `MealLogSection` to take `logDays` and fan the dispatch**

In `lib/app/feature/today/widgets/meal_log_section.dart`:

Replace the `day` field (lines 45-47) and its doc with:

```dart
  /// The days meals logged from this section are recorded onto. Null logs to
  /// today (stamped at the current time); a single-element list logs to one
  /// day (the History view), and a multi-day list bulk-logs the same entry
  /// onto every day in the range.
  final List<DateTime>? logDays;
```

(Keep the `dayStart` field and its doc as-is.)

Add this private method to the class (it has several callers below — the quick-pick chip and each food from the "Something else" sheet — so it is not a single-use extraction):

```dart
  /// Logs [name] under [mealOfTheDay] onto every day in [logDays], or to today
  /// when [logDays] is null.
  void _logOntoTargetDays(
    MealOfTheDay mealOfTheDay,
    String name, {
    Nutrition nutrition = const Nutrition(),
    double quantity = 1,
    String? usualMealId,
    String? photoPath,
  }) {
    final targetDays = logDays;
    final dailyLogBloc = getIt<DailyLogBloc>();
    if (targetDays == null) {
      dailyLogBloc.add(
        DailyLogEvent.mealLogged(
          mealOfTheDay,
          name,
          nutrition: nutrition,
          quantity: quantity,
          usualMealId: usualMealId,
          photoPath: photoPath,
        ),
      );
      return;
    }
    for (final day in targetDays) {
      dailyLogBloc.add(
        DailyLogEvent.mealLogged(
          mealOfTheDay,
          name,
          nutrition: nutrition,
          quantity: quantity,
          usualMealId: usualMealId,
          photoPath: photoPath,
          day: day,
          dayStart: dayStart,
        ),
      );
    }
  }
```

Change the quick-pick chip `onPressed` (was lines 132-142) to:

```dart
                              onPressed: () => _logOntoTargetDays(
                                mealOfTheDay,
                                usualMeal.name,
                                nutrition: usualMeal.nutrition,
                                usualMealId: usualMeal.id,
                                photoPath: usualMeal.photoPath,
                              ),
```

Change the "Something else" per-food dispatch (was lines 181-190) to:

```dart
                              _logOntoTargetDays(
                                mealOfTheDay,
                                foodResult.name,
                                nutrition: foodResult.nutrition,
                                quantity: foodResult.quantity,
                              );
```

Change the `OtherMealUsualsSheet` construction (was lines 200-205) to forward `logDays`:

```dart
                              builder: (_) => OtherMealUsualsSheet(
                                mealOfTheDay: mealOfTheDay,
                                usualsByMeal: otherMealUsuals,
                                logDays: logDays,
                                dayStart: dayStart,
                              ),
```

- [ ] **Step 4: Update `OtherMealUsualsSheet` to take `logDays` and fan the dispatch**

In `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`:

Replace the `day` field (lines 26-28) and its doc with:

```dart
  /// The days a tapped usual is logged onto. Null logs to today; a multi-day
  /// list logs the usual onto every day in the range.
  final List<DateTime>? logDays;
```

Replace the card `onTap` (lines 57-70) with a loop:

```dart
                  onTap: () {
                    final dailyLogBloc = getIt<DailyLogBloc>();
                    final targetDays = logDays;
                    if (targetDays == null) {
                      dailyLogBloc.add(
                        DailyLogEvent.mealLogged(
                          mealOfTheDay,
                          usualMeal.name,
                          nutrition: usualMeal.nutrition,
                          usualMealId: usualMeal.id,
                          photoPath: usualMeal.photoPath,
                        ),
                      );
                    } else {
                      for (final day in targetDays) {
                        dailyLogBloc.add(
                          DailyLogEvent.mealLogged(
                            mealOfTheDay,
                            usualMeal.name,
                            nutrition: usualMeal.nutrition,
                            usualMealId: usualMeal.id,
                            photoPath: usualMeal.photoPath,
                            day: day,
                            dayStart: dayStart,
                          ),
                        );
                      }
                    }
                    Navigator.of(context).pop();
                  },
```

- [ ] **Step 5: Update `HistoryMealSheet` to pass a one-element `logDays`**

In `lib/app/feature/history/widgets/history_meal_sheet.dart`, change the `MealLogSection` arg (line 69) from `day: day,` to `logDays: [day],` (leave `dayStart: dayStart,`).

- [ ] **Step 6: Update the `OtherMealUsualsSheet` test to the new API and add a multi-day test**

In `test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart`:

Change `pumpSheet`'s `DateTime? day` parameter to `List<DateTime>? logDays`, and the widget's `day: day,` to `logDays: logDays,`.

In `'forwards day and dayStart when logging a usual'`, change the pump arg `day: DateTime(2026, 6, 16),` to `logDays: [DateTime(2026, 6, 16)],` (leave the verify unchanged).

Add a multi-day test:

```dart
    testWidgets('logs the tapped usual onto every day in a range', (
      tester,
    ) async {
      await pumpSheet(
        tester,
        const {
          MealOfTheDay.lunch: [
            UsualMeal(
              id: 'u',
              name: 'Salad',
              nutrition: Nutrition(calories: 250),
            ),
          ],
        },
        logDays: [DateTime(2026, 6, 15), DateTime(2026, 6, 16)],
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      );

      await tester.tap(find.text('Salad'));
      await tester.pumpAndSettle();

      for (final day in [DateTime(2026, 6, 15), DateTime(2026, 6, 16)]) {
        verify(
          () => dailyLogBloc.add(
            DailyLogEvent.mealLogged(
              MealOfTheDay.breakfast,
              'Salad',
              nutrition: const Nutrition(calories: 250),
              usualMealId: 'u',
              day: day,
              dayStart: const TimeOfDay(hour: 4, minute: 0),
            ),
          ),
        ).called(1);
      }
    });
```

- [ ] **Step 7: Run the affected tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart test/app/feature/history/widgets/history_meal_sheet_test.dart --test-randomize-ordering-seed random`
Expected: PASS (existing tests + the two new multi-day tests). `history_meal_sheet_test` still passes because one day yields one event.

- [ ] **Step 8: Commit**

Tell the developer to commit. Changed: `meal_log_section.dart`, `cross_meal_picker_sheet.dart`, `history_meal_sheet.dart`, and the two today widget test files.
Suggested message: `feat: fan meal logging across a list of days`

---

## Task 3: Fan weight logging across a list of days

Widen `WeightEntryField` from a single `day` to a `days` list: it displays and
prefills from the first day and writes the entered weight to every day.

**Files:**
- Modify: `lib/app/widgets/inputs/weight_entry_field.dart`
- Modify: `lib/app/feature/history/view/history_view.dart:450`
- Modify: `lib/app/feature/today/view/today_view.dart:242` (inside `_WeightTracker`)
- Test: `test/app/widgets/weight_entry_field_test.dart`

**Interfaces:**
- Produces: `WeightEntryField({required List<DateTime> days, bool showLastWeightButton})` — reads/prefills the weigh-in for `days.first`; typing/clearing/"Use last" dispatches `weightOnDayChanged` once per day in `days`.

- [ ] **Step 1: Update the `WeightEntryField` tests to the new API and add a multi-day test**

In `test/app/widgets/weight_entry_field_test.dart`, change every `WeightEntryField(day: day` to `WeightEntryField(days: [day]` (7 call sites at lines 47, 59, 81, 104, 128, 147, 176 — keep the trailing `, showLastWeightButton: true)` where present). Leave the `verify(... weightOnDayChanged(day, ...))` blocks unchanged.

Add a multi-day test:

```dart
    testWidgets('typing a weight writes it to every day in the range', (
      tester,
    ) async {
      final days = [DateTime(2026, 6, 15), DateTime(2026, 6, 16)];
      final dailyLogBloc = dailyLogBlocWith([]);
      await tester.pumpPumpPumpItUP(
        WeightEntryField(days: days),
        deps: [dailyLogBloc],
      );

      await tester.enterText(find.byType(TextField), '170');
      await tester.pump();

      for (final day in days) {
        verify(
          () => dailyLogBloc.add(
            DailyLogEvent.weightOnDayChanged(day, 170, WeightUnit.lb, dayStart),
          ),
        ).called(1);
      }
    });
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `fvm flutter test test/app/widgets/weight_entry_field_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `WeightEntryField` has no `days` parameter.

- [ ] **Step 3: Rewrite `WeightEntryField` to take `days`**

In `lib/app/widgets/inputs/weight_entry_field.dart`:

Update the doc `{@template}` first sentence to read "for a range of days" and replace the `day` field (lines 23-25) with:

```dart
  /// The days whose weigh-in this field edits. The field displays and prefills
  /// the weigh-in for the first day; entering or clearing a value writes it to
  /// every day, so a multi-day range logs the same weight across all of them.
  final List<DateTime> days;
```

Update the constructor param from `required this.day,` to `required this.days,`.

In `_WeightEntryFieldState`, introduce a `_displayDay` getter and replace `widget.day` usages with it:

```dart
  DateTime get _displayDay => widget.days.first;
```

- `initState` (line 44): `final dayWeight = _dailyLogBloc.state.weightOn(_displayDay, _dayStart);`
- `listenWhen` (lines 63-64): compare `previous.weightOn(_displayDay, _dayStart)` to `current.weightOn(_displayDay, _dayStart)`.
- listener body (line 66): `final dayWeight = state.weightOn(_displayDay, _dayStart);`
- selector (line 86): `(state.weightOn(_displayDay, _dayStart), state.latestWeight)`.

Replace the "Use last" `onPressed` (lines 120-127) with a per-day write:

```dart
                        onPressed: () {
                          for (final day in widget.days) {
                            _dailyLogBloc.add(
                              DailyLogEvent.weightOnDayChanged(
                                day,
                                latestWeight.weight,
                                latestWeight.weightUnit,
                                _dayStart,
                              ),
                            );
                          }
                        },
```

Replace the `onChanged` (lines 133-140) with a per-day write:

```dart
                onChanged: (value) {
                  for (final day in widget.days) {
                    _dailyLogBloc.add(
                      DailyLogEvent.weightOnDayChanged(
                        day,
                        double.tryParse(value),
                        weightUnit,
                        _dayStart,
                      ),
                    );
                  }
                },
```

- [ ] **Step 4: Update the History and Today call sites**

In `lib/app/feature/history/view/history_view.dart:450`, change `WeightEntryField(day: historyDay.day),` to `WeightEntryField(days: [historyDay.day]),`.

In `lib/app/feature/today/view/today_view.dart`, inside `_WeightTracker.build` (line 242), change `WeightEntryField(day: day, showLastWeightButton: true)` to `WeightEntryField(days: [day], showLastWeightButton: true)`. (Task 6 changes what `_WeightTracker` is given; this keeps it compiling with no behavior change for now.)

- [ ] **Step 5: Run the weight tests to verify they pass**

Run: `fvm flutter test test/app/widgets/weight_entry_field_test.dart --test-randomize-ordering-seed random`
Expected: PASS (existing tests + the new multi-day test).

- [ ] **Step 6: Commit**

Tell the developer to commit. Changed: `weight_entry_field.dart`, `history_view.dart`, `today_view.dart`, `weight_entry_field_test.dart`.
Suggested message: `feat: write weight entry across a list of days`

---

## Task 4: Optional title-widget slot on the shared app bar

Let `TheUsualAppBar` render a custom title widget (the date pill) while History
keeps its plain string title.

**Files:**
- Modify: `lib/app/widgets/display/the_usual_app_bar.dart`
- Test: `test/app/widgets/display/the_usual_app_bar_test.dart` (create if absent)

**Interfaces:**
- Produces: `TheUsualAppBar({required String title, Widget? titleWidget})` — renders `titleWidget` centered when non-null, otherwise `Text(title)`. `title` remains the semantic/fallback label.

- [ ] **Step 1: Write the failing test**

Create `test/app/widgets/display/the_usual_app_bar_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../helpers/helpers.dart';

void main() {
  group(TheUsualAppBar, () {
    testWidgets('renders the string title when no title widget is given', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'History')),
      );

      expect(find.text('History'), findsOneWidget);
    });

    testWidgets('renders the title widget when provided', (tester) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(
          appBar: TheUsualAppBar(
            title: 'Today',
            titleWidget: Icon(Icons.calendar_today, key: Key('custom-title')),
          ),
        ),
      );

      expect(find.byKey(const Key('custom-title')), findsOneWidget);
      expect(find.text('Today'), findsNothing);
    });
  });
}
```

(If `pumpPumpPumpItUP` requires a `deps:` list, pass `deps: const []`; confirm against `test/helpers/helpers.dart`.)

- [ ] **Step 2: Run the test to verify it fails**

Run: `fvm flutter test test/app/widgets/display/the_usual_app_bar_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `TheUsualAppBar` has no `titleWidget` parameter.

- [ ] **Step 3: Add the optional slot**

In `lib/app/widgets/display/the_usual_app_bar.dart`:

Update the constructor and add the field:

```dart
  const TheUsualAppBar({required this.title, this.titleWidget, super.key});

  /// The text shown centered in the bar when [titleWidget] is null. Always set
  /// as the semantic/fallback label even when a custom widget is supplied.
  final String title;

  /// A custom widget shown centered in place of [title], e.g. the Today view's
  /// tappable date pill.
  final Widget? titleWidget;
```

Change the `AppBar` title (line 26) to:

```dart
      title: titleWidget ?? Text(title),
```

- [ ] **Step 4: Run the test to verify it passes**

Run: `fvm flutter test test/app/widgets/display/the_usual_app_bar_test.dart --test-randomize-ordering-seed random`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

Tell the developer to commit. Changed: `the_usual_app_bar.dart`, `the_usual_app_bar_test.dart`.
Suggested message: `feat: add optional title widget to TheUsualAppBar`

---

## Task 5: Date pill + range picker wiring in the Today view

Hold the selected range, derive the displayed day / log targets / highlight,
render the tappable date pill, and feed everything through. This is the task
that turns the parts above into the feature.

**Files:**
- Modify: `lib/app/feature/today/view/today_view.dart`
- Test: `test/app/feature/today/view/today_view_test.dart`

**Interfaces:**
- Consumes: `DateTimeRange.logicalDays` (Task 1); `MealLogSection({logDays, dayStart})` (Task 2); `WeightEntryField({days})` (Task 3); `TheUsualAppBar({titleWidget})` (Task 4).

- [ ] **Step 1: Add the `intl` import and pill key, and the failing render test**

In `test/app/feature/today/view/today_view_test.dart`, add tests inside the group (the existing `find.text('Today')` test keeps passing because the pill contains a `Text('Today')`):

```dart
    testWidgets('shows a tappable date pill labelled Today by default', (
      tester,
    ) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      final pill = find.byKey(const Key('today-date-pill'));
      expect(pill, findsOneWidget);
      expect(
        find.descendant(of: pill, matching: find.text('Today')),
        findsOneWidget,
      );
    });

    testWidgets('opens the date picker when the pill is tapped', (
      tester,
    ) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      await tester.tap(find.byKey(const Key('today-date-pill')));
      await tester.pumpAndSettle();

      // The Material range picker surfaces a Save / cancel action; assert the
      // dialog opened by its date-range picker type.
      expect(find.byType(DateRangePickerDialog), findsOneWidget);
    });
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/view/today_view_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — no widget with key `today-date-pill`.

- [ ] **Step 3: Add the `intl` import and selected-range state**

In `lib/app/feature/today/view/today_view.dart`, add the import near the top (after the `flutter/material.dart` import):

```dart
import 'package:intl/intl.dart';
```

In `_TodayViewState`, add the field below `Timer? _refreshTimer;`:

```dart
  /// The day(s) the view shows and logs onto. Null is the live "today" view:
  /// it follows the clock and stamps entries at the current time. A non-null
  /// range is a specific single day (start == end) or a multi-day span the
  /// user picked, whose logs fan across every day in it.
  DateTimeRange? _selectedRange;
```

- [ ] **Step 4: Derive the displayed day, log targets, and highlight, and pass them through**

In `build` (currently lines 64-177), after `final currentMeal = ...` and inside the inner `DailyLogBloc` builder where `today`, `dayStartTime`, and `mealEntries` are in scope, compute the derived values. Replace the body that currently uses `today` so it uses `displayDay` / `logDays` / `isToday`.

Concretely, change the `UserSettingsBloc` selector builder region (lines 85-104) so that after `final today = now.logicalDay(dayStartTime);` you derive:

```dart
                final today = now.logicalDay(dayStartTime);
                final selectedRange = _selectedRange;
                final isToday = selectedRange == null;
                final displayDay = selectedRange == null
                    ? today
                    : DateUtils.dateOnly(selectedRange.start);
                final logDays = selectedRange?.logicalDays;
                final logDayStart = selectedRange == null ? null : dayStartTime;
```

Then within the `DailyLogBloc` builder, change `breakdownOn(today, dayStartTime)` to `breakdownOn(displayDay, dayStartTime)`, and:

- `_WeightTracker(day: today)` → `_WeightTracker(days: logDays ?? [today])`
- the four `MealLogSection`s: change `day: today,` in `orderedQuickPicks` / `usualsFromOtherMeals` (lines 151, 157) to `day: displayDay,`; set `isCurrent: isToday && mealOfTheDay == currentMeal,` (was `mealOfTheDay == currentMeal`); and add `logDays: logDays,` and `dayStart: logDayStart,` to each `MealLogSection`.

- [ ] **Step 5: Replace the app-bar title with the date pill**

Change the `Scaffold` `appBar` (line 69) from `const TheUsualAppBar(title: 'Today')` to a pill that reads the current selection and opens the picker. Because the pill needs `context`, `setState`, and the current `_selectedRange`, build it inline in `build` (do not pass `context` into a helper). Insert this just before `return Scaffold(` in `build`:

```dart
    final selectedRange = _selectedRange;
    final today = now.logicalDay(getIt<UserSettingsBloc>().state.dayStartTime);
    final pillLabel = _pillLabel(context, selectedRange, today);
```

Set the app bar to:

```dart
      appBar: TheUsualAppBar(
        title: 'Today',
        titleWidget: _DateNavigationPill(
          label: pillLabel,
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDateRange:
                  selectedRange ?? DateTimeRange(start: today, end: today),
            );
            if (picked == null) return;
            final startDay = DateUtils.dateOnly(picked.start);
            final endDay = DateUtils.dateOnly(picked.end);
            final isSingleToday =
                DateUtils.isSameDay(startDay, endDay) &&
                DateUtils.isSameDay(startDay, today);
            setState(() {
              _selectedRange = isSingleToday
                  ? null
                  : DateTimeRange(start: startDay, end: endDay);
            });
          },
        ),
      ),
```

Note: `now` is computed at the top of `build` (line 65). The duplicate `final today` here and inside the inner builder are both `now.logicalDay(dayStartTime)`; that is fine — the inner one reads `dayStartTime` from the settings selector, this one reads it from the bloc directly for the pill label. Keep both local and clear.

Add the label helper and the pill widget at the bottom of the file:

```dart
  /// The pill's label: "Today" for the live view, a single formatted date for
  /// one selected day, or a "start – end" span for a range.
  String _pillLabel(
    BuildContext context,
    DateTimeRange? selectedRange,
    DateTime today,
  ) {
    if (selectedRange == null) return 'Today';
    final monthDay = DateFormat.MMMd();
    final startLabel = monthDay.format(selectedRange.start);
    if (DateUtils.isSameDay(selectedRange.start, selectedRange.end)) {
      return startLabel;
    }
    return '$startLabel – ${monthDay.format(selectedRange.end)}';
  }
```

```dart
/// The tappable app-bar title on the Today view: a pill showing the current
/// day or range that opens the date picker when tapped.
class _DateNavigationPill extends StatelessWidget {
  const _DateNavigationPill({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppDesign.radius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: const Key('today-date-pill'),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesign.spacing.md,
            vertical: AppDesign.spacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: theme.textTheme.titleMedium),
              SizedBox(width: AppDesign.spacing.xs),
              const Icon(Icons.calendar_today, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 6: Update `_WeightTracker` to take a list of days**

In `lib/app/feature/today/view/today_view.dart`, change `_WeightTracker` from `final DateTime day;` to:

```dart
  /// The days whose weigh-in this field records. One day in the live/single-day
  /// view; every day in a selected range.
  final List<DateTime> days;
```

Update its constructor param to `required this.days,`, and in its `build` change `WeightEntryField(days: [day], showLastWeightButton: true)` (set in Task 3) to `WeightEntryField(days: days, showLastWeightButton: true)`.

- [ ] **Step 7: Run the Today view tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/view/today_view_test.dart --test-randomize-ordering-seed random`
Expected: PASS — existing tests plus the pill render and picker-open tests. (`DateRangePickerDialog` comes from `flutter/material.dart`, already imported in the test via the app barrel/Material.)

- [ ] **Step 8: Add a highlight-gating test**

The current-meal highlight should not show once a non-today day is selected.
The highlight lives on `MealLogSection.isCurrent`. Add a test that drives a
selection and asserts no section is current. Because driving the native picker
to a specific past date in a widget test is brittle, assert the simpler live
invariant and leave the selected-state highlight to manual verification:

```dart
    testWidgets('highlights the current meal in the live today view', (
      tester,
    ) async {
      stubDailyLog(const DailyLogState());
      stubSettings(const UserSettingsState());
      await pumpView(tester);

      final sections = tester
          .widgetList<MealLogSection>(find.byType(MealLogSection))
          .toList();
      expect(sections.where((section) => section.isCurrent).length, equals(1));
    });
```

Run: `fvm flutter test test/app/feature/today/view/today_view_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 9: Commit**

Tell the developer to commit. Changed: `today_view.dart`, `today_view_test.dart`.
Suggested message: `feat: date pill + multi-day picker on the Today view`

---

## Task 6: Full suite + analyzer, then manual verification

**Files:** none (verification only).

- [ ] **Step 1: Run the analyzer**

Run: `fvm flutter analyze`
Expected: No errors. (Per project rules, do not chase info/warning-level lints; fix only errors.)

- [ ] **Step 2: Run the full test suite with random ordering**

Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: All tests pass. If any unrelated test references the old `day:` / `WeightEntryField(day:)` APIs, update it to the new list form (`logDays: [...]` / `days: [...]`).

- [ ] **Step 3: Ask the developer to run the app and verify manually**

Provide this checklist for the developer to run from VS Code:
- Tap the pill → picker opens. Pick a single past day → pill shows that date; the day's meals, weight, and quick picks reflect that day; logging a meal lands on that day; no meal section is highlighted.
- Pick today again → pill reads "Today"; the live view returns with the current meal highlighted.
- Pick a multi-day range → pill shows "start – end". Log a quick pick and a "Something else"; confirm (via History or by switching to each day) the entry landed on every day in the range. Enter a weight; confirm it landed on every day.
- From History, add a forgotten meal → still logs onto that single day (regression check).

- [ ] **Step 4: Commit (if any test fixups were needed in Step 2)**

Tell the developer to commit any fixups. Otherwise nothing to commit.
Suggested message: `test: align remaining call sites with multi-day logging APIs`

---

## Self-Review

**Spec coverage:**
- Selected-day state (`DateTimeRange? _selectedRange`, null = live) → Task 5.
- Pill + `showDateRangePicker`, any past/present/future date → Task 5 (firstDate 2000, lastDate 2100), Task 4 (slot).
- Pill label (Today / single date / range) → Task 5 `_pillLabel`.
- Display the selected day's breakdown (`displayDay`) → Task 5.
- Logging fans across every day in the range → Task 2 (meals), Task 3 (weight), Task 5 (wires `logDays`).
- Editing an existing entry stays single-entry (by id) → unchanged by design; no task touches `LoggedEntryRow`. ✓
- Current-meal highlight only when live → Task 5 (`isToday && ...`), tested Step 8.
- Lifecycle/midnight: live follows clock, selected stays put → existing resume logic untouched; `_selectedRange` persists across rebuilds. ✓
- History regression (one-element list) → Task 2 Step 5/7, Task 3 Step 4, Task 6 Step 3.
- No persisted-shape change → stated in Global Constraints. ✓

**Placeholder scan:** No TBD/TODO; every code step shows full code. ✓

**Type consistency:** `logDays: List<DateTime>?` used identically in `MealLogSection`, `OtherMealUsualsSheet`, and the today wiring; `days: List<DateTime>` used identically in `WeightEntryField` and `_WeightTracker`; `titleWidget: Widget?` in `TheUsualAppBar`; `DateTimeRange.logicalDays` getter name consistent across Tasks 1 and 5. ✓
