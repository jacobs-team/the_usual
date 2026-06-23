# Cloud Sync & Account Migration — Spec

Status: draft for review. Nothing here is built yet.

Provider is Firebase (decided; free tier validated below). The Google sign-in + `isNewUser` path and the Firestore real-time listener API (`snapshots()`, `metadata.hasPendingWrites`) are checked against the current FlutterFire docs (June 2026). The remaining Firestore read/write calls and all config steps are illustrative and must be confirmed against the docs at build time, per the project rule.

## Goal

Today the app is local-only. A guest accumulates meal logs, weigh-ins, settings, and usuals in `HydratedBloc` storage on the device. We want a signed-in account to own that data in the cloud, with two behaviors that differ from a stock "your data lives in the cloud" app:

1. **Sign up (new account):** the guest's current local data becomes the new account's cloud data. Nothing is lost. The user is warned with a confirmation dialog before this happens, if they choose so, they can throw away the local data and start a fresh cloud account.
2. **Sign in (existing account that already has cloud data):** the account's cloud data wins. The guest's local data is replaced by the download and is gone forever. The user is warned with a confirmation dialog before this happens.
3. **Sign out:** the data is safely on the server, so local data is cleared and the device returns to a fresh guest state.

## What syncs

The synced payload is the union of two blocs:

- `DailyLogBloc` → `DailyLogState` (`mealEntries`, `weightEntries`).
- `UserSettingsBloc` → `UserSettingsState` (reminders, goals, units, theme, usuals, etc.).

Not synced: `OnboardingBloc` (local progress; see "Empty data routes to onboarding" for how sync operations reset or complete it), `DevToolsCubit` (diagnostics), `AuthCubit` (identity, not user content).

The cloud document is a single JSON blob keyed by bloc:

```json
{
  "schemaVersion": 1,
  "dailyLog": { ...DailyLogState.toJson() },
  "userSettings": { ...UserSettingsState.toJson() }
}
```

Reusing each bloc's existing `toJson`/`fromJson` keeps one serialization path. The per-bloc `version` fields ride along inside their sub-objects, so the existing migration logic keeps working on downloaded data exactly as it does on local data.

## Data model: guest is local, cloud is per-user

The guest stays purely local. We do not create a cloud identity or cloud document until the user signs in. Pure guests cost nothing on the cloud and work fully offline, which matches the current architecture.

On sign-in we resolve one of two cases and act:

| Case                                       | Detection                                    | Action                                                                                                                                                                                                                |
| ------------------------------------------ | -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| New account                                | provider says "first sign-in"                | Upload local data as the account's first cloud document if they choose to, if they choose not to they can delete their local data and start with a fresh cloud account. dialog must be very clear about data deletion |
| Existing account, has cloud data           | provider says "returning" / cloud doc exists | If local has established data, show the replace-warning dialog. On confirm, download and overwrite local. On cancel, sign back out and stay guest.                                                                 |
| Existing account, no established data      | as above, but local has no established data  | Download silently. No dialog (nothing to lose).                                                                                                                                                                       |

**Established data** = at least one logged meal (`DailyLogBloc.mealEntries`), more than one weigh-in day (`weightEntries` on distinct logical days), or more than one usual meal (`UserSettingsBloc.usuals`). A single logged meal counts; a lone weigh-in or a lone usual does not, and no setting other than the usuals list counts. One getter, `hasEstablishedData`, drives both the sign-in dialogs (is there anything worth keeping?) and the onboarding routing below (is this an established user?).

## Sign-in flow (the important one)

```
User taps "Sign in with Google"
        │
        ▼
Authenticate with Google ──cancelled──▶ stay guest, no change
        │
        ▼
Resolve account: isNewUser AND confirm cloud-doc existence
        │
        ├──────────────── NEW account ────────────────┐
        │                                              │
        │   established data?                          │
        │     ├─ no  ─▶ create empty cloud doc ─▶ signedIn ─▶ onboarding
        │     └─ yes ─▶ dialog: "Keep your data, or start fresh?"
        │                 ├─ keep        ─▶ upload local ─▶ signedIn (in app)
        │                 └─ start fresh ─▶ clear local + empty cloud doc ─▶ signedIn ─▶ onboarding
        │
        └────────────── EXISTING account ──────────────┐
                                                        │
            established data?
              ├─ no  ─▶ download ─▶ overwrite local ─▶ signedIn*
              └─ yes ─▶ dialog: "Replace local with cloud?" (local lost forever)
                          ├─ confirm ─▶ download ─▶ overwrite local ─▶ signedIn*
                          └─ cancel  ─▶ sign back out ─▶ stay guest

* lands in app when the downloaded account has established data; routes to
  onboarding if it does not (see "Empty data routes to onboarding").
```

