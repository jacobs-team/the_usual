# History: Add Meals To A Past Day — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let a user add a forgotten meal to any past day from the History view, reusing the Today meal card scoped to that day.

**Architecture:** Make meal logging day-aware via optional params on `DailyLogEvent.mealLogged`, thread the target day through the existing `MealLogSection` add UI, and open that exact card in a bottom sheet from a new per-meal `+` button on each history day.

**Tech Stack:** Flutter, flutter_bloc, freezed, HydratedBloc, mocktail, bloc_test.

## Global Constraints

- Use `fvm flutter` for all Flutter CLI commands.
- Never run the code generator (build_runner is always watching). After editing a `@freezed` file, wait for it to regenerate before running tests.
- Never run `git commit`/`git push`. Each task ends by asking Jacob to commit with the suggested message.
- Always use barrel files over direct imports.
- Run tests with random seed ordering: `--test-randomize-ordering-seed random`.
- Use matchers (`equals()`, `isNull`, etc.), `blocTest` for blocs, `mocktail` for mocks, and `initHydratedStorage()` in HydratedBloc test setup.
- Do not change how Today logs meals (it must keep logging to `clock.now()`).
- No persisted-state migration: `MealLogEntry` and `DailyLogState` shapes are unchanged; only an event gains optional params, and events are not persisted.

## File Structure

- Modify `lib/app/feature/today/bloc/daily_log_event.dart` — add optional `day`/`dayStart` to `mealLogged`.
- Modify `lib/app/feature/today/bloc/daily_log_bloc.dart` — stamp `loggedAt` from `day`/`dayStart` when given.
- Modify `lib/app/feature/today/widgets/meal_log_section.dart` — accept and forward `day`/`dayStart`.
- Modify `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart` — accept and forward `day`/`dayStart`.
- Create `lib/app/feature/history/widgets/history_meal_sheet.dart` — hosts `MealLogSection` for one meal on one past day, reactive to both blocs.
- Modify `lib/app/feature/history/widgets/widgets.dart` — export the new sheet.
- Modify `lib/app/feature/history/view/history_view.dart` — render all four meals always, each with a `+` that opens the sheet.

Tests:

- Modify `test/app/feature/today/bloc/daily_log_bloc_test.dart`
- Modify `test/app/feature/today/widgets/meal_log_section_test.dart`
- Modify `test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart`
- Modify `test/app/feature/history/view/history_view_test.dart` (create if absent)

---

### Task 1: Day-aware meal logging in the bloc

**Files:**

- Modify: `lib/app/feature/today/bloc/daily_log_event.dart:5-12`
- Modify: `lib/app/feature/today/bloc/daily_log_bloc.dart:115-130`
- Test: `test/app/feature/today/bloc/daily_log_bloc_test.dart`

**Interfaces:**

- Produces: `DailyLogEvent.mealLogged(MealOfTheDay mealOfTheDay, String name, {Nutrition nutrition, double quantity, String? usualMealId, String? photoPath, DateTime? day, TimeOfDay? dayStart})`. When `day` and `dayStart` are both non-null, the entry's `loggedAt` is `day.atDayStart(dayStart)`; otherwise `clock.now()`.

- [ ] **Step 1: Write the failing test**

Add this `blocTest` inside the existing `group('mealLogged', () {` block in `test/app/feature/today/bloc/daily_log_bloc_test.dart` (the file already defines `const dayStart = TimeOfDay(hour: 0, minute: 0)` at the top of `main`):

```dart
blocTest<DailyLogBloc, DailyLogState>(
  'stamps loggedAt at the logical day start when a day is given',
  build: DailyLogBloc.new,
  act: (bloc) => bloc.add(
    const DailyLogEvent.mealLogged(
      MealOfTheDay.dinner,
      'Tacos',
      nutrition: Nutrition(calories: 650),
      day: _pastDay,
      dayStart: TimeOfDay(hour: 4, minute: 0),
    ),
  ),
  verify: (bloc) {
    final entry = bloc.state.mealEntries.single;
    expect(
      entry.loggedAt,
      equals(_pastDay.atDayStart(const TimeOfDay(hour: 4, minute: 0))),
    );
    expect(entry.mealOfTheDay, equals(MealOfTheDay.dinner));
    expect(entry.loggedAt.logicalDay(const TimeOfDay(hour: 4, minute: 0)),
        equals(_pastDay));
  },
);
```

