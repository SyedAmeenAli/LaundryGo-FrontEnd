import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../asset_registry/laundrygo_assets.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';

/// The signature LaundryGo mark, animated with SPIN (one drum-style
/// rotation loop with a settle wobble) and FLOAT (bubbles drifting past
/// it) — the app's two most recognizable motion concepts, combined into a
/// single reusable component so Splash, loading states, and Sign-in share
/// exactly one implementation.
///
/// Respects reduced motion: when `MediaQuery.disableAnimations` is true the
/// mark renders static, no rotation or bubbles.
class LaundryGoLogo extends StatefulWidget {
  const LaundryGoLogo({super.key, this.size = 96, this.showBubbles = true});

  final double size;
  final bool showBubbles;

  @override
  State<LaundryGoLogo> createState() => _LaundryGoLogoState();
}

class _LaundryGoLogoState extends State<LaundryGoLogo>
    with TickerProviderStateMixin {
  late final AnimationController _spin;
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();
    _spin = AnimationController(vsync: this, duration: LGMotion.slowLoop)
      ..repeat();
    _float = AnimationController(vsync: this, duration: LGMotion.slowLoop)
      ..repeat();
  }

  @override
  void dispose() {
    _spin.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final mark = Image.asset(
      LaundryGoAssets.logoMark,
      width: widget.size,
      height: widget.size,
    );

    if (reduceMotion) return mark;

    return SizedBox(
      width: widget.size * 1.6,
      height: widget.size * 1.6,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          if (widget.showBubbles) ..._buildBubbles(),
          AnimatedBuilder(
            animation: _spin,
            builder: (context, child) {
              // SPIN: rotate 0->360 over the first 65% of the loop, hold,
              // then a tiny settle wobble before looping — never a bare
              // linear spinner.
              final t = _spin.value;
              double angle;
              if (t < 0.65) {
                angle = Curves.easeInOutCubic.transform(t / 0.65) * 2 * math.pi;
              } else if (t < 0.85) {
                angle = 2 * math.pi;
              } else {
                final settle = Curves.easeOut.transform((t - 0.85) / 0.15);
                angle = 2 * math.pi - math.sin(settle * math.pi) * 0.06;
              }
              return Transform.rotate(angle: angle, child: child);
            },
            child: mark,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBubbles() {
    const count = 4;
    return List.generate(count, (i) {
      final phaseOffset = i / count;
      return AnimatedBuilder(
        animation: _float,
        builder: (context, child) {
          // FLOAT: bubbles rising with gentle horizontal drift, fading in
          // and out rather than popping in/out abruptly.
          final t = (_float.value + phaseOffset) % 1.0;
          final rise = Curves.easeOut.transform(t);
          final dy = -rise * widget.size * 0.9;
          final dx = math.sin(t * 2 * math.pi + i) * (widget.size * 0.12);
          final opacity = (t < 0.15)
              ? t / 0.15
              : (1 - ((t - 0.15) / 0.85)).clamp(0.0, 1.0);
          final bubbleSize = widget.size * (0.05 + 0.03 * (i.isEven ? 1 : 0.6));
          return Transform.translate(
            offset: Offset(dx, dy),
            child: Opacity(
              opacity: opacity * 0.55,
              child: Container(
                width: bubbleSize,
                height: bubbleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: LGColors.info.withValues(alpha: 0.5),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.6),
                    width: 0.6,
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
