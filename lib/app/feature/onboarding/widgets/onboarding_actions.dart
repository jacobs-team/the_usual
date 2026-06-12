import 'package:flutter/material.dart';

/// {@template onboarding_actions}
/// Bottom action area shared by onboarding screens. Reserves fixed-height
/// slots below the primary button so the button sits at the same position on
/// every screen, whether or not the slots are filled.
/// {@endtemplate}
class OnboardingActions extends StatelessWidget {
  /// {@macro onboarding_actions}
  const OnboardingActions({
    required this.primary,
    this.secondary,
    this.above,
    super.key,
  });

  /// The main call to action, stretched to full width.
  final Widget primary;

  /// Optional secondary action shown below [primary], always at the bottom.
  final Widget? secondary;

  /// Optional supporting content shown above [primary].
  final Widget? above;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 48, child: above),
        const SizedBox(height: 12),
        primary,
        SizedBox(height: 48, child: secondary),
      ],
    );
  }
}
