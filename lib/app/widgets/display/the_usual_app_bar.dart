import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template the_usual_app_bar}
/// The app bar shared by the main tabs. A centered [title] with the settings
/// shortcut, plus a dev tools shortcut in debug builds. Only the [title]
/// differs between tabs.
/// {@endtemplate}
class TheUsualAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// {@macro the_usual_app_bar}
  const TheUsualAppBar({required this.title, super.key});

  /// The text shown centered in the bar.
  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      actions: [
        IconButton(
          onPressed: () => context.go(Routes.settings),
          tooltip: context.l10n.settingsTooltip,
          icon: const Icon(Icons.settings_outlined),
        ),
        if (kDebugMode)
          IconButton(
            onPressed: () => context.push(Routes.devTools),
            tooltip: context.l10n.devToolsTooltip,
            icon: const Icon(Icons.code),
          ),
      ],
    );
  }
}
