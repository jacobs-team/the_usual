# Google Sign-In (client-only) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add optional, client-only Google sign-in: a `google_sign_in`-backed `AuthRepository`, the existing `AuthCubit` reshaped as the auth state holder + router refresh signal, a `/sign-in` screen with a guest path, and a Settings account row — all under a new `feature/auth`.

**Architecture:** `AuthRepository` (the sole `google_sign_in` v7 touchpoint) exposes a `Stream<AuthUser?>` plus `initialize/signIn/restore/signOut`. `AuthCubit` (HydratedCubit, `Listenable`) subscribes to that stream and persists `{status, user}`. The GoRouter gates a one-time `/sign-in` screen on `status == unknown`; guest and signed-in pass. No backend, no tokens, no sync.

**Tech Stack:** Flutter, flutter_bloc + hydrated_bloc, freezed + json_serializable, injectable/get_it, go_router, google_sign_in ^7.x.

## Global Constraints

- Use `fvm flutter` for every Flutter CLI command.
- Always use barrel files (`package:the_usual/app/app.dart`) over direct imports.
- The freezed/json_serializable/injectable code generator runs in the background (watch mode). Do NOT invoke build_runner; after editing a `@freezed`/`@injectable` class, wait for generation. If it isn't running, ask the developer.
- Do NOT run the app. Ask the developer to run it for manual verification.
- **Do NOT write automated tests for this feature** (per direction). Verify each task with `fvm flutter analyze` (no new errors) and, where noted, a manual run.
- Do NOT fix info/warning-level lints unless they are errors — except do keep new code analyzer-clean.
- Do NOT run `git commit`/`git push`. Where a step says "Commit", stage nothing and tell the developer exactly what changed with a suggested message; the developer commits.
- `@singleton` for the cubit, `@lazySingleton`/`@LazySingleton(as: ...)` for the repository (match existing DI patterns).
- Naming: variables hold the full model-type name. Doc comments describe what a thing IS, not a changelog.
- This changes a persisted `HydratedCubit` shape (`AuthState`): bump `version` and migrate in `fromJson` (old `{user, token}` → `unknown`).
- `google_sign_in` v7 API (verified, pub.dev 7.2.0): `GoogleSignIn.instance`; `await initialize({clientId, serverClientId})` once; guard interactive sign-in with `supportsAuthenticate()` then `await authenticate()`; `attemptLightweightAuthentication()` for silent restore; auth changes via `authenticationEvents` stream of sealed `GoogleSignInAuthenticationEventSignIn(user)` / `GoogleSignInAuthenticationEventSignOut()`; `GoogleSignInAccount` has `id`/`email`/`displayName`/`photoUrl`; `signOut()` to sign out. Confirm the exact `GoogleSignInException` cancellation code member against the installed version.

---

## File Structure

- Create `lib/app/feature/auth/model/auth_user.dart` — `AuthUser` freezed model.
- Create `lib/app/feature/auth/data/auth_repository.dart` — `AuthRepository` interface + `GoogleAuthRepository`.
- Create `lib/app/feature/auth/cubit/auth_cubit.dart` — `AuthCubit` + `AuthState` + `AuthStatus` (moved from `core/cubit`).
- Create `lib/app/feature/auth/view/sign_in_view.dart` — the real sign-in screen.
- Create `lib/app/feature/auth/widgets/google_sign_in_button.dart` and `auth_account_tile.dart`.
- Create `lib/app/feature/auth/auth.dart` — feature barrel.
- Delete `lib/app/core/cubit/auth_cubit.dart` (+ generated parts) and update `lib/app/core/cubit/cubit.dart`.
- Delete `lib/app/feature/sign_in/` (replaced by `feature/auth/view`).
- Delete `test/app/core/cubit/auth_cubit_test.dart` (tests removed API; no replacement per no-tests direction).
- Modify `pubspec.yaml`, `lib/environment.dart`, `lib/app/navigation/routes.dart`, `lib/app/navigation/app_router.dart`, `lib/app/the_usuals_app.dart`, `lib/app/feature/feature.dart`, the app barrel chain, `lib/app/feature/user_settings/view/user_settings_view.dart`, and `lib/l10n/arb/app_en.arb` + `app_es.arb`.

---

