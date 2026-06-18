# Onboarding Normalization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reorder the onboarding flow so the first meal log comes before optional config, merge the two reminder screens into one, fix the persisted-state model so step order is safe to change, and align onboarding styling with the rest of the app.

**Architecture:** `OnboardingBloc` is a `HydratedBloc`. Today it persists `activeStepIndex`, a positional index into a derived `activeSteps` list. We replace that with the current `OnboardingStep` stored by name, then reshape the step enum (merge `reminderStyle` + `mealSchedule` into `reminders`, move `firstLog` up). A versioned `fromJson` migration (v1 positional → v2 named) keeps existing and completed users intact. The onboarding draft commits to `UserSettingsBloc` / `DailyLogBloc` only when `step` reaches `complete`, so reordering does not change when data is written.

**Tech Stack:** Flutter, `flutter_bloc`, `hydrated_bloc`, `freezed`, `json_serializable`, `injectable`, `bloc_test`, `mocktail`.

## Global Constraints

- Use `fvm flutter` for all Flutter CLI commands, never bare `flutter`.
- Never run the app and never run the code generator (`build_runner`). The generator runs in a background watcher; after editing a `@freezed` class, assume `*.freezed.dart` / `*.g.dart` regenerate automatically. If generated symbols are missing, ask Jacob whether the watcher is running rather than invoking it.
- Never run `git commit` or `git push`. Where a step says "Commit", stage the listed files with `git add` and then ask Jacob to commit with the suggested message.
- Run tests with random seed ordering: `--test-randomize-ordering-seed random`.
- Use `@freezed` for states/events. Keep `fromJson` arrow-bodied and route versions in a delegated `_fromVersionedJson` factory so `toJson` still generates.
- Persisted-state rule: any change to the persisted shape must keep old stored data loading correctly, with a `version` bump and migration. A user whose old data resolves to `complete` must stay `complete`.
- Naming: variables named after their full model type (`mealOfTheDay`, not `meal`).
- Get bloc instances via `getIt<T>()` in views.
- Prefer `BlocSelector` over `BlocBuilder`; select multiple values with a record.
- Use matchers (`equals()`, `isTrue`, `contains`, `isA<T>().having`) in tests, never raw assertions.
- Barrel files over direct imports.
- Do not extract single-use widgets to their own files.

---

## File Structure

- `lib/app/feature/onboarding/bloc/onboarding_state.dart` — replace `activeStepIndex` with `step`; reshape `OnboardingStep`; v2 migration. (Modify)
- `lib/app/feature/onboarding/bloc/onboarding_bloc.dart` — step-by-name navigation; updated skip logic. (Modify)
- `lib/app/feature/onboarding/view/onboarding_view.dart` — switch over the reshaped enum. (Modify)
- `lib/app/feature/onboarding/view/reminders_view.dart` — new merged screen. (Create)
- `lib/app/feature/onboarding/view/reminder_style_view.dart` — delete. (Delete)
- `lib/app/feature/onboarding/view/meal_schedule_view.dart` — delete. (Delete)
- `lib/app/feature/onboarding/view/view.dart` — barrel: drop the two deleted views, add `reminders_view`. (Modify)
- `lib/app/feature/onboarding/view/first_log_view.dart` — rebuild `_FoodCard` on themed `Card`; fix placeholder + magic numbers. (Modify)
- `lib/app/feature/onboarding/widgets/onboarding_actions.dart` — named constant for reserved slot height. (Modify)
- Test files mirror each of the above.

---

## Task 1: Persist the current step by name (no flow change)

Replace the positional `activeStepIndex` with an `OnboardingStep step` field serialized by name. Keep the current 8-value enum and both reminder views unchanged. The app must behave identically. Bump persisted version to 2 with a v1→v2 migration that converts the stored index to the equivalent step name, and convert the v0 path to land on a named step too.

**Files:**
- Modify: `lib/app/feature/onboarding/bloc/onboarding_state.dart`
- Modify: `lib/app/feature/onboarding/bloc/onboarding_bloc.dart:22-29` (navigation), `:120-140` (skip)
- Modify: `lib/app/feature/onboarding/widgets/onboarding_top_bar.dart:35-37` (selector returns the same list)
- Test: `test/app/feature/onboarding/bloc/onboarding_bloc_test.dart`
- Test (touch, index → step): `test/app/app_test.dart`, `test/app/feature/onboarding/view/*_test.dart`

**Interfaces:**
- Produces: `OnboardingState({int version, OnboardingStep step, UserSettingsState settings, List<String> firstLogSelectedIds, Map<String,double> firstLogQuantities})`. `step` defaults to `OnboardingStep.welcome`.
- Produces: `List<OnboardingStep> get activeSteps` (still present; returns the reachable steps).
- Removes: the `int activeStepIndex` field and the `OnboardingStep get step` computed getter (replaced by the stored field).
- Consumed by: `app_router.dart:27` and `the_usuals_app.dart:91-92` via `state.step` (unchanged call sites).

