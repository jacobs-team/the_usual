import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_usual/app/app.dart';

/// {@template food_entry_sheet}
/// Bottom sheet capturing a food name plus optional calories, used both for
/// adding a usual meal and logging a one-off. Pops with a
/// ([String], [int]?, [bool]) record of name, calories, and whether to add it
/// to the usual meals, or null when cancelled.
/// {@endtemplate}
class FoodEntrySheet extends StatefulWidget {
  /// {@macro food_entry_sheet}
  const FoodEntrySheet({
    required this.title,
    required this.confirmLabel,
    this.showAddToUsualMeals = false,
    super.key,
  });

  /// Heading shown at the top of the sheet.
  final String title;

  /// Label for the confirm button.
  final String confirmLabel;

  /// Whether to show the "Add to usual meals" checkbox, checked by default.
  final bool showAddToUsualMeals;

  @override
  State<FoodEntrySheet> createState() => _FoodEntrySheetState();
}

class _FoodEntrySheetState extends State<FoodEntrySheet> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  bool _addToUsualMeals = true;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 18,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: textTheme.titleMedium),
            const SizedBox(height: 14),
            const SectionLabel('NAME'),
            const SizedBox(height: 6),
            TheUsualTextField(
              controller: _nameController,
              autofocus: true,
              hintText: 'e.g. Chicken caesar salad',
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            const SectionLabel('CALORIES · OPTIONAL'),
            const SizedBox(height: 6),
            TheUsualTextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              hintText: 'Leave blank to skip',
              suffixText: ' cal',
            ),
            if (widget.showAddToUsualMeals)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Add to usual meals'),
                value: _addToUsualMeals,
                onChanged: (value) =>
                    setState(() => _addToUsualMeals = value ?? false),
              ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _nameController.text.trim().isEmpty
                        ? null
                        : () => Navigator.of(context).pop((
                            _nameController.text,
                            int.tryParse(_caloriesController.text),
                            _addToUsualMeals,
                          )),
                    child: Text(widget.confirmLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