## Task 1: Dependency, `AuthUser` model, and feature scaffold

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/app/feature/auth/model/auth_user.dart`
- Create: `lib/app/feature/auth/auth.dart`
- Modify: `lib/app/feature/feature.dart`

**Produces:** `AuthUser({required String id, required String email, String? displayName, String? photoUrl})` with `fromJson`/`toJson`; `feature/auth/auth.dart` barrel exported from the feature barrel.

- [ ] **Step 1: Add the dependency**

In `pubspec.yaml`, under `dependencies:` (alphabetical), add:

```yaml
  google_sign_in: ^7.2.0
```

Run: `fvm flutter pub get`
Expected: resolves with no version conflict (SDK is `>=3.8.0`).

- [ ] **Step 2: Create the `AuthUser` model**

Create `lib/app/feature/auth/model/auth_user.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

/// {@template auth_user}
/// The signed-in Google identity, as the app uses it: a stable id, email, and
/// optional display name and avatar. Mapped from the SDK account by
/// `AuthRepository` so the rest of the app never sees google_sign_in types.
/// {@endtemplate}
@freezed
abstract class AuthUser with _$AuthUser {
  /// {@macro auth_user}
  const factory AuthUser({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
```

- [ ] **Step 3: Create the feature barrel and export it**

Create `lib/app/feature/auth/auth.dart`:

```dart
export 'cubit/auth_cubit.dart';
export 'data/auth_repository.dart';
export 'model/auth_user.dart';
export 'view/sign_in_view.dart';
export 'widgets/auth_account_tile.dart';
export 'widgets/google_sign_in_button.dart';
```

(The exported files are created in later tasks; the barrel will not analyze clean until then — that is expected within this task and resolved by Task 5/6. To keep Task 1 self-contained and analyzable, comment out the not-yet-created exports and uncomment them as their files land. Start with only `model/auth_user.dart` exported.)

So for now `auth.dart` is:

```dart
export 'model/auth_user.dart';
```

In `lib/app/feature/feature.dart`, replace the line `export 'sign_in/view/sign_in_view.dart';` with:

```dart
export 'auth/auth.dart';
```

- [ ] **Step 4: Verify**

Wait for codegen to produce `auth_user.freezed.dart` / `auth_user.g.dart`.
Run: `fvm flutter analyze lib/app/feature/auth`
Expected: no errors.

- [ ] **Step 5: Commit** — tell the developer. Changed: `pubspec.yaml`, `pubspec.lock`, `feature/auth/model/auth_user.dart`, `feature/auth/auth.dart`, `feature/feature.dart`. Suggested message: `feat: add google_sign_in dep and AuthUser model`

---

## Task 2: `AuthRepository` + Google implementation + config

**Files:**
- Modify: `lib/environment.dart`
- Create: `lib/app/feature/auth/data/auth_repository.dart`
- Modify: `lib/app/feature/auth/auth.dart` (export the repository)

**Interfaces:**
- Consumes: `AuthUser` (Task 1).
- Produces: `abstract interface class AuthRepository` with `Stream<AuthUser?> get authChanges`, `Future<void> initialize()`, `Future<void> signIn()`, `Future<void> restore()`, `Future<void> signOut()`. Registered as `@LazySingleton(as: AuthRepository)`.

- [ ] **Step 1: Add client-id config**

In `lib/environment.dart`, add static fields to the config class (match the existing style there; values are placeholders the developer fills from the Google Cloud Console):

```dart
  /// iOS OAuth client id for Google Sign-In (from Google Cloud Console).
  static const String? googleIosClientId = null;

  /// Web/server OAuth client id. Only needed for an ID token / backend; null
  /// for the current client-only flow.
  static const String? googleServerClientId = null;
```

(If `environment.dart` exposes config per-environment differently, follow that pattern; the key requirement is two nullable `String?` accessors reachable as shown in Step 2.)

- [ ] **Step 2: Create the repository**

Create `lib/app/feature/auth/data/auth_repository.dart`:

```dart
import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/environment.dart';

/// {@template auth_repository}
/// The single touchpoint for the google_sign_in SDK. Exposes the current Google
/// user as a stream and the actions to change it, mapping SDK accounts to
/// [AuthUser] so callers never depend on google_sign_in types.
/// {@endtemplate}
abstract interface class AuthRepository {
  /// Emits the current user, or null when signed out. Broadcast.
  Stream<AuthUser?> get authChanges;

  /// Idempotent; completes once the SDK is initialized.
  Future<void> initialize();

  /// Interactive sign-in. The resulting user arrives on [authChanges].
  /// Returns normally on user cancellation; throws on real failure.
  Future<void> signIn();

  /// Silent re-auth on startup.
  Future<void> restore();

  /// Signs out (keeps the account for future lightweight auth).
  Future<void> signOut();
}

/// {@macro auth_repository}
@LazySingleton(as: AuthRepository)
class GoogleAuthRepository implements AuthRepository {
  /// {@macro auth_repository}
  GoogleAuthRepository([GoogleSignIn? googleSignIn])
    : _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final GoogleSignIn _googleSignIn;
  final StreamController<AuthUser?> _authChanges =
      StreamController<AuthUser?>.broadcast();
  StreamSubscription<GoogleSignInAuthenticationEvent>? _eventSubscription;
  bool _initialized = false;

  @override
  Stream<AuthUser?> get authChanges => _authChanges.stream;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _googleSignIn.initialize(
      clientId: EnvironmentConfig.googleIosClientId,
      serverClientId: EnvironmentConfig.googleServerClientId,
    );
    _eventSubscription = _googleSignIn.authenticationEvents.listen(
      _onAuthenticationEvent,
      onError: (Object _) => _authChanges.add(null),
    );
  }

  void _onAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    final account = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };
    _authChanges.add(account == null ? null : _toAuthUser(account));
  }