- [ ] **Step 1: Write failing migration + navigation tests**

In `test/app/feature/onboarding/bloc/onboarding_bloc_test.dart`, replace the `activeStepIndex`-based navigation and migration tests with step-based ones. Add:

```dart
group('navigation', () {
  blocTest<OnboardingBloc, OnboardingState>(
    'continuePressed advances to the next step',
    seed: () => const OnboardingState(step: OnboardingStep.reminderStyle),
    build: OnboardingBloc.new,
    act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
    expect: () => [
      isA<OnboardingState>().having(
        (s) => s.step,
        'step',
        OnboardingStep.mealSchedule,
      ),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'backPressed returns to the previous step',
    seed: () => const OnboardingState(step: OnboardingStep.mealSchedule),
    build: OnboardingBloc.new,
    act: (bloc) => bloc.add(const OnboardingEvent.backPressed()),
    expect: () => [
      isA<OnboardingState>().having(
        (s) => s.step,
        'step',
        OnboardingStep.reminderStyle,
      ),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'continuePressed at the last step stays put',
    seed: () => const OnboardingState(step: OnboardingStep.complete),
    build: OnboardingBloc.new,
    act: (bloc) => bloc.add(const OnboardingEvent.continuePressed()),
    expect: () => <OnboardingState>[],
  );
});

group('fromJson migration', () {
  Map<String, dynamic> v1Json({required int activeStepIndex}) => {
    'version': 1,
    'activeStepIndex': activeStepIndex,
    'settings': const UserSettingsState().toJson(),
    'firstLogSelectedIds': <String>[],
    'firstLogQuantities': <String, double>{},
  };

  test('v1 index maps to the equivalent step by name', () {
    final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 1));
    expect(restored.step, equals(OnboardingStep.buildUsuals));
    expect(restored.version, equals(2));
  });

  test('v1 completed users resolve to complete', () {
    final restored = OnboardingState.fromJson(
      v1Json(activeStepIndex: OnboardingStep.values.length - 1),
    );
    expect(restored.step, equals(OnboardingStep.complete));
  });

  test('v1 index past the end clamps to complete', () {
    final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 99));
    expect(restored.step, equals(OnboardingStep.complete));
  });

  test('a newer unknown version resolves to complete', () {
    final restored = OnboardingState.fromJson({
      'version': 999,
      'step': 'welcome',
      'settings': const UserSettingsState().toJson(),
    });
    expect(restored.step, equals(OnboardingStep.complete));
  });
});
```

Keep the existing v0 tests but assert on `step` instead of `activeStepIndex`:

```dart
test('v0 data resolves to the equivalent step', () {
  // v0 predates goals; its order was [welcome, buildUsuals, reminderStyle,
  // mealSchedule, weightTracking, firstLog, complete], so index 5 is firstLog.
  final restored = OnboardingState.fromJson(v0Json(activeStepIndex: 5));
  expect(restored.step, equals(OnboardingStep.firstLog));
});
```

- [ ] **Step 2: Run the tests to verify they fail**

Run: `fvm flutter test test/app/feature/onboarding/bloc/onboarding_bloc_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `OnboardingState` has no `step` parameter / `activeStepIndex` still required.

- [ ] **Step 3: Rewrite `onboarding_state.dart`**

Replace the field and the version routing. Full file:

```dart
part of 'onboarding_bloc.dart';

/// {@template onboarding_state}
/// State for the onboarding flow.
/// {@endtemplate}
@freezed
abstract class OnboardingState with _$OnboardingState {
  /// {@macro onboarding_state}
  @JsonSerializable(explicitToJson: true)
  const factory OnboardingState({
    /// Schema version of the persisted state. Bump it and add a `fromJson`
    /// case whenever the persisted shape changes in a way old stored data
    /// can't be read as-is, so existing users are migrated instead of reset.
    @Default(2) int version,

    /// The step the flow is on, stored by name so reordering the enum never
    /// shifts where saved data resolves.
    @Default(OnboardingStep.welcome) OnboardingStep step,

    /// Draft of the user's settings and usuals, committed to
    /// [UserSettingsBloc] when onboarding completes.
    @Default(UserSettingsState()) UserSettingsState settings,
    @Default(<String>[]) List<String> firstLogSelectedIds,

    /// How many of each selected first-log item the user had, keyed by usual
    /// meal id. An item absent from the map defaults to one.
    @Default(<String, double>{}) Map<String, double> firstLogQuantities,
  }) = _OnboardingState;

  const OnboardingState._();

  static const _currentVersion = 2;

  factory OnboardingState.fromJson(Map<String, dynamic> json) =>
      OnboardingState._fromVersionedJson(json);

