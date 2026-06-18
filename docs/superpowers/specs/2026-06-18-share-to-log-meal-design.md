# Share-to-Log a Meal — Design

**Date:** 2026-06-18
**Status:** Approved design, ready for implementation plan

## Problem

Logging a meal from a photo today is a chore: the user takes the photo in the
camera app, switches to The Usual, opens the log-meal sheet, picks the photo,
and taps Estimate. Five steps across two apps.

We want the OS share sheet to be a first-class entry point. From any app that
can share an image (Camera, Photos, a messaging thread), the user picks a
**Log meal** share target. The app opens, estimates the nutrition from the
shared photo(s), and pre-fills the log-meal sheet targeted at the current meal
slot. The user taps **Confirm** to log.

## Goals

- A **Log meal** target in the iOS and Android share sheets that accepts one or
  more images.
- Sharing opens the app, runs the existing AI estimate, and pre-fills the
  existing entry sheet targeted at the current meal slot
  (`MealOfTheDay.fromTime(now)`), editable before confirming.
- **Estimate, then confirm** — nothing is logged without the user tapping
  Confirm.
- Multiple shared photos are sent together in **one** estimate pass; the
  persisted `MealEntryMode` (the Itemize toggle) decides one combined row vs
  per-food rows, exactly as it does today.
- Lift the current **one-photo-at-a-time** limit on the normal add-meal sheet so
  the user can attach several photos there too.
- Move the bloated add-meal form/sheet logic into a **bloc**, following the
  app's existing bloc patterns.

## Non-goals

- Web. Only iOS and Android can register share targets; web keeps the existing
  in-app flow.
- Sharing text (recipes/descriptions) into the target. Images only for now.
- Fully automatic "log without review" — explicitly rejected in favor of
  estimate-then-confirm.
- Background/headless logging. The app comes to the foreground to let the user
  confirm.

## Decisions

- **Plumbing:** `receive_sharing_intent`. Standard Flutter package for OS share
  targets, dual-platform, multi-image first-class, least native code for the
  coverage. Alternatives considered: `share_handler` (no advantage here, its
  extras target messaging apps) and hand-rolled platform channels (most native
  code to own).
- **Review surface:** reuse the existing `FoodEntrySheet`, seeded with the
  shared photos and an auto-run estimate, rather than a bespoke share screen.
- **Multi-photo semantics:** all photos in one multimodal request; grouping is
  decided by the persisted `MealEntryMode`, not by photo count.
- **Logging ownership:** stays with the caller (the `MealLogSection` or the
  share handler), which dispatches `MealLogged`/`usualMealAdded`. The new bloc
  owns drafting and estimation only.

---

## Architecture

Four units, each independently understandable and testable.

### 1. `FoodEntryBloc` — drafting and estimation (refactor)

New feature folder `lib/app/feature/meal_entry/` with the standard layout
(`bloc/bloc.dart` barrel, `meal_entry_bloc.dart` with `part` files
`meal_entry_event.dart` and `meal_entry_state.dart`).

**Registration — per-surface, widget-owned.** Onboarding renders `FoodEntryForm`
inline in more than one place at once (build-usuals, first-log), so a
`@singleton` would cross their state. The bloc is therefore `@injectable` (a
factory, fresh instance per call). The owning widget creates it and owns its
lifecycle: `FoodEntryForm`'s `State` creates `_bloc = getIt<FoodEntryBloc>()` in
`initState` (dispatching `started` with that surface's seed) and `close()`s it
in `dispose`, so the bloc dies with the sheet or page and multiple forms coexist.
It is provided down via `BlocProvider.value` for `BlocBuilder`/`BlocSelector`
descendants to read. Per the "no `context.read`" rule, event dispatch goes
through the held `_bloc` field within the owning `State`; child rows stay dumb
and report up through `onChanged`-style callbacks as they do today.

All logic now in `FoodEntryForm`'s `State` (drafts, AI orchestration, mode,
generating flag) moves here.

**New model — `FoodDraft`** (`@freezed`, in `lib/app/model/`): one editable food
row as data.

```dart
@freezed
abstract class FoodDraft with _$FoodDraft {
  const factory FoodDraft({
    required String id,
    @Default('') String name,
    @Default(1) double quantity,
    @Default(Nutrition()) Nutrition nutrition,
    @Default(false) bool addToUsualMeals,
  }) = _FoodDraft;
}
```

`id` is a uuid generated when the draft is created, used as the row widget key
so text controllers rebuild correctly when an estimate replaces the list. The
draft is in-memory only (not persisted), so no migration concern.

