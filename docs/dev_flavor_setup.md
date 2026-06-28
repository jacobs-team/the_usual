# Dev flavor Firebase setup

Goal: the `development` flavor talks to its own Firebase project, wired the exact
same way production already is. Production stays untouched.

How prod is wired (the thing we are mirroring):

| Piece | Production | Development (to create) |
|------|------------|-------------------------|
| Firebase project | `the-usual-500220` | a new `the-usual-dev` |
| Android app / package | `com.jblankenship.theusual` | `com.jblankenship.theusual.dev` |
| iOS app / bundle | `com.jblankenship.theusual` | `com.jblankenship.theusual.dev` |
| Android config | `android/app/google-services.json` | `android/app/src/development/google-services.json` |
| iOS config | `ios/Runner/GoogleService-Info.plist` | per-flavor plist wired to `Debug/Release/Profile-development` |
| Dart options | `lib/firebase_options.dart` | `lib/firebase_options_development.dart` |
| Build-time config | `config/prod.json` | `config/dev.json` |
| Google reversed client id | in `ios/Runner/Info.plist` | add the dev one alongside it |

The Dart wiring is already done. The steps below produce the dev project and its
config files.

## 1. Create the dev Firebase project (console)

1. Firebase console → Add project → name it (e.g. `the-usual-dev`).
2. Build → Firestore Database → Create database. Use the same location and mode
   as prod.
3. Authentication → Sign-in method → enable Google. Set a support email.

## 2. Register the apps + generate config (terminal)

From the repo root:

```sh
dart pub global activate flutterfire_cli   # if you don't have it
flutterfire configure \
  --project=the-usual-dev \
  --out=lib/firebase_options_development.dart \
  --ios-bundle-id=com.jblankenship.theusual.dev \
  --ios-build-config=Debug-development \
  --android-package-name=com.jblankenship.theusual.dev \
  --android-out=android/app/src/development/google-services.json \
  --platforms=android,ios,web
```

This registers the `.dev` apps in the dev project, writes
`lib/firebase_options_development.dart` (replacing the placeholder), drops the
dev `google-services.json` into the development source set, and wires the dev
`GoogleService-Info.plist` to the iOS development build configs.

## 3. Android Google Sign-In: add the debug SHA-1 (console)

Google Sign-In on Android needs the signing fingerprint registered.

```sh
cd android && ./gradlew signingReport
```

Copy the `SHA1` from the `debug` variant. In the dev Firebase project → Project
settings → your Android app → Add fingerprint → paste it. Then re-download
`google-services.json` (or re-run the `flutterfire configure` command above).

## 4. Fill in the OAuth client ids (config)

After step 2, open the generated dev `GoogleService-Info.plist` and copy:

- `CLIENT_ID` → put in `config/dev.json` as `GOOGLE_IOS_CLIENT_ID`.
- `REVERSED_CLIENT_ID` → add to `ios/Runner/Info.plist` URL schemes, next to the
  existing prod one.

For `GOOGLE_SERVER_CLIENT_ID` in `config/dev.json`, use the dev project's **Web**
OAuth client id (Firebase console → Authentication, or Google Cloud console →
Credentials for the dev project).

## 5. Run it

Use the "Launch development" run config. Sign in with Google, log something, then
confirm the write lands in the **dev** project's Firestore and prod shows nothing
new.
