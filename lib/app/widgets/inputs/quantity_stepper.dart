import 'package:flutter/material.dart';
import 'package:the_usual/app/core/extensions/extensions.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template quantity_stepper}
/// A control for picking a quantity: a minus and a plus button flanking the
/// current value, with a toggle on the right that switches the step size. By
/// default the buttons move by a whole one and the toggle reads `.1`; tapping
/// it drops to tenth steps, shows the value with its decimal, and the toggle
/// reads `1` so the next tap returns to whole steps. Double-tapping the value
/// switches the step size too, the way to do it when the toggle is hidden via
/// [showStepSizeToggle]; a dotted underline under the value hints at it then.
/// The minus button is disabled once the value reaches [minQuantity]. Reports
/// the new value on each step.
/// {@endtemplate}
class QuantityStepper extends StatefulWidget {
  /// {@macro quantity_stepper}
  const QuantityStepper({
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 0.1,
    this.dense = false,
    this.showStepSizeToggle = true,
    super.key,
  });

  /// The current quantity to show.
  final double quantity;

  /// Called with the new quantity when the user steps up or down.
  final ValueChanged<double> onChanged;

  /// The lowest quantity allowed; the minus button is disabled here.
  final double minQuantity;

  /// Compact sizing for use inside dense list rows.
  final bool dense;

  /// Whether to show the trailing toggle that switches between whole and tenth
  /// steps. When false the stepper always moves by whole ones.
  final bool showStepSizeToggle;

  @override
  State<QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<QuantityStepper> {
  bool _stepByTenths = false;

  double get _step => _stepByTenths ? 0.1 : 1;

  /// Rounds a stepped value to the nearest tenth, clearing the floating-point
  /// dust repeated 0.1 steps accumulate (2.2 + 0.1 becomes 2.3000000000000003).
  double _cleanStep(double value) => (value * 10).roundToDouble() / 10;

  /// Switches the step size. Leaving tenth steps for whole ones snaps a value
  /// stuck between whole numbers back to the nearest whole, never below the
  /// floor, so whole stepping resumes from a round figure.
  void _toggleStepSize() {
    setState(() => _stepByTenths = !_stepByTenths);
    if (_stepByTenths) return;
    final rounded = widget.quantity.roundToDouble();
    final whole = rounded < 1 ? 1.0 : rounded;
    if (whole != widget.quantity) widget.onChanged(whole);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final buttonSize = widget.dense ? 28.0 : 40.0;
    final iconSize = widget.dense ? 18.0 : AppDesign.iconSizes.md;
    // Only step down when there's room without dropping below the floor, so a
    // whole step stops at 1 while tenth steps can reach the 0.1 minimum. The
    // epsilon absorbs the floating-point dust tenth steps leave behind.
    const epsilon = 0.001;
    final canDecrement =
        widget.quantity - _step >= widget.minQuantity - epsilon;

    // In tenth mode the value always carries its decimal so the mode is legible
    // even at a whole number, e.g. "2.0"; in whole mode a trailing ".0" is
    // dropped.
    final valueLabel = _stepByTenths
        ? widget.quantity.toStringAsFixed(1)
        : widget.quantity.trimmedDecimal;

    // When the step-size toggle is hidden, a dotted underline hints that
    // double-tapping the value switches between whole and tenth steps; it turns
    // the primary colour while tenth steps are active.
    final showStepHint = !widget.showStepSizeToggle;
    final valueStyle = theme.textTheme.titleMedium?.copyWith(
      color: _stepByTenths ? colorScheme.primary : null,
      decoration: showStepHint ? TextDecoration.underline : null,
      decorationStyle: TextDecorationStyle.dotted,
      decorationColor: _stepByTenths
          ? colorScheme.primary
          : colorScheme.onSurfaceVariant,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
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
                onPressed: canDecrement
                    ? () =>
                          widget.onChanged(_cleanStep(widget.quantity - _step))
                    : null,
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onDoubleTap: _toggleStepSize,
                child: Container(
                  constraints: BoxConstraints(minWidth: buttonSize),
                  height: buttonSize,
                  alignment: Alignment.center,
                  child: Text(valueLabel, style: valueStyle),
                ),
              ),
              _StepButton(
                icon: Icons.add,
                size: buttonSize,
                iconSize: iconSize,
                onPressed: () =>
                    widget.onChanged(_cleanStep(widget.quantity + _step)),
              ),
            ],
          ),
        ),
        if (widget.showStepSizeToggle) ...[
          SizedBox(
            width: widget.dense ? AppDesign.spacing.xs : AppDesign.spacing.sm,
          ),
          _StepSizeToggle(
            stepByTenths: _stepByTenths,
            size: buttonSize,
            onPressed: _toggleStepSize,
          ),
        ],
      ],
    );
  }
}

/// The pill that switches the stepper's step size. It shows the step the user
/// can switch to — `.1` while stepping by whole ones, `1` while stepping by
/// tenths — and fills in to mark the tenth mode as active.
class _StepSizeToggle extends StatelessWidget {
  const _StepSizeToggle({
    required this.stepByTenths,
    required this.size,
    required this.onPressed,
  });

  final bool stepByTenths;
  final double size;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppDesign.spacing.sm),
          minimumSize: Size(size, size),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDesign.radius.sm),
          ),
          side: BorderSide(
            color: stepByTenths
                ? colorScheme.primary
                : colorScheme.outlineVariant,
          ),
          backgroundColor: stepByTenths
              ? colorScheme.primary
              : colorScheme.surfaceContainerLowest,
          foregroundColor: stepByTenths
              ? colorScheme.onPrimary
              : colorScheme.primary,
        ),
        child: Text(
          stepByTenths ? '1' : '.1',
          style: theme.textTheme.titleMedium?.copyWith(
            color: stepByTenths ? colorScheme.onPrimary : colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
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
