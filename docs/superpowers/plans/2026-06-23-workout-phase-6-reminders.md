# Workout Feature — Phase 6: Reminders Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:subagent-driven-development. Checkbox (`- [ ]`) steps.

**Goal:** A configurable workout reminder — enable, pick days of the week, pick a time — scheduled as weekly notifications, plus a settings "Workouts" section that also holds the workout weight-unit toggle.

**Architecture:** Add workout-reminder mutation events to `UserSettingsBloc` (the `workoutReminder` field and `workoutWeightUnit` event already exist from Phase 1). Extend `NotificationService.sync` to schedule a weekly notification per selected day (gated on the global notifications style). `the_usuals_app._syncNotifications` passes the workout reminder. New settings widgets render the controls.

**Tech Stack:** Flutter, flutter_local_notifications, flutter_bloc, get_it.

## Global Constraints

- **Spec:** `docs/superpowers/specs/2026-06-23-workout-feature-design.md`, section 7. Cadence-style recurrence is OUT of scope (day-of-week + time only).
- **Reminder copy (exact):** title `'Did you work out today?'`, body `'Tap to log it in The Usual.'`
- **Gating:** schedule workout reminders only when `reminderStyle == ReminderStyle.notifications` AND `workoutReminder.enabled` AND `daysOfWeek` is non-empty. (The global notifications style is the master switch and governs permission, exactly as meal/weight reminders gate on it.)
- **Notification id scheme:** workout reminders use base `300` + `dayOfWeek` (1-7), i.e. ids 301-307, disjoint from meals (0-3), end-of-day (100), weight (200+). Reuse the service's existing `cancelAll`-then-reschedule flow in `sync`.
- `daysOfWeek` are ints 1=Monday … 7=Sunday (matches `DateTime.weekday`).
- No "skip when already logged" for workouts (not specified) — keep it simple.
- Reuse `showTimePicker` and the `ActionChip` time-chip pattern from `MealReminderRow`; reuse `FilterChip`/`ChoiceChip` styling for day and unit selectors. Reuse `SectionLabel`. No new colors/fonts.
- Naming: full model-type variable names. Widgets dispatch via `getIt<UserSettingsBloc>()`. Never run the app. `fvm flutter`/`fvm dart` only; one-shot build permitted if the watcher lags (this run only). Do NOT commit (controller commits). Full TDD; tests locate by type/key/icon and verify dispatched events / scheduled notifications. Run with `--test-randomize-ordering-seed random`.

---

### Task 1: Workout reminder events in UserSettingsBloc

**Files:**
- Modify: `lib/app/feature/user_settings/bloc/user_settings_event.dart`
- Modify: `lib/app/feature/user_settings/bloc/user_settings_bloc.dart`
- Modify: `test/app/feature/user_settings/bloc/user_settings_bloc_test.dart`

**Events produced:**
```dart
const factory UserSettingsEvent.workoutReminderToggled({required bool enabled}) = SettingsWorkoutReminderToggled;
const factory UserSettingsEvent.workoutReminderDayToggled(int dayOfWeek, {required bool enabled}) = SettingsWorkoutReminderDayToggled;
const factory UserSettingsEvent.workoutReminderTimeChanged(TimeOfDay timeOfDay) = SettingsWorkoutReminderTimeChanged;
```

**Handlers:**
- `workoutReminderToggled` → `state.copyWith(workoutReminder: state.workoutReminder.copyWith(enabled: enabled))`.
- `workoutReminderDayToggled` → add/remove `dayOfWeek` in `state.workoutReminder.daysOfWeek` (a new `Set<int>`), emit `copyWith(workoutReminder: ...copyWith(daysOfWeek: updated))`.
- `workoutReminderTimeChanged` → `copyWith(workoutReminder: ...copyWith(timeOfDay: timeOfDay))`.

Add the three cases to the exhaustive `switch`.

**Tests** (mirror existing settings bloc tests): toggling enable updates `workoutReminder.enabled`; toggling a day on adds it, off removes it; changing time updates it. Use `isA<UserSettingsState>().having(...)`.

