---
name: upgrade-dependencies
description: Upgrade all Flutter dependencies to their latest compatible versions, apply migration guides for upgraded packages, then fix analyzer issues and broken tests. Use when the user says "upgrade dependencies", "update packages", "bump deps", or "update all flutter dependencies".
---

# Upgrade Flutter Dependencies

Upgrade every package in `pubspec.yaml` to its latest possible version, migrate the codebase for breaking changes, and leave the analyzer and test suite green. Use `fvm flutter` / `fvm dart` for all CLI commands.

## Step 1: Snapshot current versions

Save the current resolved versions so upgrades can be diffed later:

```
Copy-Item pubspec.lock pubspec.lock.bak
```

## Step 2: Upgrade to latest versions

Do NOT use `pub upgrade --major-versions` — it lets the solver silently settle packages below their latest version. Instead, pin everything to latest explicitly and downgrade only what conflicts:

1. Find the latest published version of every direct dependency:

   ```
   fvm dart pub outdated --json
   ```

   Use the `latest` field for each package.

2. Edit `pubspec.yaml` and set every direct dependency in `dependencies` and `dev_dependencies` to `^<latest>`. Skip SDK-sourced entries (`flutter`, `flutter_localizations`, `flutter_test`, `flutter_web_plugins`).

3. Resolve:

   ```
   fvm flutter pub get
   ```

4. If resolution fails, read the solver's conflict output, identify the incompatibility, and downgrade the **minimal set** of packages needed to resolve it — prefer downgrading the package that blocks the fewest others, and only step down as far as the solver requires. Re-run `fvm flutter pub get` and repeat until resolution succeeds. Record every downgrade and the reason for it.

5. Upgrade all remaining transitive dependencies to their latest compatible versions:

   ```
   fvm flutter pub upgrade
   ```

Finally, run `fvm dart pub outdated` and report any package still behind its latest version along with what is blocking it (SDK constraint, peer dependency, discontinued, etc.). Do not force-resolve these.

## Step 3: List upgraded packages

Diff `pubspec.lock.bak` against the new `pubspec.lock` and build a table of every changed package: name, old version, new version, and whether the bump is major, minor, or patch. Delete `pubspec.lock.bak` once the list is captured.

## Step 4: Apply migrations

For each **direct** dependency that changed:

1. Fetch its changelog at `https://pub.dev/packages/<package>/changelog` (WebFetch). For major bumps also check the package README/repo for a dedicated migration guide.
2. Read every entry between the old and new version and note breaking changes, deprecations, and renamed/removed APIs.
3. Search the codebase for affected APIs and apply the required changes. Follow the project conventions in CLAUDE.md while editing.

Transitive bumps need no migration unless the analyzer surfaces errors from them.

If codegen-related packages changed (`freezed`, `json_serializable`, `injectable_generator`, `build_runner`, `flutter_gen_runner`), regenerate:

```
fvm dart run build_runner build --delete-conflicting-outputs
```

## Step 5: Fix analyzer issues

```
fvm flutter analyze
```

Fix all **errors**. Per project rules, leave warnings and info-level diagnostics alone unless they were introduced by this upgrade.

## Step 6: Run the test suite

```
very_good test --coverage --test-randomize-ordering-seed=random --exclude-coverage "**/*.g.dart" --exclude-coverage "**/*.freezed.dart" --exclude-coverage "lib/l10n/gen/*"
```

If Very Good CLI is not installed, install it first with `dart pub global activate very_good_cli`.

Fix any broken tests. Distinguish the two failure causes:

- Test relies on an API or behavior the upgrade changed: update the test to the new behavior.
- Upgrade genuinely broke app behavior: fix the app code, not the test.

Re-run until all tests pass and coverage stays at or above the CI minimum (95%).

## Step 7: Report

Summarize: the upgraded-packages table, packages held back and why, migrations applied, and the final analyze/test/coverage results.
