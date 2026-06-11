// coverage:ignore-file

/// Centralized design tokens for the application.
///
/// Use namespaces for token groups:
/// * [AppDesign.spacing] for padding, margins, and gaps.
/// * [AppDesign.radius] for corner radii.
/// * [AppDesign.iconSizes] for icon sizes.
/// * [AppDesign.durations] for animation durations.
abstract final class AppDesign {
  /// Spacing tokens for padding, margins, and gaps.
  static const spacing = SpacingTokens._();

  /// Corner radius tokens.
  static const radius = RadiusTokens._();

  /// Icon size tokens.
  static const iconSizes = IconSizeTokens._();

  /// Animation duration tokens.
  static const durations = DurationTokens._();
}

/// Spacing tokens on a 4pt grid.
///
/// Use these for padding, margins, and gaps between elements instead of
/// hardcoded values.
final class SpacingTokens {
  const SpacingTokens._();

  /// Extra small spacing (4) — tight gaps inside compact components.
  double get xs => 4;

  /// Small spacing (8) — gaps between closely related elements.
  double get sm => 8;

  /// Medium spacing (12) — default gap between list items and content insets.
  double get md => 12;

  /// Large spacing (16) — standard content padding.
  double get lg => 16;

  /// Extra large spacing (24) — generous padding, e.g. button insets.
  double get xl => 24;

  /// Double extra large spacing (32) — section-level offsets.
  double get xxl => 32;
}

/// Corner radius tokens.
///
/// Use with `BorderRadius.circular` or `Radius.circular` instead of
/// hardcoded values.
final class RadiusTokens {
  const RadiusTokens._();

  /// Small radius (12) — inputs, snack bars, and list tiles.
  double get sm => 12;

  /// Medium radius (16) — cards and buttons.
  double get md => 16;

  /// Large radius (24) — dialogs, sheets, and media surfaces.
  double get lg => 24;

  /// Extra large radius (32) — pill-like floating surfaces.
  double get xl => 32;
}

/// Icon size tokens.
final class IconSizeTokens {
  const IconSizeTokens._();

  /// Medium icon size (24) — the standard icon size.
  double get md => 24;

  /// Large icon size (48) — emphasized states such as error placeholders.
  double get lg => 48;

  /// Extra large icon size (96) — full-screen overlays and splashes.
  double get xl => 96;
}

/// Animation duration tokens.
final class DurationTokens {
  const DurationTokens._();

  /// Fast transitions (250ms) — icon fades and page snaps.
  Duration get fast => const Duration(milliseconds: 250);
}
