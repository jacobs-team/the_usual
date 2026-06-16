import 'package:flutter/material.dart';

/// The application's color palette derived from the "Solar Flame" design
/// system — vibrant solar oranges and deep red over warm peach surfaces, with
/// a deep navy anchor for structural elements. The dark scheme keeps the same
/// accent families over warm near-black surfaces.
abstract final class AppPalette {
  // ── Primary ──
  static const primary = Color(0xFF904D00);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFF8C00);
  static const onPrimaryContainer = Color(0xFF623200);
  static const inversePrimary = Color(0xFFFFB77D);
  static const primaryFixed = Color(0xFFFFDCC3);
  static const primaryFixedDim = Color(0xFFFFB77D);
  static const onPrimaryFixed = Color(0xFF2F1500);
  static const onPrimaryFixedVariant = Color(0xFF6E3900);

  // ── Secondary ──
  static const secondary = Color(0xFFB52424);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFF5A52);
  static const onSecondaryContainer = Color(0xFF600006);
  static const secondaryFixed = Color(0xFFFFDAD6);
  static const secondaryFixedDim = Color(0xFFFFB4AC);
  static const onSecondaryFixed = Color(0xFF410003);
  static const onSecondaryFixedVariant = Color(0xFF92030F);

  // ── Tertiary ──
  static const tertiary = Color(0xFF4F6073);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF9AABC0);
  static const onTertiaryContainer = Color(0xFF2F4051);
  static const tertiaryFixed = Color(0xFFD2E4FB);
  static const tertiaryFixedDim = Color(0xFFB7C8DE);
  static const onTertiaryFixed = Color(0xFF0B1D2D);
  static const onTertiaryFixedVariant = Color(0xFF38485A);

  // ── Surface ──
  static const surface = Color(0xFFFFF8F4);
  static const onSurface = Color(0xFF1F1B17);
  static const onSurfaceVariant = Color(0xFF564334);
  static const surfaceDim = Color(0xFFE2D8D2);
  static const surfaceBright = Color(0xFFFFF8F4);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFFCF2EB);
  static const surfaceContainer = Color(0xFFF6ECE5);
  static const surfaceContainerHigh = Color(0xFFF0E6E0);
  static const surfaceContainerHighest = Color(0xFFEAE1DA);
  static const surfaceTint = Color(0xFF904D00);

  // ── Outline ──
  static const outline = Color(0xFF897362);
  static const outlineVariant = Color(0xFFDDC1AE);

  // ── Error ──
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ── Inverse ──
  static const inverseSurface = Color(0xFF34302B);
  static const onInverseSurface = Color(0xFFF9EFE8);

  // ── Shadow / Scrim ──
  static const shadow = Color(0xFF000000);
  static const scrim = Color(0xFF000000);

  // ── Dark overrides ──
  // The solar accents shift to their light tones so they read on dark
  // surfaces; the surfaces themselves are warm near-blacks.
  static const darkPrimary = Color(0xFFFFB77D);
  static const darkOnPrimary = Color(0xFF4D2700);
  static const darkPrimaryContainer = Color(0xFF6E3900);
  static const darkOnPrimaryContainer = Color(0xFFFFDCC3);
  static const darkInversePrimary = Color(0xFF904D00);
  static const darkSecondary = Color(0xFFFFB4AC);
  static const darkOnSecondary = Color(0xFF5F0009);
  static const darkSecondaryContainer = Color(0xFF92030F);
  static const darkOnSecondaryContainer = Color(0xFFFFDAD6);
  static const darkTertiary = Color(0xFFB7C8DE);
  static const darkOnTertiary = Color(0xFF20303F);
  static const darkTertiaryContainer = Color(0xFF38485A);
  static const darkOnTertiaryContainer = Color(0xFFD2E4FB);
  static const darkSurface = Color(0xFF1A1714);
  static const darkOnSurface = Color(0xFFF0E6E0);
  static const darkOnSurfaceVariant = Color(0xFFDDC1AE);
  static const darkSurfaceDim = Color(0xFF1A1714);
  static const darkSurfaceBright = Color(0xFF423933);
  static const darkSurfaceContainerLowest = Color(0xFF120F0D);
  static const darkSurfaceContainerLow = Color(0xFF211D19);
  static const darkSurfaceContainer = Color(0xFF261F1B);
  static const darkSurfaceContainerHigh = Color(0xFF312822);
  static const darkSurfaceContainerHighest = Color(0xFF3C322B);
  static const darkSurfaceTint = Color(0xFFFFB77D);
  static const darkOutline = Color(0xFFA89684);
  static const darkOutlineVariant = Color(0xFF564334);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInverseSurface = Color(0xFFF0E6E0);
  static const darkOnInverseSurface = Color(0xFF34302B);
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
    onPrimaryFixed: onPrimaryFixed,
    onPrimaryFixedVariant: onPrimaryFixedVariant,
    secondary: secondary,
    onSecondary: onSecondary,
    secondaryContainer: secondaryContainer,
    onSecondaryContainer: onSecondaryContainer,
    secondaryFixed: secondaryFixed,
    secondaryFixedDim: secondaryFixedDim,
    onSecondaryFixed: onSecondaryFixed,
    onSecondaryFixedVariant: onSecondaryFixedVariant,
    tertiary: tertiary,
    onTertiary: onTertiary,
    tertiaryContainer: tertiaryContainer,
    onTertiaryContainer: onTertiaryContainer,
    tertiaryFixed: tertiaryFixed,
    tertiaryFixedDim: tertiaryFixedDim,
    onTertiaryFixed: onTertiaryFixed,
    onTertiaryFixedVariant: onTertiaryFixedVariant,
    surface: surface,
    onSurface: onSurface,
    onSurfaceVariant: onSurfaceVariant,
    surfaceDim: surfaceDim,
    surfaceBright: surfaceBright,
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
    onPrimaryFixed: onPrimaryFixed,
    onPrimaryFixedVariant: onPrimaryFixedVariant,
    secondary: darkSecondary,
    onSecondary: darkOnSecondary,
    secondaryContainer: darkSecondaryContainer,
    onSecondaryContainer: darkOnSecondaryContainer,
    secondaryFixed: secondaryFixed,
    secondaryFixedDim: secondaryFixedDim,
    onSecondaryFixed: onSecondaryFixed,
    onSecondaryFixedVariant: onSecondaryFixedVariant,
    tertiary: darkTertiary,
    onTertiary: darkOnTertiary,
    tertiaryContainer: darkTertiaryContainer,
    onTertiaryContainer: darkOnTertiaryContainer,
    tertiaryFixed: tertiaryFixed,
    tertiaryFixedDim: tertiaryFixedDim,
    onTertiaryFixed: onTertiaryFixed,
    onTertiaryFixedVariant: onTertiaryFixedVariant,
    surface: darkSurface,
    onSurface: darkOnSurface,
    onSurfaceVariant: darkOnSurfaceVariant,
    surfaceDim: darkSurfaceDim,
    surfaceBright: darkSurfaceBright,
    surfaceContainerLowest: darkSurfaceContainerLowest,
    surfaceContainerLow: darkSurfaceContainerLow,
    surfaceContainer: darkSurfaceContainer,
    surfaceContainerHigh: darkSurfaceContainerHigh,
    surfaceContainerHighest: darkSurfaceContainerHighest,
    surfaceTint: darkSurfaceTint,
    outline: darkOutline,
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
