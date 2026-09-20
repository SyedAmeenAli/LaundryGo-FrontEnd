import 'package:flutter/material.dart';

import 'colors.dart';
import 'radius.dart';
import 'typography.dart';

/// LaundryGo Flow theme — light + dark, built entirely from the token
/// files above. Crisp, mostly-flat surfaces (rule: "most content should
/// remain crisp and readable"); elevation/translucency are opt-in per
/// component (bottom sheets, floating nav), not a global card treatment.
class LGTheme {
  LGTheme._();

  static ThemeData get light => _build(
    brightness: Brightness.light,
    background: LGColors.backgroundLight,
    surface: LGColors.surfaceLight,
    onSurface: LGColors.textPrimaryLight,
    onSurfaceVariant: LGColors.textSecondaryLight,
    border: LGColors.borderLight,
    red: LGColors.red,
    green: LGColors.green,
    textTheme: LGTypography.light,
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    background: LGColors.backgroundDark,
    surface: LGColors.surfaceDark,
    onSurface: LGColors.textPrimaryDark,
    onSurfaceVariant: LGColors.textSecondaryDark,
    border: LGColors.borderDark,
    red: LGColors.redDark,
    green: LGColors.greenDark,
    textTheme: LGTypography.dark,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color onSurface,
    required Color onSurfaceVariant,
    required Color border,
    required Color red,
    required Color green,
    required TextTheme textTheme,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: red,
      onPrimary: Colors.white,
      secondary: green,
      onSecondary: Colors.white,
      error: LGColors.error,
      onError: Colors.white,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: onSurfaceVariant,
      outline: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: onSurface,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: LGRadius.cardR,
          side: BorderSide(color: border),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: Colors.white,
          // A bare `Size.fromHeight(52)` sets minimum WIDTH to infinity —
          // correct for a button stretched full-width in a `SizedBox`, but
          // it demands infinite width from any `Row` sibling (squeezing an
          // `Expanded` neighbour to zero, wrapping its text one
          // char-per-line). A real minimum width keeps both usages safe.
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(borderRadius: LGRadius.buttonR),
          textStyle: LGTypography.button(Colors.white),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size(64, 52),
          side: BorderSide(color: border, width: 1.4),
          shape: RoundedRectangleBorder(borderRadius: LGRadius.buttonR),
          textStyle: LGTypography.button(onSurface),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: red,
          textStyle: LGTypography.button(red),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: LGRadius.fieldR,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: LGRadius.fieldR,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LGRadius.fieldR,
          borderSide: BorderSide(color: red, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: LGRadius.fieldR,
          borderSide: const BorderSide(color: LGColors.error, width: 1.4),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: red.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelSmall),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    );
  }
}
