import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';

/// Reads the same reduced-motion signal [LaundryGoLogo] already respects
/// (`MediaQuery.disableAnimations`) — the one place every motion component
/// in this file checks it, so a future new component just calls this.
bool laundryGoReducedMotion(BuildContext context) =>
    MediaQuery.maybeOf(context)?.disableAnimations ?? false;

/// The base LaundryGo tactile wrapper — every interactive surface in the
/// app (buttons, cards, header icons, nav items) should route through
/// this rather than hand-rolling its own `GestureDetector` + `AnimatedScale`.
///
/// TAP is always immediate — `onTap` fires on tap-up like any normal
/// widget, never delayed waiting to see if a long-press follows (rule:
/// "long press must not break UX"). Tap gives a quick press-scale
/// (default 1.0 → 0.985, 100–160ms — the Karpathy-style "1.0 → 0.98 →
/// 1.0" button rule already used across the app, just centralized here).
///
/// LONG-PRESS is a genuinely separate, optional layer: after ~280ms hold
/// it grows a soft halo + very subtle circular "lens" under the touch
/// point via [LaundryGoMagnifier], on top of a slightly bigger scale
/// (1.04). It does not replace or gate the tap.
class LaundryGoPressable extends StatefulWidget {
  const LaundryGoPressable({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.pressScale = 0.985,
    this.enableLongPressEffect = true,
    this.longPressScale = 1.04,
    this.haloColor,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Extra callback fired when the long-press effect completes its hold
  /// threshold — purely additive, never required for the widget to work.
  final VoidCallback? onLongPress;

  final BorderRadius borderRadius;
  final double pressScale;
  final bool enableLongPressEffect;
  final double longPressScale;
  final Color? haloColor;

  @override
  State<LaundryGoPressable> createState() => _LaundryGoPressableState();
}

class _LaundryGoPressableState extends State<LaundryGoPressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  bool _tapPressed = false;
  bool _longPressed = false;
  Offset? _localPos;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _reduced => laundryGoReducedMotion(context);

  void _setTapPressed(bool v) {
    if (widget.onTap == null) return;
    setState(() => _tapPressed = v);
  }

  void _handleLongPress() {
    if (!widget.enableLongPressEffect || _reduced) return;
    setState(() => _longPressed = true);
    _controller.forward();
    HapticFeedback.selectionClick();
    widget.onLongPress?.call();
  }

  void _handleLongPressEnd() {
    if (!_longPressed) return;
    _controller.reverse();
    setState(() => _longPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final red = Theme.of(context).brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final halo = widget.haloColor ?? red;
    final scale = _reduced
        ? 1.0
        : (_longPressed
              ? widget.longPressScale
              : (_tapPressed ? widget.pressScale : 1.0));

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setTapPressed(true),
      onTapUp: (_) => _setTapPressed(false),
      onTapCancel: () => _setTapPressed(false),
      onTap: widget.onTap,
      onLongPressStart: (d) {
        _localPos = d.localPosition;
        _handleLongPress();
      },
      onLongPressMoveUpdate: (d) => _localPos = d.localPosition,
      onLongPressEnd: (_) => _handleLongPressEnd(),
      onLongPressCancel: _handleLongPressEnd,
      child: AnimatedScale(
        scale: scale,
        duration: _tapPressed
            ? LGMotion.micro
            : const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          clipBehavior: Clip.none,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              widget.child,
              if (widget.enableLongPressEffect && !_reduced)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) => LaundryGoMagnifier(
                        progress: _controller.value,
                        center: _localPos,
                        color: halo,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The soft circular "lens" that blooms under a long-press — an original
/// LaundryGo take (not a copy of any platform's UI): a translucent radial
/// halo plus a thin bright rim, centered on the touch point. Extremely
/// subtle by design — never a giant glass circle, never covers text.
class LaundryGoMagnifier extends StatelessWidget {
  const LaundryGoMagnifier({
    super.key,
    required this.progress,
    required this.center,
    required this.color,
  });

  /// 0.0 (no effect) → 1.0 (fully bloomed). Feed an [AnimationController]'s
  /// value straight in.
  final double progress;
  final Offset? center;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0 || center == null) return const SizedBox.shrink();
    return CustomPaint(
      painter: _MagnifierPainter(
        progress: progress,
        center: center!,
        color: color,
      ),
    );
  }
}

class _MagnifierPainter extends CustomPainter {
  _MagnifierPainter({
    required this.progress,
    required this.center,
    required this.color,
  });

  final double progress;
  final Offset center;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 26 + 10 * progress;
    final halo = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.16 * progress),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, halo);

    final rim = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Colors.white.withValues(alpha: 0.35 * progress);
    canvas.drawCircle(center, radius * 0.7, rim);
  }

  @override
  bool shouldRepaint(covariant _MagnifierPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.center != center ||
      oldDelegate.color != color;
}