  factory OnboardingState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
        return _migratedFromLegacyIndex(json, goalsAlreadyPresent: false);
      case 1:
        return _migratedFromLegacyIndex(json, goalsAlreadyPresent: true);
      case _currentVersion:
        return _$OnboardingStateFromJson(json);
      default:
        // A newer, unknown version, e.g. after the user downgrades. Resolve to
        // a completed onboarding so the user is never sent back through it,
        // which would let a stale draft overwrite their saved settings.
        return const OnboardingState(step: OnboardingStep.complete);
    }
  }

  /// Converts legacy data that stored `activeStepIndex` as a position in the
  /// active-steps list into the current name-based [step]. v0 predates the
  /// `goals` step; v1 includes it. The legacy active-steps list dropped
  /// `mealSchedule` when reminders were off, mirrored here.
  static OnboardingState _migratedFromLegacyIndex(
    Map<String, dynamic> json, {
    required bool goalsAlreadyPresent,
  }) {
    final settings = json['settings'] == null
        ? const UserSettingsState()
        : UserSettingsState.fromJson(
            json['settings'] as Map<String, dynamic>,
          );

    final legacyOrder = <OnboardingStep>[
      OnboardingStep.welcome,
      OnboardingStep.buildUsuals,
      OnboardingStep.reminderStyle,
      OnboardingStep.mealSchedule,
      if (goalsAlreadyPresent) OnboardingStep.weightTracking,
      if (goalsAlreadyPresent) OnboardingStep.goals,
      if (!goalsAlreadyPresent) OnboardingStep.weightTracking,
      OnboardingStep.firstLog,
      OnboardingStep.complete,
    ]..removeWhere(
      (step) =>
          step == OnboardingStep.mealSchedule &&
          settings.reminderStyle == ReminderStyle.none,
    );

    final index = (json['activeStepIndex'] as int? ?? 0).clamp(
      0,
      legacyOrder.length - 1,
    );

    return _$OnboardingStateFromJson({
      ...json,
      'version': _currentVersion,
      'step': legacyOrder[index].name,
    });
  }

  /// The steps reachable given the current selections. Picking
  /// [ReminderStyle.none] removes the meal schedule step.
  List<OnboardingStep> get activeSteps {
    final steps = [...OnboardingStep.values];
    if (settings.reminderStyle == ReminderStyle.none) {
      steps.remove(OnboardingStep.mealSchedule);
    }
    return steps;
  }
}

/// The ordered steps of the onboarding flow.
enum OnboardingStep {
  welcome,
  buildUsuals,
  reminderStyle,
  mealSchedule,
  weightTracking,
  goals,
  firstLog,
  complete;

  /// Whether this step appears as a dot in the progress indicator. The welcome
  /// intro and completion screen are bookends and don't get a dot.
  bool get showsProgressDot =>
      this != OnboardingStep.welcome && this != OnboardingStep.complete;
}
```

Note: the legacy v0 ordering placed `weightTracking` then `firstLog` with no `goals`; the v1 ordering inserts `goals` after `weightTracking`. The `goalsAlreadyPresent` flag selects between them. `_$OnboardingStateFromJson` reads the injected `'step'` name and ignores the leftover `'activeStepIndex'` key.

- [ ] **Step 4: Update navigation and skip in `onboarding_bloc.dart`**

Replace the index arithmetic with step lookups within `activeSteps`. Change `BackPressed` / `ContinuePressed`:

```dart
BackPressed() => emit(state.copyWith(step: _stepRelativeTo(state, -1))),
ResetPressed() => emit(const OnboardingState()),
SkipPressed() => _onSkipPressed(event, emit),
ContinuePressed() => emit(state.copyWith(step: _stepRelativeTo(state, 1))),
```

Add the helper inside the bloc:

```dart
/// The step [offset] positions from the current one within [activeSteps],
/// clamped to the valid range.
OnboardingStep _stepRelativeTo(OnboardingState state, int offset) {
  final steps = state.activeSteps;
  final index = steps.indexOf(state.step);
  final next = (index + offset).clamp(0, steps.length - 1);
  return steps[next];
}
```

Rewrite `_onSkipPressed` to advance by step instead of index:

```dart
void _onSkipPressed(SkipPressed event, Emitter<OnboardingState> emit) {
  final nextStep = _stepRelativeTo(state, 1);
  emit(switch (state.step) {
    OnboardingStep.reminderStyle => state.copyWith(
      settings: state.settings.copyWith(
        reminderStyle: ReminderStyle.onAppOpen,
      ),
      step: nextStep,
    ),
    OnboardingStep.weightTracking => state.copyWith(
      settings: state.settings.copyWith(
        weightCheckinFrequency: WeightCheckinFrequency.off,
        startingWeight: null,
      ),
      step: nextStep,
    ),
    _ => state.copyWith(step: nextStep),
  });
}
```

- [ ] **Step 5: Update tests that construct `OnboardingState(activeStepIndex: ...)`**

These constructor call sites must switch to `step:`. Map each by the active-steps order they assumed:
- `test/app/app_test.dart:18` `activeStepIndex: 7` → `step: OnboardingStep.complete`
- `test/app/app_test.dart:176` `activeStepIndex: 5` → `step: OnboardingStep.goals`
- `test/app/feature/onboarding/view/goals_view_test.dart:14` `activeStepIndex: 5` → `step: OnboardingStep.goals`
- `test/app/feature/onboarding/view/weight_tracking_view_test.dart:14` `activeStepIndex: 4` → `step: OnboardingStep.weightTracking`
- `test/app/feature/onboarding/view/first_log_view_test.dart` all `activeStepIndex: 5` → `step: OnboardingStep.firstLog`
- `test/app/feature/onboarding/view/meal_schedule_view_test.dart:14` `activeStepIndex: 3` → `step: OnboardingStep.mealSchedule`
- `test/app/feature/onboarding/view/reminder_style_view_test.dart:15` `activeStepIndex: 2` → `step: OnboardingStep.reminderStyle`

In `test/app/feature/onboarding/view/onboarding_view_test.dart`, change the helpers to take a step:

```dart
OnboardingBloc blocAtStep(OnboardingStep step) {
  final bloc = MockOnboardingBloc();
  when(() => bloc.state).thenReturn(OnboardingState(step: step));
  // ... existing whenListen stubbing, using OnboardingState(step: step)
  return bloc;
}