  AuthUser _toAuthUser(GoogleSignInAccount account) => AuthUser(
    id: account.id,
    email: account.email,
    displayName: account.displayName,
    photoUrl: account.photoUrl,
  );

  @override
  Future<void> signIn() async {
    if (!_googleSignIn.supportsAuthenticate()) return;
    try {
      await _googleSignIn.authenticate();
    } on GoogleSignInException catch (error) {
      // A user-cancelled sign-in is not an error; anything else propagates.
      if (error.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
  }

  @override
  Future<void> restore() => _googleSignIn.attemptLightweightAuthentication();

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
```

Note: replace `EnvironmentConfig` with the actual config class name used in `lib/environment.dart` if different. Confirm `GoogleSignInExceptionCode.canceled` is the correct member in the installed `google_sign_in`; if the enum differs, use the version's cancellation code.

- [ ] **Step 3: Export it**

In `lib/app/feature/auth/auth.dart`, add:

```dart
export 'data/auth_repository.dart';
```

- [ ] **Step 4: Verify**

Wait for injectable codegen to register `GoogleAuthRepository`.
Run: `fvm flutter analyze lib/app/feature/auth lib/environment.dart`
Expected: no errors. Confirm `dependencies.config.dart` now registers `AuthRepository`.

- [ ] **Step 5: Commit** — Changed: `environment.dart`, `feature/auth/data/auth_repository.dart`, `feature/auth/auth.dart`, generated DI config. Suggested message: `feat: AuthRepository wrapping google_sign_in v7`

---

## Task 3: Reshape `AuthCubit`/`AuthState`, relocate to `feature/auth`

**Files:**
- Create: `lib/app/feature/auth/cubit/auth_cubit.dart`
- Delete: `lib/app/core/cubit/auth_cubit.dart` (+ `.freezed.dart`, `.g.dart`)
- Modify: `lib/app/core/cubit/cubit.dart`
- Modify: `lib/app/feature/auth/auth.dart` (export the cubit)
- Delete: `test/app/core/cubit/auth_cubit_test.dart`

**Interfaces:**
- Consumes: `AuthRepository` (Task 2), `AuthUser` (Task 1).
- Produces: `AuthCubit` (`@singleton`, `HydratedCubit<AuthState>`, `Listenable`, ctor `AuthCubit(AuthRepository)`) with `signInWithGoogle()`, `continueAsGuest()`, `signOut()`, `restoreOnStartup()`, and `CancelToken cancelToken`. `AuthState({int version, AuthStatus status, AuthUser? user})` with `bool get signedIn`. `enum AuthStatus { unknown, signedIn, guest }`.

- [ ] **Step 1: Create the relocated cubit**

Create `lib/app/feature/auth/cubit/auth_cubit.dart`:

```dart
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:the_usual/app/app.dart';

part 'auth_cubit.freezed.dart';
part 'auth_cubit.g.dart';

/// How the user relates to an account, persisted across restarts.
enum AuthStatus {
  /// No decision yet — the one-time sign-in screen should be offered.
  unknown,

  /// Signed in with Google.
  signedIn,

  /// Chose to use the app without an account.
  guest,
}

/// {@template auth_cubit}
/// Holds the app's authentication state and drives the router. Subscribes to
/// [AuthRepository.authChanges] and persists the durable result; transient
/// progress and errors live in the views that call its methods.
/// {@endtemplate}
@singleton
class AuthCubit extends HydratedCubit<AuthState> implements Listenable {
  /// {@macro auth_cubit}
  AuthCubit(this._repository) : super(const AuthState()) {
    _subscription = _repository.authChanges.listen(_onAuthChanged);
  }

  final AuthRepository _repository;
  StreamSubscription<AuthUser?>? _subscription;
  final List<VoidCallback> _listeners = [];

  /// Cancels in-flight HTTP requests on sign-out.
  CancelToken cancelToken = CancelToken();

  void _onAuthChanged(AuthUser? user) {
    if (user != null) {
      emit(state.copyWith(status: AuthStatus.signedIn, user: user));
    } else if (state.status == AuthStatus.signedIn) {
      // The SDK signed out; keep the user in the app as a guest rather than
      // bouncing them back to the one-time sign-in gate.
      emit(state.copyWith(status: AuthStatus.guest, user: null));
    }
  }

  /// Initializes the SDK and restores a previous session silently. Call once at
  /// app start.
  Future<void> restoreOnStartup() async {
    try {
      await _repository.initialize();
      await _repository.restore();
    } on Exception {
      // A failed silent restore leaves the persisted state untouched.
    }
  }

  /// Triggers the interactive Google sign-in flow. The result arrives via the
  /// repository stream. Throws on failure so the caller can surface it.
  Future<void> signInWithGoogle() async {
    await _repository.initialize();
    await _repository.signIn();
  }

  /// Records that the user chose to continue without an account.
  void continueAsGuest() =>
      emit(state.copyWith(status: AuthStatus.guest, user: null));

  /// Signs out of Google and cancels active requests; the user stays in the app
  /// as a guest.
  Future<void> signOut() async {
    cancelToken.cancel('Signed out');
    cancelToken = CancelToken();
    await _repository.signOut();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) => AuthState.fromJson(json);

  @override
  Map<String, dynamic> toJson(AuthState state) => state.toJson();

  @override
  void addListener(VoidCallback listener) => _listeners.add(listener);

  @override
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  @override
  void onChange(Change<AuthState> change) {
    super.onChange(change);
    for (final listener in _listeners) {
      listener();
    }
  }
}

/// {@template auth_state}
/// The authentication state: the user's [status] and, when signed in, their
/// [user].
/// {@endtemplate}
@freezed
abstract class AuthState with _$AuthState {
  /// {@macro auth_state}
  @JsonSerializable(explicitToJson: true)
  const factory AuthState({
    @Default(2) int version,
    @Default(AuthStatus.unknown) AuthStatus status,
    AuthUser? user,
  }) = _AuthState;

  const AuthState._();

  static const _currentVersion = 2;

  /// Whether the user is signed in with Google.
  bool get signedIn => status == AuthStatus.signedIn;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      AuthState._fromVersionedJson(json);

  factory AuthState._fromVersionedJson(Map<String, dynamic> json) {
    final version = json['version'] as int? ?? 0;
    switch (version) {
      case 0:
      case 1:
        // v0/v1 stored a placeholder {user, token} string pair with no real
        // Google identity. Discard it and start unknown rather than fabricate
        // a signed-in state.
        return const AuthState();
      case _currentVersion:
        return _$AuthStateFromJson(json);
      default:
        // A newer, unknown version (e.g. a downgrade): read with the current
        // schema as a best effort instead of discarding.
        return _$AuthStateFromJson(json);
    }
  }
}
```

- [ ] **Step 2: Delete the old cubit and fix the core barrel**

Delete `lib/app/core/cubit/auth_cubit.dart`, `lib/app/core/cubit/auth_cubit.freezed.dart`, `lib/app/core/cubit/auth_cubit.g.dart`.

In `lib/app/core/cubit/cubit.dart`, remove `export 'auth_cubit.dart';`. If that leaves the file empty, leave it exporting whatever else it had; if it only exported auth, delete `cubit.dart` and remove its export from the core barrel (`lib/app/core/core.dart` or wherever `cubit.dart` is exported). Confirm `AuthCubit`/`AuthState` now resolve through `package:the_usual/app/app.dart` via the feature barrel.

- [ ] **Step 3: Export the cubit from the feature barrel**

In `lib/app/feature/auth/auth.dart` add (keep alphabetical):

```dart
export 'cubit/auth_cubit.dart';
```

- [ ] **Step 4: Delete the obsolete test**

Delete `test/app/core/cubit/auth_cubit_test.dart` (it exercises the removed `setSession`/`token` API; no replacement per the no-tests direction).

- [ ] **Step 5: Verify**

Wait for codegen (`auth_cubit.freezed.dart`/`.g.dart`, DI config: `AuthCubit` now takes `AuthRepository`).
Run: `fvm flutter analyze`
Expected: no errors. `RestClient` still compiles (it only uses `AuthCubit.cancelToken`, resolved through the barrel). Confirm `dependencies.config.dart` constructs `AuthCubit(getIt<AuthRepository>())`.

- [ ] **Step 6: Commit** — Changed: new `feature/auth/cubit/auth_cubit.dart`, deleted `core/cubit/auth_cubit*.dart` + old test, barrel updates, regenerated DI/freezed. Suggested message: `refactor: reshape AuthCubit (status+user) into feature/auth`

---

## Task 4: Router gate + startup restore

**Files:**
- Modify: `lib/app/navigation/routes.dart`
- Modify: `lib/app/navigation/app_router.dart`
- Modify: `lib/app/the_usuals_app.dart`

**Interfaces:**
- Consumes: `AuthCubit` (Task 3) — `getIt<AuthCubit>()`, `state.status`, `restoreOnStartup()`; `SignInView` (Task 5).
- Produces: `Routes.signIn = '/sign-in'`; a `/sign-in` route; auth redirect.

- [ ] **Step 1: Add the route constant**

In `lib/app/navigation/routes.dart`, replace the commented `// static const String signIn = '/sign-in';` with:

```dart
  static const String signIn = '/sign-in';
```

- [ ] **Step 2: Add the route and the redirect/refresh**

In `lib/app/navigation/app_router.dart`:

Add the refresh listenable and extend the redirect (replace the existing `redirect:` block, keeping the onboarding rule):

```dart
      refreshListenable: getIt<AuthCubit>(),
      redirect: (context, state) {
        final onboardingComplete =
            getIt<OnboardingBloc>().state.step == OnboardingStep.complete;
        if (!onboardingComplete) return Routes.onboarding;

        final status = getIt<AuthCubit>().state.status;
        final atSignIn = state.matchedLocation == Routes.signIn;
        if (status == AuthStatus.unknown && !atSignIn) return Routes.signIn;
        if (status != AuthStatus.unknown && atSignIn) return Routes.today;
        return null;
      },
```

Add a top-level route to the `routes` list (next to `/onboarding`):

```dart
    GoRoute(
      path: Routes.signIn,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SignInView());
      },
    ),
```

- [ ] **Step 3: Restore on startup**

In `lib/app/the_usuals_app.dart` `initState` (after `super.initState();`), add:

```dart
    getIt<AuthCubit>().restoreOnStartup();
```

- [ ] **Step 4: Verify**

Run: `fvm flutter analyze lib/app/navigation lib/app/the_usuals_app.dart`
Expected: no errors. (`SignInView` must exist — if doing tasks in order, Task 5 precedes a clean analyze here; if not, this analyzes clean once Task 5 lands. Reorder Task 5 before Task 4 if you prefer a clean gate per task.)

- [ ] **Step 5: Commit** — Changed: `routes.dart`, `app_router.dart`, `the_usuals_app.dart`. Suggested message: `feat: gate a one-time /sign-in screen via AuthCubit + restore on startup`

---

## Task 5: Sign-in screen + Google button (do before Task 4 for clean analyze)

**Files:**
- Create: `lib/app/feature/auth/widgets/google_sign_in_button.dart`
- Create: `lib/app/feature/auth/view/sign_in_view.dart`
- Modify: `lib/app/feature/auth/auth.dart`
- Delete: `lib/app/feature/sign_in/` (old placeholder)
- Modify: `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_es.arb`

**Interfaces:**
- Consumes: `AuthCubit` (Task 3).
- Produces: `SignInView`, `GoogleSignInButton`.

- [ ] **Step 1: Add l10n strings**

In `lib/l10n/arb/app_en.arb` add (with the `@`-metadata blocks matching the file's style):

```json
    "signInWithGoogle": "Sign in with Google",
    "continueAsGuest": "Continue as guest",
    "signOut": "Sign out",
    "signInFailed": "Could not sign in. Please try again."
```

Add Spanish equivalents to `lib/l10n/arb/app_es.arb`:

```json
    "signInWithGoogle": "Iniciar sesión con Google",
    "continueAsGuest": "Continuar como invitado",
    "signOut": "Cerrar sesión",
    "signInFailed": "No se pudo iniciar sesión. Inténtalo de nuevo."
```

- [ ] **Step 2: Create the Google button**

Create `lib/app/feature/auth/widgets/google_sign_in_button.dart`. A stateful button that shows a local spinner while awaiting and surfaces failures via snackbar (transient state stays in the widget):

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/l10n/l10n.dart';

/// A button that runs the interactive Google sign-in flow, showing a spinner
/// while it is in progress and a snackbar if it fails.
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _busy = false;

  Future<void> _signIn() async {
    setState(() => _busy = true);
    try {
      await getIt<AuthCubit>().signInWithGoogle();
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.signInFailed)),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: _busy ? null : _signIn,
      icon: _busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.login),
      label: Text(context.l10n.signInWithGoogle),
    );
  }
}
```

(Confirm `context.l10n` is the localization accessor used elsewhere; the codebase already uses `context.l10n.signIn`.)

- [ ] **Step 3: Create the sign-in view**

Create `lib/app/feature/auth/view/sign_in_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template sign_in_view}
/// The one-time, optional sign-in screen shown after onboarding: sign in with
/// Google, or continue without an account.
/// {@endtemplate}
class SignInView extends StatelessWidget {
  /// {@macro sign_in_view}
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GoogleSignInButton(),
              SizedBox(height: AppDesign.spacing.md),
              TextButton(
                onPressed: () => getIt<AuthCubit>().continueAsGuest(),
                child: Text(context.l10n.continueAsGuest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: Wire barrel, remove placeholder**

In `lib/app/feature/auth/auth.dart` add:

```dart
export 'view/sign_in_view.dart';
export 'widgets/google_sign_in_button.dart';
```

Delete the old `lib/app/feature/sign_in/` directory. Confirm nothing else imports it (the feature barrel line was already swapped in Task 1; grep `sign_in/view` to be sure).

- [ ] **Step 5: Verify**

Run: `fvm flutter analyze lib/app/feature/auth lib/l10n`
Expected: no errors. (l10n regenerates `app_localizations*`.)

- [ ] **Step 6: Commit** — Changed: sign-in view + button, l10n arb (+ generated), barrel, deleted old `sign_in/`. Suggested message: `feat: Google sign-in screen with guest option`

---

## Task 6: Settings account row

**Files:**
- Create: `lib/app/feature/auth/widgets/auth_account_tile.dart`
- Modify: `lib/app/feature/auth/auth.dart`
- Modify: `lib/app/feature/user_settings/view/user_settings_view.dart`

**Interfaces:**
- Consumes: `AuthCubit` (Task 3), `GoogleSignInButton` (Task 5).
- Produces: `AuthAccountTile`.

- [ ] **Step 1: Create the account tile**

Create `lib/app/feature/auth/widgets/auth_account_tile.dart` — reflects auth state: signed-in shows the account + sign out; otherwise shows the sign-in button.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template auth_account_tile}
/// The Settings account control: shows the signed-in Google account with a sign
/// out action, or a sign-in button when signed out / guest.
/// {@endtemplate}
class AuthAccountTile extends StatelessWidget {
  /// {@macro auth_account_tile}
  const AuthAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, AuthState>(
      bloc: getIt<AuthCubit>(),
      selector: (state) => state,
      builder: (context, state) {
        final user = state.user;
        if (state.status == AuthStatus.signedIn && user != null) {
          return Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              leading: user.photoUrl == null
                  ? const Icon(Icons.account_circle)
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl!),
                    ),
              title: Text(user.displayName ?? user.email),
              subtitle: user.displayName == null ? null : Text(user.email),
              trailing: TextButton(
                onPressed: () => getIt<AuthCubit>().signOut(),
                child: Text(context.l10n.signOut),
              ),
            ),
          );
        }
        return const GoogleSignInButton();
      },
    );
  }
}
```

- [ ] **Step 2: Export and add to settings**

In `lib/app/feature/auth/auth.dart` add `export 'widgets/auth_account_tile.dart';`.

In `lib/app/feature/user_settings/view/user_settings_view.dart`, add to the `ListView` children (place near the top or bottom to match the section rhythm), following the existing `SectionLabel` + widget pattern:

```dart
            const SectionLabel('ACCOUNT'),
            const AuthAccountTile(),
