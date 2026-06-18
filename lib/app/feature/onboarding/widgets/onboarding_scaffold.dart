import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template onboarding_scaffold}
/// Shared scaffold for every onboarding screen. It owns the safe area and body
/// padding so each step renders inside identical insets, keeping titles and the
/// bottom actions aligned from screen to screen. Steps only provide their
/// [child] content and, when they have one, an [appBar].
/// {@endtemplate}
class OnboardingScaffold extends StatelessWidget {
  /// {@macro onboarding_scaffold}
  const OnboardingScaffold({
    required this.child,
    this.appBar,
    this.resizeToAvoidBottomInset,
    super.key,
  });

  /// The screen's content, laid out inside the shared padding.
  final Widget child;

  /// Optional top bar. Steps without progress chrome omit it.
  final PreferredSizeWidget? appBar;

  /// Forwarded to [Scaffold.resizeToAvoidBottomInset] for steps whose layout
  /// should not reflow when the keyboard opens.
  final bool? resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    const spacing = AppDesign.spacing;
    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.xl,
            spacing.xl,
            spacing.xl,
            spacing.xs,
          ),
          child: child,
        ),
      ),
    );
  }
}
