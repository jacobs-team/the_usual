import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The value [WorkoutEntrySheet] pops when the user confirms: the exercise
/// name, its type, the sets (for strength) or duration (for cardio), and
/// whether to save this exercise as a usual.
typedef WorkoutEntryResult = ({
  String name,
  WorkoutType type,
  List<WorkoutSet> sets,
  Duration? duration,
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
    this.initialType = WorkoutType.strength,
    this.initialSets,
    this.initialDuration,
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

  /// The exercise type to pre-select.
  final WorkoutType initialType;

  /// The sets to pre-fill for a strength exercise. Defaults to a single empty
  /// set.
  final List<WorkoutSet>? initialSets;

  /// The duration to pre-fill for a cardio exercise.
  final Duration? initialDuration;

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
  late WorkoutType _type = widget.initialType;
  late List<WorkoutSet> _currentSets =
      widget.initialSets ?? const [WorkoutSet()];
  late Duration _duration = widget.initialDuration ?? Duration.zero;
  late bool _saveAsUsual = getIt<UserSettingsBloc>().state.saveWorkoutAsUsual;
  var _bodyweightChecked = false;
  var _estimating = false;
  var _bodyweightHintShown = false;

  // Photo name-suggestion flow disabled — kept commented for easy restore.
  // /// Name-suggestion chips shown below the name field after a photo scan.
  // var _suggestions = const <String>[];
  //
  // /// Whether the AI photo-suggestion flow is running.
  // var _suggesting = false;

  bool get _aiAvailable => getIt<WorkoutAiRepository>().isConfigured;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canConfirm =>
      _nameController.text.trim().isNotEmpty && !_estimating;

  void _setSaveAsUsual(bool saveAsUsual) {
    setState(() => _saveAsUsual = saveAsUsual);
    getIt<UserSettingsBloc>().add(
      UserSettingsEvent.saveWorkoutAsUsualChanged(value: saveAsUsual),
    );
  }

  // Photo name-suggestion flow disabled — kept commented for easy restore.
  // /// Injects suggestions directly — used in widget tests to avoid the
  // /// platform image-picker dialog.
  // @visibleForTesting
  // void applySuggestionsForTest(List<String> suggestions) {
  //   setState(() => _suggestions = suggestions);
  // }
  //
  // Future<void> _pickPhotosAndSuggest() async {
  //   final photos = await pickMealPhotos(context);
  //   if (photos.isEmpty) return;
  //   if (!mounted) return;
  //   setState(() => _suggesting = true);
  //   try {
  //     final names = await getIt<WorkoutAiRepository>().suggestNamesFromPhoto(
  //       photos,
  //     );
  //     if (!mounted) return;
  //     setState(() {
  //       _suggestions = names;
  //       _suggesting = false;
  //     });
  //   } on Exception catch (_) {
  //     if (!mounted) return;
  //     setState(() => _suggesting = false);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Could not read the photo. Try again.')
  // ),
  //     );
  //   }
  // }
  //
  // void _applyChip(String name) {
  //   _nameController.text = name;
  //   setState(() => _suggestions = const []);
  // }

  Future<void> _confirm() async {
    final name = _nameController.text.trim();

    if (_type == WorkoutType.cardio) {
      Navigator.of(context).pop((
        name: name,
        type: WorkoutType.cardio,
        sets: const <WorkoutSet>[],
        duration: _duration,
        addToUsuals: _saveAsUsual,
      ));
      return;
    }

    var sets = _currentSets;

    if (_bodyweightChecked && widget.bodyWeight != null && _aiAvailable) {
      final messenger = ScaffoldMessenger.of(context);
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
          // The bodyweight checkbox is the source of truth: every set the user
          // left without a manual weight gets the estimate. The per-set
          // weightAutoEstimated flag only reflects the checkbox state at the
          // last field edit, so relying on it misses sets entered before the
          // box was ticked.
          sets = [
            for (final workoutSet in sets)
              if (workoutSet.weight == null)
                workoutSet.copyWith(
                  weight: estimate,
                  weightAutoEstimated: true,
                )
              else
                workoutSet,
          ];
        }
      } on Object catch (error, stackTrace) {
        // A failed estimate must not drop the user's confirm: log the exercise
        // with the sets as entered and tell them the estimate was skipped.
        log(
          'Bodyweight load estimate failed',
          name: 'WorkoutEntrySheet',
          error: error,
          stackTrace: stackTrace,
        );
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Could not estimate set weight. Logged without it.'),
          ),
        );
      } finally {
        if (mounted) setState(() => _estimating = false);
      }
    }

    if (!mounted) return;
    Navigator.of(context).pop((
      name: name,
      type: WorkoutType.strength,
      sets: sets,
      duration: null,
      addToUsuals: _saveAsUsual,
    ));
  }

  @override
  Widget build(BuildContext context) {
    // Photo name-suggestion flow disabled — kept commented for easy restore.
    // final textTheme = Theme.of(context).textTheme;
    // final aiButtonStyle = FilledButton.styleFrom(
    //   visualDensity: VisualDensity.compact,
    //   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //   padding: EdgeInsets.symmetric(
    //     horizontal: AppDesign.spacing.md,
    //     vertical: AppDesign.spacing.sm,
    //   ),
    // );

    return TheUsualBottomSheet(
      title: widget.title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(AppDesign.spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TheUsualTextField(
                    controller: _nameController,
                    autofocus: true,
                    hintText: _type == WorkoutType.cardio
                        ? 'e.g. Running'
                        : 'e.g. Bench Press',
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                  ),
                  SizedBox(height: AppDesign.spacing.md),
                  SegmentedButton<WorkoutType>(
                    key: const Key('workout-type-selector'),
                    showSelectedIcon: false,
                    segments: [
                      for (final workoutType in WorkoutType.values)
                        ButtonSegment(
                          value: workoutType,
                          label: Text(workoutType.label),
                        ),
                    ],
                    selected: {_type},
                    onSelectionChanged: (selection) =>
                        setState(() => _type = selection.first),
                  ),
                  // Photo name-suggestion flow disabled — kept commented for
                  // easy restore.
                  // if (_suggesting) ...[
                  //   SizedBox(height: AppDesign.spacing.sm),
                  //   Row(
                  //     children: [
                  //       const SizedBox(
                  //         width: 16,
                  //         height: 16,
                  //         child: CircularProgressIndicator(strokeWidth: 2),
                  //       ),
                  //       SizedBox(width: AppDesign.spacing.sm),
                  //       Text('Finding exercises…', style: textTheme.bodySmall
                  // ),
                  //     ],
                  //   ),
                  // ],
                  // if (_suggestions.isNotEmpty) ...[
                  //   SizedBox(height: AppDesign.spacing.sm),
                  //   Wrap(
                  //     spacing: AppDesign.spacing.sm,
                  //     runSpacing: AppDesign.spacing.xs,
                  //     children: [
                  //       for (final suggestion in _suggestions)
                  //         ActionChip(
                  //           label: Text(suggestion),
                  //           onPressed: () => _applyChip(suggestion),
                  //         ),
                  //     ],
                  //   ),
                  // ],
                  SizedBox(height: AppDesign.spacing.md),
                  if (_type == WorkoutType.strength) ...[
                    const SectionLabel('SETS'),
                    SetFields(
                      initial: _currentSets,
                      weightUnit: widget.weightUnit,
                      bodyweight: _bodyweightChecked,
                      onChanged: (sets) => setState(() => _currentSets = sets),
                    ),
                    SizedBox(height: AppDesign.spacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          key: const Key('bodyweight-checkbox'),
                          visualDensity: VisualDensity.compact,
                          value: _bodyweightChecked,
                          onChanged: (_) {
                            if (widget.bodyWeight == null) {
                              setState(() => _bodyweightHintShown = true);
                              return;
                            }
                            setState(
                              () => _bodyweightChecked = !_bodyweightChecked,
                            );
                          },
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estimate set weight based on body weight',
                              ),
                              Text(
                                'e.g. push-ups, pull-ups',
                                key: const Key('bodyweight-help'),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              if (_bodyweightHintShown &&
                                  widget.bodyWeight == null)
                                Text(
                                  'Add your body weight to estimate bodyweight '
                                  'sets. Log it on the Today view or set a '
                                  'starting weight in Settings.',
                                  key: const Key('bodyweight-hint'),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SectionLabel('TIME'),
                    SizedBox(height: AppDesign.spacing.sm),
                    TimeField(
                      initial: _duration,
                      onChanged: (duration) =>
                          setState(() => _duration = duration),
                    ),
                  ],
                  if (widget.showAddToUsuals) ...[
                    Row(
                      children: [
                        Checkbox(
                          key: const Key('save-as-usual-checkbox'),
                          visualDensity: VisualDensity.compact,
                          value: _saveAsUsual,
                          onChanged: (value) => _setSaveAsUsual(value ?? false),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _setSaveAsUsual(!_saveAsUsual),
                          child: const Text('Save as usual'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
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
