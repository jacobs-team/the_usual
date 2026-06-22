# Google Sign-In (client-only) design

## Goal

Add optional Google sign-in to the app. Signing in is client-only: the Google
identity is obtained on-device and stored locally for display and as a UI
signal. There is no backend, no token verification, and no data sync. Users may
continue as a guest and use the app fully without an account.

The existing `AuthCubit` stays as the auth state holder and the router's
refresh signal. A new `AuthRepository` isolates the `google_sign_in` SDK so the
cubit and tests never touch SDK types. Everything lives in a new `feature/auth`.

## Decisions (settled during brainstorming)

- **Client-only, no backend.** We store the Google profile locally. The
  `idToken`/access tokens are not used (nothing verifies them).
- **Optional with guest.** No hard gate. After onboarding, a one-time
  `/sign-in` screen offers Google sign-in with a prominent "Continue as guest".
  The choice is recorded so the user is not asked again. Sign-in/out is also
  available in Settings.
- **Onboarding first**, then the optional `/sign-in` screen.
- **Google only, indefinitely** — no provider abstraction (YAGNI). The
  repository wraps Google directly.
- **`AuthCubit` relocates** from `core/cubit` into `feature/auth/cubit`.
  `RestClient` only uses `AuthCubit.cancelToken` and imports through the app
  barrel, so it is unaffected.
- **Sign-out maps to `guest`** (provisional): an explicit sign-out keeps the
  user in the app rather than bouncing them back to the one-time `/sign-in`
  gate. Revisit when the Supabase backend lands and sign-out may need to stop
  syncing or require re-auth.

## `google_sign_in` v7 API (verified against pub.dev v7.2.0)

- Singleton: `GoogleSignIn.instance`.
- `Future<void> initialize({String? clientId, String? serverClientId})` — must
  complete before any sign-in call. Called once.
- Interactive sign-in: guard with `GoogleSignIn.instance.supportsAuthenticate()`
  (true on Android/iOS), then `await GoogleSignIn.instance.authenticate()`.
- Silent restore: `attemptLightweightAuthentication()` after initialize.
- Auth changes arrive on the `authenticationEvents` stream as a sealed type:
  - `GoogleSignInAuthenticationEventSignIn()` with `event.user`
  - `GoogleSignInAuthenticationEventSignOut()`
- `GoogleSignInAccount` exposes `id`, `email`, `displayName`, `photoUrl`.
- Sign out: `GoogleSignIn.instance.signOut()` (sign out, keep the account
  available for lightweight re-auth). `disconnect()` revokes entirely — not used
  here.
- Cancellation/errors throw `GoogleSignInException` (e.g. `code ==
  GoogleSignInExceptionCode.canceled`), which the repository surfaces.

## Components (`lib/app/feature/auth/`)

```
feature/auth/
  data/auth_repository.dart    # the only google_sign_in touchpoint
  model/auth_user.dart         # freezed domain model
  cubit/auth_cubit.dart        # AuthCubit + AuthState (moved from core/cubit)
  view/sign_in_view.dart       # Google button + "Continue as guest"
  widgets/google_sign_in_button.dart
  widgets/auth_account_tile.dart   # account row reused by Settings
  auth.dart                    # barrel
```

### `AuthUser` (`model/auth_user.dart`)

`@freezed`, `@JsonSerializable` (persisted inside `AuthState`):

```dart
const factory AuthUser({
  required String id,
  required String email,
  String? displayName,
  String? photoUrl,
}) = _AuthUser;
```

### `AuthRepository` (`data/auth_repository.dart`)

`@lazySingleton`, plain Dart (no Flutter widgets). The sole `google_sign_in`
touchpoint; maps `GoogleSignInAccount` → `AuthUser`.

Interface:

```dart
abstract interface class AuthRepository {
  /// Emits the current Google user, or null when signed out. Backed by the
  /// SDK's authenticationEvents stream. Broadcast.
  Stream<AuthUser?> get authChanges;

  /// Idempotent; completes once the SDK is initialized.
  Future<void> initialize();

  /// Interactive sign-in. Resolves when the flow completes; the resulting
  /// user also arrives on [authChanges]. Throws on failure; returns normally
  /// (no user) on user cancellation.
  Future<void> signIn();

  /// Silent re-auth on startup (attemptLightweightAuthentication).
  Future<void> restore();

  /// Signs out (keeps the account for future lightweight auth).
  Future<void> signOut();
}
```

The concrete `GoogleAuthRepository` holds `GoogleSignIn.instance`, calls
`initialize(...)` with the platform client IDs, listens to
`authenticationEvents`, and pushes mapped `AuthUser?` onto a broadcast
controller for `authChanges`. To stay unit-testable, the concrete class takes
an optional injected `GoogleSignIn` (defaults to `GoogleSignIn.instance`) so a
fake can be supplied in tests; the injectable registration uses the default.

### `AuthCubit` / `AuthState` (`cubit/auth_cubit.dart`)

Stays a `HydratedCubit<AuthState>` and keeps `implements Listenable` (the
router refresh signal) and the `cancelToken`. Now constructor-injected with
`AuthRepository`; subscribes to `repository.authChanges` and emits accordingly.

`AuthState` v2:

