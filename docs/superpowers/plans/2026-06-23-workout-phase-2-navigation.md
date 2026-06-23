# Workout Feature — Phase 2: Navigation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Restructure the bottom navigation to two tabs (Meals, Workouts) and move History to an app-bar action, without modifying the existing meal `HistoryView` widget.

**Architecture:** The `StatefulShellRoute`'s second branch changes from History to a new minimal `WorkoutsView`. `/history` becomes a top-level route pushed from an app-bar history action. `TheUsualAppBar` gains an optional `historyRoute` that renders a history `IconButton`. The Today view passes `Routes.history`; the Workouts tab's history action is wired later in Phase 7 when workout history exists.

**Tech Stack:** Flutter, go_router, flutter_bloc, get_it, l10n (gen_l10n).

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, section 3.
- **Do NOT modify the meal `HistoryView` widget** (`lib/app/feature/history/view/history_view.dart`). Only its route entry point changes.
- The new `WorkoutsView` in this phase is a **minimal placeholder** (app bar + empty body). It must NOT depend on `WorkoutLogBloc` or any new bloc yet — Phase 3 builds the real body. This keeps `app_test.dart` (which boots the full app) green without new getIt registrations.
- Bottom nav labels are hidden (`NavigationDestinationLabelBehavior.alwaysHide`); the icon carries the meaning. Labels still set for semantics/tooltip.
- Never run the app. Use `fvm flutter` / `fvm dart`, never bare. A `build_runner watch` is running but may lag; if generated output is stale after ~30s, a one-shot `fvm dart run build_runner build --delete-conflicting-outputs` is permitted for this automated run only.
- Barrel files: import via `package:the_usual/app/app.dart`; export new files through their barrels.
- Do NOT commit (the controller commits per task). Leave changes in the working tree.
- Testing: widget tests via the `pumpPumpPumpItUP` helper (`test/helpers/pump_app.dart`); it accepts a `router:` GoRouter for navigation tests. Locate widgets by type/key/icon, NOT by display string. Run with `--test-randomize-ordering-seed random`. Full TDD: test first.

---

### Task 1: Workouts route + minimal WorkoutsView scaffold

**Files:**
- Modify: `lib/app/navigation/routes.dart`
- Create: `lib/app/feature/workout/view/workouts_view.dart`
- Create: `lib/app/feature/workout/view/view.dart`
- Modify: `lib/app/feature/workout/workout.dart`
- Create: `test/app/feature/workout/view/workouts_view_test.dart`

**Interfaces:**
- Produces: `Routes.workouts` (`'/workouts'`); `WorkoutsView` (StatelessWidget, `Scaffold` + `TheUsualAppBar(title: 'Workouts')`, empty body).

- [ ] **Step 1: Write the failing test**

Create `test/app/feature/workout/view/workouts_view_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_usual/app/app.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(WorkoutsView, () {
    testWidgets('renders the shared app bar', (tester) async {
      await tester.pumpPumpPumpItUP(const WorkoutsView());

      expect(find.byType(TheUsualAppBar), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isA<Text>());
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/feature/workout/view/workouts_view_test.dart`
Expected: FAIL — `WorkoutsView` is undefined.

- [ ] **Step 3: Add the route constant**

In `lib/app/navigation/routes.dart`, add after the `today` line:

```dart
  static const String workouts = '/workouts';
```

- [ ] **Step 4: Create the placeholder view**

Create `lib/app/feature/workout/view/workouts_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template workouts_view}
/// The Workouts tab: logs the day's workouts from the user's usuals, grouped
/// by training group. The body is filled in a later phase.
/// {@endtemplate}
class WorkoutsView extends StatelessWidget {
  /// {@macro workouts_view}
  const WorkoutsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TheUsualAppBar(title: 'Workouts'),
      body: SizedBox.shrink(),
    );
  }
}
```

- [ ] **Step 5: Create the view barrel and export it**

Create `lib/app/feature/workout/view/view.dart`:

```dart
export 'workouts_view.dart';
```

In `lib/app/feature/workout/workout.dart`, add:

```dart
export 'view/view.dart';
```

- [ ] **Step 6: Run test to verify it passes**