```

(Match the surrounding `SizedBox`/spacing between a `SectionLabel` and its content used by the other sections.)

- [ ] **Step 3: Verify**

Run: `fvm flutter analyze lib/app/feature/auth lib/app/feature/user_settings`
Expected: no errors.

- [ ] **Step 4: Commit** — Changed: `auth_account_tile.dart`, barrel, `user_settings_view.dart`. Suggested message: `feat: account row in Settings (sign in / out)`

---

## Task 7: Platform configuration (developer-supplied IDs)

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: Android config (`android/app/build.gradle` / Google Cloud OAuth client; no app-code change required for basic flow)
- Modify: `lib/environment.dart` (fill the client ids)

This task needs OAuth client IDs from the developer's Google Cloud Console; flag and pause for them.

- [ ] **Step 1: iOS URL scheme + client id**

In Google Cloud Console create an **iOS** OAuth client for the app's bundle id. Put its reversed client id into `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_REVERSED_IOS_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

Set `EnvironmentConfig.googleIosClientId` in `lib/environment.dart` to the iOS client id (`YOUR_IOS_CLIENT_ID.apps.googleusercontent.com`).

- [ ] **Step 2: Android OAuth client**

In Google Cloud Console create an **Android** OAuth client with the app package name and the signing SHA-1 (debug and release). No `google-services.json` is required for basic `google_sign_in` v7 sign-in; Credential Manager uses the registered client. Leave `googleServerClientId` null unless a server/ID-token is needed later.