Future<void> pumpAtStep(WidgetTester tester, OnboardingStep step) {
  // ... deps: [blocAtStep(step)]
}
```
Update each `pumpAtStep(tester, N)` call to pass the matching `OnboardingStep`.

Delete the obsolete `activeSteps`/clamp unit tests that asserted index behavior (`'returns clamped step ...'`, the `activeStepIndex: 99/1` cases) — superseded by the navigation and migration groups in Step 1. Keep the `activeSteps` membership tests (`includes mealSchedule by default`, `drops mealSchedule when reminders are off`) and the `showsProgressDot` tests unchanged.

- [ ] **Step 6: Run the full onboarding + app test suites to verify they pass**

Run: `fvm flutter test test/app/feature/onboarding test/app/app_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 7: Commit**

Stage and ask Jacob to commit:
```bash
git add lib/app/feature/onboarding/bloc test/app/feature/onboarding test/app/app_test.dart
```
Suggested message: `refactor(onboarding): persist current step by name with v2 migration`

---

## Task 2: Reshape the flow — merge reminders, move first log up

Merge `reminderStyle` + `mealSchedule` into one `reminders` screen, move `firstLog` to right after `buildUsuals`, and drop the `activeSteps` conditional (the schedule is now inline, so there is no separate step to remove). Update the v2 migration mapping so the now-removed legacy steps resolve to `reminders`.

**Files:**
- Modify: `lib/app/feature/onboarding/bloc/onboarding_state.dart` (enum + migration mapping + `activeSteps`)
- Create: `lib/app/feature/onboarding/view/reminders_view.dart`
- Delete: `lib/app/feature/onboarding/view/reminder_style_view.dart`, `lib/app/feature/onboarding/view/meal_schedule_view.dart`
- Modify: `lib/app/feature/onboarding/view/view.dart` (barrel)
- Modify: `lib/app/feature/onboarding/view/onboarding_view.dart` (switch)
- Modify: `lib/app/feature/onboarding/bloc/onboarding_bloc.dart` (`_onSkipPressed` reminders case)
- Delete: `test/app/feature/onboarding/view/reminder_style_view_test.dart`, `test/app/feature/onboarding/view/meal_schedule_view_test.dart`
- Create: `test/app/feature/onboarding/view/reminders_view_test.dart`
- Modify: `test/app/feature/onboarding/view/onboarding_view_test.dart`, `test/app/feature/onboarding/bloc/onboarding_bloc_test.dart`

**Interfaces:**
- Produces: `enum OnboardingStep { welcome, buildUsuals, firstLog, reminders, weightTracking, goals, complete }`.
- Produces: `class RemindersView extends StatelessWidget` in `reminders_view.dart`.
- Consumes: `OnboardingState.step`, `OnboardingState.activeSteps`, navigation from Task 1.

- [ ] **Step 1: Update the enum + migration, write failing migration tests**

In `onboarding_state.dart`, reshape the enum:

```dart
enum OnboardingStep {
  welcome,
  buildUsuals,
  firstLog,
  reminders,
  weightTracking,
  goals,
  complete;

  bool get showsProgressDot =>
      this != OnboardingStep.welcome && this != OnboardingStep.complete;
}
```

