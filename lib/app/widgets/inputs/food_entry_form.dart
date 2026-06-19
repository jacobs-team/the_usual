import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/app/core/dependencies/dependencies.dart';
import 'package:the_usual/design_system/design_system.dart';
import 'package:uuid/uuid.dart';

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
    this.initialPhotos,
    this.autoEstimate = false,
    this.initialMealOfTheDay,
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

  /// Photos to pre-load into the form (e.g. from the OS share target).
  final List<MealPhoto>? initialPhotos;

  /// When true and [initialPhotos] is non-empty, kicks a photo estimate
  /// immediately after the bloc starts (the share-to-log path).
  final bool autoEstimate;

  /// The target meal slot to pre-select.
  final MealOfTheDay? initialMealOfTheDay;

  @override
  State<FoodEntryForm> createState() => FoodEntryFormState();
}

/// State for [FoodEntryForm]. Exposes [results], [hasContent], [isGenerating],
/// [mealOfTheDay], and [changeMealOfTheDay] so host widgets can read entries
/// and gate their confirm action via a [GlobalKey].
class FoodEntryFormState extends State<FoodEntryForm> {
  late final FoodEntryBloc _bloc;

  // Tracks ids of food drafts whose addToUsualMeals has been set to the
  // correct default for this form. When an estimate creates new drafts with
  // new ids (which default to false in the bloc), the listener syncs them to
  // widget.showAddToUsualMeals before the row renders.
  final Set<String> _initializedFoodIds = {};

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _bloc = getIt<FoodEntryBloc>();
    final initialFoods = widget.initialFoods;
    final List<FoodDraft> initialDrafts;
    if (initialFoods == null || initialFoods.isEmpty) {
      final draft = FoodDraft(
        id: _uuid.v4(),
        addToUsualMeals: widget.showAddToUsualMeals,
      );
      _initializedFoodIds.add(draft.id);
      initialDrafts = [draft];
    } else {
      final drafts = <FoodDraft>[];
      for (final food in initialFoods) {
        final draft = FoodDraft(
          id: _uuid.v4(),
          name: food.name,
          quantity: food.quantity,
          nutrition: food.nutrition,
          addToUsualMeals: food.addToUsualMeals,
        );
        _initializedFoodIds.add(draft.id);
        drafts.add(draft);
      }
      initialDrafts = drafts;
    }
    _bloc.add(
      MealEntryEvent.started(
        initialFoods: initialDrafts,
        photos: widget.initialPhotos ?? const [],
        mealOfTheDay: widget.initialMealOfTheDay,
        autoEstimate: widget.autoEstimate,
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  /// The non-empty rows as results for the host to log or save.
  List<FoodEntryResult> get results => [
    for (final foodDraft in _bloc.state.foods)
      if (foodDraft.name.trim().isNotEmpty)
        (
          name: foodDraft.name.trim(),
          nutrition: foodDraft.nutrition,
          quantity: foodDraft.quantity,
          addToUsualMeals:
              widget.showAddToUsualMeals && foodDraft.addToUsualMeals,
        ),
  ];

  /// Whether any row has a name entered.
  bool get hasContent => _bloc.state.hasContent;

  /// Whether an AI estimate is currently running.
  bool get isGenerating => _bloc.state.isGenerating;

  /// The currently selected meal slot.
  MealOfTheDay get mealOfTheDay => _bloc.state.mealOfTheDay;

  /// Switches the target meal slot.
  void changeMealOfTheDay(MealOfTheDay mealOfTheDay) =>
      _bloc.add(MealEntryEvent.mealOfTheDayChanged(mealOfTheDay));

  bool get _aiAvailable => getIt<MealAiRepository>().isConfigured;

  Future<void> _photoWithAi() async {
    final photo = await pickMealPhoto(context);
    if (photo == null) return;
    _bloc
      ..add(MealEntryEvent.photosAdded([photo]))
      ..add(const MealEntryEvent.photoEstimateRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<FoodEntryBloc, MealEntryState>(
        listener: (context, state) {
          widget.onChanged?.call();
          final message = state.errorMessage;
          if (state.status == MealEntryStatus.failure && message != null) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(message)));
          }
          // When showAddToUsualMeals is true, any food the bloc creates via an
          // estimate uses addToUsualMeals: false (the bloc doesn't know about
          // the form setting). Sync new ids to the correct default here so the
          // user sees each row checked by default, matching the old behavior.
          if (widget.showAddToUsualMeals) {
            for (final foodDraft in state.foods) {
              if (!_initializedFoodIds.contains(foodDraft.id)) {
                _initializedFoodIds.add(foodDraft.id);
                _bloc.add(
                  MealEntryEvent.foodAddToUsualMealsToggled(
                    foodDraft.id,
                    addToUsualMeals: true,
                  ),
                );
              }
            }
          } else {
            _initializedFoodIds.addAll(state.foods.map((f) => f.id));
          }
        },
        builder: (context, state) => _buildForm(context, state),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MealEntryState state) {
    final textTheme = Theme.of(context).textTheme;
    final isGenerating = state.isGenerating;
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
                  onPressed: isGenerating
                      ? null
                      : () {
                          if (!_bloc.state.hasContent) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Type a meal name or description first.',
                                ),
                              ),
                            );
                            return;
                          }
                          _bloc.add(const MealEntryEvent.estimateRequested());
                        },
                  icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                  label: const Text('Estimate'),
                ),
              ),
              SizedBox(width: AppDesign.spacing.sm),
              Expanded(
                child: FilledButton.tonalIcon(
                  style: aiButtonStyle,
                  onPressed: isGenerating ? null : _photoWithAi,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Photo'),
                ),
              ),
              SizedBox(width: AppDesign.spacing.sm),
              Checkbox(
                visualDensity: VisualDensity.compact,
                value: state.mealEntryMode == MealEntryMode.itemized,
                onChanged: isGenerating
                    ? null
                    : (value) => _bloc.add(
                          MealEntryEvent.entryModeToggled(
                            (value ?? false)
                                ? MealEntryMode.itemized
                                : MealEntryMode.wholeMeal,
                          ),
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
          if (isGenerating) ...[
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
        for (var index = 0; index < state.foods.length; index++) ...[
          if (index > 0) SizedBox(height: AppDesign.spacing.md),
          _FoodEntryRow(
            key: ValueKey(state.foods[index].id),
            foodDraft: state.foods[index],
            autofocus: widget.autofocusFirst && index == 0,
            showQuantity: widget.showQuantity,
            showAddToUsualMeals: widget.showAddToUsualMeals,
            canRemove: state.foods.length > 1,
            onNameChanged: (name) => _bloc.add(
              MealEntryEvent.foodNameChanged(state.foods[index].id, name),
            ),
            onNutritionChanged: (nutrition) => _bloc.add(
              MealEntryEvent.foodNutritionChanged(
                state.foods[index].id,
                nutrition,
              ),
            ),
            onQuantityChanged: (quantity) => _bloc.add(
              MealEntryEvent.foodQuantityChanged(
                state.foods[index].id,
                quantity,
              ),
            ),
            onAddToUsualMealsToggled: (addToUsualMeals) => _bloc.add(
              MealEntryEvent.foodAddToUsualMealsToggled(
                state.foods[index].id,
                addToUsualMeals: addToUsualMeals,
              ),
            ),
            onRemove: () => _bloc.add(
              MealEntryEvent.foodRemoved(state.foods[index].id),
            ),
          ),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _bloc.add(const MealEntryEvent.foodAdded()),
            icon: const Icon(Icons.add),
            label: const Text('Add item'),
          ),
        ),
      ],
    );
  }
}

