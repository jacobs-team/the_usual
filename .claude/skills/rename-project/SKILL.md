---
name: rename-project
description: Rename a project freshly cloned from the flutter_template repo — Dart package name, iOS/Android bundle IDs and display names, and every remaining template reference. Use when the user says "rename this project", "set up this clone", "rename the app", or "apply the template rename".
---

# Rename Project From Template

Fully rename a fresh clone of `flutter_template` into its own project: Dart package, platform bundle identifiers, display names, and every leftover reference. Use `fvm flutter` / `fvm dart` for all project CLI commands.

## Step 0: Gather inputs

Three values are required. Derive defaults, then confirm them with the user before changing anything:

- **`project_name`** (snake_case Dart package name, e.g. `my_app`) — default to the repo folder name if it is valid snake_case.
- **`display_name`** (human app name, e.g. `My App`) — default to title-cased `project_name`.
- **`bundle_id`** (reverse-DNS, e.g. `com.example.myapp`) — no safe default; ask the user. Validate it works on both platforms: Android allows underscores but not hyphens, iOS allows hyphens but not underscores, so use all-lowercase alphanumeric segments (no separators) and keep the same ID on both platforms. Each segment must start with a letter.

Also record the old values for the find/replace sweep: package `flutter_template`, and the current display names/bundle IDs found in `android/app/build.gradle*` and `ios/Flutter/*.xcconfig`.

## Step 1: Dart package rename

1. In `pubspec.yaml`, set `name: <project_name>` and update the `description`.
2. Replace every `package:flutter_template/` import with `package:<project_name>/` across `lib/` and `test/` (all `.dart` files, including generated ones — they get regenerated anyway, but this keeps the tree consistent if codegen fails midway).
3. Resolve and regenerate:

   ```
   fvm flutter pub get
   fvm dart run build_runner build --delete-conflicting-outputs
   fvm flutter gen-l10n
   ```

## Step 2: Bundle IDs and app names (rename CLI)

1. Install the rename CLI if missing: `fvm dart pub global activate rename`.
2. Apply the new identifiers:

   ```
   fvm dart pub global run rename setBundleId --targets android,ios --value <bundle_id>
   fvm dart pub global run rename setAppName --targets android,ios,web --value "<display_name>"
   ```

3. The rename CLI only touches base values — this template uses flavors, so verify and fix the flavor layer manually:
   - `android/app/build.gradle*`: the `namespace`, per-flavor `applicationId`/`applicationIdSuffix`, and the `appName` manifest placeholder for each flavor (development/staging/production). Keep the existing suffix scheme (e.g. `.dev`, `.stg`) on the new bundle ID.
   - The Kotlin `MainActivity` package: if its directory path under `android/app/src/main/kotlin/` reflects the old package, move it to match the new `namespace` and update its `package` declaration.
   - `ios/Flutter/*.xcconfig` and `ios/Runner.xcodeproj/project.pbxproj`: `PRODUCT_BUNDLE_IDENTIFIER` per configuration and `FLAVOR_APP_NAME` per flavor (e.g. `<display_name> Dev` for development).

## Step 3: Sweep the remaining references

1. Search the whole repo for leftovers (exclude `.git`, `build`, `.dart_tool`, `.fvm`):

   ```
   grep -ri "flutter_template" .
   grep -ri "<old display name>" .
   ```

2. Fix every hit. Expected locations:
   - `.github/workflows/main.yaml` — the workflow `name`.
   - `README.md` — title and description.
   - `web/index.html` — `<title>` and meta description; `web/manifest.json` — `name`/`short_name` (if the rename CLI didn't already).
   - `.idea/` module files, if present.
   - Code comments or docs referencing the template name.
3. Set up the project's own coverage badge gist with the GitHub CLI (the template ships with the badge steps commented out and the README pointing at the template's gist):
   1. Verify auth: `gh auth status`. The active account's token must include the `gist` scope (run `gh auth refresh -s gist` if missing). Note the account login (`<gist_owner>`) and the repo slug from `gh repo view --json nameWithOwner`.
   2. Create a public gist with a placeholder badge file and record the gist ID from the returned URL:

      ```
      printf '{"schemaVersion":1,"label":"Coverage","message":"unknown","color":"lightgrey"}' > /tmp/coverage.json
      gh gist create /tmp/coverage.json --public --desc "<project_name> coverage badge"
      ```

   3. Set the secret the workflow uses to update the gist: `gh auth token | gh secret set GIST_TOKEN --repo <owner/repo>`. Tell the user this stores their gh OAuth token as the secret; they can replace it with a dedicated PAT (`gist` scope only) whenever they like.
   4. In `.github/workflows/main.yaml`, uncomment the `Extract Coverage` and `Update Coverage Badge Gist` steps, set `gistID:` to the new gist ID, and guard both steps with `if: github.ref == 'refs/heads/main'` so PR runs don't overwrite the badge.
   5. In `README.md`, point the `[coverage_badge]` link at the new gist: `https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/<gist_owner>/<gist_id>/raw/coverage.json`.
   6. The badge stays "unknown" until the first successful CI run on `main` updates the gist.

4. Repeat the grep until it returns no hits outside `.git`.

## Step 4: Validate dynamic values in the diff

The rename CLI replaces some build-time placeholders with the literal app name. Review the full diff and restore every dynamic value:

```
git diff
```

Walk the diff for the platform files and verify that anything that was a placeholder before the rename is STILL a placeholder after:

- `android/app/src/main/AndroidManifest.xml` — `android:label` must stay `${appName}` (the per-flavor value comes from the Gradle manifest placeholder), never the literal display name.
- `ios/Runner/Info.plist` — `CFBundleDisplayName`/`CFBundleName` must keep `$(...)` build-setting references (e.g. `$(FLAVOR_APP_NAME)`), never the literal display name.
- Any other `${...}` (Gradle) or `$(...)` (Xcode) reference the CLI replaced with a literal — revert it to the placeholder.

Rule of thumb: in the diff, a removed line containing `${...}` or `$(...)` whose replacement is a hardcoded string is a regression — restore the placeholder. Literal old-name strings (e.g. in README or web/manifest.json) are the only things that should become the new name.

## Step 5: Verify

```
fvm flutter pub get
fvm flutter analyze
fvm flutter test
```

All must pass. If the user has a device/emulator handy, suggest a quick `fvm flutter run` smoke test to confirm the app boots, shows the new display name, and hot reload works.

## Step 6: Report

Summarize: old → new values for package, bundle IDs (per flavor), display names (per flavor), the list of files touched in the sweep, the new gist ID and `GIST_TOKEN` secret setup, and the verify results. Remind the user the badge updates after the first CI run on `main`.
