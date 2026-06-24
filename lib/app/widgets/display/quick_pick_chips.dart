import 'package:flutter/material.dart';
import 'package:the_usual/app/app.dart';
import 'package:the_usual/design_system/design_system.dart';

/// The data backing a single quick-pick chip: its label and the actions for a
/// tap (log it) and a long-press menu (remove it from the user's usuals).
class QuickPickChipData {
  /// {@macro quick_pick_chip}
  const QuickPickChipData({
    required this.label,
    required this.onPressed,
    required this.onRemove,
  });

  /// The text shown on the chip, e.g. "+ Oatmeal".
  final String label;

  /// Called when the chip is tapped.
  final VoidCallback onPressed;

  /// Called when the chip's "Remove from usuals" menu item is chosen.
  final VoidCallback onRemove;
}

/// {@template expandable_chip_wrap}
/// Lays the quick-pick [chips] out in a wrap that shows at most
/// [maxCollapsedRows] rows. When more chips than that exist they are hidden
/// behind a "Show N more" toggle and revealed in place when expanded. Starts
/// collapsed.
/// {@endtemplate}
class ExpandableChipWrap extends StatefulWidget {
  /// {@macro expandable_chip_wrap}
  const ExpandableChipWrap({
    required this.chips,
    this.maxCollapsedRows = 3,
    super.key,
  });

  /// The quick picks to render, in display order.
  final List<QuickPickChipData> chips;

  /// How many rows of chips to show before the rest are hidden behind the
  /// toggle.
  final int maxCollapsedRows;

  @override
  State<ExpandableChipWrap> createState() => _ExpandableChipWrapState();
}

class _ExpandableChipWrapState extends State<ExpandableChipWrap> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = AppDesign.spacing.sm;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chipWidths = [
          for (final chip in widget.chips)
            _chipWidth(context, chip.label, theme.textTheme.labelLarge),
        ];
        final collapsedVisible = _collapsedVisibleCount(
          chipWidths,
          maxWidth: constraints.maxWidth,
          spacing: spacing,
        );
        final hiddenCount = widget.chips.length - collapsedVisible;
        final hasOverflow = hiddenCount > 0;
        final visibleCount = _expanded ? widget.chips.length : collapsedVisible;
        final visibleChips = widget.chips.take(visibleCount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final chip in visibleChips)
                  QuickPickChip(
                    label: chip.label,
                    onPressed: chip.onPressed,
                    onRemove: chip.onRemove,
                  ),
              ],
            ),
            if (hasOverflow)
              Padding(
                padding: EdgeInsets.only(top: AppDesign.spacing.xs),
                child: TextButton.icon(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDesign.spacing.sm,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 18,
                  ),
                  label: Text(
                    _expanded ? 'Show less' : 'Show $hiddenCount more',
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// The rendered width of a chip with [label]: the measured text width plus
  /// the chip's horizontal padding. The dashed border is painted in the
  /// foreground and adds no layout width.
  double _chipWidth(BuildContext context, String label, TextStyle? style) {
    final textPainter = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    return textPainter.width + AppDesign.spacing.md * 2;
  }

  /// How many of the leading chips fit within the collapsed row budget, laid
  /// out the same way [Wrap] does: each chip joins the current row when it
  /// fits, or starts the next one otherwise.
  int _collapsedVisibleCount(
    List<double> chipWidths, {
    required double maxWidth,
    required double spacing,
  }) {
    var rows = 1;
    var rowWidth = 0.0;
    var count = 0;
    for (final chipWidth in chipWidths) {
      final projectedWidth = rowWidth == 0
          ? chipWidth
          : rowWidth + spacing + chipWidth;
      if (projectedWidth <= maxWidth) {
        rowWidth = projectedWidth;
      } else {
        rows++;
        if (rows > widget.maxCollapsedRows) break;
        rowWidth = chipWidth;
      }
      count++;
    }
    return count;
  }
}

/// {@template quick_pick_chip}
/// A quick pick for a usual not yet logged: a dashed border and a muted fill
/// mark it as available to add rather than already on the day. Tapping logs it;
/// a long press opens a menu to remove it from the user's usuals.
/// {@endtemplate}
class QuickPickChip extends StatelessWidget {
  /// {@macro quick_pick_chip}
  const QuickPickChip({
    required this.label,
    required this.onPressed,
    required this.onRemove,
    super.key,
  });

  /// The text shown on the chip, e.g. "+ Oatmeal".
  final String label;

  /// Called when the chip is tapped.
  final VoidCallback onPressed;

  /// Called when the "Remove from usuals" menu item is chosen.
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppDesign.radius.lg);

    return MenuAnchor(
      menuChildren: [
        MenuItemButton(
          leadingIcon: const Icon(Icons.delete_outline),
          onPressed: onRemove,
          child: const Text('Remove from usuals'),
        ),
      ],
      builder: (context, controller, child) {
        return DashedBorder(
          color: theme.colorScheme.outlineVariant,
          radius: AppDesign.radius.lg,
          child: Material(
            borderRadius: borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              onLongPress: controller.open,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesign.spacing.md,
                  vertical: AppDesign.spacing.sm,
                ),
                child: Text(label, style: theme.textTheme.labelLarge),
              ),
            ),
          ),
        );
      },
    );
  }
}
