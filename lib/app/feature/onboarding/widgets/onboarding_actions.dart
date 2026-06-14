import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template onboarding_actions}
/// Bottom action area shared by onboarding screens. The secondary slot below
/// the primary button is fixed-height so the button stays put whether or not
/// it is filled; the supporting slot above only takes space when provided.
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
        if (above != null) ...[
          SizedBox(height: 48, child: above),
          SizedBox(height: AppDesign.spacing.md),
        ],
        primary,
        SizedBox(height: 48, child: secondary),
      ],
    );
  }
}