- [ ] **Step 1:** Write failing tests. **Step 2:** run them (FAIL — events undefined). **Step 3:** add events + switch cases + handlers. **Step 4:** run with random seed (PASS, existing settings tests still pass). **Step 5:** report. Commit: `feat(workout): add workout reminder settings events`.

---

### Task 2: Schedule the workout reminder in NotificationService

**Files:**
- Modify: `lib/app/core/service/notification_service.dart`
- Modify: `lib/app/the_usuals_app.dart`
- Modify: `test/app/core/service/notification_service_test.dart`

**Behavior:**
- Add a parameter to `sync`: `WorkoutReminder workoutReminder = const WorkoutReminder(enabled: false, timeOfDay: TimeOfDay(hour: 18, minute: 0))` (defaulted so existing test calls/behavior are unchanged).
- After the weight scheduling block in `sync`, add:
  ```dart
  if (reminderStyle == ReminderStyle.notifications && workoutReminder.enabled) {
    for (final dayOfWeek in workoutReminder.daysOfWeek) {
      await _scheduleWeekly(
        id: _workoutBaseId + dayOfWeek,
        title: 'Did you work out today?',
        body: 'Tap to log it in The Usual.',
        dayOfWeek: dayOfWeek,
        time: workoutReminder.timeOfDay,
      );
    }
  }
  ```
- Add `static const _workoutBaseId = 300;`.
- Add `_scheduleWeekly`, mirroring `_scheduleDaily` but anchored to a weekday and repeating weekly:
  ```dart
  Future<void> _scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int dayOfWeek,
    required TimeOfDay time,
  }) async {
    var scheduled = _nextInstanceOf(time); // existing helper: today/tomorrow at time
    while (scheduled.weekday != dayOfWeek) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await plugin.zonedSchedule(
      id: id,
      scheduledDate: scheduled,
      title: title,
      body: body,
      notificationDetails: _details,            // use the same NotificationDetails the daily scheduler uses
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle, // match _scheduleDaily's mode
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }
  ```
  (Read `_scheduleDaily` first and copy its exact `notificationDetails`/`androidScheduleMode` arguments so the two are consistent.)
- In `lib/app/the_usuals_app.dart` `_syncNotifications()`, pass `workoutReminder: settings.workoutReminder` to `getIt<NotificationService>().sync(...)`.

**Tests** (add to `notification_service_test.dart`, mirroring its existing `zonedSchedule` verification): 
1. with `reminderStyle.notifications` + `workoutReminder(enabled: true, daysOfWeek: {1, 3})`, `zonedSchedule` is called with `id: 301` and `id: 303` and the workout title (verify both, and assert `matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime`).
2. `workoutReminder.enabled: false` → no workout `zonedSchedule` calls (id ≥ 300).
3. `reminderStyle.none` → no workout calls even when enabled.

- [ ] **Step 1-5:** TDD cycle. Run `notification_service_test.dart` then the full suite; fix fallout (e.g. any sync call site). Commit: `feat(workout): schedule weekly workout reminders`.

---

### Task 3: WorkoutReminderRow widget (toggle + day chips + time)

**Files:**
- Create: `lib/app/widgets/selectors/workout_reminder_row.dart`
- Modify: `lib/app/widgets/widgets.dart`
- Create: `test/app/widgets/workout_reminder_row_test.dart`

**Interface produced:**
```dart
class WorkoutReminderRow extends StatelessWidget {
  const WorkoutReminderRow({
    required this.workoutReminder,
    required this.onToggled,         // ValueChanged<bool>
    required this.onDayToggled,      // void Function(int dayOfWeek, bool enabled)
    required this.onTimeChanged,     // ValueChanged<TimeOfDay>
    super.key,
  });
}
```

