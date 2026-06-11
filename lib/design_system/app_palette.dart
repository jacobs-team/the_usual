// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

/// The application's color palette derived from the "Sensory Sommelier"
/// design system — warm coffee tones from ristretto to steamed milk.
abstract final class AppPalette {
  // ── Primary ──
  static const primary = Color(0xFF271310);
  static const onPrimary = Color(0xFFFAF9F5);
  static const primaryContainer = Color(0xFF3E2723);
  static const onPrimaryContainer = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFF5D4037);
  static const primaryFixedDim = Color(0xFF4E342E);

  // ── Secondary ──
  static const secondary = Color(0xFF504442);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD3C3C0);
  static const onSecondaryContainer = Color(0xFF3E2723);

  // ── Tertiary ──
  static const tertiary = Color(0xFF827472);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFE2E3DF);
  static const onTertiaryContainer = Color(0xFF504442);

  // ── Surface ──
  static const surface = Color(0xFFFAF9F5);
  static const onSurface = Color(0xFF1A1C1A);
  static const onSurfaceVariant = Color(0xFF504442);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF4F4F0);
  static const surfaceContainer = Color(0xFFEEEDE9);
  static const surfaceContainerHigh = Color(0xFFE8E7E3);
  static const surfaceContainerHighest = Color(0xFFE2E3DF);
  static const surfaceTint = Color(0xFF271310);

  // ── Outline ──
  static const outline = Color(0xFF827472);
  static const outlineVariant = Color(0xFFD3C3C0);

  // ── Error ──
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF410002);

  // ── Inverse ──
  static const inverseSurface = Color(0xFF1A1C1A);
  static const onInverseSurface = Color(0xFFFAF9F5);
  static const inversePrimary = Color(0xFFD3C3C0);

  // ── Shadow / Scrim ──
  static const shadow = Color(0xFF271310);
  static const scrim = Color(0xFF271310);

  // ── Dark overrides ──
  static const darkPrimary = Color(0xFFD3C3C0);
  static const darkOnPrimary = Color(0xFF271310);
  static const darkPrimaryContainer = Color(0xFF5D4037);
  static const darkOnPrimaryContainer = Color(0xFFFAF9F5);
  static const darkSecondary = Color(0xFFD3C3C0);
  static const darkOnSecondary = Color(0xFF271310);
  static const darkSecondaryContainer = Color(0xFF504442);
  static const darkOnSecondaryContainer = Color(0xFFF4F4F0);
  static const darkTertiary = Color(0xFFA89896);
  static const darkOnTertiary = Color(0xFF1A1C1A);
  static const darkTertiaryContainer = Color(0xFF504442);
  static const darkOnTertiaryContainer = Color(0xFFE2E3DF);
  static const darkSurface = Color(0xFF1A1C1A);
  static const darkOnSurface = Color(0xFFFAF9F5);
  static const darkOnSurfaceVariant = Color(0xFFD3C3C0);
  static const darkSurfaceContainerLowest = Color(0xFF121211);
  static const darkSurfaceContainerLow = Color(0xFF1F201E);
  static const darkSurfaceContainer = Color(0xFF262624);
  static const darkSurfaceContainerHigh = Color(0xFF2E2E2C);
  static const darkSurfaceContainerHighest = Color(0xFF3A3937);
  static const darkSurfaceTint = Color(0xFFD3C3C0);
  static const darkOutlineVariant = Color(0xFF504442);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInverseSurface = Color(0xFFFAF9F5);
  static const darkOnInverseSurface = Color(0xFF1A1C1A);
  static const darkInversePrimary = Color(0xFF3E2723);
  static const darkShadow = Color(0xFF000000);
  static const darkScrim = Color(0xFF000000);

  /// Light [ColorScheme] built from the palette.
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    primaryFixed: primaryFixed,
    primaryFixedDim: primaryFixedDim,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: onSurfaceVariant,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    surfaceTint: surfaceTint,
    outline: outline,
    outlineVariant: outlineVariant,
    error: error,
    onError: onError,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: inversePrimary,
    shadow: shadow,
    scrim: scrim,
  );

  /// Dark [ColorScheme] built from the palette.
  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: darkPrimary,
    onPrimary: darkOnPrimary,
    primaryContainer: darkPrimaryContainer,
    onPrimaryContainer: darkOnPrimaryContainer,
    primaryFixed: primaryFixed,
    primaryFixedDim: primaryFixedDim,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    surface: darkSurface,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    surfaceContainerLowest: darkSurfaceContainerLowest,
    surfaceContainerLow: darkSurfaceContainerLow,
    surfaceContainer: darkSurfaceContainer,
    surfaceContainerHigh: darkSurfaceContainerHigh,
    surfaceContainerHighest: darkSurfaceContainerHighest,
    surfaceTint: darkSurfaceTint,
    outline: outline,
    outlineVariant: darkOutlineVariant,
    error: darkError,
    onError: darkOnError,
    errorContainer: darkErrorContainer,
    onErrorContainer: darkOnErrorContainer,
    inverseSurface: darkInverseSurface,
    onInverseSurface: darkOnInverseSurface,
    inversePrimary: darkInversePrimary,
    shadow: darkShadow,
    scrim: darkScrim,
  );
}
