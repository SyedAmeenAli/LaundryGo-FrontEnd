import 'package:flutter/widgets.dart';

/// Deliberate rounded-geometry scale (8/12/16/24 core, two extras for
/// hero/large-card use). Pick the smallest radius that fits the surface —
/// not every surface defaults to the largest one.
class LGRadius {
  LGRadius._();

  static const double micro = 4;
  static const double compact = 8;
  static const double field = 12;
  static const double button = 16;
  static const double card = 20;
  static const double cardLarge = 24;
  static const double hero = 28;

  static BorderRadius get microR => BorderRadius.circular(micro);
  static BorderRadius get compactR => BorderRadius.circular(compact);
  static BorderRadius get fieldR => BorderRadius.circular(field);
  static BorderRadius get buttonR => BorderRadius.circular(button);
  static BorderRadius get cardR => BorderRadius.circular(card);
  static BorderRadius get cardLargeR => BorderRadius.circular(cardLarge);
  static BorderRadius get heroR => BorderRadius.circular(hero);
}
