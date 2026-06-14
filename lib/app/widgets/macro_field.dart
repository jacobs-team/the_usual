import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';

/// {@template macro_field}
/// A [TheUsualTextField] specialized for a nutrition value: numeric keyboard,
/// digits-only input capped at [maxDigits], and a [unit] suffix (e.g. " cal" or
/// " g"). Parses the text to an int for its callbacks.
/// {@endtemplate}
class MacroField extends StatelessWidget {
  /// {@macro macro_field}
  const MacroField({
    required this.unit,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.hintText = '—',
    this.maxDigits = 4,
    this.autoSize = false,
    this.dense = false,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// The unit shown as a suffix inside the field, e.g. 'cal' or 'g'.
  final String unit;

  /// Controller for the text. Mutually exclusive with [initialValue].
  final TextEditingController? controller;

  /// Starting text when no [controller] is provided.
  final String? initialValue;

  /// Focus node for the field.
  final FocusNode? focusNode;

  /// Placeholder shown when the field is empty.
  final String hintText;

  /// Maximum number of digits the field accepts.
  final int maxDigits;

  /// Sizes the field to its content.
  final bool autoSize;

  /// Compact inline styling.
  final bool dense;

  /// How the text is aligned within the field.
  final TextAlign textAlign;

  /// Action button to show on the keyboard.
  final TextInputAction? textInputAction;

  /// Called with the parsed value, or null when the field is empty.
  final ValueChanged<int?>? onChanged;

  /// Called with the parsed value when the keyboard's submit action fires.
  final ValueChanged<int?>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    final onSubmitted = this.onSubmitted;
    return TheUsualTextField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      hintText: hintText,
      autoSize: autoSize,
      dense: dense,
      textAlign: textAlign,
      textInputAction: textInputAction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(maxDigits),
      ],
      suffixText: ' $unit',
      onChanged: onChanged == null
          ? null
          : (value) => onChanged(int.tryParse(value)),
      onSubmitted: onSubmitted == null
          ? null
          : (value) => onSubmitted(int.tryParse(value)),
    );
  }
}
