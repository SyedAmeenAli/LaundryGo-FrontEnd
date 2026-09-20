import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

/// LaundryGo Flow typographic hierarchy — Poppins only, weight/size/spacing
/// carry hierarchy rather than every heading being oversized. Extends
/// Flutter's `TextTheme` roles with the extra brand-specific styles the
/// spec names (Hero, Numeric) that `TextTheme` has no slot for.
class LGTypography {
  LGTypography._();

  static TextTheme _scale(Color primary, Color secondary) {
    final base = GoogleFonts.poppinsTextTheme();
    return base
        .copyWith(
          // Display — the largest brand moment (splash wordmark, hero).
          displayLarge: base.displayLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 40,
            height: 1.1,
            color: primary,
          ),
          // H1
          headlineLarge: base.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            height: 1.15,
            color: primary,
          ),
          // H2
          headlineMedium: base.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            height: 1.2,
            color: primary,
          ),
          // H3
          headlineSmall: base.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 21,
            height: 1.25,
            color: primary,
          ),
          // Title
          titleLarge: base.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: primary,
          ),
          // Subtitle
          titleMedium: base.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: primary,
          ),
          titleSmall: base.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: primary,
          ),
          // Body Large
          bodyLarge: base.bodyLarge?.copyWith(
            fontSize: 17,
            height: 1.45,
            color: primary,
          ),
          // Body
          bodyMedium: base.bodyMedium?.copyWith(
            fontSize: 15,
            height: 1.45,
            color: primary,
          ),
          // Body Small / Caption
          bodySmall: base.bodySmall?.copyWith(
            fontSize: 13,
            height: 1.4,
            color: secondary,
          ),
          // Label
          labelLarge: base.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.1,
            color: primary,
          ),
          // Caption
          labelSmall: base.labelSmall?.copyWith(
            fontSize: 11,
            letterSpacing: 0.2,
            color: secondary,
          ),
        )
        .apply(bodyColor: primary, displayColor: primary);
  }

  static final light = _scale(
    LGColors.textPrimaryLight,
    LGColors.textSecondaryLight,
  );
  static final dark = _scale(
    LGColors.textPrimaryDark,
    LGColors.textSecondaryDark,
  );

  /// Hero — larger than Display, reserved for splash/onboarding full-bleed
  /// moments. Not part of Flutter's `TextTheme`, so exposed separately.
  static TextStyle hero(Color color) => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.05,
    color: color,
  );

  /// Numeric — tabular figures for prices/KPIs/counts, slightly tighter
  /// tracking than body text so digits align cleanly in tables and totals.
  static TextStyle numeric(Color color, {double size = 20}) =>
      GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: size,
        letterSpacing: -0.2,
        color: color,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  /// Button — used explicitly by custom button components rather than
  /// relying on `labelLarge` alone, so button styling can evolve
  /// independently of generic labels.
  static TextStyle button(Color color) => GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.1,
    color: color,
  );
}
