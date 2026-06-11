// coverage:ignore-file

import 'package:flutter/widgets.dart';
import 'package:flutter_template/l10n/gen/app_localizations.dart';

/// Re-exports generated localization classes and provides convenient access
/// to localized strings throughout the app.
export 'package:flutter_template/l10n/gen/app_localizations.dart';

/// Extension on [BuildContext] for quick access to [AppLocalizations].
extension AppLocalizationsX on BuildContext {
  /// The current localized strings for this context.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