Simplify `activeSteps` (no conditional left — the schedule lives inside the reminders screen):

```dart
List<OnboardingStep> get activeSteps => OnboardingStep.values;
```

In `_migratedFromLegacyIndex`, the `legacyOrder` list still references the OLD step names by spelling them out as a local list of name strings, since those enum values no longer exist. Replace the typed list with name strings and map removed names to `reminders`:

```dart
static OnboardingState _migratedFromLegacyIndex(
  Map<String, dynamic> json, {
  required bool goalsAlreadyPresent,
}) {
  final settings = json['settings'] == null
      ? const UserSettingsState()
      : UserSettingsState.fromJson(json['settings'] as Map<String, dynamic>);

  // Step names as they were ordered in the legacy positional schema.
  final legacyNames = <String>[
    'welcome',
    'buildUsuals',
    'reminderStyle',
    'mealSchedule',
    if (goalsAlreadyPresent) 'weightTracking',
    if (goalsAlreadyPresent) 'goals',
    if (!goalsAlreadyPresent) 'weightTracking',
    'firstLog',
    'complete',
  ]..removeWhere(
    (name) =>
        name == 'mealSchedule' &&
        settings.reminderStyle == ReminderStyle.none,
  );

  final index = (json['activeStepIndex'] as int? ?? 0).clamp(
    0,
    legacyNames.length - 1,
  );

  // The two legacy reminder steps collapse into the single reminders step.
  const legacyToCurrent = <String, String>{
    'reminderStyle': 'reminders',
    'mealSchedule': 'reminders',
  };
  final legacyName = legacyNames[index];
  final currentName = legacyToCurrent[legacyName] ?? legacyName;

  return _$OnboardingStateFromJson({
    ...json,
    'version': _currentVersion,
    'step': currentName,
  });
}
```

Update the migration tests in `onboarding_bloc_test.dart` for the new mapping:

```dart
test('legacy reminderStyle index maps to reminders', () {
  // v1 order index 2 was reminderStyle.
  final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 2));
  expect(restored.step, equals(OnboardingStep.reminders));
});

test('legacy mealSchedule index maps to reminders', () {
  final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 3));
  expect(restored.step, equals(OnboardingStep.reminders));
});

test('legacy completed users still resolve to complete', () {
  final restored = OnboardingState.fromJson(v1Json(activeStepIndex: 7));
  expect(restored.step, equals(OnboardingStep.complete));
});
```

Update the `activeSteps` membership tests: `mealSchedule` no longer exists, so replace those two tests with:

```dart
test('activeSteps is the full step list', () {
  expect(
    const OnboardingState().activeSteps,
    equals(OnboardingStep.values),
  );
});
```

- [ ] **Step 2: Run migration tests to verify they fail**