Two distinct dialogs:

- **New account, has guest data** — offers a choice, not a warning: keep the guest data (upload it as the account's first cloud document) or start fresh (discard local and create an empty cloud document). The "start fresh" option must be unmistakable that guest data is deleted permanently.
- **Existing account, has guest data** — a destructive warning: the account's cloud data replaces local guest data, which is lost forever. Confirm to download, cancel to back out and stay guest. Names the account being signed into.

When there is no established data, neither dialog appears: a new account starts empty, an existing account downloads silently. Wording finalized during build and localized.

## Sign-out flow

Hard-clear local on sign-out, but only after the cloud is confirmed current. Local data is destroyed here, so we must never clear until the latest local state is safely on the server.

1. **Flush and confirm sync, while still authenticated.** Push the latest local state and await the server confirming the write (a server-acked snapshot, not just the local Firestore cache). Firestore rules require `auth.uid`, so this happens before provider sign-out.
2. If the sync cannot be confirmed (offline, or the write fails), **abort sign-out** and surface an error. Do not clear local. We use `ConnectivityCubit` to block sign-out offline rather than risk losing unsynced edits.
3. Sign out of the provider.
4. Clear the synced blocs' local `HydratedStorage` entries, emit their initial states, and reset `OnboardingBloc` to its initial step.
5. `AuthStatus` → `guest`.

The device is now a clean guest. We clear before the next guest starts logging, otherwise the previous account's data would leak into and then upload under a new sign-in. A cleared device has no established data, so the onboarding rule below routes it through onboarding.

## Empty data routes to onboarding

Whenever a sync operation leaves the device without established data, the user is sent through onboarding again. Onboarding builds the usuals library and does a first log, so a user with nothing established is effectively fresh.

The invariant: onboarding is complete if and only if the device `hasEstablishedData` (at least one logged meal, more than one weigh-in day, or more than one usual). This is the same getter the sign-in dialogs use. After any operation that replaces local data, evaluate it and set `OnboardingBloc` accordingly:

- **Sign-out** and **new-account "start fresh"** clear local, so both leave the device empty and reset `OnboardingBloc` to its initial step. The router (which already gates on `OnboardingStep.complete`) sends the user to onboarding.
- **Existing-account download** with established data marks onboarding complete, so the returning user lands in the app. If a downloaded account has none, it routes to onboarding too.
- **New-account "keep my data"** only happens when established data exists (that is what raised the dialog), so onboarding is already complete and stays so.

A device whose only data is a lone weigh-in or a lone usual is therefore treated as fresh and re-onboarded, by design. A single logged meal, by contrast, is enough to count as established.

## Ongoing sync (after sign-in)

MVP scope:

- **Real-time subscription (cloud → device).** While signed in, `SyncRepository` listens to the user's cloud document and applies every change to the local blocs. On Firestore this is `DocumentReference.snapshots()`: the first event delivers current cloud state (so it also covers pull-on-startup and pull-on-sign-in, no separate fetch needed), and each later event delivers a change made on another device. Verified against the Firestore "Listen to realtime updates" doc.
- **Write-through on change, debounced (device → cloud).** When a synced bloc emits while signed in, push the merged document after a short debounce (a few seconds) so rapid edits collapse into one write.
- **Conflict policy:** last-write-wins on the whole document. The only "merge" is the explicit guest-vs-cloud choice at sign-in, resolved by the dialog. Accepted limitation: one account actively edited on two devices within a few seconds can drop one side's change. Out of scope by decision, the app assumes a user is not editing the same account from two devices at once.

**Feedback-loop guard (required by the two-way sync).** Without care, an applied remote change re-emits a bloc state, which the write-through pushes back up, which fires the listener again. Two defenses, both needed:

1. Ignore snapshots whose `metadata.hasPendingWrites == true`. Those are this device's own writes echoing back before the server confirms them, not remote changes.
2. While applying a downloaded snapshot, suppress write-through (a flag on `SyncRepository`), and skip the apply entirely when the incoming document equals the current local state. Idempotent applies and equal-state skips stop the bounce even for server-confirmed echoes of our own writes.

Out of scope for MVP: field-level merge (whole-document last-write-wins only) and an offline write queue beyond what the provider's own offline cache gives. Noted as follow-ups.

Firestore's `snapshots()` is the real-time mechanism above, and its offline cache flows through the same stream.

## Layering (matches the existing UI / BLOC / REPO / API / CLIENT pattern)

```
View (sign-in view, replace-warning dialog via BlocListener)
  └─ AuthCubit          orchestrates the sign-in branch, owns the transient dialog signal
       ├─ AuthRepository   Google sign-in + Firebase Auth; exposes AuthUser and isNewUser
       └─ SyncRepository   gathers/applies bloc JSON; one-time existence read, debounced
                           upload, and the live snapshots() subscription, on cloud_firestore
```

The repositories talk to the Firebase SDKs directly, exactly as today's `GoogleAuthRepository` wraps `google_sign_in`. There is no provider-agnostic client layer: the provider is decided and we are not switching, so an interface whose only purpose is swapping providers would be a speculative abstraction (see "Keep it simple").

### Repository responsibilities

`AuthRepository` (the existing interface, extended): `signInWithGoogle()` performs Google sign-in and Firebase credential sign-in and reports `isNewUser` alongside the mapped `AuthUser`; `signOut()`; an `authChanges` stream. It wraps `google_sign_in` and `firebase_auth` and keeps Firebase types out of the rest of the app, the way the current repository already does for `google_sign_in`.

`SyncRepository`: `cloudDocExists(uid)` (one `.get()`, hardens the `isNewUser` branch), `upload(uid, data)` (writes the merged document, debounced), and `watch(uid)` (the `snapshots()` stream, filtering `hasPendingWrites`). It also gathers each synced bloc's `toJson()` into the merged document and applies a downloaded document back to the blocs via `stateRestored`.

### Applying downloaded state to running singletons

The data blocs are DI singletons, so we cannot recreate them. Each synced bloc gets one new event that emits a restored state from a `Map`. `HydratedBloc` then persists it automatically on emit.

```dart
// daily_log_event.dart
const factory DailyLogEvent.stateRestored(Map<String, dynamic> json) = StateRestored;

// handler
StateRestored() => emit(DailyLogState.fromJson(event.json)),
```

`SyncRepository.applyCloudDocument` dispatches `stateRestored` to each bloc with its sub-object, inside try/catch, and only after a full successful download so a partial fetch never wipes local data.

### AuthCubit changes

`AuthState` gains one transient, non-persisted field for the dialog (same pattern as `justLoggedEntryId`), so the persisted shape and its version are unaffected:

```dart
@JsonKey(includeFromJson: false, includeToJson: false)
SignInDecision? pendingDecision, // e.g. existingAccountWillReplaceGuest
```

New methods:

- `signInWithGoogle()` — authenticates, resolves new/existing, uploads or downloads, or sets `pendingDecision` to trigger the dialog.
- `confirmReplaceWithCloud()` — download + overwrite + `signedIn`.
- `cancelExistingAccountSignIn()` — sign back out, clear `pendingDecision`, stay guest.

Keep all sync metadata (e.g. `lastSyncedAt`) out of the synced bloc states and out of the cloud payload. Put it in `AuthState` or a small separate store. Adding fields to a synced bloc's state changes its persisted shape and the cloud blob, which forces a version bump and migration on both. Avoid that.

## Firebase implementation

Packages: `firebase_core`, `firebase_auth`, `cloud_firestore`. Setup via `flutterfire configure` (generates `firebase_options.dart`, drops `GoogleService-Info.plist` / `google-services.json`, wires the iOS reversed-client-id URL scheme). Enable the Google provider in the Auth console. Firestore rule: `match /users/{uid} { allow read, write: if request.auth.uid == uid; }`.

New-vs-existing comes from `additionalUserInfo.isNewUser`, guarded by a `cloudDocExists` check for the case where the Auth record exists but the document does not.

```dart
// AuthRepository: Google sign-in + Firebase credential sign-in
Future<({AuthUser user, bool isNewUser})> signInWithGoogle() async {
  final googleUser = await _googleSignIn.authenticate();
  final credential =
      GoogleAuthProvider.credential(idToken: googleUser.authentication.idToken);
  final result = await FirebaseAuth.instance.signInWithCredential(credential);
  final user = result.user!;
  return (
    user: AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    ),
    isNewUser: result.additionalUserInfo?.isNewUser ?? false,
  );
}

// SyncRepository on cloud_firestore
DocumentReference<Map<String, dynamic>> _doc(String uid) =>
    FirebaseFirestore.instance.doc('users/$uid');

Future<bool> cloudDocExists(String uid) async => (await _doc(uid).get()).exists;

Future<void> upload(String uid, Map<String, dynamic> data) => _doc(uid).set(data);

// Real-time. hasPendingWrites filters out this device's own un-acked writes,
// so applying a remote change doesn't bounce back as a new upload.
Stream<Map<String, dynamic>?> watch(String uid) => _doc(uid)
    .snapshots()
    .where((snap) => !snap.metadata.hasPendingWrites)
    .map((snap) => snap.data());
```

Notes:

- Firestore's offline cache matches the app's offline-first model, and its `snapshots()` stream is the real-time mechanism in the MVP scope above.
- Considered and rejected for MVP: Firebase anonymous auth + `linkWithCredential`, which would upgrade a guest in place and keep data automatically. It forces a cloud identity from first launch (network at first run, cloud cost for pure guests), against the "guest stays local and free" model. Revisit only if that tradeoff changes.

## Why Firebase, and the free tier (validated June 2026)

`additionalUserInfo.isNewUser` makes the new-vs-existing branch (the heart of this feature) reliable with no extra query, it slots into the existing `google_sign_in` flow with the least change, and Firestore's `snapshots()` delivers the requested real-time sync directly, with an offline cache that matches the app's offline-first design.

Both providers' free tiers were checked and are comparable for this app, which is the agreed condition for committing to one:

| | Firebase Spark | Supabase Free |
| --- | --- | --- |
| Auth (Google) | 50K MAU | 50K MAU |
| Storage | 1 GiB | 500 MB |
| Egress | 10 GiB/mo | 5 GB/mo |
| Op limits | 50K reads, 20K writes, 20K deletes per day | unlimited API requests; 2M realtime msgs/mo |
| Gotchas | daily op caps; never pauses | projects pause after 1 week idle; max 2 projects |

Both cover this app (one small JSON document per user) with enormous headroom, and both give 50K MAU. Firebase wins on the feature fit above; Supabase's inactivity pausing is the main reason it would have been slightly worse for a low-traffic app. Decision stands: Firebase. We are not building a provider-swap abstraction for it.

## Keep it simple — no premature optimization

The project rule is to avoid speculative abstractions and premature optimization. What that pruned, and what was deliberately kept simple:

- **Single provider, no swap layer.** Firebase is decided and we are not switching, so there is no provider-agnostic client interface. The repositories call the Firebase SDKs directly, the way `GoogleAuthRepository` calls `google_sign_in` today. If we ever did switch, we rewrite two repositories, which is cheaper than carrying an unused abstraction now.
- **One cloud document, whole-document writes.** No field-level merge and no per-bloc document split. Both were considered for the two-device conflict and rejected, since the app assumes one active device per account.
- **No offline write queue.** We rely on Firestore's own offline cache rather than building a queue/retry layer.
- **Simple debounce on write-through, not a batching system.** It exists only to collapse rapid edits into one write.
- **Reuse, don't reinvent.** Sync serialization reuses each bloc's existing `toJson`/`fromJson` and the existing per-bloc version migration; applying a download reuses one new `stateRestored` event per bloc rather than a new persistence path.

Kept because they are essential complexity, not optimization: the feedback-loop guard (any two-way real-time sync needs it) and the sign-out "confirm cloud is current" step (it prevents data loss).

## Edge cases

- **Offline at sign-in.** Existing-account download cannot proceed safely, block with an error using `ConnectivityCubit`. New-account upload can proceed once connectivity returns; simplest MVP is to require connectivity for sign-in and message clearly.
- **Download fails midway.** Apply only after a complete successful fetch. Never partially overwrite local.
- **Sign-in cancelled** at the provider sheet: no state change.
- **Dialog cancelled:** sign back out of the provider so we are not left half-authenticated; local data untouched.
- **No established guest data into existing account:** no dialog, silent download.
- **Repeated sign-out/sign-in as different accounts:** sign-out must fully clear synced local state so account B never inherits account A's residue.

## Decisions locked

- **Provider:** Firebase. Free tiers validated as comparable (both 50K MAU, ample storage); no provider-swap abstraction is built.
- **Established-data predicate:** at least one logged meal, more than one weigh-in day, or more than one usual. Drives both the dialogs and onboarding routing.
- **Conflict:** whole-document last-write-wins; simultaneous two-device editing is out of scope.
- **Sign-out:** hard-clear local, only after the cloud is confirmed current; blocked offline.

All decisions are settled. The spec is ready to build from.
