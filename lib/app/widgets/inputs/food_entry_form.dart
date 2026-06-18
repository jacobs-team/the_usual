import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';

/// One food the user confirmed in a [FoodEntryForm]: its name, nutrition,
/// quantity, and whether to also save it to the usual meals. One-off data
/// handed back to the caller to log, so it needs no model of its own.
typedef FoodEntryResult = ({
  String name,
  Nutrition nutrition,
  double quantity,
  bool addToUsualMeals,
});

/// {@template food_entry_form}
/// The editable body shared by every "capture what you ate" surface: an
/// optional AI assist row (estimate from a description, estimate from a photo,
/// and the itemize toggle) above a list of food rows, each a name with its
/// nutrition fields and optional quantity. Hosted inside [FoodEntrySheet] as a
/// bottom sheet and inline in onboarding's build-usuals step.
///
/// The form owns its rows; read the current entries through
/// [FoodEntryFormState.results] from a [GlobalKey]. [onChanged] fires whenever
/// the rows or generating state change so the host can re-evaluate its own
/// controls.
/// {@endtemplate}
class FoodEntryForm extends StatefulWidget {
  /// {@macro food_entry_form}
  const FoodEntryForm({
    this.initialFoods,
    this.showQuantity = true,
    this.showAddToUsualMeals = false,
    this.autofocusFirst = true,
    this.onChanged,
    super.key,
  });

  /// Foods to seed the rows with. When null or empty the form starts with a
  /// single empty row.
  final List<FoodEntryResult>? initialFoods;

  /// Whether to show the quantity stepper. When false the quantity is always 1.
  final bool showQuantity;

  /// Whether to show the "Save as usual" option per row.
  final bool showAddToUsualMeals;

  /// Whether the first row grabs focus when first shown.
  final bool autofocusFirst;

  /// Called whenever the rows or the generating state change.
  final VoidCallback? onChanged;

  @override
  State<FoodEntryForm> createState() => FoodEntryFormState();
}

/// State for [FoodEntryForm]. Exposes [results] and [hasContent] so a host
/// widget can read the entries and gate its confirm action.
class FoodEntryFormState extends State<FoodEntryForm> {
  /// The foods being captured. Always at least one row.
  final List<_FoodDraft> _drafts = [];

  late MealEntryMode _mode;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _mode = getIt<UserSettingsBloc>().state.mealEntryMode;
    final initialFoods = widget.initialFoods;
    if (initialFoods == null || initialFoods.isEmpty) {
      _drafts.add(_FoodDraft(addToUsualMeals: widget.showAddToUsualMeals));
    } else {
      for (final food in initialFoods) {
        _drafts.add(
          _FoodDraft(
            name: food.name,
            quantity: food.quantity,
            nutrition: food.nutrition,
            addToUsualMeals: food.addToUsualMeals,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final draft in _drafts) {
      draft.dispose();
    }
    super.dispose();
  }

  /// The non-empty rows as results for the host to log or save.
  List<FoodEntryResult> get results => [
    for (final draft in _drafts)
      if (draft.nameController.text.trim().isNotEmpty)
        (
          name: draft.nameController.text.trim(),
          nutrition: draft.nutrition,
          quantity: draft.quantity,
          addToUsualMeals: widget.showAddToUsualMeals && draft.addToUsualMeals,
        ),
  ];

  /// Whether any row has a name entered.
  bool get hasContent =>
      _drafts.any((draft) => draft.nameController.text.trim().isNotEmpty);

  /// Whether an AI estimate is currently running.
  bool get isGenerating => _isGenerating;

  /// Whether AI assistance is available (an API key is configured).
  bool get _aiAvailable => getIt<MealAiRepository>().isConfigured;

  void _notify() => widget.onChanged?.call();

  /// Switches the AI mode and remembers it as the user's new default.
  void _setMode(MealEntryMode mode) {
    if (mode == _mode) return;
    getIt<UserSettingsBloc>().add(
      UserSettingsEvent.mealEntryModeChanged(mode),
    );
    setState(() => _mode = mode);
  }

  void _addDraft() {
    setState(() {
      _drafts.add(_FoodDraft(addToUsualMeals: widget.showAddToUsualMeals));
    });
    _notify();
  }

  void _removeDraft(_FoodDraft draft) {
    setState(() {
      draft.dispose();
      _drafts.remove(draft);
      if (_drafts.isEmpty) {
        _drafts.add(_FoodDraft(addToUsualMeals: widget.showAddToUsualMeals));
      }
    });
    _notify();
  }

  /// Estimates nutrition with the AI. A single filled row is treated as a
  /// description the AI may split per the selected [MealEntryMode]; several
  /// filled rows are already itemized by the user, so each row is estimated on
  /// its own and filled in place, keeping every row and its name.
  Future<void> _estimateWithAi() async {
    final messenger = ScaffoldMessenger.of(context);
    final namedDrafts = _drafts
        .where((draft) => draft.nameController.text.trim().isNotEmpty)
        .toList();
    if (namedDrafts.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Type a meal name or description first.')),
      );
      return;
    }
    if (namedDrafts.length == 1) {
      final description = namedDrafts.first.nameController.text.trim();
      await _runEstimate(
        messenger,
        () => getIt<MealAiRepository>().suggestFromDescription(
          description,
          mode: _mode,
        ),
        keepFirstName: _mode == MealEntryMode.wholeMeal ? description : null,
      );
      return;
    }
    await _estimateEachRow(messenger, namedDrafts);
  }

  /// Estimates each of [namedDrafts] as its own single item, in parallel, and
  /// rebuilds those rows with the estimated nutrition and quantity while
  /// keeping their names. Rows are kept, so estimating never discards the items
  /// the user already entered. Empty rows are left untouched.
  Future<void> _estimateEachRow(
    ScaffoldMessengerState messenger,
    List<_FoodDraft> namedDrafts,
  ) async {
    final repository = getIt<MealAiRepository>();
    setState(() => _isGenerating = true);
    _notify();
    try {
      final estimates = await Future.wait([
        for (final draft in namedDrafts)
          repository.suggestFromDescription(
            draft.nameController.text.trim(),
            mode: MealEntryMode.wholeMeal,
          ),
      ]);
      if (!mounted) return;
      final estimateByDraft = <_FoodDraft, AiMealSuggestion>{};
      for (final (index, draft) in namedDrafts.indexed) {
        final suggestions = estimates[index];
        if (suggestions.isNotEmpty) estimateByDraft[draft] = suggestions.first;
      }
      setState(() {
        final rebuiltDrafts = <_FoodDraft>[];
        for (final draft in _drafts) {
          final estimate = estimateByDraft[draft];
          if (estimate == null) {
            rebuiltDrafts.add(draft);
            continue;
          }
          rebuiltDrafts.add(
            _FoodDraft(
              name: draft.nameController.text,
              quantity: estimate.quantity,
              nutrition: estimate.nutrition,
              addToUsualMeals: draft.addToUsualMeals,
            ),
          );
          draft.dispose();
        }
        _drafts
          ..clear()
          ..addAll(rebuiltDrafts);
      });
    } on Object catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not estimate nutrition: $error')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
      _notify();
    }
  }

