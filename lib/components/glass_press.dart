import 'package:flutter/material.dart';

import '../design_system/motion.dart';

/// The "pressed" look every tappable surface shares: a soft colored glow
/// blooming outward plus a diagonal glass sheen sweeping across the
/// surface — the iOS-style "liquid glass" highlight, not a flat opacity
/// dim. Wrap any button/card's content in this; the parent still owns the
/// actual gesture handling and just flips [pressed].
class GlassGlow extends StatelessWidget {
  const GlassGlow({
    super.key,
    required this.pressed,
    required this.child,
    required this.borderRadius,
    this.glowColor = Colors.white,
  });

  final bool pressed;
  final Widget child;
  final BorderRadius borderRadius;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: LGMotion.micro,
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: pressed
            ? [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.45),
                  blurRadius: 22,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            child,
            IgnorePointer(
              child: AnimatedOpacity(
                duration: LGMotion.micro,
                curve: Curves.easeOut,
                opacity: pressed ? 1 : 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.30),
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.18),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
