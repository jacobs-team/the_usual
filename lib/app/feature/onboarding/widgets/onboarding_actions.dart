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

  /// Height reserved for the [above] and [secondary] slots so the primary
  /// button keeps a stable position whether or not those slots are filled.
  static const _slotHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (above != null) ...[
          SizedBox(height: _slotHeight, child: above),
          SizedBox(height: AppDesign.spacing.md),
        ],
        primary,
        SizedBox(height: _slotHeight, child: secondary),
      ],
    );
  }
}
