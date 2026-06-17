import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// One food the user confirmed in the [FoodEntrySheet]: its name, nutrition,
/// quantity, and whether to also save it to the usual meals. One-off data
/// handed back to the caller to log, so it needs no model of its own.
typedef FoodEntryResult = ({
  String name,
  Nutrition nutrition,
  int quantity,
  bool addToUsualMeals,
});

/// {@template food_entry_sheet}
/// Bottom sheet for capturing what the user ate, by hand or with AI assistance.
///
/// The sheet is always a list of food rows: one for a simple entry, more when
/// the user itemizes or adds them. The [MealEntryMode] toggle only changes what
/// the AI returns — one combined item ([MealEntryMode.wholeMeal]) or one per
/// food ([MealEntryMode.itemized]) — not the layout. It starts from the user's
/// remembered preference and updates it when changed. Pops with the list of
/// [FoodEntryResult]s to log, or null when cancelled.
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
  /// The foods being captured. Always at least one row.
  final List<_FoodDraft> _drafts = [];

  late MealEntryMode _mode;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _mode = getIt<UserSettingsBloc>().state.mealEntryMode;
    _drafts.add(_FoodDraft(addToUsualMeals: true));
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  /// Whether AI assistance is available (an API key is configured).
  bool get _aiAvailable => getIt<MealAiRepository>().isConfigured;

  bool get _canConfirm =>
      !_isGenerating &&
      _drafts.any((draft) => draft.nameController.text.trim().isNotEmpty);

  /// Switches the AI mode and remembers it as the user's new default.
  void _setMode(MealEntryMode mode) {
    if (mode == _mode) return;
    getIt<UserSettingsBloc>().add(
      UserSettingsEvent.mealEntryModeChanged(mode),
    );
    setState(() => _mode = mode);
  }

  void _addDraft() {
    setState(() => _drafts.add(_FoodDraft(addToUsualMeals: true)));
  }

  void _removeDraft(_FoodDraft draft) {
    setState(() {
      draft.dispose();
      _drafts.remove(draft);
      if (_drafts.isEmpty) _drafts.add(_FoodDraft(addToUsualMeals: true));
    });
  }

  /// Estimates the food from the first row's name, used as the description.
  /// In whole-meal mode that typed name is kept as written.
  Future<void> _estimateWithAi() async {
    final messenger = ScaffoldMessenger.of(context);
    final description = _drafts.first.nameController.text.trim();
    if (description.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Type a meal name or description first.')),
      );
      return;
    }
    await _runEstimate(
      messenger,
      () => getIt<MealAiRepository>().suggestFromDescription(
        description,
        mode: _mode,
      ),
      keepFirstName: _mode == MealEntryMode.wholeMeal ? description : null,
    );
  }

  /// Snaps or picks a photo and estimates the food from it.
  Future<void> _photoWithAi() async {
    final messenger = ScaffoldMessenger.of(context);
    final photo = await pickMealPhoto(context);
    if (photo == null) return;
    await _runEstimate(
      messenger,
      () => getIt<MealAiRepository>().suggestFromPhoto(
        photo.bytes,
        mode: _mode,
        imageMediaType: photo.mediaType,
      ),
    );
  }

  /// Runs [request] and replaces the rows with the estimate for the user to
  /// review, surfacing any failure. When [keepFirstName] is set the first row's
  /// name is kept instead of the model's, so a typed description stays as the
  /// user wrote it.
  Future<void> _runEstimate(
    ScaffoldMessengerState messenger,
    Future<List<AiMealSuggestion>> Function() request, {
    String? keepFirstName,
  }) async {
    setState(() => _isGenerating = true);
    try {
      final suggestions = await request();
      if (!mounted || suggestions.isEmpty) return;
      setState(() {
        for (final draft in _drafts) {
          draft.dispose();
        }
        _drafts
          ..clear()
          ..addAll([
            for (final (index, suggestion) in suggestions.indexed)
              _FoodDraft(
                name: index == 0 && keepFirstName != null
                    ? keepFirstName
                    : suggestion.name,
                quantity: suggestion.quantity,
                nutrition: suggestion.nutrition,
                addToUsualMeals: true,
              ),
          ]);
      });
    } on Object catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not estimate nutrition: $error')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _confirm() {
    final results = <FoodEntryResult>[
      for (final draft in _drafts)
        if (draft.nameController.text.trim().isNotEmpty)
          (
            name: draft.nameController.text.trim(),
            nutrition: draft.nutrition,
            quantity: draft.quantity,
            addToUsualMeals:
                widget.showAddToUsualMeals && draft.addToUsualMeals,
          ),
    ];
    if (results.isEmpty) return;
    Navigator.of(context).pop(results);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Lift the sheet above the keyboard, then keep the content clear of the
    // home indicator with SafeArea. The status bar is handled by the route's
    // useSafeArea, which strips the top padding here.
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDesign.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(widget.title, style: textTheme.titleMedium),
                  ),
                  if (_aiAvailable) ...[
                    Text('How should we log it?', style: textTheme.bodySmall),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => const _MealEntryModeInfoDialog(),
                      ),
                      icon: const Icon(Icons.info_outline, size: 18),
                      tooltip: 'How logging modes work',
                    ),
                  ],
                ],
              ),
              if (_aiAvailable) ...[
                SizedBox(height: AppDesign.spacing.md),
                SegmentedButton<MealEntryMode>(
                  showSelectedIcon: false,
                  segments: [
                    for (final mode in MealEntryMode.values)
                      ButtonSegment(value: mode, label: Text(mode.label)),
                  ],
                  selected: {_mode},
                  onSelectionChanged: _isGenerating
                      ? null
                      : (selection) => _setMode(selection.first),
                ),
                SizedBox(height: AppDesign.spacing.sm),
                Text(_mode.summary, style: textTheme.bodySmall),
                SizedBox(height: AppDesign.spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _isGenerating ? null : _estimateWithAi,
                        icon: const Icon(Icons.auto_awesome_outlined),
                        label: const Text('Estimate'),
                      ),
                    ),
                    SizedBox(width: AppDesign.spacing.sm),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: _isGenerating ? null : _photoWithAi,
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: const Text('Photo'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDesign.spacing.sm),
                if (_isGenerating)
                  Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: AppDesign.spacing.sm),
                      Text('Estimating…', style: textTheme.bodySmall),
                    ],
                  )
                else
                  Text(
                    'Type a name and tap Estimate, or snap a photo.',
                    style: textTheme.bodySmall,
                  ),
              ],
              SizedBox(height: AppDesign.spacing.md),
              for (var index = 0; index < _drafts.length; index++) ...[
                if (index > 0) SizedBox(height: AppDesign.spacing.md),
                _FoodItemRow(
                  key: ObjectKey(_drafts[index]),
                  draft: _drafts[index],
                  autofocus: index == 0,
                  showQuantity: widget.showQuantity,
                  showAddToUsualMeals: widget.showAddToUsualMeals,
                  canRemove: _drafts.length > 1,
                  onChanged: () => setState(() {}),
                  onRemove: () => _removeDraft(_drafts[index]),
                ),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _addDraft,
                  icon: const Icon(Icons.add),
                  label: const Text('Add item'),
                ),
              ),
              SizedBox(height: AppDesign.spacing.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: AppDesign.spacing.sm),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _canConfirm ? _confirm : null,
                      child: Text(widget.confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explains how each [MealEntryMode] turns a meal into log entries, so the
/// user understands that the toggle changes the AI's output.
class _MealEntryModeInfoDialog extends StatelessWidget {
  const _MealEntryModeInfoDialog();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: const Text('How should we log it?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final mode in MealEntryMode.values) ...[
            if (mode != MealEntryMode.values.first)
              SizedBox(height: AppDesign.spacing.md),
            Text(mode.label, style: textTheme.titleSmall),
            SizedBox(height: AppDesign.spacing.xs),
            Text(mode.detail, style: textTheme.bodyMedium),
          ],
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

/// The mutable state of one food being captured: its name field plus the
/// nutrition, quantity, and add-to-usuals choice. Owned by the sheet, which
/// disposes it.
class _FoodDraft {
  _FoodDraft({
    String name = '',
    this.quantity = 1,
    this.nutrition = const Nutrition(),
    this.addToUsualMeals = false,
  }) : nameController = TextEditingController(text: name);

  final TextEditingController nameController;
  int quantity;
  Nutrition nutrition;
  bool addToUsualMeals;

  void dispose() => nameController.dispose();
}

/// One editable food row: name, optional quantity, nutrition, and an optional
/// add-to-usuals toggle, with a remove control shown when more than one row is
/// present.
class _FoodItemRow extends StatelessWidget {
  const _FoodItemRow({
    required this.draft,
    required this.autofocus,
    required this.showQuantity,
    required this.showAddToUsualMeals,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final _FoodDraft draft;
  final bool autofocus;
  final bool showQuantity;
  final bool showAddToUsualMeals;
  final bool canRemove;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // A tinted, elevated card (the app's themed Card) with white field fills so
    // the inputs read clearly against it.
    return Card(
      color: colorScheme.surfaceContainer,
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            fillColor: colorScheme.surfaceContainerLowest,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDesign.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TheUsualTextField(
                      controller: draft.nameController,
                      autofocus: autofocus,
                      hintText: 'e.g. Chicken caesar salad',
                      onChanged: (_) => onChanged(),
                    ),
                  ),
                  if (canRemove)
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(Icons.close),
                      tooltip: 'Remove',
                    ),
                ],
              ),
              SizedBox(height: AppDesign.spacing.md),
              NutritionFields(
                dense: true,
                initial: draft.nutrition,
                onChanged: (nutrition) => draft.nutrition = nutrition,
              ),
              if (showQuantity || showAddToUsualMeals) ...[
                SizedBox(height: AppDesign.spacing.md),
                Row(
                  children: [
                    if (showQuantity)
                      QuantityStepper(
                        dense: true,
                        quantity: draft.quantity,
                        onChanged: (quantity) {
                          draft.quantity = quantity;
                          onChanged();
                        },
                      ),
                    const Spacer(),
                    if (showAddToUsualMeals)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            visualDensity: VisualDensity.compact,
                            value: draft.addToUsualMeals,
                            onChanged: (value) {
                              draft.addToUsualMeals = value ?? false;
                              onChanged();
                            },
                          ),
                          const Text('Save as usual'),
                        ],
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
