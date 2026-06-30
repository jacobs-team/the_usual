# The Usual — Featureset

What the app can do for the user, end to end. This describes capabilities, not implementation. It reflects the current state of the code as of 2026-06-27. Where the older spec docs still mark a feature "planned," the code shows it shipped, and this document follows the code.

The Usual is a meal, weight, and workout tracker built on one idea: most days you eat and train the same things. Instead of searching a database every time, you build a small library of your "usuals" and log them with a tap. Anything new can be described in text or photographed, and Claude estimates the nutrition for you to confirm. It runs on iOS, Android, Web, and Windows, works fully offline, and syncs across devices when you sign in.

---

## 1. Logging meals

The core loop is logging what you ate in as few taps as possible.

- **Tap a usual.** Each meal slot (Breakfast, Lunch, Dinner, Snacks) shows quick-pick chips for your saved usuals. One tap logs it with its stored nutrition and quantity.
- **Smart quick-pick order.** Chips are ordered by what you logged most recently at that meal time, then by how often you log it there. Anything already logged today for that slot is hidden so the list stays short.
- **Log from another meal.** A "from another meal" picker lets you log a usual that belongs to a different slot, for the day you eat breakfast food at lunch. It logs into the slot you are viewing, not its home slot.
- **Something New.** For anything not in your usuals, open the entry form to type a name and enter nutrition by hand, or let the AI estimate it.
- **Save as usual.** Any one-off entry can be saved into your usuals library from the entry form, so next time it is a single tap.
- **Quantity.** Every entry carries a quantity multiplier. Log 1.5 or 0.5 servings and the calories and macros scale automatically.
- **Itemize or combine.** When entering a multi-food meal you choose "one meal" (a single combined entry) or "itemize" (one row per food). The choice is remembered as your default and switchable per entry.

### AI nutrition

When an Anthropic API key is configured, Claude fills in nutrition so you do not have to look it up.

- **From text.** Describe a meal like "chicken and rice" and Claude returns a name, per-unit calories and macros (protein, carbs, fat), and a suggested quantity. In itemize mode it splits the description into separate foods, each estimated on its own.
- **From a photo.** Snap or attach a photo of the food or its nutrition label and Claude estimates the nutrition. You can add multiple photos and include a text hint to sharpen the result.
- **Always editable.** Every AI value is a starting point. You review and adjust name, quantity, calories, and each macro before confirming.
- **Graceful fallback.** With no API key the app runs normally and the AI features show a setup message instead of calling Claude. Estimation failures fall back to manual entry.
- Powered by Claude (Sonnet) through Genkit with the Anthropic plugin, at temperature 0 for repeatable estimates.

### Share to log

The app registers as a system "Log meal" share target. Share a food photo from Photos or another app and The Usual opens the meal entry sheet pre-populated with that photo, auto-running an AI estimate. This works both when the app is launched fresh by the share and when it is already running.

---

## 2. The Today screen

Today is the home view. It shows the current day by default and answers "how am I doing right now."

- **Calorie and macro bar.** A bar sized to your daily calorie goal fills with colored segments for protein, carbs, and fat by gram count. It reads "X / Y cal" against your goal, or prompts you to set a goal if none exists. A tooltip breaks down all logged macros and calories remaining.
- **Meal sections.** Breakfast, Lunch, Dinner, and Snacks are laid out as separate sections. The slot matching the current time is outlined to focus your attention.
- **Inline weight check-in.** A weight field on the day's card lets you log or update today's weigh-in, pre-filled with today's value or your last weight as a hint. A "use last" shortcut fills the most recent weight in one tap. Clearing the field removes the weigh-in.
- **Edit anything inline.** Tap a logged entry to expand it and edit calories and each macro, adjust the quantity with a stepper, or remove it.
- **Stay in sync with your usuals.** A logged entry tracks the usual it came from. If you rename the usual the entry reflects it. If the entry's nutrition drifts from the usual, an "update usual to match" action appears. If it was never saved, "save as usual" appears.

### Date navigation

The "Today" title is a tappable date pill.

- **Pick any day.** Open the date picker and jump to any past or future day. The pill shows "Today" in live view or the formatted date otherwise.
- **Swipe between days.** Swipe left or right to move one day at a time.
- **Past days.** Viewing a past day shows that day's breakdown, quick picks, and weight. Logging stamps onto that day rather than now.
- **Multi-day logging.** Select a date range and a logged entry fans out across every day in the range. Editing an existing entry only touches that one entry.