**State** (`@freezed`, `MealEntryState`):

| Field | Type | Purpose |
|---|---|---|
| `foods` | `List<FoodDraft>` | The editable rows; always at least one. |
| `mealEntryMode` | `MealEntryMode` | Seeded from `UserSettingsBloc`; drives the Itemize toggle. |
| `mealOfTheDay` | `MealOfTheDay` | Target slot. Defaulted by the caller; surfaced by the share sheet's slot selector. |
| `photos` | `List<MealPhoto>` | Photos retained for the estimate (new — the form discards them today). |
| `status` | `MealEntryStatus` | `idle` / `generating` / `failure`. |
| `errorMessage` | `String?` | Set on `failure`, shown in the sheet. |

`MealEntryStatus` is a small enum following the loading/success/failure
convention in the BLoC rules. `success` is represented by `idle` with populated
`foods` (the estimate result lands in `foods`); a distinct success state isn't
needed because the UI reacts to `foods` + `status`.

**Events** (`@freezed` sealed, named factories like the other blocs):

- `started({List<FoodDraft>? initialFoods, List<MealPhoto> photos, MealOfTheDay? mealOfTheDay, bool autoEstimate})`
  — seeds the bloc; when `autoEstimate` is true and photos are present, kicks a
  photo estimate immediately (the share path).
