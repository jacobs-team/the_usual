// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:the_usual/design_system/app_design.dart';
import 'package:the_usual/design_system/app_palette.dart';

/// Central place for defining the application's visual theme.
class AppTheme {
  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final base = ThemeData(colorScheme: colorScheme);
    // Display, headline, and title in Plus Jakarta Sans; body and labels in
    // Hanken Grotesk.
    final bodyTextTheme = GoogleFonts.hankenGroteskTextTheme(base.textTheme);
    TextStyle? heading(TextStyle? style) =>
        style == null ? null : GoogleFonts.plusJakartaSans(textStyle: style);
    final textTheme = bodyTextTheme.copyWith(
      displayLarge: heading(bodyTextTheme.displayLarge),
      displayMedium: heading(bodyTextTheme.displayMedium),
      displaySmall: heading(bodyTextTheme.displaySmall),
      headlineLarge: heading(bodyTextTheme.headlineLarge),
      headlineMedium: heading(bodyTextTheme.headlineMedium),
      headlineSmall: heading(bodyTextTheme.headlineSmall),
      titleLarge: heading(bodyTextTheme.titleLarge),
      titleMedium: heading(
        bodyTextTheme.titleMedium,
      )?.copyWith(fontWeight: FontWeight.bold),
      titleSmall: heading(bodyTextTheme.titleSmall),
    );

    final smRadius = BorderRadius.circular(AppDesign.radius.sm);
    final smShape = RoundedRectangleBorder(borderRadius: smRadius);
    final mdRadius = BorderRadius.circular(AppDesign.radius.md);
    final mdShape = RoundedRectangleBorder(borderRadius: mdRadius);
    final lgShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDesign.radius.lg),
    );
    final buttonPadding = EdgeInsets.symmetric(
      horizontal: AppDesign.spacing.xl,
      vertical: AppDesign.spacing.md,
    );
    // Buttons and input fields share the same corner radius.
    final inputBorder = OutlineInputBorder(
      borderRadius: mdRadius,
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 3,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDesign.radius.md),
          side: BorderSide(color: colorScheme.outline),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: mdShape,
          padding: buttonPadding,
          textStyle: textTheme.labelLarge,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          shape: mdShape,
          padding: buttonPadding,
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: mdShape,
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: mdShape,
          side: BorderSide(color: colorScheme.outlineVariant),
          textStyle: textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDesign.spacing.lg,
          vertical: AppDesign.spacing.md,
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.secondaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: EdgeInsets.symmetric(
          horizontal: AppDesign.spacing.md,
          vertical: AppDesign.spacing.xs,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 0,
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? colorScheme.secondary
                : colorScheme.onSurfaceVariant,
            size: AppDesign.iconSizes.md,
          ),
        ),
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 0,
        selectedIconTheme: IconThemeData(color: colorScheme.secondary),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: lgShape,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDesign.radius.lg),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        shape: smShape,
        behavior: SnackBarBehavior.floating,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        shape: const CircleBorder(),
      ),

      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 0.5,
        space: 0,
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDesign.spacing.md,
          vertical: AppDesign.spacing.xs,
        ),
        shape: smShape,
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.onPrimary
              : colorScheme.onSurfaceVariant,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }

  /// Light theme configuration.
  static final ThemeData light = _buildTheme(AppPalette.lightScheme);

  /// Dark theme configuration.
  static final ThemeData dark = _buildTheme(AppPalette.darkScheme);
}

/// A stadium-shaped, tonal button style for the app's prominent inline actions
/// (e.g. "Add", "Other meal", "New workout"). Sized to match
/// the app bar's date pill: the secondary-container fill, compact label, and
/// tight padding of the [ChipThemeData] above.
ButtonStyle pillButtonStyle(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  return FilledButton.styleFrom(
    backgroundColor: colorScheme.secondaryContainer,
    foregroundColor: colorScheme.onSecondaryContainer,
    shape: const StadiumBorder(),
    textStyle: theme.textTheme.labelMedium,
    iconSize: 16,
    padding: EdgeInsets.symmetric(
      horizontal: AppDesign.spacing.md,
      vertical: AppDesign.spacing.xs,
    ),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}