Run: `fvm flutter test test/app/feature/onboarding/bloc/onboarding_bloc_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — `OnboardingStep.reminders` undefined / `mealSchedule` references won't compile.

- [ ] **Step 3: Create the merged `reminders_view.dart`**

Combine the reminder-style picker with the schedule section. The schedule renders only when a style other than `none` is chosen. Full file:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template reminders_view}
/// Onboarding screen for how and when the app checks in about meals. The
/// reminder style picker is always shown; the per-meal or end-of-day schedule
/// appears below it once a style other than [ReminderStyle.none] is chosen.
/// {@endtemplate}
class RemindersView extends StatelessWidget {
  /// {@macro reminders_view}
  const RemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const OnboardingTopBar(step: OnboardingStep.reminders),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.xl),
          child:
              BlocSelector<
                OnboardingBloc,
                OnboardingState,
                (
                  ReminderStyle,
                  MealCheckinScheduleMode,
                  Map<MealOfTheDay, MealReminder>,
                  MealReminder,
                  bool,
                )
              >(
                bloc: getIt<OnboardingBloc>(),
                selector: (state) => (
                  state.settings.reminderStyle,
                  state.settings.mealCheckinScheduleMode,
                  state.settings.mealReminders,
                  state.settings.endOfDayReminder,
                  state.settings.skipLoggedMealReminders,
                ),
                builder: (context, selected) {
                  final (
                    reminderStyle,
                    mealCheckinScheduleMode,
                    mealReminders,
                    endOfDayReminder,
                    skipLoggedMealReminders,
                  ) = selected;
                  final remindersOff = reminderStyle == ReminderStyle.none;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'How should we check in?',
                                style: textTheme.headlineSmall,
                              ),
                              SizedBox(height: AppDesign.spacing.sm),
                              const Text(
                                'We ask if you ate. You tap what it was.',
                              ),
                              SizedBox(height: AppDesign.spacing.xl),
                              for (final style in ReminderStyle.values) ...[
                                if (style != ReminderStyle.values.first)
                                  SizedBox(height: AppDesign.spacing.md),
                                RadioOptionCard(
                                  title: style.label,
                                  subtitle: style.description,
                                  note: style.permissionNote,
                                  selected: style == reminderStyle,
                                  onTap: () => getIt<OnboardingBloc>().add(
                                    OnboardingEvent.reminderStyleSelected(
                                      style,
                                    ),
                                  ),
                                ),
                              ],
                              if (!remindersOff) ...[
                                SizedBox(height: AppDesign.spacing.xl),
                                const SectionLabel('WHEN SHOULD WE ASK'),
                                SizedBox(height: AppDesign.spacing.md),
                                MealScheduleModeSelector(
                                  mealCheckinScheduleMode:
                                      mealCheckinScheduleMode,
                                  onChanged: (mealCheckinScheduleMode) =>
                                      getIt<OnboardingBloc>().add(
                                        OnboardingEvent.mealCheckinScheduleModeChanged(
                                          mealCheckinScheduleMode,
                                        ),
                                      ),
                                ),
                                SizedBox(height: AppDesign.spacing.md),
                                if (mealCheckinScheduleMode ==
                                    MealCheckinScheduleMode.perMeal) ...[
                                  for (final mealOfTheDay in MealOfTheDay.values)
                                    if (mealReminders[mealOfTheDay]
                                        case final mealReminder?)
                                      MealReminderRow(
                                        mealOfTheDay: mealOfTheDay,
                                        mealReminder: mealReminder,
                                        onToggled: (enabled) =>
                                            getIt<OnboardingBloc>().add(
                                              OnboardingEvent.mealReminderToggled(
                                                mealOfTheDay,
                                                enabled: enabled,
                                              ),
                                            ),
                                        onTimeChanged: (timeOfDay) =>
                                            getIt<OnboardingBloc>().add(
                                              OnboardingEvent.mealReminderTimeChanged(
                                                mealOfTheDay,
                                                timeOfDay,
                                              ),
                                            ),
                                      ),
                                  SkipLoggedRemindersTile(
                                    skipLoggedMealReminders:
                                        skipLoggedMealReminders,
                                    onChanged: (value) =>
                                        getIt<OnboardingBloc>().add(
                                          OnboardingEvent.skipLoggedMealRemindersChanged(
                                            skipLoggedMealReminders: value,
                                          ),
                                        ),
                                  ),
                                ],
                                if (mealCheckinScheduleMode ==
                                    MealCheckinScheduleMode.endOfDay)
                                  EndOfDayReminderRow(
                                    mealReminder: endOfDayReminder,
                                    onTimeChanged: (timeOfDay) =>
                                        getIt<OnboardingBloc>().add(
                                          OnboardingEvent.endOfDayTimeChanged(
                                            timeOfDay,
                                          ),
                                        ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppDesign.spacing.md),
                      OnboardingActions(
                        primary: FilledButton(
                          onPressed: () async {
                            // Choosing notifications prompts the OS first. If
                            // it isn't granted, revert to the on-app-open style
                            // and stay on this step.
                            if (reminderStyle == ReminderStyle.notifications) {
                              final status =
                                  await getIt<NotificationService>()
                                      .requestPermission();
                              if (!status.isGranted) {
                                getIt<OnboardingBloc>().add(
                                  const OnboardingEvent.reminderStyleSelected(
                                    ReminderStyle.onAppOpen,
                                  ),
                                );
                                if (!context.mounted) return;
                                await showDialog<void>(
                                  context: context,
                                  builder: (_) =>
                                      const EnableNotificationsInSettingsDialog(),
                                );
                                return;
                              }
                            }
                            getIt<OnboardingBloc>().add(
                              const OnboardingEvent.continuePressed(),
                            );
                          },
                          child: const Text('Continue'),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Delete the old views and update the barrel + switch**

Delete `reminder_style_view.dart` and `meal_schedule_view.dart`. In `view.dart`, remove their exports and add `export 'reminders_view.dart';`. Update `onboarding_view.dart`'s switch:

```dart
return switch (step) {
  OnboardingStep.welcome => const WelcomeView(),
  OnboardingStep.buildUsuals => const BuildUsualsView(),
  OnboardingStep.firstLog => const FirstLogView(),
  OnboardingStep.reminders => const RemindersView(),
  OnboardingStep.weightTracking => const WeightTrackingView(),
  OnboardingStep.goals => const GoalsView(),
  // TODO(onboarding): route to the home/log feature once it exists.
  OnboardingStep.complete => const CompleteView(),
};
```

- [ ] **Step 5: Update the skip handler's reminders case**

In `onboarding_bloc.dart`, the skip-as-opt-out case keyed on `OnboardingStep.reminderStyle` becomes `OnboardingStep.reminders`:

```dart
OnboardingStep.reminders => state.copyWith(
  settings: state.settings.copyWith(
    reminderStyle: ReminderStyle.onAppOpen,
  ),
  step: nextStep,
),
```

- [ ] **Step 6: Write the merged view test**

Create `test/app/feature/onboarding/view/reminders_view_test.dart`, modeled on the deleted `reminder_style_view_test.dart` and `meal_schedule_view_test.dart`. Cover:

```dart
testWidgets('shows the reminder style options', (tester) async {
  // stub OnboardingState(step: OnboardingStep.reminders) with default settings
  // pump RemindersView
  expect(find.byType(RadioOptionCard), findsNWidgets(ReminderStyle.values.length));
});