- `foodAdded()`
- `foodRemoved(String id)`
- `foodNameChanged(String id, String name)`
- `foodNutritionChanged(String id, Nutrition nutrition)`
- `foodQuantityChanged(String id, double quantity)`
- `foodAddToUsualMealsToggled(String id, {required bool addToUsualMeals})`
- `entryModeToggled(MealEntryMode mealEntryMode)`
- `mealOfTheDayChanged(MealOfTheDay mealOfTheDay)`
- `photosAdded(List<MealPhoto> photos)`
- `photosCleared()`
- `estimateRequested()` — description path: estimates from the current rows'
  names (mirrors the form's single-row vs multi-row logic today).
- `photoEstimateRequested()` — estimates from the held `photos` (plus the first
  row's typed name as a hint, as today).

**Handler rules:** exhaustive `switch` in `on<MealEntryEvent>`. Async handlers
(`estimateRequested`, `photoEstimateRequested`, and `started` when
auto-estimating) emit `generating`, call `MealAiRepository`, then emit `idle`
with rebuilt `foods` or `failure` with a message. Wrapped in try/catch per the
rules.

**Estimation logic preserved from the form:**

- One named row → `suggestFromDescription`; the mode may split it.
- Several named rows → estimate each on its own (`Future.wait`), keep names,
  fill nutrition/quantity in place.
- Photo path → `suggestFromPhoto` with all held photos; in whole-meal mode keep
  a typed first-row name over the model's.

**Mode persistence:** `FoodEntryBloc` is constructor-injected with
`UserSettingsBloc`. On `started` it seeds `mealEntryMode` from
`UserSettingsBloc.state.mealEntryMode`; on `entryModeToggled` it updates its own
state **and** dispatches `UserSettingsEvent.mealEntryModeChanged` so the default
still persists app-wide.

**The text-field tension (why bloc, not cubit, still works):** a bloc can't own
`TextEditingController`s. Resolution: the bloc owns names as `String`s. Each row
widget owns its controller, keyed by `FoodDraft.id`, seeds it from state, and
dispatches `foodNameChanged` on edit. When an estimate replaces `foods`, rows
get new ids → controllers rebuild from the new names. No part of this requires
cubit; bloc is used throughout.

### 2. View layer — thin

- `FoodEntryForm` becomes a `BlocBuilder`/`BlocSelector` over `FoodEntryBloc`,
  dispatching events instead of mutating `setState`. Per the rules, prefer
  `BlocSelector` with a record when several pieces of state are read together.
- `FoodEntrySheet` reads `foods`/`status` from the bloc instead of a
  `GlobalKey`; its confirm button enables on `hasContent && status != generating`.
- **Slot selector:** `FoodEntrySheet` gains an optional meal-slot selector,
  shown only when launched from share (`showMealSelector: true`). When opened
  from a `MealLogSection` the slot is fixed by the section and the selector is
  hidden, so existing behavior is unchanged.
- `MealLogSection` keeps owning the post-confirm logging fan-out
  (`MealLogged` + `usualMealAdded`), reading the final `foods` and fixed
  `mealOfTheDay` from the bloc.

### 3. Multi-photo estimation

- `pickMealPhoto` → returns `List<MealPhoto>`. The camera/library source dialog
  stays; camera yields one photo, library uses `ImagePicker().pickMultiImage`
  (downscaled as today). Renamed to reflect the list return (e.g.
  `pickMealPhotos`).
- `MealAiClient.generateStructured` and `MealAiRepository.suggestFromPhoto`
  accept a `List<Uint8List>` (with per-image media types) and emit multiple
  image blocks in a single multimodal request. Single-photo callers pass a
  one-element list.
- The persisted `MealEntryMode` still decides combined vs itemized — unchanged.
- This lifts the one-photo limit on the normal add-meal sheet at the same time.

### 4. `ShareIngestService` and routing

- `ShareIngestService` (`@singleton`, `lib/app/core/service/`) wraps
  `receive_sharing_intent`: exposes the cold-start initial media
  (`getInitialMedia`) and the warm-start `getMediaStream`, normalizing both into
  `List<MealPhoto>` (reading the shared files' bytes and media types). Platform
  glue, so `coverage:ignore-file` like `meal_photo_picker`.
- Listened to once at the app root (the `MaterialApp.router` host). On images
  arriving **and** onboarding complete, open `FoodEntrySheet` seeded via
  `FoodEntryBloc.started(photos: ..., mealOfTheDay: MealOfTheDay.fromTime(now),
  autoEstimate: true, ...)` with `showMealSelector: true`. The user reviews the
  prefilled rows, can change the slot, taps Confirm to log into the chosen slot.
- **Onboarding guard:** if onboarding is incomplete when a share arrives, the
  photos are held in the service and the share is ignored until the app reaches
  Today, then surfaced — never log into a half-configured app. (The router
  already redirects to onboarding when incomplete.)
- **Cold vs warm start:** `receive_sharing_intent` covers both; the service
  drains the initial media once after the app is ready and listens to the stream
  thereafter.
- `receive_sharing_intent` must be told the media has been consumed
  (`reset()`), so a relaunch doesn't re-open the sheet for an old share.

### Native configuration (in the plan, flagged for the developer)

- **iOS:** a new Share Extension target, a shared **App Group** entitlement on
  both the app and the extension, and an Info.plist activation rule accepting
  images (single and multiple). Signing/capabilities must be confirmed by the
  developer in Xcode — the agent will write what it can but cannot fully
  configure code signing.
- **Android:** `SEND` and `SEND_MULTIPLE` intent-filters for `image/*` on the
  main activity in the manifest.

---

## Error handling

- Estimation failure (any path) emits `failure` with a message. In the share
  flow the sheet stays open with the photos attached and rows editable, with a
  retry, rather than dead-ending. Mirrors the form's current snackbar-on-error
  behavior, surfaced through bloc state.
- A share with no readable image is ignored (no sheet), logged in debug.
- An empty estimate result leaves the rows as-is (matches current behavior).

## Testing

- `blocTest` for `FoodEntryBloc`: `started` seeding (with and without
  auto-estimate), add/remove/edit rows, mode toggle (asserts it persists to
  `UserSettingsBloc`), `mealOfTheDayChanged`, description estimate
  success/failure, photo estimate success/failure — all with a mocked
  `MealAiRepository` (mocktail). Use `isA<MealEntryState>().having(...)`.
- `MealAiRepository`/`MealAiClient` multi-image: assert multiple images are
  passed through (mock the client).
- Widget tests for `FoodEntrySheet`: confirm gating, slot selector visibility,
  finding widgets by type/key/icon — not by text.
- `ShareIngestService` is platform glue: `coverage:ignore`.
- Random seed ordering; `initHydratedStorage()` where a `HydratedBloc` is in
  play.

## Implementation phases

The plan is staged; each phase lands and is verified before the next.

1. **`FoodEntryBloc` refactor.** Introduce `FoodDraft`, the bloc, and rewire
   `FoodEntryForm`/`FoodEntrySheet` to it. No behavior change for the user.
   Single-photo estimation still. Full bloc tests.
2. **Multi-photo.** `pickMealPhotos`, multi-image repository/client, and the
   bloc holding/estimating multiple photos. The normal sheet now accepts several
   photos.
3. **Share ingestion.** `receive_sharing_intent`, `ShareIngestService`, native
   config, app-root listener, share-launched `FoodEntrySheet` with slot
   selector and the onboarding guard.

## Open risks

- iOS Share Extension signing is developer-confirmed in Xcode; the agent can't
  fully automate it.
- Large/many images through the iOS extension memory budget — mitigated by the
  existing on-capture downscale; shared originals may be larger, so the service
  should downscale on ingest too.
