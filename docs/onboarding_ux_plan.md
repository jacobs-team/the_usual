# Onboarding UX Plan

Status: implemented in `lib/app/feature/onboarding/` (WIP, tests pending update). Figma iteration ongoing.
Last updated: 2026-06-12

## Decisions

| Decision               | Choice                                                                                               |
| ---------------------- | ---------------------------------------------------------------------------------------------------- |
| Food library structure | Grouped by meal: breakfast, lunch, dinner, snacks                                                    |
| Profile data collected | Starting weight only, with lbs/kg toggle                                                             |
| Meal reminder times    | Prefilled defaults (9:00am, 2:00pm, 7:30pm), editable, per-meal toggles, alternative end-of-day mode |
| Accounts               | Local-first, no auth                                                                                 |
| State persistence      | HydratedBloc, partial onboarding resumes after app kill                                              |
| Weight check-ins       | Optional. Frequency has an Off choice, and skipping the weight screen turns check-ins off            |
| Reminder style default | Notifications pre-selected on the screen. Skipping falls back to "when I open the app"               |

## Flow

```
Welcome → Build your usuals → Reminder style → Meal schedule → Weight tracking → First log
```

The flow is a list of active steps derived from state (`OnboardingState.activeSteps`). Picking "don't remind me" on screen 3 removes Meal schedule from the list, and going back to change the answer restores it. Navigation is an index into that list: back moves -1, skip and continue move +1. Progress dots across the top render from the same list, so the dot count matches the steps the user will actually see. Back navigation everywhere past Welcome.

## Skip semantics

Skip means "get me past this screen," but the implied intent differs per screen. Skipping never dead-ends a feature silently: it either keeps editable defaults or turns the feature off in a way Settings can undo.

| Screen          | Intent when skipping                       | What happens                                                                  |
| --------------- | ------------------------------------------ | ----------------------------------------------------------------------------- |
| Welcome         | n/a                                        | No skip, single Get started CTA                                               |
| Build usuals    | "I'll add foods later"                     | Empty library. Backfills at log time via "I ate something else" + save        |
| Reminder style  | "Don't make me decide how to be nagged"    | Falls back to "when I open the app": least intrusive, no OS permission prompt, core loop stays alive |
| Meal schedule   | "Defaults are fine"                        | Keeps prefilled times and toggles                                             |
| Weight tracking | "I don't want to weigh in"                 | Weight check-ins set to off, starting weight cleared                          |
| First log       | n/a                                        | No skip. Exits via "Log it" or "I didn't eat [meal]"                          |

Skipping reminder style intentionally does not mean "no reminders." The user declined a decision, not the feature. Opting out of reminders is an explicit choice ("Don't remind me") on the same screen.

## Screens

### 1. Welcome

- Single screen, no carousel, no sign-in.
- Copy: "Track what you eat in two taps. Set up your usual meals once and logging takes seconds."
- One CTA: Get started.

### 2. Build your usuals

- Highest-risk screen for drop-off. Optimize for speed and skippability.
- Four meal sections as tabs or a stepper: Breakfast, Lunch, Dinner, Snacks.
- Per item: text name, optional photo from camera or library.
- Suggestion chips per meal to reduce typing (e.g. "eggs", "cereal", "leftovers" under breakfast).
- Each section skippable, no minimum item count.
- Target outcome: 3 to 5 items in at least one meal.
- Post-onboarding: items entered via "I ate something else" at log time offer "add to my usuals" so the library backfills itself.

### 3. Reminder style

- Three options: push notifications, when I open the app, don't remind me.
- Notifications is pre-selected, so Continue is always available.
- OS notification permission prompt fires only after the user confirms notifications, so the system dialog has context. (Not yet implemented, open TODO in the bloc.)
- Permission denied: fall back to "when I open the app" and tell the user, never fail silently.
- "Don't remind me" removes screen 4 from the flow.

### 4. Meal schedule

- Segmented control with two modes.
- Per-meal mode (default): each meal with items is toggled on with a prefilled time. Breakfast 9:00am, lunch 2:00pm, dinner 7:30pm. Times editable, meals toggleable off.
- End-of-day mode: one daily check-in at a single editable time covering the whole day.
- Copy nudges toward per-meal: "Logging near when you ate is more accurate, and you can snap a photo while the food is in front of you."

### 5. Weight tracking

- Frequency: daily, every 2 days, weekly, off.
- Off hides the time-of-day and starting weight sections and shows "You can turn them on any time in Settings."
- Time of day: morning, evening, night. Morning recommended, weight is most consistent then.
- Starting weight input with lbs/kg toggle. Doubles as the baseline, no separate profile screen.

### 6. First log

- No "you're all set" dead end. Use the current time to ask the first real question, e.g. "Did you eat lunch today?"
- Tappable options from the user's usuals for that meal, plus "I ate something else" leading to text or photo entry.
- If it's before any meal time: lightweight confirmation, "You're set, we'll check in at 2:00pm."

## Core loop (for context, post-onboarding)

1. Reminder fires at a meal time (notification or on app open).
2. "Did you eat lunch today?" with that meal's usuals as quick picks.
3. "I ate something else" opens text or photo entry, with an option to save it to usuals.
4. Weight check-in prompts on the configured cadence and time of day.

## Design artifacts

- Figma: https://www.figma.com/design/gLktQT6yLJ41g6UezllCAX (page "Onboarding v1")
- Claude Design project: "The Usual" on claude.ai/design (project id 20e323be-7d5d-4227-9dce-6fc7049e11d6)
- HTML preview sources: `design/ds/` in this repo. Edit these and re-sync with DesignSync to update Claude Design.

## Implementation notes

- `OnboardingBloc` is a `HydratedBloc`. State persists `activeStepIndex`, a position in the derived `activeSteps` list, not a raw step enum value.
- Events are intent-level and minimal: `backPressed`, `skipPressed`, `continuePressed` plus per-field selection events. There are no dedicated `getStartedPressed` or `firstLogCompleted` events. Get started and finishing the first log are just `continuePressed`. Skip is its own event because it carries per-step fallbacks (see Skip semantics).
- First log pre-selects the meal nearest the current time via `Meal.fromTime`.

## Open items

- Figma wireframes need updating to match the implemented flow.
- Settings screen must expose everything set in onboarding (reminder style, meal times, weight cadence including off).
- Notification scheduling approach on iOS/Android still undecided. Permission request on picking notifications is not yet implemented.
- "Before any meal time" confirmation state on first log is not yet implemented.
- Bloc tests still target the old event and state shape and need a rewrite.