```dart
enum AuthStatus { unknown, signedIn, guest }

@freezed
abstract class AuthState with _$AuthState {
  @JsonSerializable(explicitToJson: true)
  const factory AuthState({
    @Default(2) int version,
    @Default(AuthStatus.unknown) AuthStatus status,
    AuthUser? user,
  }) = _AuthState;

  const AuthState._();
  static const _currentVersion = 2;

  bool get signedIn => status == AuthStatus.signedIn;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      AuthState._fromVersionedJson(json);

  factory AuthState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
      case 1:
        // v0/v1 stored a placeholder {user, token} pair with no real Google
        // identity. Discard it and start unknown rather than fabricate a
        // signed-in state.
        return const AuthState();
      case _currentVersion:
        return _$AuthStateFromJson(json);
      default:
        return _$AuthStateFromJson(json);
    }
  }
}
```

Methods (each wrapped in try/catch per repo rules):

- `signInWithGoogle()` — `await repository.signIn()`. The `authChanges`
  subscription emits `status: signedIn, user: ...` on success. Rethrows so the
  view can show an error; user-cancellation is a no-op.
- `continueAsGuest()` — `emit(state.copyWith(status: guest, user: null))`.
- `signOut()` — `await repository.signOut()`; subscription emits a signed-out
  event, which the cubit maps to `status: guest` (the user stays in the app,
  and the one-time `/sign-in` gate does not reappear).
- `restoreOnStartup()` — `await repository.initialize(); await
  repository.restore();` Called once at app start. If a previous Google session
  is still valid, `authChanges` emits the user → `signedIn`. If `status` was
  persisted as `signedIn` but restore yields no user, the cubit downgrades to
  `unknown`.

**Transient state stays in the view.** Loading and error are not persisted: the
cubit methods are async, and `SignInView` shows a local spinner while awaiting
and a snackbar on error. `AuthState` persists only the durable
`{status, user}`.

`AuthState` enum is persisted by `name` (json_serializable default for enums is
the name), so adding future statuses at the end is safe.

### Router (`app_router.dart`)

- Add `Routes.signIn = '/sign-in'` and a top-level `GoRoute` for it
  (NoTransitionPage, like the others).
- Set `refreshListenable: getIt<AuthCubit>()` on the `GoRouter` (the cubit is a
  `Listenable`; redirect re-runs on auth change).
- Redirect, evaluated after the existing onboarding check:

```
1. if onboarding not complete -> Routes.onboarding   (unchanged)
2. if status == unknown and not already at /sign-in   -> Routes.signIn
3. if status != unknown and at /sign-in               -> Routes.today
4. otherwise null
```

Guest and signedIn both pass the gate. Sign-out maps to `guest`, so the gate
does not reappear.

### App boot (`the_usuals_app.dart`)

Call `getIt<AuthCubit>().restoreOnStartup()` once during app init (e.g. in
`initState`), so a returning signed-in user is restored silently before first
paint. The existing onboarding-completion listener is unchanged.

### Sign-in screen (`view/sign_in_view.dart`)

Replaces the placeholder. A `GoogleSignInButton` and a "Continue as guest"
action. The button awaits `getIt<AuthCubit>().signInWithGoogle()`, showing a
local progress indicator and a snackbar on failure. "Continue as guest" calls
`continueAsGuest()`. On success/guest the router redirect moves to `/today`.

### Settings account row

A new `AuthSection` (or row) in the user-settings view, reusing
`AuthAccountTile`:
- signed in: show the account (avatar/name/email) + "Sign out"
  (`signOut()`).
- guest/unknown: show "Sign in with Google" (`signInWithGoogle()`).

## Platform configuration (prerequisite task)

OAuth client IDs come from the Google Cloud Console (the developer supplies
them):
- **iOS**: add the iOS client ID and the reversed-client-id URL scheme to
  `ios/Runner/Info.plist` (`CFBundleURLSchemes`). Pass the iOS client ID to
  `initialize(clientId: ...)`.
- **Android**: register the app's SHA-1 with an OAuth client; v7 uses Credential
  Manager. A `serverClientId` (web client ID) is only needed for an ID token /
  backend, which we do not use, so it is optional here.

These values are environment config; the plan will wire `initialize(...)` to
read them and flag the exact strings for the developer to provide.

## Testing

No automated tests for this feature for now (per direction). Verify with
`fvm flutter analyze` and a manual run on a device/simulator. The existing
`AuthCubit` test (`test/app/core/cubit/auth_cubit_test.dart`) exercises the old
`setSession`/`token` API that this change removes, so it is deleted rather than
updated. The architecture (repository seam, mockable `AuthRepository`) keeps the
feature test-ready for when tests are wanted.

## Future (Supabase)

The app stays local-first. Eventually, signing in will post/grab the user's data
to/from a Supabase DB tied to the account as needed (sync on top of local
storage, not a replacement); it does not now. This design accommodates that
without building it:

- The `AuthRepository` interface is the swap point. Supabase auth signs in with
  the Google ID token (`supabase.auth.signInWithIdToken(provider: google, idToken:
  ...)`), and the repository already has the `idToken` via
  `account.authentication.idToken`. When the backend lands, the repository
  gains an `idToken` accessor (or a Supabase-backed implementation) without the
  cubit or router changing shape.
- Sign-out semantics (`guest` vs. clearing/stopping local-data sync) get
  revisited then.

These are explicitly NOT built now.

## Out of scope

Backend verification, session tokens, cloud data sync, additional providers
(Apple/email), and scope/authorization requests (`authorizationClient`).
