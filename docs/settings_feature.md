# Settings Feature

Status: implemented in `lib/app/feature/user_settings/`. Reached from the Today app bar.
Last updated: 2026-06-13

## Purpose

Settings lets the user revisit and change every choice made during onboarding, plus manage their usual meals library. It is the long-lived owner of the user's preferences; onboarding fills it in once, and this screen edits it forever after.

## Screens

### Settings (`/settings`)

A scrolling list of sections:

- **How we check in** — reminder style: Notifications, When I open the app, Don't remind me.
- **When we ask** — only shown when reminders are on. A segmented control for per-meal vs once-a-day, then either per-meal reminder rows (toggle + time) or a single daily check-in row. When reminders are off, a dashed info box explains why this section is empty.
- **Weight check-ins** — frequency chips (Daily / Every 2 days / Weekly / Off), and when not Off: time-of-day chips and a current-weight field with a lb/kg toggle. Off shows a dashed info box.
- **Your food** — a row summarizing the usuals library ("17 items · Breakfast 5 · …") that navigates to the usual meals screen.
- **Replay onboarding** — resets the onboarding flow and returns to it.

### Your usual meals (`/settings/usuals`)

A tab per meal (breakfast, lunch, dinner, snacks), each tab listing that meal's usual meals with an inline-editable calorie field and a remove button, plus an "Add a usual" button that opens the name + calories sheet. Empty tabs show a dashed info box.

## Interactions

| Action | What happens |
| --- | --- |
| Pick a reminder style | Commits immediately to settings |
| Toggle/segment the meal schedule | Updates the schedule mode or a meal's reminder |
| Tap a reminder time chip | Opens a time picker, saves the chosen time |
| Pick weight frequency / time / unit, type a weight | Each commits immediately |
| Tap "Your usual meals" | Navigates to the usual meals tabs |
| Edit a usual meal's calories inline | Saves to that usual meal |
| Add / remove a usual meal | Updates the library |
| Replay onboarding | Resets onboarding state and routes to `/onboarding` |

Every edit writes straight to the settings store — there's no save button.

## How the code fits together

### The data store: `UserSettingsBloc`

`lib/app/feature/user_settings/bloc/user_settings_bloc.dart` (with `user_settings_event.dart` and `user_settings_state.dart` as part files).

- A `HydratedBloc`, so settings persist across restarts.
- `UserSettingsState` is the single settings model: `reminderStyle`, `mealCheckinScheduleMode`, `mealReminders` (a `Map<MealOfTheDay, MealReminder>`), `endOfDayReminder`, `weightCheckinFrequency`, `weightTimeOfDay`, `weightUnit`, `startingWeight`, and the `usuals` library (`Map<MealOfTheDay, List<UsualMeal>>`). It carries sensible defaults so a brand-new state is already valid.
- This same class is what onboarding edits as a draft. On completion, the app-level listener in `the_usuals_app.dart` fires `settingsCommitted(state.settings)` to hand the draft over here (and logs the starting weight as the first weigh-in).
- Events cover every editable field plus the usuals library: `reminderStyleSelected`, `mealCheckinScheduleModeChanged`, `mealReminderToggled`, `mealReminderTimeChanged`, `endOfDayTimeChanged`, `weightCheckinFrequencySelected`, `weightTimeOfDaySelected`, `weightUnitSelected`, `startingWeightChanged`, `usualMealAdded`, `usualMealRemoved`, `usualMealCaloriesChanged`, and `settingsCommitted`. The handler is an exhaustive `switch`; simple field updates emit inline, list edits delegate to `_on…` methods.

### The models it owns

- `lib/app/model/reminder_style.dart`, `meal_checkin_schedule_mode.dart`, `weight_checkin_frequency.dart`, `weight_time_of_day.dart`, `weight_unit.dart` — enums, each carrying its own display `label` (and `ReminderStyle` a `description`) so the UI never switches over enum values.
- `lib/app/model/meal_reminder.dart` — `MealReminder` (`enabled` + `timeOfDay`), with a `TimeOfDayConverter` since `TimeOfDay` has no built-in JSON.
- `lib/app/model/usual_meal.dart` — `UsualMeal` (`id`, `name`, optional `photoPath`, optional `calories`).

### The view tree

The two views are thin scaffolds; each section is its own widget that reads only the slice of state it needs.

- `view/user_settings_view.dart` — `UserSettingsView` lists `SectionLabel`s and the section widgets.
- `view/usual_meals_view.dart` — `UsualMealsView`, a `DefaultTabController` with one `UsualMealList` per meal.
- `widgets/reminder_style_section.dart` — `BlocSelector` on `reminderStyle`, renders a `RadioOptionCard` per style.
- `widgets/meal_schedule_section.dart` — selects the schedule-related fields as a record; shows the mode selector and reminder rows, or the "reminders off" info box.
- `widgets/weight_section.dart` — stateful (owns the weight text controller); selects frequency/time/unit; shows chips, the weight input, or the "off" info box.
- `widgets/usual_meals_row.dart` — the summary row on the Settings screen.
- `widgets/usual_meal_list.dart` / `usual_meal_row.dart` — one meal's tab and one usual-meal row (inline calorie edit + remove).
- `widgets/info_box.dart` — the dashed-border notice used by the off/empty states.

Every section gets the bloc via `getIt<UserSettingsBloc>()` and adds events directly; none of them hold local copies of settings.

### Shared widgets it reuses (`lib/app/widgets/`)

`MealScheduleModeSelector`, `MealReminderRow`, `EndOfDayReminderRow`, `WeightCheckinFrequencyChips`, `WeightTimeOfDayChips`, `WeightInput`, `RadioOptionCard`, `SectionLabel`, `FoodEntrySheet`, `TheUsualTextField`. These are presentational and callback-driven — onboarding drives the same widgets with `OnboardingBloc` events, which is why they live in the shared folder rather than this feature.

### Routing

`Routes.settings` (`/settings`) builds `UserSettingsView`; `Routes.usualMeals` (`/settings/usuals`, composed from `Routes.usualMealsSegment`) builds `UsualMealsView`. The Settings back button returns to `/today`.

## Relationship to onboarding and today

- **Onboarding → Settings**: onboarding edits a `UserSettingsState` draft and commits it here on completion. The same shared widgets render both flows.
- **Settings → Today**: Today reads `usuals` from this store to build its quick-pick chips, and `weightUnit` when recording a weigh-in.

## Not built yet

- OS notification scheduling/permission when Notifications is the chosen style.
- A daily calorie goal and target weight (deliberately omitted for now).
- Macros (fat/carbs/protein) on `UsualMeal`.