- [ ] **Step 3: Verify (developer, on device)**

Ask the developer to run the app on an iOS simulator/device and an Android device and complete a Google sign-in, then sign out from Settings, then continue-as-guest from a fresh install. Confirm the `/sign-in` screen appears once after onboarding and not again after a choice.

- [ ] **Step 4: Commit** — Changed: `Info.plist`, `environment.dart`, any Android config. Suggested message: `chore: platform config for Google sign-in`

---

## Task 8: Final verification

- [ ] **Step 1: Analyzer**

Run: `fvm flutter analyze`
Expected: no errors. (Info/warning lints unrelated to this feature are out of scope.)

- [ ] **Step 2: Manual smoke (developer)**

Fresh install → onboarding → `/sign-in` appears once. Sign in with Google → lands on Today; Settings shows the account; sign out → stays in app as guest; relaunch → no `/sign-in` gate. Separately: continue-as-guest → Today; relaunch → no gate.

- [ ] **Step 3: Commit any fixups** — only if needed.

---

## Self-Review

**Spec coverage:**
- `feature/auth` layout, `AuthUser`, `AuthRepository` (stream + initialize/signIn/restore/signOut), Google v7 mapping → Tasks 1–2.
- `AuthCubit`/`AuthState` v2 (status+user), `Listenable`, `cancelToken`, migration, relocation, repo subscription, sign-out→guest → Task 3.
- Router refreshListenable + `/sign-in` gate rule + startup restore → Task 4.
- Sign-in screen + guest, transient state in view → Task 5.
- Settings account row → Task 6.
- Platform OAuth config (iOS scheme, Android client) → Task 7.
- No tests (per direction); obsolete test deleted → Task 3 / Global Constraints.
- Local-first + future Supabase: out of scope, no code now. ✓

**Placeholder scan:** Client-ids are intentionally developer-supplied in Task 7 (flagged), not plan placeholders. Code steps contain full code. ✓

**Type consistency:** `AuthRepository` method names (`initialize/signIn/restore/signOut/authChanges`) identical across Tasks 2–3; `AuthStatus { unknown, signedIn, guest }` and `AuthState({version, status, user})` consistent across Tasks 3–6; `getIt<AuthCubit>()` accessor used uniformly. ✓

**Note:** Do Task 5 before Task 4 if you want each task to analyze cleanly in isolation (Task 4 references `SignInView`).
