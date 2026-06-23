import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
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
    this.bodyWeight,
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

  /// The user's body weight already converted into [weightUnit], or null when
  /// no weight has been recorded.
  final double? bodyWeight;

  @override
  State<WorkoutEntrySheet> createState() => WorkoutEntrySheetState();
}

/// State for [WorkoutEntrySheet].
@visibleForTesting
class WorkoutEntrySheetState extends State<WorkoutEntrySheet> {
  late final _nameController = TextEditingController(
    text: widget.initialName ?? '',
  );
  late List<WorkoutSet> _currentSets =
      widget.initialSets ?? const [WorkoutSet()];
  var _saveAsUsual = false;
  var _bodyweightChecked = false;
  var _estimating = false;

  /// Name-suggestion chips shown below the name field after a photo scan.
  var _suggestions = const <String>[];

  /// Whether the AI photo-suggestion flow is running.
  var _suggesting = false;

  bool get _aiAvailable => getIt<WorkoutAiRepository>().isConfigured;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      _nameController.text.trim().isNotEmpty && !_estimating;

  /// Injects suggestions directly — used in widget tests to avoid the platform
  /// image-picker dialog.
  @visibleForTesting
  void applySuggestionsForTest(List<String> suggestions) {
    setState(() => _suggestions = suggestions);
  }

  Future<void> _pickPhotosAndSuggest() async {
    final photos = await pickMealPhotos(context);
    if (photos.isEmpty) return;
    if (!mounted) return;
    setState(() => _suggesting = true);
    try {
      final names = await getIt<WorkoutAiRepository>().suggestNamesFromPhoto(
        photos,
      );
      if (!mounted) return;
      setState(() {
        _suggestions = names;
        _suggesting = false;
      });
    } on Exception catch (_) {
      if (!mounted) return;
      setState(() => _suggesting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read the photo. Try again.')),
      );
    }
  }

  void _applyChip(String name) {
    _nameController.text = name;
    setState(() => _suggestions = const []);
  }

  Future<void> _confirm() async {
    final name = _nameController.text.trim();
    var sets = _currentSets;

    if (_bodyweightChecked &&
        widget.bodyWeight != null &&
        _aiAvailable) {
      setState(() => _estimating = true);
      try {
        final estimate = await getIt<WorkoutAiRepository>()
            .estimateBodyweightLoad(
              exerciseName: name,
              bodyWeight: widget.bodyWeight!,
              unit: widget.weightUnit,
            );
        if (!mounted) return;
        if (estimate != null) {
          sets = [
            for (final workoutSet in sets)
              if (workoutSet.weightAutoEstimated && workoutSet.weight == null)
                workoutSet.copyWith(
                  weight: estimate,
                  weightAutoEstimated: true,
                )
              else
                workoutSet,
          ];
        }
      } finally {
        if (mounted) setState(() => _estimating = false);
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop((
      name: name,
      sets: sets,
      addToUsuals: _saveAsUsual,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final aiButtonStyle = FilledButton.styleFrom(
      visualDensity: VisualDensity.compact,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.symmetric(
        horizontal: AppDesign.spacing.md,
        vertical: AppDesign.spacing.sm,
      ),
    );

    return TheUsualBottomSheet(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TheUsualTextField(
                  controller: _nameController,
                  autofocus: true,
                  hintText: 'e.g. Bench Press',
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (_aiAvailable) ...[
                SizedBox(width: AppDesign.spacing.sm),
                FilledButton.tonalIcon(
                  style: aiButtonStyle,
                  onPressed: _suggesting ? null : _pickPhotosAndSuggest,
                  icon: const Icon(
                    Icons.photo_camera_outlined,
                    size: 18,
                  ),
                  label: const Text('Photo'),
                ),
              ],
            ],
          ),
          if (_suggesting) ...[
            SizedBox(height: AppDesign.spacing.sm),
            Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: AppDesign.spacing.sm),
                Text('Finding exercises…', style: textTheme.bodySmall),
              ],
            ),
          ],
          if (_suggestions.isNotEmpty) ...[
            SizedBox(height: AppDesign.spacing.sm),
            Wrap(
              spacing: AppDesign.spacing.sm,
              runSpacing: AppDesign.spacing.xs,
              children: [
                for (final suggestion in _suggestions)
                  ActionChip(
                    label: Text(suggestion),
                    onPressed: () => _applyChip(suggestion),
                  ),
              ],
            ),
          ],
          SizedBox(height: AppDesign.spacing.md),
          const SectionLabel('SETS'),
          SetFields(
            initial: _currentSets,
            weightUnit: widget.weightUnit,
            bodyweight: _bodyweightChecked,
            onChanged: (sets) => setState(() => _currentSets = sets),
          ),
          SizedBox(height: AppDesign.spacing.sm),
          Row(
            children: [
              Checkbox(
                key: const Key('bodyweight-checkbox'),
                value: _bodyweightChecked,
                onChanged: (_) {
                  if (widget.bodyWeight == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Add your body weight to estimate bodyweight sets. '
                          'Log it on the Today view or set a starting weight '
                          'in Settings.',
                        ),
                      ),
                    );
                    return;
                  }
                  setState(() => _bodyweightChecked = !_bodyweightChecked);
                },
              ),
              const Text('Bodyweight'),
            ],
          ),
          if (widget.showAddToUsuals) ...[
            Row(
              children: [
                Checkbox(
                  key: const Key('save-as-usual-checkbox'),
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
            key: const Key('confirm-button'),
            onPressed: _canConfirm ? _confirm : null,
            child: Text(widget.confirmLabel),
          ),
        ],
      ),
    );
  }
}
