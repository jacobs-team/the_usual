import 'package:flutter/material.dart';
import 'package:the_usual/design_system/design_system.dart';

/// {@template the_usual_bottom_sheet}
/// The app's standard modal bottom sheet: a title with a top-right close button
/// over scrollable content, padded and kept clear of the keyboard and the home
/// indicator. Present it with [TheUsualBottomSheet.show] so every sheet shares
/// the same flags: no drag handle, dismissed only through the close button.
///
/// Provide [child] for ordinary box content or [slivers] for content that is
/// already sliver-based (e.g. a `MealLogSection`); exactly one is required.
/// {@endtemplate}
class TheUsualBottomSheet extends StatelessWidget {
  /// {@macro the_usual_bottom_sheet}
  const TheUsualBottomSheet({
    required this.title,
    this.child,
    this.slivers,
    this.onClose,
    super.key,
  }) : assert(
         (child == null) != (slivers == null),
         'Provide either child or slivers, not both.',
       );

  /// Heading shown at the top of the sheet, beside the close button.
  final String title;

  /// Box content for the sheet body. Mutually exclusive with [slivers].
  final Widget? child;

  /// Sliver content for the sheet body, for content that is already a sliver.
  /// Mutually exclusive with [child].
  final List<Widget>? slivers;

  /// Called when the close button is tapped. Defaults to popping the sheet.
  final VoidCallback? onClose;

  /// Shows [builder]'s sheet with the app's standard flags: a scrollable sheet
  /// kept within the safe area, with no drag handle, dismissed only through the
  /// close button. Presented on the root navigator so it covers the floating
  /// nav bar rather than letting it paint over the sheet.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      enableDrag: false,
      isDismissible: false,
      builder: builder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final header = SliverPadding(
      padding: EdgeInsets.fromLTRB(
        AppDesign.spacing.lg,
        AppDesign.spacing.lg,
        AppDesign.spacing.lg,
        AppDesign.spacing.sm,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(child: Text(title, style: textTheme.titleMedium)),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
              tooltip: 'Close',
            ),
          ],
        ),
      ),
    );

    final child = this.child;

    // Lift the sheet above the keyboard, then keep the content clear of the
    // home indicator with SafeArea. The route's useSafeArea strips the top
    // padding here.
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: [
            header,
            if (child != null)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppDesign.spacing.lg,
                  0,
                  AppDesign.spacing.lg,
                  AppDesign.spacing.lg,
                ),
                sliver: SliverToBoxAdapter(child: child),
              ),
            ...?slivers,
          ],
        ),
      ),
    );
  }
}