Run: `fvm flutter test test/app/feature/workout/view/workouts_view_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

- [ ] **Step 7: Report for controller commit**

Report files changed. Suggested commit message: `feat(workout): add Routes.workouts and placeholder WorkoutsView`.

---

### Task 2: History action on TheUsualAppBar

Add an optional `historyRoute` to the shared app bar. When set, it renders a history `IconButton` (before the settings gear) that pushes the route.

**Files:**
- Modify: `lib/app/widgets/display/the_usual_app_bar.dart`
- Modify: `test/app/widgets/display/the_usual_app_bar_test.dart`

**Interfaces:**
- Consumes: `context.l10n.historyTooltip` (already exists in `app_en.arb`).
- Produces: `TheUsualAppBar({required String title, Widget? titleWidget, String? historyRoute})`. When `historyRoute != null`, an `Icons.history_outlined` button that does `context.push(historyRoute)`.

- [ ] **Step 1: Write the failing tests**

In `test/app/widgets/display/the_usual_app_bar_test.dart`, add these inside the `group(TheUsualAppBar, ...)` (keep the existing two tests). Add the imports `package:go_router/go_router.dart`:

```dart
    testWidgets('shows no history action when historyRoute is null', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(appBar: TheUsualAppBar(title: 'Today')),
      );

      expect(find.byIcon(Icons.history_outlined), findsNothing);
    });

    testWidgets('shows a history action when historyRoute is set', (
      tester,
    ) async {
      await tester.pumpPumpPumpItUP(
        const Scaffold(
          appBar: TheUsualAppBar(title: 'Today', historyRoute: '/history'),
        ),
      );

      expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    });

    testWidgets('the history action pushes the history route', (tester) async {
      final router = GoRouter(
        initialLocation: '/start',
        routes: [
          GoRoute(
            path: '/start',
            builder: (context, state) => const Scaffold(
              appBar: TheUsualAppBar(title: 'Today', historyRoute: '/history'),
            ),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const Scaffold(
              body: SizedBox.shrink(key: Key('history-screen')),
            ),
          ),
        ],
      );

      await tester.pumpPumpPumpItUP(const SizedBox.shrink(), router: router);
      await tester.tap(find.byIcon(Icons.history_outlined));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('history-screen')), findsOneWidget);
    });
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `fvm flutter test test/app/widgets/display/the_usual_app_bar_test.dart`
Expected: FAIL — `historyRoute` is not a parameter; the push test can't find the icon.

- [ ] **Step 3: Add the parameter and action**

In `lib/app/widgets/display/the_usual_app_bar.dart`, update the constructor and doc, and add the field:

```dart
  const TheUsualAppBar({
    required this.title,
    this.titleWidget,
    this.historyRoute,
    super.key,
  });
```

Add the field after `titleWidget`:

```dart
  /// When set, the bar shows a history button that pushes this route. Null on
  /// screens that have no history shortcut (e.g. the history screen itself).
  final String? historyRoute;
```

In `build`, change the `actions` list so the history button renders first when `historyRoute` is set:

```dart
      actions: [
        if (historyRoute case final historyRoute?)
          IconButton(
            onPressed: () => context.push(historyRoute),
            tooltip: context.l10n.historyTooltip,
            icon: const Icon(Icons.history_outlined),
          ),
        IconButton(
          onPressed: () => context.go(Routes.settings),
          tooltip: context.l10n.settingsTooltip,
          icon: const Icon(Icons.settings_outlined),
        ),
        if (kDebugMode)
          IconButton(
            onPressed: () => context.push(Routes.devTools),
            tooltip: context.l10n.devToolsTooltip,
            icon: const Icon(Icons.code),
          ),
      ],
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `fvm flutter test test/app/widgets/display/the_usual_app_bar_test.dart --test-randomize-ordering-seed random`
Expected: PASS (5 tests).

- [ ] **Step 5: Report for controller commit**

Suggested commit message: `feat(workout): add optional history action to TheUsualAppBar`.

---

### Task 3: Restructure router to Meals/Workouts tabs with History as a pushed route

**Files:**
- Modify: `lib/app/navigation/app_router.dart`
- Modify: `lib/app/feature/today/view/today_view.dart`
- Modify: `test/app/navigation/navigation_wrapper_test.dart`

**Interfaces:**
- Consumes: `Routes.workouts` (Task 1), `WorkoutsView` (Task 1), `TheUsualAppBar.historyRoute` (Task 2).
- Produces: nav destinations `[Meals, Workouts]`; shell branch 1 = `/workouts`; `/history` as a top-level pushed route.

- [ ] **Step 1: Write/adjust the failing test**

In `test/app/navigation/navigation_wrapper_test.dart`, change the branch-switch test to tap the Workouts destination (branch 1 is now Workouts). Replace the `'switches branch when a nav item is selected'` test body's tap and comment:

```dart
      // Workouts is the unselected destination, so it shows its outlined icon.
      await tester.tap(find.byIcon(Icons.fitness_center_outlined));

      verify(
        () => navigationShell.goBranch(
          1,
          initialLocation: any(named: 'initialLocation'),
        ),
      ).called(1);
