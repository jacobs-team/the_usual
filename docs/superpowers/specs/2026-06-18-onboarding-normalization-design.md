# Onboarding Normalization — Design

Date: 2026-06-18

## Goal

Bring the onboarding feature in line with the rest of the app: reuse shared
widgets, remove ad-hoc styling, and improve the step flow so the user reaches
the core "log a meal in two taps" payoff before optional configuration. Fix the
persisted-state fragility that makes reordering steps dangerous.

## Background

The onboarding feature already reuses many shared widgets (`UsualMealSection`,
`RadioOptionCard`, the weight/meal selectors, `MacroField`, `WeightInput`,
`FoodEntrySheet`) and mostly styles through `AppDesign` tokens and
`Theme.of(context)`. The divergences are smaller than "neglected" suggests, but
real:

- All config screens (reminders, schedule, weight, goals) come before the user
  ever logs a meal. The welcome screen promises "two taps," then four config
  screens precede the payoff.
- Reminders are split across two screens (`reminderStyle`, `mealSchedule`) that
  are one decision.
- `first_log_view` defines a bespoke `_FoodCard` that hand-rolls a selection
  border with a `Container` instead of the themed `Card` + `InkWell` the rest of
  the app uses, carries a magic `165/134` aspect ratio, and always shows an
  empty grey image placeholder ignoring the meal's `photoPath`.
- `onboarding_actions` hardcodes `48` for reserved button-height slots.
- Persisted state stores `activeStepIndex` as a **positional** index into
  `activeSteps`. Reordering the `OnboardingStep` enum shifts every stored index.
  This already caused a regression once (the v0 → v1 `goals` insertion), handled
  by `_migratedFromV0`.

The onboarding draft (settings + first-log selections) commits to
`UserSettingsBloc` and `DailyLogBloc` via a `BlocListener` in `the_usuals_app`
the moment `step` transitions to `OnboardingStep.complete`. The router redirect
treats `step == complete` as "onboarding done." Nothing commits before then, so
step order does not affect when data is written.

## Flow changes

New step sequence (7 steps, down from 8):

```
welcome → buildUsuals → firstLog → reminders → weightTracking → goals → complete
```

1. **`firstLog` moves up**, directly after `buildUsuals`. The user logs a meal
   before any reminder/weight/goal config. The draft still commits on `complete`,
   so the early log just sits in onboarding state until the flow finishes — the
   same as today.

2. **`reminderStyle` + `mealSchedule` merge** into one `reminders` screen:
   - The style picker (`RadioOptionCard` list: none / on-app-open / notifications)
     stays at the top.
   - The schedule section (`MealScheduleModeSelector` plus the per-meal
     `MealReminderRow`s and `SkipLoggedRemindersTile`, or the `EndOfDayReminderRow`)
     renders inline below the picker.
   - When the style is `ReminderStyle.none`, the schedule section is hidden
     entirely.
   - The OS notification permission request (currently fired on the
     `reminderStyle` Continue button) moves to the merged screen's Continue
     button, with the same fallback to `onAppOpen` if denied.

   Because the schedule is now part of the reminders screen, the `activeSteps`
   conditional that removed `mealSchedule` when reminders were off is deleted.
   The step list becomes fixed.

3. **`weightTracking` and `goals` stay split and stay separate screens**, just
   reordered after `firstLog`. `weightTracking` keeps cadence + time + starting
   weight (the weigh-in habit); `goals` keeps the calorie goal + goal weight (the
   targets). They are not merged.

`welcome` and `complete` remain bookends without the top bar / progress dot.

## Persisted-state migration

Root-cause fix: stop storing position, store identity.

- Replace `activeStepIndex` (an `int` position into `activeSteps`) with the
  current step stored **by enum name**, e.g. a field of type `OnboardingStep`
  serialized via its `name`. Navigation (`BackPressed` / `ContinuePressed`)
  computes the previous/next step within `activeSteps` from the current step
  rather than incrementing an index.
- Bump the persisted `version` to `2`.
- `fromJson` version routing:
  - `case 0`: existing v0 migration, then continue into the v1 → v2 mapping.
  - `case 1`: read the old `activeStepIndex` against the **old** step order
    (`welcome, buildUsuals, reminderStyle, mealSchedule, weightTracking, goals,
    firstLog, complete`, with `mealSchedule` removed when reminders are off),
    resolve the old `OnboardingStep`, then map it to the new step:
    - `reminderStyle` and `mealSchedule` → `reminders`
    - every other step → itself (`welcome`, `buildUsuals`, `firstLog`,
      `weightTracking`, `goals`, `complete`)
  - `case 2` (`_currentVersion`): read with the generated `fromJson`.
  - `default` (newer/unknown, e.g. after a downgrade): resolve to `complete` so
    the user is never sent back through onboarding, which would let a stale draft
    overwrite their saved settings.
- A user who had completed onboarding (old `step == complete`) resolves to the
  new `complete`, so the redirect keeps them in the app and the commit listener
  never re-fires.

After this change, future step reorders only need a new `case` mapping old step
names to new ones, never positional arithmetic.

The migration encodes the historical (old) enum order as a local constant in the
migration code, since the live enum no longer reflects it.

## Styling and reuse cleanup

- **`_FoodCard`** (`first_log_view`): rebuild on the themed `Card` + `InkWell`
  used elsewhere (`cross_meal_picker_sheet`). Drop the hand-rolled border and the
  magic `165/134` aspect ratio. Show the meal's `photoPath` image when present;
  when absent, drop the empty grey placeholder rather than always rendering it.
  Keep the multi-select grid with the inline `QuantityStepper` on selected cards.
  Keep the widget inline in `first_log_view` (single use, per project rules).
- **`onboarding_actions`**: replace the bare `48` heights with a named constant
  that documents intent (reserving button-height so the layout does not jump when
  the secondary slot is empty). Behavior unchanged.
- Audit every onboarding view for any remaining non-token spacing, sizes, or
  colors. Align ad-hoc section headers with the app's `labelMedium`-uppercase
  `onSurfaceVariant` convention (matching `SectionLabel` and the picker headers).

## Out of scope

- Bloc event handlers (other than the navigation index → step change and the
  merged reminders permission flow).
- The `UserSettingsState` draft shape.
- The completion commit in `the_usuals_app`.
- Adding new product features (e.g. capturing meal photos during onboarding).
  Showing an existing `photoPath` is in scope; capturing new photos is not.

## Testing

- Update onboarding view tests for the new step set and the merged `reminders`
  screen. Remove `mealSchedule` view tests in favor of the merged screen's tests.
- Update `onboarding_view_test` routing for the new sequence.
- Update `onboarding_bloc_test` for step-by-name navigation and the v1 → v2
  migration: assert an old completed state resolves to `complete`, and an old
  mid-flow `reminderStyle`/`mealSchedule` index resolves to `reminders`.
- Verify `initHydratedStorage()` setup covers the new persisted shape.
- Keep random seed ordering.
```