Add this top-level constant just above `void main() {` in the same file:

```dart
final _pastDay = DateTime(2026, 6, 16);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — compile error, `mealLogged` has no `day`/`dayStart` parameter.

- [ ] **Step 3: Add the event parameters**

In `lib/app/feature/today/bloc/daily_log_event.dart`, replace the `mealLogged` factory (lines 5-12) with:

```dart
  const factory DailyLogEvent.mealLogged(
    MealOfTheDay mealOfTheDay,
    String name, {
    @Default(Nutrition()) Nutrition nutrition,
    @Default(1) double quantity,
    String? usualMealId,
    String? photoPath,
    DateTime? day,
    TimeOfDay? dayStart,
  }) = MealLogged;
```

Wait for build_runner to regenerate `daily_log_bloc.freezed.dart`.

- [ ] **Step 4: Stamp loggedAt from the day**

In `lib/app/feature/today/bloc/daily_log_bloc.dart`, replace `_onMealLogged` (lines 115-130) with:

```dart
  void _onMealLogged(MealLogged event, Emitter<DailyLogState> emit) {
    final name = event.name.trim();
    if (name.isEmpty) return;

    final day = event.day;
    final dayStart = event.dayStart;
    final loggedAt = day != null && dayStart != null
        ? day.atDayStart(dayStart)
        : clock.now();

    final mealLogEntry = MealLogEntry(
      id: _uuid.v4(),
      loggedAt: loggedAt,
      mealOfTheDay: event.mealOfTheDay,
      name: name,
      nutrition: event.nutrition,
      quantity: event.quantity.asLoggedQuantity,
      usualMealId: event.usualMealId,
      photoPath: event.photoPath,
    );
    emit(state.copyWith(mealEntries: [...state.mealEntries, mealLogEntry]));
  }
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/bloc/daily_log_bloc_test.dart --test-randomize-ordering-seed random`
Expected: PASS (new test plus all existing `mealLogged` tests, which omit `day`/`dayStart` and still log to now).

- [ ] **Step 6: Hand off for commit**

Tell Jacob the changes are ready and suggest:
`feat: make meal logging day-aware via optional day/dayStart on mealLogged`

---

### Task 2: Thread day/dayStart through the add UI

**Files:**

- Modify: `lib/app/feature/today/widgets/meal_log_section.dart`
- Modify: `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`
- Test: `test/app/feature/today/widgets/meal_log_section_test.dart`
- Test: `test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart`

**Interfaces:**

- Consumes: `DailyLogEvent.mealLogged(..., {DateTime? day, TimeOfDay? dayStart})` from Task 1.
- Produces:
  - `MealLogSection(... , {DateTime? day, TimeOfDay? dayStart})` — forwards `day`/`dayStart` into every meal it logs and into `OtherMealUsualsSheet`.
  - `OtherMealUsualsSheet(... , {DateTime? day, TimeOfDay? dayStart})` — forwards them into `mealLogged`.

- [ ] **Step 1: Write the failing tests**

In `test/app/feature/today/widgets/meal_log_section_test.dart`, change `pumpSection` to accept and pass `day`/`dayStart`. Update its signature to add:

```dart
      DateTime? day,
      TimeOfDay? dayStart,
```

and pass them into the `MealLogSection(...)` constructor:

```dart
            MealLogSection(
              mealOfTheDay: MealOfTheDay.breakfast,
              mealLogEntries: mealLogEntries,
              quickPicks: quickPicks,
              otherMealUsuals: otherMealUsuals,
              isCurrent: isCurrent,
              nutritionExpandedByDefault: nutritionExpandedByDefault,
              day: day,
              dayStart: dayStart,
            ),
```

Then add this test inside the `group(MealLogSection, () {` block:

```dart
testWidgets('forwards day and dayStart when logging a quick pick', (
  tester,
) async {
  await pumpSection(
    tester,
    quickPicks: const [
      UsualMeal(id: 'u', name: 'Oatmeal', nutrition: Nutrition(calories: 300)),
    ],
    day: DateTime(2026, 6, 16),
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
        day: DateTime(2026, 6, 16),
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      ),
    ),
  ).called(1);
});
```

In `test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart`, change `pumpSheet` to accept and pass `day`/`dayStart`:

```dart
    Future<void> pumpSheet(
      WidgetTester tester,
      Map<MealOfTheDay, List<UsualMeal>> usualsByMeal, {
      DateTime? day,
      TimeOfDay? dayStart,
    }) {
      return tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc],
        OtherMealUsualsSheet(
          mealOfTheDay: MealOfTheDay.breakfast,
          usualsByMeal: usualsByMeal,
          day: day,
          dayStart: dayStart,
        ),
      );
    }
