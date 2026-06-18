import 'package:flutter/material.dart';
import 'package:the_usual/app/widgets/inputs/food_entry_form.dart';
import 'package:the_usual/app/widgets/layout/the_usual_bottom_sheet.dart';

/// {@template food_entry_sheet}
/// Bottom sheet for capturing what the user ate, by hand or with AI assistance.
/// Wraps a [FoodEntryForm] with a heading and a confirm button; pops with the
/// list of [FoodEntryResult]s to log, or null when cancelled.
/// {@endtemplate}
class FoodEntrySheet extends StatefulWidget {
  /// {@macro food_entry_sheet}
  const FoodEntrySheet({
    required this.title,
    required this.confirmLabel,
    this.showAddToUsualMeals = false,
    this.showQuantity = true,
    super.key,
  });

  /// Heading shown at the top of the sheet.
  final String title;

  /// Label for the confirm button.
  final String confirmLabel;

  /// Whether to show the "Add to usual meals" option, checked by default.
  final bool showAddToUsualMeals;

  /// Whether to show the quantity stepper. When false the quantity is always 1.
  final bool showQuantity;

  @override
  State<FoodEntrySheet> createState() => _FoodEntrySheetState();
}

class _FoodEntrySheetState extends State<FoodEntrySheet> {
  final _formKey = GlobalKey<FoodEntryFormState>();

  void _confirm() {
    final results = _formKey.currentState?.results ?? const [];
    if (results.isEmpty) return;
    Navigator.of(context).pop(results);
  }

  @override
  Widget build(BuildContext context) {
    final form = _formKey.currentState;
    final canConfirm = form != null && !form.isGenerating && form.hasContent;
    return TheUsualBottomSheet(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FoodEntryForm(
            key: _formKey,
            showQuantity: widget.showQuantity,
            showAddToUsualMeals: widget.showAddToUsualMeals,
            onChanged: () => setState(() {}),
          ),
          FilledButton(
            onPressed: canConfirm ? _confirm : null,
            child: Text(widget.confirmLabel),
          ),
        ],
      ),
    );
  }
}
