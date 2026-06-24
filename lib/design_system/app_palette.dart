import 'package:flutter/material.dart';

/// The application's color palette derived from the "Professional Blue" design
/// system — deep navy and sky-blue accents over soft sky-blue surfaces, with a
/// warm gold tertiary. Professional Blue is a light palette, so it is the light
/// scheme; the dark scheme is a derived cool-navy variant keeping the same
/// accent families.
abstract final class AppPalette {
  // ── Primary ── (deep navy)
  static const primary = Color(0xFF131B2E);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF131B2E);
  static const onPrimaryContainer = Color(0xFF7C839B);
  static const inversePrimary = Color(0xFFBEC6E0);
  static const primaryFixed = Color(0xFFDAE2FD);
  static const primaryFixedDim = Color(0xFFBEC6E0);
  static const onPrimaryFixed = Color(0xFF131B2E);
  static const onPrimaryFixedVariant = Color(0xFF3F465C);

  // ── Secondary ── (sky blue)
  static const secondary = Color(0xFF00668A);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFF40C2FD);
  static const onSecondaryContainer = Color(0xFF004D6A);
  static const secondaryFixed = Color(0xFFC4E7FF);
  static const secondaryFixedDim = Color(0xFF7BD0FF);
  static const onSecondaryFixed = Color(0xFF001E2C);
  static const onSecondaryFixedVariant = Color(0xFF004C69);

  // ── Tertiary ── (warm gold)
  static const tertiary = Color(0xFF000000);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF271901);
  static const onTertiaryContainer = Color(0xFF98805D);
  static const tertiaryFixed = Color(0xFFFCDEB5);
  static const tertiaryFixedDim = Color(0xFFDEC29A);
  static const onTertiaryFixed = Color(0xFF271901);
  static const onTertiaryFixedVariant = Color(0xFF574425);

  // ── Surface ── (soft sky blue)
  static const surface = Color(0xFFF8F9FF);
  static const onSurface = Color(0xFF0D1C2E);
  static const onSurfaceVariant = Color(0xFF45464D);
  static const surfaceDim = Color(0xFFCCDBF3);
  static const surfaceBright = Color(0xFFF8F9FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFEFF4FF);
  static const surfaceContainer = Color(0xFFE6EEFF);
  static const surfaceContainerHigh = Color(0xFFDCE9FF);
  static const surfaceContainerHighest = Color(0xFFD5E3FC);
  static const surfaceTint = Color(0xFF565E74);

  // ── Macros ── (protein teal, carbs blue, fat amber — red is reserved for
  // the over-goal state, so no macro uses it). White reads on all three.
  static const proteinMacro = Color(0xFF2E8B7F);
  static const carbsMacro = Color(0xFF3E78B2);
  static const fatMacro = Color(0xFFC68A2E);
  static const onMacro = Color(0xFFFFFFFF);

  // ── Trend accents ── (warm amber-orange, complementary to the blue palette
  // so a goal reference line reads against both the navy card and blue bars).
  static const goalLine = Color(0xFFF5A623);

  // On the dark scheme the trends card sits on a light primary, where the
  // bright amber-orange washes out; this deeper burnt orange keeps the goal
  // line and its label readable there.
  static const darkGoalLine = Color(0xFFC2410C);

  // ── Outline ──
  static const outline = Color(0xFF76777D);
  static const outlineVariant = Color(0xFFC6C6CD);

  // ── Error ──
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // ── Inverse ──
  static const inverseSurface = Color(0xFF233144);
  static const onInverseSurface = Color(0xFFEAF1FF);

  // ── Shadow / Scrim ──
  static const shadow = Color(0xFF000000);
  static const scrim = Color(0xFF000000);

  // ── Dark overrides ──
  // The navy and sky-blue accents shift to their light tones so they read on
  // dark surfaces; the surfaces are cool navy-tinted near-blacks.
  static const darkPrimary = Color(0xFFBEC6E0);
  static const darkOnPrimary = Color(0xFF131B2E);
  static const darkPrimaryContainer = Color(0xFF3F465C);
  static const darkOnPrimaryContainer = Color(0xFFDAE2FD);
  static const darkInversePrimary = Color(0xFF565E74);
  static const darkSecondary = Color(0xFF7BD0FF);
  static const darkOnSecondary = Color(0xFF00344A);
  static const darkSecondaryContainer = Color(0xFF004C69);
  static const darkOnSecondaryContainer = Color(0xFFC4E7FF);
  static const darkTertiary = Color(0xFFDEC29A);
  static const darkOnTertiary = Color(0xFF271901);
  static const darkTertiaryContainer = Color(0xFF574425);
  static const darkOnTertiaryContainer = Color(0xFFFCDEB5);
  static const darkSurface = Color(0xFF0E1622);
  static const darkOnSurface = Color(0xFFDEE3EB);
  static const darkOnSurfaceVariant = Color(0xFFC6C6CD);
  static const darkSurfaceDim = Color(0xFF0E1622);
  static const darkSurfaceBright = Color(0xFF343C4A);
  static const darkSurfaceContainerLowest = Color(0xFF090E17);
  static const darkSurfaceContainerLow = Color(0xFF161E2A);
  static const darkSurfaceContainer = Color(0xFF1A2230);
  static const darkSurfaceContainerHigh = Color(0xFF242C3A);
  static const darkSurfaceContainerHighest = Color(0xFF2F3745);
  static const darkSurfaceTint = Color(0xFFBEC6E0);
  static const darkOutline = Color(0xFF8F9099);
  static const darkOutlineVariant = Color(0xFF43474E);
  static const darkError = Color(0xFFFFB4AB);
  static const darkOnError = Color(0xFF690005);
  static const darkErrorContainer = Color(0xFF93000A);
  static const darkOnErrorContainer = Color(0xFFFFDAD6);
  static const darkInverseSurface = Color(0xFFDEE3EB);
  static const darkOnInverseSurface = Color(0xFF2D3542);
  static const darkShadow = Color(0xFF000000);
  static const darkScrim = Color(0xFF000000);

  /// Light [ColorScheme] built from the palette (Professional Blue).
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