---

## 3. History

History is the month-by-month journal of everything you have logged.

- **Browse by month.** A strip of month chips (each showing that month's latest weight) plus swipe paging moves between months, newest first. If a month empties out after deletions, it falls back to the nearest one.
- **Month trends chart.** A dark summary card plots two things: a weight line across the month with the net change and your goal weight marked, and a per-day calorie bar chart with an average line and your calorie goal line. The weight line needs at least two weigh-ins and the calorie bars at least two logged days to render. Tapping a calorie bar jumps to that day.
- **Day cards.** Each day collapses to a summary (date, calories, key macro, weight) and expands to show the weight field and all meal sections with their entries.
- **Edit the past.** Every past day is fully editable. Add a forgotten meal with the "+" on any meal section using the same entry form as Today, edit any entry's nutrition and quantity, fix or delete a weigh-in, and remove entries outright.

---

## 4. Weight tracking

Weight is tracked as a series of weigh-ins over time, optional and on your schedule.

- **Log weigh-ins** inline from Today or any history day, in pounds or kilograms per your setting.
- **Set a goal weight** that shows as a reference line on the history weight chart.
- **Net change** is surfaced over selectable windows on the Today weight card and across each month in history.
- **Reminders** prompt you to weigh in. Choose a frequency of daily, every two days, weekly, or off, and a time of day of morning, evening, or night. Non-daily schedules run on a rolling two-week cycle since the OS does not support arbitrary intervals.

---

## 5. Workouts

A full workout tracker sits alongside meals as its own bottom-nav tab.

### Structure

- **Groups.** Organize training into groups like Push, Pull, Legs, or Cardio. Create, rename inline, and delete empty groups. The app ships seeded Push/Pull/Legs defaults.
- **Exercise types.** An exercise is either strength (tracked by sets of weight and reps) or cardio (tracked by duration). The type is auto-detected from the group name across roughly seventy cardio activity names and is toggleable.
- **Sets.** Strength exercises hold a list of sets, each with a weight and reps, supporting fractional plate weights.

### Logging

- **Quick-pick usuals.** Each group shows chips for your saved workout usuals, ordered by recent and frequent use, hiding anything already logged that day. One tap logs it with its default sets or duration. Swipe a chip to remove that usual.
- **New workout.** Open the entry sheet to log an exercise by name, set its type, and enter sets (weight and reps) or a duration. Add and remove sets freely. Optionally save it as a usual.
- **Date navigation.** A date pill and left/right swipe move between days, and a date range logs an exercise across multiple days, mirroring the meal experience.
- **Edit inline.** Tap a logged exercise to expand and edit its sets or duration, push changed values back to its usual with "update usual to match," save an unsaved one, or delete it.
- **Weight unit** for workouts is set independently of body weight, in pounds or kilograms.

### AI workout helpers

- **Bodyweight load estimation.** For a bodyweight exercise, check the estimate option and Claude estimates the effective load as a percentage of your body weight (for example a push-up at about 65 percent), filling any set where you left the weight blank. It uses your latest logged weight or your starting weight.
- **Photo-to-exercise suggestions.** Repository support exists to identify exercises from a gym-equipment photo, though that entry flow is currently disabled in the UI.

### Progress and history

- **Days lens.** A month-by-month history of training days, newest first, each showing total volume and expanding to all exercises grouped by their training group.
- **Exercises lens.** Every strength exercise with at least two sessions, each with a sparkline of estimated one-rep-max over time and its latest value, sorted by most recently trained.
- **Exercise detail.** Tap an exercise for a full estimated 1RM line chart with net change, tappable session points, top-set labels, and a reverse-chronological session list.
- **Strength math.** Estimated 1RM uses the Epley formula (weight times 1 plus reps over 30), treating single reps as raw weight and capping above twelve reps where the formula is unreliable. Volume is weight times reps, summed per day.
- **Reminders.** Toggle workout reminders on with a time and specific days of the week.

---

## 6. Onboarding

A short guided setup runs on first launch and is fully replayable from Settings.

1. **Welcome.** Sign in with Google to back up and sync, or continue offline as a guest.
2. **Build your usuals.** Add meals per slot with nutrition, using per-meal suggestion chips to cut typing. Skippable, leaving an empty library you backfill as you log.
3. **First log.** Log what you ate today from the usuals you just built, with a quantity stepper, or add Something New. Skippable.
4. **Reminders.** Choose a reminder style (notifications or none), then a meal schedule of per-meal times (with each meal toggleable, defaults of Breakfast 9:00am, Lunch 2:00pm, Dinner 7:30pm, Snacks off) or a single end-of-day prompt (default 8:00pm). Optionally skip reminders once a meal is logged.
5. **Weight check-ins.** Pick a frequency, a time of day, your starting weight, and unit. Skippable to off.
6. **Goals.** Set an optional daily calorie goal and goal weight, each with a unit toggle.
7. **Complete.** The app opens to Today.

Progress survives an app kill, the step is stored by name so reordering the flow never strands a returning user, and back navigation works at every step except Welcome.

---

## 7. Accounts and sync

- **Google sign-in** is optional. Guests get the full app locally with no account.
- **What syncs.** When signed in, meals, weigh-ins, workouts, and all settings (usuals library, goals, units, reminders, workout groups) sync across devices through Firebase.
- **Offline-first.** Everything is persisted locally so the app works with no connection. Local edits write through to the cloud on a short debounce, and remote changes pull down live, with a guard against echoing the app's own writes.
- **Account transitions are handled.** Signing in with guest data already present lets you keep it or start fresh. An existing cloud account applies its data on a new device automatically. Sign-out confirms the cloud is current before clearing local state and returns you to guest.

---

## 8. Settings

Everything chosen during onboarding is editable later, plus more.

- **Reminder style and schedule** for meals, identical options to onboarding.
- **Weight check-ins** frequency, time, current weight, and unit.
- **Workouts** weight unit, reminder on/off, reminder days, and reminder time.
- **Goals** daily calorie goal and goal weight, each clearable.
- **Your food** manages the usuals library in a tab per meal: add, edit name and nutrition, and remove, with AI or manual nutrition entry.
- **Your day** sets when a new day begins (default midnight) so meals and weigh-ins logged late at night count toward the right day and Today does not roll over on you.
- **Appearance** picks System, Light, or Dark theme.
- **Account** shows the signed-in Google account with sign-out, or a sign-in button for guests.
- **Replay onboarding** restarts the setup flow.

Edits save immediately with no save button.

---

## 9. Platforms and design

- **Platforms.** iOS, Android, Web, and Windows from one codebase.
- **Design language.** A warm, editorial "espresso bar" aesthetic. Boundaries come from tonal layering and soft background shifts rather than hard borders, floating elements use glassmorphism, type is set in Manrope, and depth comes from diffuse ambient shadows rather than hard lines.

---

## Capability status at a glance

| Area      | Capability                                                         | Status             |
| --------- | ------------------------------------------------------------------ | ------------------ |
| Meals     | Tap-to-log usuals, smart quick-picks, cross-meal logging           | Shipped            |
| Meals     | AI nutrition from text and photo, itemize/combine                  | Shipped            |
| Meals     | Share-to-log from other apps                                       | Shipped            |
| Today     | Calorie/macro bar, inline edit, date navigation, multi-day logging | Shipped            |
| History   | Month browsing, trends chart, full retroactive editing             | Shipped            |
| Weight    | Inline weigh-ins, goal, net change, scheduled reminders            | Shipped            |
| Workouts  | Groups, strength/cardio logging, usuals, progress charts           | Shipped            |
| Workouts  | AI bodyweight load estimation                                      | Shipped            |
| Workouts  | Photo-to-exercise suggestions                                      | Built, UI disabled |
| Accounts  | Google sign-in, cross-device cloud sync, offline-first             | Shipped            |
| Settings  | Full editing of all preferences, theme, day start, usuals          | Shipped            |
| Reminders | Calorie-threshold notification suppression                         | Designed, on hold  |

---

_Sources: code under `lib/app/feature/{today,meal_entry,history,workout,user_settings,onboarding,auth}`, `lib/app/core/{service,networking}`, and `lib/app/model`; specs and plans under `docs/superpowers/` and `.superpowers/`; `design/DESIGN.md`._
