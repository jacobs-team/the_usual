import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template quantity_stepper}
/// A compact control for picking a whole-number quantity: a minus and a plus
/// button flanking the current count. The minus button is disabled once the
/// count reaches [minQuantity]. Reports the new value on each step.
/// {@endtemplate}
class QuantityStepper extends StatelessWidget {
  /// {@macro quantity_stepper}
  const QuantityStepper({
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.dense = false,
    super.key,
  });

  /// The current quantity to show.
  final int quantity;

  /// Called with the new quantity when the user steps up or down.
  final ValueChanged<int> onChanged;

  /// The lowest quantity allowed; the minus button is disabled here.
  final int minQuantity;

  /// Compact sizing for use inside dense list rows.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonSize = dense ? 32.0 : 40.0;
    final iconSize = dense ? 18.0 : AppDesign.iconSizes.md;
    final canDecrement = quantity > minQuantity;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDesign.radius.sm),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            size: buttonSize,
            iconSize: iconSize,
            onPressed: canDecrement ? () => onChanged(quantity - 1) : null,
          ),
          Container(
            constraints: BoxConstraints(minWidth: buttonSize),
            alignment: Alignment.center,
            child: Text('$quantity', style: theme.textTheme.titleMedium),
          ),
          _StepButton(
            icon: Icons.add,
            size: buttonSize,
            iconSize: iconSize,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.onPressed,
  });

  final IconData icon;
  final double size;
  final double iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: iconSize,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