```

Then add this test inside the `group(OtherMealUsualsSheet, () {` block:

```dart
testWidgets('forwards day and dayStart when logging a usual', (tester) async {
  await pumpSheet(
    tester,
    const {
      MealOfTheDay.lunch: [
        UsualMeal(id: 'u', name: 'Salad', nutrition: Nutrition(calories: 250)),
      ],
    },
    day: DateTime(2026, 6, 16),
    dayStart: const TimeOfDay(hour: 4, minute: 0),
  );

  await tester.tap(find.text('Salad'));
  await tester.pumpAndSettle();

  verify(
    () => dailyLogBloc.add(
      DailyLogEvent.mealLogged(
        MealOfTheDay.breakfast,
        'Salad',
        nutrition: const Nutrition(calories: 250),
        usualMealId: 'u',
        day: DateTime(2026, 6, 16),
        dayStart: const TimeOfDay(hour: 4, minute: 0),
      ),
    ),
  ).called(1);
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — compile error, `MealLogSection` and `OtherMealUsualsSheet` have no `day`/`dayStart` parameter.

- [ ] **Step 3: Add params to OtherMealUsualsSheet and forward them**

In `lib/app/feature/today/widgets/cross_meal_picker_sheet.dart`, add two fields to `OtherMealUsualsSheet`. Update its constructor and fields:

```dart
  const OtherMealUsualsSheet({
    required this.mealOfTheDay,
    required this.usualsByMeal,
    this.day,
    this.dayStart,
    super.key,
  });

  /// The meal a tapped usual is logged under.
  final MealOfTheDay mealOfTheDay;

  /// Usuals from other meals, grouped by their own meal.
  final Map<MealOfTheDay, List<UsualMeal>> usualsByMeal;

  /// The day a tapped usual is logged onto. Null logs to today.
  final DateTime? day;

  /// The user's day-start, used with [day] to stamp the entry onto that day.
  final TimeOfDay? dayStart;
```

In its `build`, pass `day`/`dayStart` into each `_UsualMealCard`:

```dart
                _UsualMealCard(
                  mealOfTheDay: mealOfTheDay,
                  usualMeal: usualMeal,
                  day: day,
                  dayStart: dayStart,
                ),
```

Add the fields to `_UsualMealCard` (update its constructor and fields):

```dart
  const _UsualMealCard({
    required this.mealOfTheDay,
    required this.usualMeal,
    this.day,
    this.dayStart,
  });

  /// The meal the usual is logged under when tapped.
  final MealOfTheDay mealOfTheDay;

  /// The usual meal this card represents.
  final UsualMeal usualMeal;

  /// The day the usual is logged onto. Null logs to today.
  final DateTime? day;

  /// The user's day-start, used with [day] to stamp the entry onto that day.
  final TimeOfDay? dayStart;
```

In `_UsualMealCard`'s `onTap`, forward them into `mealLogged`:

```dart
        onTap: () {
          getIt<DailyLogBloc>().add(
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
          Navigator.of(context).pop();
        },
```

- [ ] **Step 4: Add params to MealLogSection and forward them**

In `lib/app/feature/today/widgets/meal_log_section.dart`, add two fields. Update the constructor (lines 13-21) to add after `nutritionExpandedByDefault`:

```dart
    this.day,
    this.dayStart,
```

Add the field declarations after `nutritionExpandedByDefault` (around line 41):

```dart
  /// The day meals logged from this section are recorded onto. Null logs to
  /// today; the History view passes the day being edited.
  final DateTime? day;

  /// The user's day-start, used with [day] to stamp entries onto that day.
  final TimeOfDay? dayStart;
```

In the quick-pick chip `onPressed` (lines 123-131), forward them:

```dart
                              onPressed: () => getIt<DailyLogBloc>().add(
                                DailyLogEvent.mealLogged(
                                  mealOfTheDay,
                                  usualMeal.name,
                                  nutrition: usualMeal.nutrition,
                                  usualMealId: usualMeal.id,
                                  photoPath: usualMeal.photoPath,
                                  day: day,
                                  dayStart: dayStart,
                                ),
                              ),
```

In the "Something New" results loop (lines 169-176), forward them:

```dart
                              getIt<DailyLogBloc>().add(
                                DailyLogEvent.mealLogged(
                                  mealOfTheDay,
                                  result.name,
                                  nutrition: result.nutrition,
                                  quantity: result.quantity,
                                  day: day,
                                  dayStart: dayStart,
                                ),
                              );
```

In the `OtherMealUsualsSheet` builder (lines 189-192), forward them:

```dart
                              builder: (_) => OtherMealUsualsSheet(
                                mealOfTheDay: mealOfTheDay,
                                usualsByMeal: otherMealUsuals,
                                day: day,
                                dayStart: dayStart,
                              ),
```

- [ ] **Step 5: Run tests to verify they pass**

Run: `fvm flutter test test/app/feature/today/widgets/meal_log_section_test.dart test/app/feature/today/widgets/cross_meal_picker_sheet_test.dart --test-randomize-ordering-seed random`
Expected: PASS (new forwarding tests plus all existing tests; Today still passes no `day`/`dayStart`, so its behavior is unchanged).

- [ ] **Step 6: Hand off for commit**

Suggested message:
`feat: thread target day through MealLogSection and the cross-meal picker`

---

### Task 3: History meal sheet widget

**Files:**

- Create: `lib/app/feature/history/widgets/history_meal_sheet.dart`
- Modify: `lib/app/feature/history/widgets/widgets.dart`
- Test: `test/app/feature/history/widgets/history_meal_sheet_test.dart`

**Interfaces:**

- Consumes: `MealLogSection(... , {DateTime? day, TimeOfDay? dayStart})` from Task 2; the `orderedQuickPicks` / `usualsFromOtherMeals` / `breakdownOn` extensions on `List<MealLogEntry>`.
- Produces: `HistoryMealSheet({required MealOfTheDay mealOfTheDay, required DateTime day})` — a sheet body that renders the Today meal card for `mealOfTheDay` on `day`, reactive to `DailyLogBloc` and `UserSettingsBloc`, logging onto `day`.

- [ ] **Step 1: Write the failing test**

Create `test/app/feature/history/widgets/history_meal_sheet_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(HistoryMealSheet, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    final day = DateTime(2026, 6, 16);

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(const DailyLogState());
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(
        const UserSettingsState(
          usuals: {
            MealOfTheDay.dinner: [
              UsualMeal(id: 'd', name: 'Tacos', nutrition: Nutrition(calories: 650)),
            ],
          },
        ),
      );
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
      registerFallbackValue(
        const DailyLogEvent.mealLogged(MealOfTheDay.dinner, 'x'),
      );
    });

    testWidgets('shows the meal card with that meal\'s quick picks', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        HistoryMealSheet(mealOfTheDay: MealOfTheDay.dinner, day: day),
      );

      expect(find.byType(MealLogSection), findsOneWidget);
      expect(find.text('+ Tacos'), findsOneWidget);
    });

    testWidgets('logs a quick pick onto the given day', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        HistoryMealSheet(mealOfTheDay: MealOfTheDay.dinner, day: day),
      );

      await tester.tap(find.text('+ Tacos'));

      verify(
        () => dailyLogBloc.add(
          DailyLogEvent.mealLogged(
            MealOfTheDay.dinner,
            'Tacos',
            nutrition: const Nutrition(calories: 650),
            usualMealId: 'd',
            day: day,
            dayStart: const TimeOfDay(hour: 0, minute: 0),
          ),
        ),
      ).called(1);
    });
  });
}
```

> Note: the assertions assume `UserSettingsState`'s default `dayStartTime` is midnight `TimeOfDay(hour: 0, minute: 0)`. If `const UserSettingsState()` defaults to a different day-start, set `dayStartTime` explicitly in the mocked state and use that value in the `verify`.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/history/widgets/history_meal_sheet_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `HistoryMealSheet` is not defined.

- [ ] **Step 3: Create the widget**

Create `lib/app/feature/history/widgets/history_meal_sheet.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';

/// {@template history_meal_sheet}
/// Bottom-sheet body that surfaces the Today meal card ([MealLogSection]) for a
/// single [mealOfTheDay] on a past [day], so a forgotten meal can be added (or
/// an existing one edited) from History. Logging is stamped onto [day]. Rebuilds
/// with the day log and user settings so quick picks and totals stay current as
/// meals are added.
/// {@endtemplate}
class HistoryMealSheet extends StatelessWidget {
  /// {@macro history_meal_sheet}
  const HistoryMealSheet({
    required this.mealOfTheDay,
    required this.day,
    super.key,
  });

  /// The meal this sheet logs and shows entries for.
  final MealOfTheDay mealOfTheDay;

  /// The logical day this sheet logs onto and reads entries from.
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      UserSettingsBloc,
      UserSettingsState,
      (Map<MealOfTheDay, List<UsualMeal>>, bool, TimeOfDay)
    >(
      bloc: getIt<UserSettingsBloc>(),
      selector: (state) => (
        state.usuals,
        state.expandNutritionByDefault,
        state.dayStartTime,
      ),
      builder: (context, selected) {
        final (usuals, expandNutritionByDefault, dayStart) = selected;
        return BlocSelector<DailyLogBloc, DailyLogState, List<MealLogEntry>>(
          bloc: getIt<DailyLogBloc>(),
          selector: (state) => state.mealEntries,
          builder: (context, mealEntries) {
            final breakdown = mealEntries.breakdownOn(day, dayStart);
            return CustomScrollView(
              shrinkWrap: true,
              slivers: [
                MealLogSection(
                  mealOfTheDay: mealOfTheDay,
                  mealLogEntries:
                      breakdown.entriesByMeal[mealOfTheDay] ??
                      const <MealLogEntry>[],
                  quickPicks: mealEntries.orderedQuickPicks(
                    mealOfTheDay: mealOfTheDay,
                    usuals: usuals,
                    day: day,
                    dayStart: dayStart,
                  ),
                  otherMealUsuals: mealEntries.usualsFromOtherMeals(
                    mealOfTheDay: mealOfTheDay,
                    usuals: usuals,
                    day: day,
                    dayStart: dayStart,
                  ),
                  isCurrent: false,
                  nutritionExpandedByDefault: expandNutritionByDefault,
                  day: day,
                  dayStart: dayStart,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
```

- [ ] **Step 4: Export it from the history widgets barrel**

In `lib/app/feature/history/widgets/widgets.dart`, add (keeping exports alphabetical):

```dart
export 'history_meal_sheet.dart';
export 'month_trends_chart.dart';
```

- [ ] **Step 5: Run test to verify it passes**

Run: `fvm flutter test test/app/feature/history/widgets/history_meal_sheet_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 6: Hand off for commit**

Suggested message:
`feat: add HistoryMealSheet hosting the Today meal card for a past day`

---

### Task 4: Per-meal add button on history days

**Files:**

- Modify: `lib/app/feature/history/view/history_view.dart:389-402`
- Test: `test/app/feature/history/view/history_view_test.dart` (create if absent)

**Interfaces:**

- Consumes: `HistoryMealSheet({required MealOfTheDay mealOfTheDay, required DateTime day})` from Task 3.

- [ ] **Step 1: Write the failing test**

If `test/app/feature/history/view/history_view_test.dart` does not exist, create it with this content. If it exists, add the `group` below into its `main`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(HistoryView, () {
    late DailyLogBloc dailyLogBloc;
    late UserSettingsBloc userSettingsBloc;

    final dinnerOnly = DailyLogState(
      mealEntries: [
        MealLogEntry(
          id: 'a',
          loggedAt: DateTime(2026, 6, 16, 19),
          mealOfTheDay: MealOfTheDay.dinner,
          name: 'Tacos',
          nutrition: const Nutrition(calories: 650),
        ),
      ],
    );

    setUp(() {
      dailyLogBloc = MockDailyLogBloc();
      when(() => dailyLogBloc.state).thenReturn(dinnerOnly);
      when(() => dailyLogBloc.stream).thenAnswer((_) => const Stream.empty());
      userSettingsBloc = MockUserSettingsBloc();
      when(() => userSettingsBloc.state).thenReturn(const UserSettingsState());
      when(
        () => userSettingsBloc.stream,
      ).thenAnswer((_) => const Stream.empty());
    });

    testWidgets('shows every meal with an add button on a day', (tester) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        const HistoryView(),
      );

      await tester.tap(find.text('Tacos').first.hitTestable());
      await tester.pumpAndSettle();

      expect(find.text('BREAKFAST'), findsOneWidget);
      expect(find.text('LUNCH'), findsOneWidget);
      expect(find.text('DINNER'), findsOneWidget);
      expect(find.text('SNACKS'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNWidgets(4));
    });

    testWidgets('tapping a meal add button opens the meal sheet', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 3000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpPumpPumpItUP(
        deps: [dailyLogBloc, userSettingsBloc],
        const HistoryView(),
      );

      await tester.tap(find.text('Tacos').first.hitTestable());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add).first);
      await tester.pumpAndSettle();

      expect(find.byType(HistoryMealSheet), findsOneWidget);
    });
  });
}
```

> Note: the day tile must be expanded before the meal labels render (the day card is an `ExpansionTile`). The test taps the day to expand it. If the title text (the formatted date) is easier to target than `'Tacos'`, expand via the date text instead. Adjust the tap target if the localized date format makes `'Tacos'` ambiguous.

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/history/view/history_view_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — only `DINNER` renders (empty meals are hidden) and there are no add icons.

- [ ] **Step 3: Render all meals with an add button**

In `lib/app/feature/history/view/history_view.dart`, replace the meal loop in `_HistoryDayCard` (lines 389-402) with:

```dart
          for (final mealOfTheDay in MealOfTheDay.values) ...[
            Row(
              children: [
                Expanded(
                  child: SectionLabel(mealOfTheDay.label.toUpperCase()),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add ${mealOfTheDay.label}',
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    showDragHandle: true,
                    builder: (_) => HistoryMealSheet(
                      mealOfTheDay: mealOfTheDay,
                      day: historyDay.day,
                    ),
                  ),
                ),
              ],
            ),
            for (final mealLogEntry in historyDay.mealEntries)
              if (mealLogEntry.mealOfTheDay == mealOfTheDay)
                LoggedEntryRow(
                  key: ValueKey(mealLogEntry.id),
                  mealLogEntry: mealLogEntry,
                  expandedByDefault: false,
                ),
            SizedBox(height: AppDesign.spacing.sm),
          ],
```

- [ ] **Step 4: Run test to verify it passes**

Run: `fvm flutter test test/app/feature/history/view/history_view_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 5: Run the full suite**

Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 6: Hand off for commit**

Suggested message:
`feat: add per-meal add button to history days, opening the meal sheet`

---

## Self-Review

**Spec coverage:**

- Day-aware logging → Task 1. ✓
- Thread target day through `MealLogSection` and `OtherMealUsualsSheet` → Task 2. ✓
- `HistoryMealSheet` hosting `MealLogSection` in a `CustomScrollView`, reactive to both blocs, computing quick-picks/other-meals/breakdown for the day → Task 3. ✓
- History day card renders all four meals always, each with a `+` opening the sheet, entries still listed with edit/delete → Task 4. ✓
- Wiring data (usuals, dayStart, expandNutritionByDefault) → Task 3 (sheet reads them from `UserSettingsBloc`). ✓
- No persisted-state migration → confirmed in Global Constraints; only the event changed. ✓
- Today behavior unchanged → Tasks 2 and 4 pass no `day`/`dayStart` from Today; existing tests guard this. ✓

**Placeholder scan:** No TBD/TODO; all steps carry concrete code and commands. Two `Note` callouts flag environment-dependent assertions (default `dayStartTime`, expand-tap target) the implementer verifies against the real defaults rather than placeholders.

**Type consistency:** `mealLogged({DateTime? day, TimeOfDay? dayStart})`, `MealLogSection({DateTime? day, TimeOfDay? dayStart})`, `OtherMealUsualsSheet({DateTime? day, TimeOfDay? dayStart})`, and `HistoryMealSheet({MealOfTheDay mealOfTheDay, DateTime day})` are used consistently across tasks. Extensions `orderedQuickPicks`/`usualsFromOtherMeals`/`breakdownOn` match their definitions in `meal_log_entry_list_extensions.dart`. ✓
