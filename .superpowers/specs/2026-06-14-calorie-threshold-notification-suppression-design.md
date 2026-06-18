# Calorie-threshold meal reminder suppression — design

Status: on hold (design approved, implementation deferred)
Date: 2026-06-14

## Goal

Don't send a meal's "did you eat X?" reminder if the user has already logged
more than a configurable calorie amount for that meal that day. The threshold
defaults to 250 calories and is configurable per meal.

Examples:
- Logged 500 cal for lunch, threshold 250 → no "did you eat lunch?" reminder.
- Logged 100 cal for lunch, threshold 250 → reminder still fires.
- Logged exactly 250 → reminder still fires (comparison is strictly greater than).

## Decisions

- **Per-meal only.** Suppression applies only in per-meal schedule mode
  (`MealCheckinScheduleMode.perMeal`). The end-of-day reminder always fires
  regardless of calories logged; no threshold is shown for it.
- **Reuse existing schedule mode.** Threshold inputs live on the existing
  per-meal reminder rows. No new "per meal" checkbox — the existing schedule
  mode selector already gates per-meal configuration.
- **Single number, no separate on/off.** Each meal has one threshold number
  (default 250). To effectively disable suppression for a meal, set it very
  high. The meal's existing enable switch still turns the whole reminder off.
- **Strict comparison.** A meal is suppressed when
  `caloriesLoggedForMeal > suppressAboveCalories`.

## Core constraint

Meal reminders are scheduled in advance as OS-level daily repeats
(`NotificationService._scheduleDaily`, using `zonedSchedule` with
`matchDateTimeComponents: DateTimeComponents.time`). The OS fires them on its
own — no app code runs at fire time to check calories. So suppression must be
decided when reminders are (re)scheduled, and re-scheduling must be triggered by
logging a meal.

Today `sync()` runs only on `UserSettingsBloc` changes and at app launch
(`the_usuals_app.dart`). The implementation adds a trigger on daily-log changes.

iOS caps pending notifications at 64, which is why the codebase uses native
daily repeats (1 slot each) rather than scheduling many individual days. This
rules out a large rolling window for meals.

## Chosen approach: cancel-to-skip-today (Approach A)

Keep the native daily repeat as the baseline for every enabled meal, so
reminders fire reliably forever even if the app is never reopened. Re-sync
whenever a meal is logged. At sync time, compute today's logged calories per
meal; if a meal is over its threshold and its reminder time is still later
today, skip scheduling that meal's slot.

Suppression self-heals on the next sync (next meal logged or next app open):
once "today" rolls over, calories reset and the meal's repeat is rescheduled.

Tradeoff: if the user logs a big meal and then never reopens the app the next
day, that next day's reminder for that meal could be missed until the app is
reopened. It self-heals on open, and a user not opening the app isn't logging
anyway.

### Approaches considered and rejected

- **B — Rolling window per meal.** Individually schedule the next ~10 days per
  meal (like the existing weight code), skipping today when over threshold.
  Precise "skip today, keep future days," but the iOS 64-slot cap forces a short
  horizon; if the app isn't opened within the window, reminders stop — and
  forgetful users are exactly who reminders exist for.
- **C — Background evaluation.** A native background task wakes at each reminder
  time and checks calories before showing. True fire-time accuracy with no
  app-open dependency, but heavy: new background-execution plugin, platform
  config, and reading log data from a background isolate. Overkill.

## Implementation outline

### Model
- `lib/app/model/meal_reminder.dart`: add `@Default(250) int suppressAboveCalories`
  to `MealReminder`. Harmlessly unused by `endOfDayReminder`.

### Settings (UserSettingsBloc)
- New event `UserSettingsEvent.mealReminderThresholdChanged(MealOfTheDay, int)`.
- Handler `copyWith`s the meal's reminder, mirroring the existing
  `mealReminderToggled` / `mealReminderTimeChanged` handlers.

### UI
- `lib/app/widgets/meal_reminder_row.dart`: add a threshold number field and an
  `onThresholdChanged` callback. Shown only in per-meal mode (the row already is).
- `lib/app/feature/user_settings/widgets/meal_schedule_section.dart`: wire
  `onThresholdChanged` to the new event at the existing `MealReminderRow` call.
- End-of-day mode shows no threshold (unchanged).

### Notification wiring
- `lib/app/core/service/notification_service.dart`: `sync()` gains a
  `Map<MealOfTheDay, int> caloriesByMealToday` parameter. In the `perMeal`
  branch, skip scheduling a meal when its today-calories exceed
  `suppressAboveCalories` and its `timeOfDay` hasn't passed yet today.
- `lib/app/the_usuals_app.dart`: `_syncNotifications` computes
  `caloriesByMealToday` from `DailyLogBloc` state via
  `breakdownOn(DateTime.now())` (see
  `lib/app/model/extensions/meal_log_entry_list_extensions.dart`), summing each
  meal's `totalNutrition.calories`. Add a
  `BlocListener<DailyLogBloc, DailyLogState>` that re-syncs on log changes, so
  logging a meal drops that meal's upcoming reminder.

## Open items to confirm before implementation

- Threshold field input affordance and validation range (e.g. min 0, sensible
  max) on `MealReminderRow`.
- Whether to also re-sync on app resume (foreground) to rearm reminders that
  were skipped while the app was backgrounded. Not required for the core flow
  (logging a meal already triggers a sync), but tightens the self-heal window.
