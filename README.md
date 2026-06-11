# Flutter Template

[![coverage][coverage_badge]](https://github.com/jcblol/flutter_template/actions)
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

## Getting Started 🚀

This project uses flavors and external configuration files for environment management.

### Prerequisites

This project uses [FVM](https://fvm.app/) to manage Flutter SDK versions. To ensure you are using the correct version defined in .fvmrc, run the following command. Keep in mind you may need to restart your terminal:

```sh
fvm use
```

### Run the App

To run a specific flavor, use the Run and Debug sidebar in VSCode or the following terminal commands:

```sh
# Development
$ fvm flutter run --flavor development --target lib/main_development.dart --dart-define-from-file=config/dev.json

# Production
$ fvm flutter run --flavor production --target lib/main_production.dart --dart-define-from-file=config/prod.json
```

It's likely that you will need to generate code when working within this project. Many aspects of this project use code generation, including go_router (if using typed routes), bloc states and events, data models, assets like images or icons, and any dependencies that are annotated for use with injectable.

To let the build runner run in the background, run:

```sh
fvm dart run build_runner watch --delete-conflicting-outputs
```

To run the build_runner once, run:

```sh
fvm dart run build_runner build --delete-conflicting-outputs
```

_Flutter Template works on iOS, Android, Web, and Windows._

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ very_good test --coverage  --test-randomize-ordering-seed=random --exclude-coverage "**/*.g.dart" --exclude-coverage "**/*.freezed.dart" --exclude-coverage "lib/l10n/gen/*"
```

### Viewing Coverage in VS Code

For a better development experience, this project recommends two extensions (found in .vscode/extensions.json):

1. Flutter Coverage: Provides a dedicated tab in the sidebar to view coverage percentages per file and folder.
2. Coverage Gutters: Displays green/red indicators next to the line numbers in your editor to show which lines are tested.

To enable the indicators:

- Ensure you have run the test command above to generate coverage/lcov.info.
- Press Cmd + Shift + P (macOS) or Ctrl + Shift + P (Windows).
- Type "Coverage Gutters: Watch" and press enter.

## Code Style & Philosophy 🧠

We follow strict engineering standards to ensure code quality and maintainability:

- [Effective Dart](https://dart.dev/effective-dart): Guidelines for consistent and customizable Dart code.
- [Very Good Engineering](https://engineering.verygood.ventures/engineering/philosophy/): Guidelines for writing great Dart code.

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:flutter_template/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
fvm flutter gen-l10n
```

## Built With 🛠️

This project utilizes a robust stack of libraries for state management, navigation, and dependency injection:

- **State Management:** [bloc][bloc_link] & [hydrated_bloc][hydrated_bloc_link] (for persistent state).
- **Navigation:** [go_router][go_router_link].
- **Networking:** [dio][dio_link].
- **Dependency Injection:** [get_it][get_it_link] & [injectable][injectable_link].

Generated by the [Very Good CLI][very_good_cli_link] 🤖

[coverage_badge]: https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/jcblol/ac78cd84ca1ae9a4bb0135c89100374a/raw/coverage.json
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[bloc_link]: https://pub.dev/packages/flutter_bloc
[hydrated_bloc_link]: https://pub.dev/packages/hydrated_bloc
[go_router_link]: https://pub.dev/packages/go_router
[dio_link]: https://pub.dev/packages/dio
[get_it_link]: https://pub.dev/packages/get_it
[injectable_link]: https://pub.dev/packages/injectable