  /// Snaps or picks a photo and estimates the food from it. Any name the user
  /// already typed is sent with the photo to sharpen the estimate, and is kept
  /// instead of the model's name in whole-meal mode, so a typed description
  /// stays as the user wrote it. With no name typed, the model names the food.
  Future<void> _photoWithAi() async {
    final messenger = ScaffoldMessenger.of(context);
    final photo = await pickMealPhoto(context);
    if (photo == null) return;
    final description = _drafts.first.nameController.text.trim();
    final hasDescription = description.isNotEmpty;
    await _runEstimate(
      messenger,
      () => getIt<MealAiRepository>().suggestFromPhoto(
        photo.bytes,
        mode: _mode,
        description: hasDescription ? description : null,
        imageMediaType: photo.mediaType,
      ),
      keepFirstName: hasDescription && _mode == MealEntryMode.wholeMeal
          ? description
          : null,
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
    _notify();
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
                addToUsualMeals: widget.showAddToUsualMeals,
              ),
          ]);
      });
    } on Object catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not estimate nutrition: $error')),
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
      _notify();
    }
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_aiAvailable) ...[
          Row(
            children: [
              Expanded(
                child: FilledButton.tonalIcon(
                  style: aiButtonStyle,
                  onPressed: _isGenerating ? null : _estimateWithAi,
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: const Text('Estimate'),
                ),
              ),
              SizedBox(width: AppDesign.spacing.sm),
              Expanded(
                child: FilledButton.tonalIcon(
                  style: aiButtonStyle,
                  onPressed: _isGenerating ? null : _photoWithAi,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Photo'),
                ),
              ),
              SizedBox(width: AppDesign.spacing.sm),
              Checkbox(
                visualDensity: VisualDensity.compact,
                value: _mode == MealEntryMode.itemized,
                onChanged: _isGenerating
                    ? null
                    : (value) => _setMode(
                        (value ?? false)
                            ? MealEntryMode.itemized
                            : MealEntryMode.wholeMeal,
                      ),
              ),
              const Text('Itemize'),
              Tooltip(
                message: MealEntryMode.itemized.detail,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                child: Padding(
                  padding: EdgeInsets.all(AppDesign.spacing.xs),
                  child: const Icon(Icons.info_outline, size: 18),
                ),
              ),
            ],
          ),
          if (_isGenerating) ...[
            SizedBox(height: AppDesign.spacing.sm),
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
            ),
          ],
          SizedBox(height: AppDesign.spacing.md),
        ],
        for (var index = 0; index < _drafts.length; index++) ...[
          if (index > 0) SizedBox(height: AppDesign.spacing.md),
          _FoodEntryRow(
            key: ObjectKey(_drafts[index]),
            draft: _drafts[index],
            autofocus: widget.autofocusFirst && index == 0,
            showQuantity: widget.showQuantity,
            showAddToUsualMeals: widget.showAddToUsualMeals,
            canRemove: _drafts.length > 1,
            onChanged: () {
              setState(() {});
              _notify();
            },
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
      ],
    );
  }
}

/// The mutable state of one food being captured: its name field plus the
/// nutrition, quantity, and add-to-usuals choice. Owned by the form, which
/// disposes it.
class _FoodDraft {
  _FoodDraft({
    String name = '',
    this.quantity = 1,
    this.nutrition = const Nutrition(),
    this.addToUsualMeals = false,
  }) : nameController = TextEditingController(text: name);

  final TextEditingController nameController;
  double quantity;
  Nutrition nutrition;
  bool addToUsualMeals;

  void dispose() => nameController.dispose();
}

/// One editable food row: name, optional quantity, nutrition, and an optional
/// add-to-usuals toggle, with a remove control shown when more than one row is
/// present. A white, elevated card (the app's themed Card) with the standard
/// tinted field fills, so it reads the same here as in the rest of the app.
class _FoodEntryRow extends StatelessWidget {
  const _FoodEntryRow({
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
    return Card(
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
    );
  }
}