**Behavior (mirror `MealReminderRow` for the toggle + time chip):**
- A `Card`/`ListTile`-style row: a `Switch(value: workoutReminder.enabled, onChanged: onToggled)`, and when enabled, a time `ActionChip(label: Text(workoutReminder.timeOfDay.format(context)))` opening `showTimePicker` → `onTimeChanged`.
- When enabled, below the row show a `Wrap` of seven `FilterChip`s for Mon-Sun (labels from a const `['Mon','Tue','Wed','Thu','Fri','Sat','Sun']`, index 0 → dayOfWeek 1). Each chip `selected: workoutReminder.daysOfWeek.contains(dayOfWeek)`, `onSelected: (sel) => onDayToggled(dayOfWeek, sel)`. Give each chip `Key('workout-day-$dayOfWeek')`.
- When disabled, show no day chips (and "No reminder" text like MealReminderRow, optional).

**Tests:** (1) toggling the `Switch` reports through `onToggled`; (2) tapping a day `FilterChip` (`Key('workout-day-3')`) reports `onDayToggled(3, true/false)`; (3) day chips are hidden when `enabled: false`. (Time-picker test optional, mirroring `meal_reminder_row_test.dart`.)

- [ ] **Step 1-5:** TDD cycle. Export from `widgets.dart` (selectors group). Commit: `feat(workout): add WorkoutReminderRow`.

---

### Task 4: Workouts settings section (reminder + weight unit) wired into UserSettingsView

**Files:**
- Create: `lib/app/feature/user_settings/widgets/workout_section.dart`
- Modify: `lib/app/feature/user_settings/widgets/widgets.dart` (barrel)
- Modify: `lib/app/feature/user_settings/view/user_settings_view.dart`
- Create: `test/app/feature/user_settings/widgets/workout_section_test.dart`

**Behavior:**
- `WorkoutSection` (StatelessWidget): a `BlocSelector<UserSettingsBloc, UserSettingsState, (WorkoutReminder, WeightUnit)>` selecting `(workoutReminder, workoutWeightUnit)`, rendering:
  - A "Units" sub-row: `WeightUnit` `ChoiceChip`s (mirror `weight_input.dart`'s unit chips) → `getIt<UserSettingsBloc>().add(UserSettingsEvent.workoutWeightUnitSelected(option))`. Give chips `Key('workout-unit-${option.name}')`.
  - The `WorkoutReminderRow` wired to `workoutReminderToggled`, `workoutReminderDayToggled`, `workoutReminderTimeChanged`.
- In `user_settings_view.dart`, add a `SectionLabel('WORKOUTS')` + `WorkoutSection` between the "WEIGHT CHECK-INS" and "GOALS" sections (following the exact `SectionLabel` + spacing + section pattern).

**Tests** (`workout_section_test.dart`, mirror `meal_schedule_section_test.dart`): with a mocked `UserSettingsBloc`, (1) tapping a unit chip (`Key('workout-unit-kg')`) dispatches `workoutWeightUnitSelected(WeightUnit.kg)`; (2) toggling the reminder switch dispatches `workoutReminderToggled(enabled: true)`; (3) with the reminder enabled, tapping a day chip dispatches `workoutReminderDayToggled`. Also add a small check to `user_settings_view_test.dart` that `find.byType(WorkoutSection)` is present (mirror how it checks other sections).

- [ ] **Step 1-5:** TDD cycle. Run the section + view tests, then the FULL suite; fix fallout. Commit: `feat(workout): add Workouts settings section (reminder + weight unit)`.

---

## Self-Review

**Spec coverage (section 7):** configurable workout reminder (enable + days + time) — Tasks 1, 3, 4; weekly scheduling gated on the notifications style — Task 2; the workout weight-unit toggle (deferred from Phase 4) — Task 4. Cadence recurrence explicitly deferred. ✓

**Placeholder scan:** concrete code for events/handlers/scheduling; exact interfaces + behavior + tests for UI. No "TBD".

**Type consistency:** `daysOfWeek` is `Set<int>` (1-7) in the model, events (`workoutReminderDayToggled(int, {bool})`), and the scheduler (`_workoutBaseId + dayOfWeek` = 301-307); `workoutReminderTimeChanged(TimeOfDay)`; `workoutWeightUnitSelected(WeightUnit)` already exists. `sync`'s new `workoutReminder` param is defaulted to disabled so existing callers/tests are unaffected.
