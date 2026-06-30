# Today Feature

Status: implemented in `lib/app/feature/today/`. The landing screen after onboarding completes.
Last updated: 2026-06-13

## Purpose

Today is the home screen and the daily capture surface. It does two jobs:

1. **Log the day's meals** from the user's usual meals in as few taps as possible, with a running calorie total.
2. **Track weight** with a single weigh-in shown at the top.

Calories are always entered by the user. There is no estimation. An entry logged without calories simply isn't counted toward the day's total until a number is filled in.

## Screen layout

Top to bottom:

- **App bar**: title "Today", a Settings action, and a debug-only dev tools action.
- **Weight tracker**: a card showing the most recent weigh-in (value + unit) or "No weigh-ins yet", with a button to log/update today's weight.
- **Calorie total**: "N cal today", summing the calories of everything logged today.
- **Four meal sections** (breakfast, lunch, dinner, snacks): each shows what's already logged for that meal, quick-pick chips for the user's usual meals not yet logged, and an "I ate Something New" entry point. The meal nearest the current time is outlined as the focal one, but every meal is fillable so the day can be backfilled.

## Interactions

| Action                                  | What happens                                                                            |
| --------------------------------------- | --------------------------------------------------------------------------------------- |
| Tap a usual-meal quick-pick chip        | Logs that meal instantly, carrying the usual meal's stored calories (which may be null) |
| Tap "I ate Something New"               | Opens a sheet for a name + optional calories, logs a one-off entry                      |
| Edit the calories field on a logged row | Updates that entry's calories; blank means it stops counting toward the total           |
| Tap the ✕ on a logged row               | Removes that entry                                                                      |
| Tap "Log weight" / "Update"             | Opens a dialog to enter a weight; records a weigh-in stamped with the current unit      |

The starting weight entered during onboarding is committed as the first weigh-in when onboarding completes, so a freshly-onboarded user already sees a weight at the top.

## How the code fits together

The feature is a single BLoC plus a view tree that reads slices of it.

### The data store: `DailyLogBloc`

`lib/app/feature/today/bloc/daily_log_bloc.dart` (with `daily_log_event.dart` and `daily_log_state.dart` as part files).

- It's a `HydratedBloc`, so everything logged persists across app restarts automatically.
- Its state holds **two lists across all days**: `mealEntries` (`List<MealLogEntry>`) and `weightEntries` (`List<WeightEntry>`). It is not "today only" — the future history/trends screen will read the same store.
- Events: `mealLogged`, `mealEntryRemoved`, `mealEntryCaloriesChanged`, `weightLogged`, `weightEntryRemoved`. The handler is an exhaustive `switch`; one-line emissions sit inline, the rest delegate to small `_on…` methods.
- State helpers narrow the data for the view: `caloriesOn(day)` sums known calories for a day, `latestWeight` returns the most recent weigh-in. Per-day, per-meal filtering happens in the view via `DateUtils.isSameDay`.

### The models

- `lib/app/model/meal_log_entry.dart` — one logged food: `id`, `loggedAt`, `mealOfTheDay`, `name`, optional `calories`, optional `usualMealId` link back to the source usual, optional `photoPath`.
- `lib/app/model/weight_entry.dart` — one weigh-in: `id`, `loggedAt`, `weight`, `weightUnit`.

Both are **snapshots**: a log entry stores its own `name`/`calories` and a weigh-in stores its own `weightUnit`, rather than looking them up live. This keeps history immutable — renaming a usual meal or switching the weight unit later never rewrites past days. The optional `usualMealId` keeps the link to the source for provenance.

### The view tree

- `view/today_view.dart` — `TodayView` is the scaffold. Its body composes **two** blocs: a `BlocSelector` on `UserSettingsBloc` for the `usuals` map (quick-pick options), wrapping a `BlocSelector` on `DailyLogBloc` that selects `(caloriesOn(today), mealEntries)`. Selecting the calorie int and the raw list — both stable references across weigh-in changes — means logging a weight doesn't rebuild the meal list. The file also holds two private widgets: `_WeightTracker` (its own `BlocSelector` on `latestWeight`) and `_LogWeightDialog`.
- `widgets/meal_log_section.dart` — `MealLogSection`, rendered once per meal. Given that meal's logged entries and usual meals, it computes the calorie subtotal and the quick-picks (usuals not already logged), and renders the logged rows, chips, and the something-else button. It adds to `DailyLogBloc` directly via `getIt`.
- `widgets/logged_entry_row.dart` — `LoggedEntryRow`, one logged entry: name, an inline-editable calories field, and a remove button. Keyed by entry id so the text field's state stays bound to the right entry when the list changes.

### Shared widgets it reuses (`lib/app/widgets/`)

`FoodEntrySheet` (name + optional calories, also used by Settings), `TheUsualTextField` (the calorie field), and `AteSomethingElseDialog` is _not_ used here — Today uses `FoodEntrySheet` so a one-off can carry calories.

### Routing

`Routes.today` (`/today`) builds `TodayView`. Onboarding's complete screen and the Settings back button both navigate here with `context.go(Routes.today)`.

## Not built yet

- The history/trends screen that will read `DailyLogBloc`'s full set.
- Wiring onboarding's first-log selections into real `MealLogEntry` records (today only the weigh-in carries over).
- Photo capture and the `photoPath` field's use.
- Macros (fat/carbs/protein) — the models will extend to them later.
