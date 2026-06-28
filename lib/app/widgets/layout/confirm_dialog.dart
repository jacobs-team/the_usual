import 'package:flutter/material.dart';

/// {@template confirm_dialog}
/// A standard yes/no confirmation dialog for destructive actions. Shows a
/// [title], an explanatory [message], a cancel button, and a confirm button
/// that is styled as destructive when [isDestructive] is true.
///
/// Present it with [ConfirmDialog.show], which resolves to `true` when the user
/// confirms and `false` when they cancel or dismiss it.
/// {@endtemplate}
class ConfirmDialog extends StatelessWidget {
  /// {@macro confirm_dialog}
  const ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    super.key,
  });

  /// Heading shown at the top of the dialog.
  final String title;

  /// Explanatory text describing what confirming will do.
  final String message;

  /// Label for the button that confirms the action.
  final String confirmLabel;

  /// Label for the button that dismisses the dialog without confirming.
  final String cancelLabel;

  /// Whether the confirm button is styled to signal a destructive action.
  final bool isDestructive;

  /// Shows the dialog and resolves to `true` when the user confirms, `false`
  /// when they cancel or dismiss it.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          key: const Key('confirm-dialog-confirm'),
          onPressed: () => Navigator.of(context).pop(true),
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                )
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
