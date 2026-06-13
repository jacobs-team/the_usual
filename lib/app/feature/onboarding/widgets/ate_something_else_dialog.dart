import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';

/// {@template ate_something_else_dialog}
/// Dialog asking the user what they ate when it isn't one of their usuals.
/// Pops with the entered name, or null when cancelled.
/// {@endtemplate}
class AteSomethingElseDialog extends StatefulWidget {
  /// {@macro ate_something_else_dialog}
  const AteSomethingElseDialog({super.key});

  @override
  State<AteSomethingElseDialog> createState() => _AteSomethingElseDialogState();
}

class _AteSomethingElseDialogState extends State<AteSomethingElseDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('What did you eat?'),
      content: TheUsualTextField(
        controller: _controller,
        autofocus: true,
        hintText: 'e.g. Ramen',
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Add'),
        ),
      ],
    );
  }
}
