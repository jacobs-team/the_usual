# Onboarding UX Plan

Status: agreed, pre-design. Figma iteration next, implementation after.
Last updated: 2026-06-11

## Decisions

| Decision | Choice |
| --- | --- |
| Food library structure | Grouped by meal: breakfast, lunch, dinner, snacks |
| Profile data collected | Starting weight only, with lbs/kg toggle |
| Meal reminder times | Prefilled defaults (9:00am, 2:00pm, 7:30pm), editable, per-meal toggles, alternative end-of-day mode |
| Accounts | Local-first, no auth |
| State persistence | HydratedBloc, partial onboarding resumes after app kill |

## Flow

```
Welcome → Build your usuals → Reminder style → Meal schedule → Weight tracking → First log
```

Progress dots across the top. Back navigation everywhere. Every screen past Welcome is skippable. Screen 4 is skipped entirely if the user picks "don't remind me" on screen 3.

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
- OS notification permission prompt fires only after the user picks notifications, so the system dialog has context.
- Permission denied: fall back to "when I open the app" and tell the user, never fail silently.
- "Don't remind me" skips screen 4.

### 4. Meal schedule

- Segmented control with two modes.
- Per-meal mode (default): each meal with items is toggled on with a prefilled time. Breakfast 9:00am, lunch 2:00pm, dinner 7:30pm. Times editable, meals toggleable off.
- End-of-day mode: one daily check-in at a single editable time covering the whole day.
- Copy nudges toward per-meal: "Logging near when you ate is more accurate, and you can snap a photo while the food is in front of you."

### 5. Weight tracking

- Frequency: daily, every 2 days, weekly.
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

## Open items

- Figma wireframes for all six screens, iterate before implementation.
- Settings screen must expose everything set in onboarding (reminder style, meal times, weight cadence).
- Notification scheduling approach on iOS/Android to be decided at implementation time.
