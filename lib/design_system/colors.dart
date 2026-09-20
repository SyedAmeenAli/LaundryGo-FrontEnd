import 'package:flutter/material.dart';

/// LaundryGo Flow color tokens — the approved brand palette, exact hex.
/// Ivory/White/Midnight/Graphite carry the dominant feeling; Red/Green are
/// restrained accents (rule: "do not make the whole interface red/green").
class LGColors {
  LGColors._();

  // Brand accents.
  static const red = Color(0xFFD22730);
  static const green = Color(0xFF00843D);

  // Named neutral palette.
  static const midnight = Color(0xFF151918);
  static const graphite = Color(0xFF303633);
  static const slate = Color(0xFF69716D);
  static const cloud = Color(0xFFEEF1EF);
  static const ivory = Color(0xFFF8F6F1);
  static const white = Color(0xFFFFFFFF);

  // Functional.
  static const success = Color(0xFF16A05A);
  static const warning = Color(0xFFD99422);
  static const error = Color(0xFFE54444);
  static const info = Color(0xFF3678C5);

  /// Rating-star gold — used only for the star icon next to a numeric
  /// rating, never as a semantic/status color.
  static const ratingGold = Color(0xFFF5A623);

  // Light theme.
  static const backgroundLight = ivory;
  static const surfaceLight = white;
  static const textPrimaryLight = midnight;
  static const textSecondaryLight = slate;
  static const borderLight = cloud;

  // Dark theme.
  static const backgroundDark = Color(0xFF101311);
  static const surfaceDark = Color(0xFF181D1A);
  static const surfaceElevatedDark = Color(0xFF202622);
  static const textPrimaryDark = Color(0xFFF5F6F4);
  static const textSecondaryDark = Color(0xFFA7AEAA);
  static const borderDark = Color(0xFF2B322D);
  static const redDark = Color(0xFFE33A43);
  static const greenDark = success;
}