```

- [ ] **Step 2: Run test to verify it fails**

Run: `fvm flutter test test/app/navigation/navigation_wrapper_test.dart`
Expected: FAIL — `Icons.fitness_center_outlined` is not present (destinations still Today/History).

- [ ] **Step 3: Update destinations**

In `lib/app/navigation/app_router.dart`, replace the `destinations` list:

```dart
  /// Destinations for the Meals and Workouts bottom navigation bar.
  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.restaurant_outlined),
      selectedIcon: Icon(Icons.restaurant),
      label: 'Meals',
    ),
    NavigationDestination(
      icon: Icon(Icons.fitness_center_outlined),
      selectedIcon: Icon(Icons.fitness_center),
      label: 'Workouts',
    ),
  ];
```

- [ ] **Step 4: Swap branch 1 to Workouts and make /history a top-level route**

In the `routes` list, change the second `StatefulShellBranch` from the History route to the Workouts route:

```dart
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.workouts,
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: WorkoutsView());
              },
            ),
          ],
        ),
```

Then add `/history` as a top-level route (a sibling of the `settings` route, NOT inside the shell), so it pushes over the tabs with a back button:

```dart
    GoRoute(
      path: Routes.history,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: HistoryView());
      },
    ),
```

Leave `Routes.today` branch 0, the `settings` route, and the debug `devTools` route unchanged.

- [ ] **Step 5: Wire the Today view's history action**

In `lib/app/feature/today/view/today_view.dart`, add `historyRoute: Routes.history` to the `TheUsualAppBar`:

```dart
      appBar: TheUsualAppBar(
        title: 'Today',
        historyRoute: Routes.history,
        titleWidget: ActionChip(
```

(keep the existing `titleWidget` ActionChip and `onPressed` exactly as they are).

- [ ] **Step 6: Run the navigation test, then the full suite**

Run: `fvm flutter test test/app/navigation/navigation_wrapper_test.dart --test-randomize-ordering-seed random`
Expected: PASS.

Then run the full suite to catch fallout (e.g., `app_test.dart` booting the app, any test that tapped the old History nav icon):

Run: `fvm flutter test --test-randomize-ordering-seed random`
Expected: PASS. If a test referenced the removed History bottom-nav destination or `Icons.history` in the nav, update it to the new structure (Workouts tab; History now reached via the Today app-bar action). Report any such fixes.

- [ ] **Step 7: Report for controller commit**

Suggested commit message: `feat(workout): two-tab nav (Meals/Workouts), History moved to app-bar action`.

---

## Self-Review

**Spec coverage (section 3):**
- Bottom nav → Meals + Workouts — Task 3. ✓
- History off the bottom bar, onto an app-bar action — Tasks 2, 3. ✓
- `/workouts` route + a renderable Workouts tab — Task 1. ✓
- `/history` standalone pushed route, existing `HistoryView` unmodified — Task 3 (route entry only; widget untouched). ✓
- Workouts-tab history action deferred to Phase 7 (workout history doesn't exist yet) — noted; `WorkoutsView` passes no `historyRoute` this phase.

**Placeholder scan:** None — every step has concrete code or an exact command.

**Type consistency:** `historyRoute` is `String?` in `TheUsualAppBar` and passed `Routes.history` (a `String`) from `TodayView`. `Routes.workouts` is referenced by the new branch. Branch index 1 = Workouts matches the `navigation_wrapper_test` `goBranch(1)` expectation and the `fitness_center_outlined` icon.

**Deferred:** Registering a `MockWorkoutLogBloc` in `pump_app.dart` is deferred to Phase 3, where `WorkoutsView` first consumes the bloc. The Phase 2 placeholder deliberately has no bloc dependency, so `app_test.dart` needs no new registration.
