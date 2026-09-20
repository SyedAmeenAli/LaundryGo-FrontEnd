import 'package:flutter/animation.dart';

/// The LaundryGo Flow motion language. Motion communicates state, not
/// decoration: four named concepts map to a fixed vocabulary of moments —
/// use the concept name to decide which one a new interaction needs, don't
/// invent a fifth.
///
/// SPIN  — washing machine: the logo mark's idle rotation loop.
/// FLOW  — water/fabric: background texture drift, screen-to-screen
///         transitions that feel like fabric settling into place.
/// FLOAT — bubbles: small ambient particles rising past a brand moment.
/// FOLD  — laundry completion: a settle/collapse transition used at the
///         end of a flow (order booked, delivery completed).
class LGMotion {
  LGMotion._();

  static const curve = Cubic(0.25, 1, 0.5, 1);
  static const spring = Curves.easeOutCubic;

  // Micro: 100-160ms — a button press, a toggle.
  static const micro = Duration(milliseconds: 140);
  // Component: 200-400ms — a card expanding, a field focusing.
  static const component = Duration(milliseconds: 260);
  // Page: 250-450ms — route transitions.
  static const page = Duration(milliseconds: 380);
  // Brand: 400-800ms — a FOLD completion moment, a hero reveal.
  static const brand = Duration(milliseconds: 600);
  // Ambient: 1.5-4s — FLOW background drift.
  static const ambient = Duration(milliseconds: 2800);
  // Slow brand loops: 8-14s — SPIN logo rotation.
  static const slowLoop = Duration(seconds: 11);

  /// Pressed-state scale for any tappable control.
  static const pressedScale = 0.97;
}
