import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The value [WorkoutEntrySheet] pops when the user confirms: the exercise
/// name, the sets, and whether to save this exercise as a usual.
typedef WorkoutEntryResult = ({
  String name,
  List<WorkoutSet> sets,
  bool addToUsuals,
});

/// {@template workout_entry_sheet}
/// Bottom sheet for capturing a single exercise: a name field, set editor, and
/// an optional "Save as usual" checkbox. Pops with a [WorkoutEntryResult] on
/// confirm, or null when cancelled.
/// {@endtemplate}
class WorkoutEntrySheet extends StatefulWidget {
  /// {@macro workout_entry_sheet}
  const WorkoutEntrySheet({
    required this.title,
    required this.confirmLabel,
    required this.weightUnit,
    this.showAddToUsuals = false,
    this.initialName,
    this.initialSets,
    super.key,
  });

  /// Heading shown at the top of the sheet.
  final String title;

  /// Label for the confirm button.
  final String confirmLabel;

  /// The weight unit shown in set fields.
  final WeightUnit weightUnit;

  /// Whether to show the "Save as usual" checkbox.
  final bool showAddToUsuals;

  /// The exercise name to pre-fill.
  final String? initialName;

  /// The sets to pre-fill. Defaults to a single empty set.
  final List<WorkoutSet>? initialSets;

  @override
  State<WorkoutEntrySheet> createState() => _WorkoutEntrySheetState();
}

class _WorkoutEntrySheetState extends State<WorkoutEntrySheet> {
  late final _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late List<WorkoutSet> _currentSets =
      widget.initialSets ?? const [WorkoutSet()];
  var _saveAsUsual = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canConfirm => _nameController.text.trim().isNotEmpty;

  void _confirm() {
    Navigator.of(context).pop((
      name: _nameController.text.trim(),
      sets: _currentSets,
      addToUsuals: _saveAsUsual,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return TheUsualBottomSheet(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TheUsualTextField(
            controller: _nameController,
            autofocus: true,
            hintText: 'e.g. Bench Press',
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppDesign.spacing.md),
          const SectionLabel('SETS'),
          SetFields(
            initial: _currentSets,
            weightUnit: widget.weightUnit,
            onChanged: (sets) => setState(() => _currentSets = sets),
          ),
          if (widget.showAddToUsuals) ...[
            SizedBox(height: AppDesign.spacing.sm),
            Row(
              children: [
                Checkbox(
                  value: _saveAsUsual,
                  onChanged: (value) =>
                      setState(() => _saveAsUsual = value ?? false),
                ),
                const Text('Save as usual'),
              ],
            ),
          ],
          SizedBox(height: AppDesign.spacing.md),
          FilledButton(
            onPressed: _canConfirm ? _confirm : null,
            child: Text(widget.confirmLabel),
          ),
        ],
      ),
    );
  }
}