testWidgets('hides the schedule when reminders are off', (tester) async {
  // stub settings.reminderStyle == ReminderStyle.none
  expect(find.byType(MealScheduleModeSelector), findsNothing);
});

testWidgets('shows the schedule when a reminder style is chosen', (tester) async {
  // stub settings.reminderStyle == ReminderStyle.onAppOpen, perMeal mode
  expect(find.byType(MealScheduleModeSelector), findsOneWidget);
  expect(find.byType(MealReminderRow), findsWidgets);
});
```
Use the existing `stubBloc` / `pumpApp` helpers and `mocktail`, matching the style of the deleted tests.

- [ ] **Step 7: Update `onboarding_view_test.dart` routing**

Replace the `reminderStyle` / `mealSchedule` route expectations with a single `reminders` expectation, and add `firstLog` in its new position:

```dart
testWidgets('routes reminders step to RemindersView', (tester) async {
  await pumpAtStep(tester, OnboardingStep.reminders);
  expect(find.byType(RemindersView), findsOneWidget);
});
```
Remove any `MealScheduleView` / `ReminderStyleView` route tests.

- [ ] **Step 8: Run the onboarding suite to verify it passes**

Run: `fvm flutter test test/app/feature/onboarding --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 9: Run the analyzer for dangling references**

Run: `fvm flutter analyze lib/app/feature/onboarding test/app/feature/onboarding`
Expected: No errors (info/warnings are out of scope per project rules).

- [ ] **Step 10: Commit**

```bash
git add lib/app/feature/onboarding test/app/feature/onboarding
```
Suggested message: `feat(onboarding): merge reminder screens and move first log before config`

---

## Task 3: Normalize `_FoodCard` onto the themed Card

Rebuild the first-log grid card on the themed `Card` + `InkWell` the rest of the app uses, drop the hand-rolled border and the `165/134` aspect ratio, and show the meal's `photoPath` image when present instead of an always-empty grey box.

**Files:**
- Modify: `lib/app/feature/onboarding/view/first_log_view.dart:74-90` (grid), `:150-218` (`_FoodCard`)
- Test: `test/app/feature/onboarding/view/first_log_view_test.dart`

**Interfaces:**
- Consumes: `UsualMeal` (`name`, `id`, `photoPath`), `QuantityStepper`, `OnboardingEvent.firstLogItemToggled`, `OnboardingEvent.firstLogItemQuantityChanged`.

- [ ] **Step 1: Write a failing test for the image behavior**

In `first_log_view_test.dart`, add:

```dart
testWidgets('a usual with no photo shows no image placeholder box', (
  tester,
) async {
  // stub state at OnboardingStep.firstLog with one usual meal, photoPath null
  await pumpFirstLog(tester);
  expect(find.byType(Image), findsNothing);
});

testWidgets('selecting a usual reveals its quantity stepper', (tester) async {
  // stub state with one usual meal selected
  await pumpFirstLog(tester);
  expect(find.byType(QuantityStepper), findsOneWidget);
});
```
(Reuse whatever first-log pump helper the file already defines; if it inlines `OnboardingState(step: OnboardingStep.firstLog, ...)`, follow that.)

- [ ] **Step 2: Run to verify the image test fails**

Run: `fvm flutter test test/app/feature/onboarding/view/first_log_view_test.dart --test-randomize-ordering-seed random`
Expected: FAIL — current `_FoodCard` always renders the placeholder `Icon`, and the assertion on `Image` / structure does not yet hold.

- [ ] **Step 3: Rebuild `_FoodCard` and the grid**

Replace the grid's magic aspect ratio with a named constant at the top of `_FoodCardState`'s file scope, and rebuild the card on `Card`. Update the `GridView.count` call:

```dart
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: AppDesign.spacing.md,
  crossAxisSpacing: AppDesign.spacing.md,
  childAspectRatio: _foodCardAspectRatio,
  children: [
    for (final usualMeal in usualMeals)
      _FoodCard(
        usualMeal: usualMeal,
        selected: selectedIds.contains(usualMeal.id),
        quantity: quantities[usualMeal.id] ?? 1,
      ),
  ],
),
```

Add the constant near the top of the file (below imports):

