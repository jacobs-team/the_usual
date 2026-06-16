import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template expandable_nutrition}
/// A food's name with its nutrition in an [ExpansionTile]: collapsed it shows a
/// read-only summary line, expanded it reveals editable [NutritionFields]. The
/// leading chevron animates and a trailing button removes the entry. Starts in
/// [expandedByDefault] and follows that value when it changes (e.g. the user
/// flips the default), while keeping any manual toggle in between.
///
/// When [quantity] is supplied the stored [nutrition] is treated as per unit:
/// the summary shows it scaled by the quantity, the name gains a `×N` prefix
/// once the quantity passes one, and a [QuantityStepper] appears above the
/// fields while expanded. Leave [quantity] null for foods that have no count,
/// such as usual meals.
/// {@endtemplate}
class ExpandableNutrition extends StatefulWidget {
  /// {@macro expandable_nutrition}
  const ExpandableNutrition({
    required this.name,
    required this.nutrition,
    required this.expandedByDefault,
    required this.onChanged,
    required this.onRemoved,
    this.onNameChanged,
    this.quantity,
    this.onQuantityChanged,
    this.expandedFooter,
    super.key,
  });

  /// The food's name.
  final String name;

  /// The per-unit nutrition to summarize when collapsed and seed the fields
  /// when open. When [quantity] is set the summary shows this scaled.
  final Nutrition nutrition;

  /// Whether the fields start expanded for editing.
  final bool expandedByDefault;

  /// Called with the parsed nutrition whenever a field changes.
  final ValueChanged<Nutrition> onChanged;

  /// Called with the new name whenever it changes. When null the name is shown
  /// read-only; when provided it becomes an editable field.
  final ValueChanged<String>? onNameChanged;

  /// How many of this food was logged. Null hides the stepper and shows the
  /// nutrition unscaled, for foods that have no count.
  final int? quantity;

  /// Called with the new quantity when the stepper is used.
  final ValueChanged<int>? onQuantityChanged;

  /// Called when the remove button is pressed.
  final VoidCallback onRemoved;

  /// Extra content shown below the fields while expanded, e.g. a sync action.
  final Widget? expandedFooter;

  @override
  State<ExpandableNutrition> createState() => _ExpandableNutritionState();
}

class _ExpandableNutritionState extends State<ExpandableNutrition> {
  final _controller = ExpansibleController();
  late final _nameController = TextEditingController(text: widget.name);
  late bool _expanded = widget.expandedByDefault;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ExpandableNutrition oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reflect an externally changed name without disturbing the cursor while
    // the user is typing into the field.
    if (widget.name != oldWidget.name && _nameController.text != widget.name) {
      _nameController.text = widget.name;
    }
    // The default flipped: reflect it on the tile after this frame, since the
    // controller drives the already-built tile.
    if (widget.expandedByDefault != oldWidget.expandedByDefault) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.expandedByDefault) {
          _controller.expand();
        } else {
          _controller.collapse();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = widget.quantity;
    final displayNutrition = quantity == null
        ? widget.nutrition
        : widget.nutrition * quantity;
    final displayName = quantity != null && quantity > 1
        ? '×$quantity ${widget.name}'
        : widget.name;
    return ExpansionTile(
      dense: true,
      controller: _controller,
      initiallyExpanded: widget.expandedByDefault,
      onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
      controlAffinity: ListTileControlAffinity.leading,
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      shape: const Border(),
      collapsedShape: const Border(),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      title: widget.onNameChanged != null
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    onChanged: widget.onNameChanged,
                    textCapitalization: TextCapitalization.sentences,
                    style: theme.textTheme.bodyLarge,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (!_expanded) ...[
                  SizedBox(width: AppDesign.spacing.sm),
                  DefaultTextStyle.merge(
                    style: theme.textTheme.bodyMedium,
                    child: NutritionSummary(displayNutrition),
                  ),
                ],
              ],
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: AppDesign.spacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                      ),
                      child: Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ),
                    if (!_expanded)
                      DefaultTextStyle.merge(
                        style: theme.textTheme.bodyMedium,
                        child: NutritionSummary(displayNutrition),
                      ),
                  ],
                );
              },
            ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_forever_outlined),
        onPressed: widget.onRemoved,
      ),
      children: [
        if (quantity != null && widget.onQuantityChanged != null) ...[
          const SectionLabel('QUANTITY'),
          SizedBox(height: AppDesign.spacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: QuantityStepper(
              dense: true,
              quantity: quantity,
              onChanged: widget.onQuantityChanged!,
            ),
          ),
          if (quantity > 1 && !widget.nutrition.isEmpty) ...[
            SizedBox(height: AppDesign.spacing.xs),
            DefaultTextStyle.merge(
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('×$quantity = '),
                  NutritionSummary(displayNutrition),
                ],
              ),
            ),
          ],
          SizedBox(height: AppDesign.spacing.md),
        ],
        NutritionFields(
          dense: true,
          initial: widget.nutrition,
          onChanged: widget.onChanged,
        ),
        if (widget.expandedFooter != null) widget.expandedFooter!,
      ],
    );
  }
}
