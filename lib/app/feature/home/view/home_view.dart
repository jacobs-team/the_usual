import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/l10n/l10n.dart';

/// {@template home_view}
/// Placeholder for the home screen shown after onboarding, where daily
/// meal logging will live.
/// {@endtemplate}
class HomeView extends StatelessWidget {
  /// {@macro home_view}
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home'),
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
      ),
      body: const Center(
        child: Text('Home coming soon.'),
      ),
    );
  }
}
