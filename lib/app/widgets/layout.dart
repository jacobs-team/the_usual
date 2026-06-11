import 'package:flutter/widgets.dart';

/// {@template layout_data}
/// Describes the layout of the current window.
/// {@endtemplate}
enum LayoutData {
  /// A small layout.
  ///
  /// Typically used for mobile phones.
  small,

  /// A medium layout.
  ///
  /// Typically used for tablets.
  medium,

  /// A large layout.
  ///
  /// Typically used for larger tablets or desktops.
  large,

  /// A large layout.
  ///
  /// Typically used for wide screen desktops.
  xlarge;

  /// Returns the max width this enum case represents
  double get maxWidth {
    switch (this) {
      case small:
        return Layout.smallBreakpoint;
      case medium:
        return Layout.mediumBreakpoint;
      case large:
        return Layout.largeBreakpoint;
      case xlarge:
        return double.infinity;
    }
  }

  /// Derives the layout from the given [windowSize].
  @visibleForTesting
  static LayoutData derive(Size windowSize) =>
      values.firstWhere((e) => windowSize.width < e.maxWidth);
}

/// {@template layout}
/// Derives and provides [LayoutData] to its descendants.
///
/// See also:
///
/// * [Layout.of], a static method which retrieves the
///   closest [LayoutData].
/// * [LayoutData], an enum which describes the layout of the current window.
/// {@endtemplate}
class Layout extends StatelessWidget {
  /// {@macro layout}
  const Layout({
    required this.child,
    this.data,
    super.key,
  });

  /// The threshold width at which the layout will change from
  /// small to medium
  static const double smallBreakpoint = 640;

  /// The threshold width at which the layout will change from
  /// medium to large
  static const double mediumBreakpoint = 768;

  /// The threshold width at which the layout will change from
  /// large to xlarge
  static const double largeBreakpoint = 1024;

  /// The layout data to provide to the child.
  ///
  /// If `null` it is derived from the current size of the window. Otherwise,
  /// it will be fixed to the provided value.
  final LayoutData? data;

  /// The child widget which will have access to the current [LayoutData].
  final Widget child;

  /// Retrieves the closest [_LayoutScope] from the given [context].
  static LayoutData of(BuildContext context) {
    final layout = context.dependOnInheritedWidgetOfExactType<_LayoutScope>();
    assert(layout != null, 'No Layout found in context');
    return layout!.layout;
  }

  @override
  Widget build(BuildContext context) {
    return _LayoutScope(
      layout: data ?? LayoutData.derive(MediaQuery.sizeOf(context)),
      child: child,
    );
  }
}

/// {@template layout_scope}
/// A widget which provides the current [LayoutData] to its descendants.
/// {@endtemplate}
class _LayoutScope extends InheritedWidget {
  /// {@macro layout_scope}
  const _LayoutScope({
    required super.child,
    required this.layout,
  });

  /// {@macro layout_data}
  final LayoutData layout;

  @override
  bool updateShouldNotify(covariant _LayoutScope oldWidget) {
    return layout != oldWidget.layout;
  }
}

/// Provides comparison operators for [LayoutData] to allow for range-based
/// layout logic (e.g., `if (layout >= LayoutData.medium)`).
extension LayoutDataCompare on LayoutData {
  /// Returns true if this layout is smaller than [other].
  bool operator <(LayoutData other) => index < other.index;

  /// Returns true if this layout is smaller than or equal to [other].
  bool operator <=(LayoutData other) => index <= other.index;

  /// Returns true if this layout is larger than [other].
  bool operator >(LayoutData other) => index > other.index;

  /// Returns true if this layout is larger than or equal to [other].
  bool operator >=(LayoutData other) => index >= other.index;
}

/// Extension on [BuildContext] to allow for easy access to the current
/// [LayoutData] and common layout predicates.
extension LayoutX on BuildContext {
  /// The current [LayoutData] retrieved from the closest [Layout] ancestor.
  LayoutData get layout => Layout.of(this);

  /// Whether the current layout is [LayoutData.small].
  bool get isMobile => layout == LayoutData.small;

  /// Whether the current layout is [LayoutData.medium].
  bool get isTablet => layout == LayoutData.medium;

  /// Whether the current layout is [LayoutData.large] or [LayoutData.xlarge].
  bool get isDesktop => layout >= LayoutData.large;
}