/// One editable food row: name, optional quantity, nutrition, and an optional
/// add-to-usuals toggle, with a remove control shown when more than one row is
/// present. A white, elevated card (the app's themed Card) with the standard
/// tinted field fills, so it reads the same here as in the rest of the app.
class _FoodEntryRow extends StatefulWidget {
  const _FoodEntryRow({
    required this.foodDraft,
    required this.autofocus,
    required this.showQuantity,
    required this.showAddToUsualMeals,
    required this.canRemove,
    required this.onNameChanged,
    required this.onNutritionChanged,
    required this.onQuantityChanged,
    required this.onAddToUsualMealsToggled,
    required this.onRemove,
    super.key,
  });

  final FoodDraft foodDraft;
  final bool autofocus;
  final bool showQuantity;
  final bool showAddToUsualMeals;
  final bool canRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<Nutrition> onNutritionChanged;
  final ValueChanged<double> onQuantityChanged;
  final ValueChanged<bool> onAddToUsualMealsToggled;
  final VoidCallback onRemove;

  @override
  State<_FoodEntryRow> createState() => _FoodEntryRowState();
}

class _FoodEntryRowState extends State<_FoodEntryRow> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.foodDraft.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                    controller: _nameController,
                    autofocus: widget.autofocus,
                    hintText: 'e.g. Chicken caesar salad',
                    onChanged: widget.onNameChanged,
                  ),
                ),
                if (widget.canRemove)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.close),
                    tooltip: 'Remove',
                  ),
              ],
            ),
            SizedBox(height: AppDesign.spacing.md),
            NutritionFields(
              key: ValueKey(widget.foodDraft.nutrition),
              dense: true,
              initial: widget.foodDraft.nutrition,
              onChanged: widget.onNutritionChanged,
            ),
            if (widget.showQuantity || widget.showAddToUsualMeals) ...[
              SizedBox(height: AppDesign.spacing.md),
              Row(
                children: [
                  if (widget.showQuantity)
                    QuantityStepper(
                      dense: true,
                      quantity: widget.foodDraft.quantity,
                      onChanged: widget.onQuantityChanged,
                    ),
                  const Spacer(),
                  if (widget.showAddToUsualMeals)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: widget.foodDraft.addToUsualMeals,
                          onChanged: (value) =>
                              widget.onAddToUsualMealsToggled(value ?? false),
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
