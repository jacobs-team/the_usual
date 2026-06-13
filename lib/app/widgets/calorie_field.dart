import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';

/// {@template calorie_field}
/// A [TheUsualTextField] specialized for calorie entry: numeric keyboard,
/// digits-only input capped at four digits, and a " cal" suffix. Parses the
/// text to an int for its callbacks.
/// {@endtemplate}
class CalorieField extends StatelessWidget {
  /// {@macro calorie_field}
  const CalorieField({
    this.controller,
    this.initialValue,
    this.focusNode,
    this.hintText = '—',
    this.autoSize = false,
    this.dense = false,
    this.textAlign = TextAlign.start,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    super.key,
  });

  /// Controller for the text. Mutually exclusive with [initialValue].
  final TextEditingController? controller;

  /// Starting text when no [controller] is provided.
  final String? initialValue;

  /// Focus node for the field.
  final FocusNode? focusNode;

  /// Placeholder shown when the field is empty.
  final String hintText;

  /// Sizes the field to its content.
  final bool autoSize;

  /// Compact inline styling.
  final bool dense;

  /// How the text is aligned within the field.
  final TextAlign textAlign;

  /// Action button to show on the keyboard.
  final TextInputAction? textInputAction;

  /// Called with the parsed calories, or null when the field is empty.
  final ValueChanged<int?>? onChanged;

  /// Called with the parsed calories when the keyboard's submit action fires.
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
        LengthLimitingTextInputFormatter(4),
      ],
      suffixText: ' cal',
      onChanged: onChanged == null
          ? null
          : (value) => onChanged(int.tryParse(value)),
      onSubmitted: onSubmitted == null
          ? null
          : (value) => onSubmitted(int.tryParse(value)),
    );
  }
}
