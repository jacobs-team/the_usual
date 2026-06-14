import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template the_usual_text_field}
/// The app's standard text field. Outlined and comfortably padded by
/// default; pass [dense] for a compact inline field.
/// {@endtemplate}
class TheUsualTextField extends StatelessWidget {
  /// {@macro the_usual_text_field}
  const TheUsualTextField({
    this.controller,
    this.focusNode,
    this.initialValue,
    this.hintText,
    this.suffixText,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.textInputAction,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.width,
    this.autoSize = false,
    this.dense = false,
    super.key,
  }) : assert(
         width == null || !autoSize,
         'Provide either width or autoSize, not both.',
       );

  /// Controller for the text. Mutually exclusive with [initialValue].
  final TextEditingController? controller;

  /// Focus node for the field, e.g. to move focus between fields.
  final FocusNode? focusNode;

  /// Starting text when no [controller] is provided.
  final String? initialValue;

  /// Placeholder shown when the field is empty.
  final String? hintText;

  /// Trailing text inside the field, e.g. a unit.
  final String? suffixText;

  /// Trailing widget inside the field, e.g. a button or chips.
  final Widget? suffixIcon;

  /// Keyboard to show while editing.
  final TextInputType? keyboardType;

  /// Restrictions on what can be typed.
  final List<TextInputFormatter>? inputFormatters;

  /// How the text is aligned within the field.
  final TextAlign textAlign;

  /// Style for the entered text. Defaults to the field's theme style.
  final TextStyle? textStyle;

  /// Action button to show on the keyboard.
  final TextInputAction? textInputAction;

  /// Whether the field grabs focus when first shown.
  final bool autofocus;

  /// Called with the new text on every change.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the keyboard's submit action is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Fixed width for the field. Mutually exclusive with [autoSize].
  final double? width;

  /// Sizes the field to its content. Mutually exclusive with [width].
  final bool autoSize;

  /// Compact inline styling: tighter padding and no outline.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final field = TextFormField(
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      keyboardType: keyboardType,
      textAlign: textAlign,
      style: textStyle,
      autofocus: autofocus,
      textInputAction: textInputAction ?? TextInputAction.done,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        isDense: dense,
        border: dense ? null : const OutlineInputBorder(),
        contentPadding: dense
            ? EdgeInsets.symmetric(
                horizontal: AppDesign.spacing.sm,
                vertical: AppDesign.spacing.sm,
              )
            : null,
      ),
      onChanged: onChanged,
      onFieldSubmitted:
          onSubmitted ?? (_) => FocusManager.instance.primaryFocus?.unfocus(),
    );

    if (width != null) return SizedBox(width: width, child: field);
    if (autoSize) return IntrinsicWidth(child: field);
    return field;
  }
}