```dart
/// Width-to-height ratio of a first-log grid card: roughly square with room
/// for the name and an optional quantity stepper below the thumbnail.
const _foodCardAspectRatio = 1.25;
```

Rewrite `_FoodCard.build` to use the themed `Card`, select via its border side, and render the photo only when present:

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final photoPath = usualMeal.photoPath;
  return Card(
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDesign.radius.md),
      side: BorderSide(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
        width: selected ? 2 : 1,
      ),
    ),
    child: InkWell(
      onTap: () => getIt<OnboardingBloc>().add(
        OnboardingEvent.firstLogItemToggled(usualMeal.id),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDesign.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (photoPath != null)
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDesign.radius.sm),
                  child: Image.file(
                    File(photoPath),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              const Spacer(),
            SizedBox(height: AppDesign.spacing.sm),
            Text(
              usualMeal.name,
              style: theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (selected) ...[
              SizedBox(height: AppDesign.spacing.sm),
              QuantityStepper(
                dense: true,
                quantity: quantity,
                onChanged: (quantity) => getIt<OnboardingBloc>().add(
                  OnboardingEvent.firstLogItemQuantityChanged(
                    usualMeal.id,
                    quantity,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
```

Add `import 'dart:io';` at the top of `first_log_view.dart` for `File`.

- [ ] **Step 4: Run the first-log tests to verify they pass**

Run: `fvm flutter test test/app/feature/onboarding/view/first_log_view_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/app/feature/onboarding/view/first_log_view.dart test/app/feature/onboarding/view/first_log_view_test.dart
```
Suggested message: `refactor(onboarding): rebuild first-log card on the themed Card`

---

## Task 4: De-magic `onboarding_actions` and audit remaining styling

Replace the bare `48` heights with a named constant and sweep the onboarding views for any non-token spacing/sizing/colors.

**Files:**
- Modify: `lib/app/feature/onboarding/widgets/onboarding_actions.dart`
- Modify (only where the audit finds non-token values): the onboarding view files
- Test: `test/app/feature/onboarding/widgets/onboarding_actions_test.dart` (create if absent)

- [ ] **Step 1: Replace the magic height in `onboarding_actions.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template onboarding_actions}
/// Bottom action area shared by onboarding screens. The secondary slot below
/// the primary button is fixed-height so the button stays put whether or not
/// it is filled; the supporting slot above only takes space when provided.
/// {@endtemplate}
class OnboardingActions extends StatelessWidget {
  /// {@macro onboarding_actions}
  const OnboardingActions({
    required this.primary,
    this.secondary,
    this.above,
    super.key,
  });

  /// Height reserved for the [above] and [secondary] slots so the primary
  /// button keeps a stable position whether or not those slots are filled.
  static const _slotHeight = 48.0;

  /// The main call to action, stretched to full width.
  final Widget primary;

  /// Optional secondary action shown below [primary], always at the bottom.
  final Widget? secondary;

  /// Optional supporting content shown above [primary].
  final Widget? above;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (above != null) ...[
          SizedBox(height: _slotHeight, child: above),
          SizedBox(height: AppDesign.spacing.md),
        ],
        primary,
        SizedBox(height: _slotHeight, child: secondary),
      ],
    );
  }
}
```

- [ ] **Step 2: Audit the onboarding views for non-token values**

Search for hardcoded numeric sizing, colors, and `TextStyle` literals across onboarding views:

Run: `fvm flutter analyze lib/app/feature/onboarding`
Then grep for residual magic values:
Run: `rg -n "SizedBox\(height: [0-9]|EdgeInsets\.[a-zA-Z]+\([0-9]|Color\(0x|fontSize:" lib/app/feature/onboarding`

For each hit that is not already a design token, replace it with the nearest `AppDesign.spacing` / `AppDesign.radius` token or a `Theme.of(context).textTheme` style. Expected after Tasks 1–3: only the intentional `_foodCardAspectRatio` and `_slotHeight` named constants remain. If a genuine new divergence is found, fix it in place; otherwise this step is a no-op confirmation.

- [ ] **Step 3: Confirm the suite still passes**

Run: `fvm flutter test test/app/feature/onboarding --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 4: Commit**

```bash
git add lib/app/feature/onboarding/widgets/onboarding_actions.dart lib/app/feature/onboarding
```
Suggested message: `refactor(onboarding): replace magic action-slot height with a named constant`

---

## Final verification

- [ ] Run the whole suite: `fvm flutter test --test-randomize-ordering-seed random` — expect PASS.
- [ ] Run `fvm flutter analyze` — expect no new errors in touched files.
- [ ] Ask Jacob to run the app from VS Code and walk the flow: welcome → build usuals → first log → reminders (toggle "none" to confirm the schedule hides) → weight → goals → complete. Confirm a previously-completed install (existing stored state) still lands in the app, not back in onboarding.
```
