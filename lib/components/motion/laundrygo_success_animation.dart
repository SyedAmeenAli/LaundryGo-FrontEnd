import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import 'laundrygo_pressable.dart';

/// The shared LaundryGo completion moment — a check mark that overshoots
/// gently (0.82 → 1.05 → 1.0) inside a soft green halo, used by every
/// "you're done" screen (Payment Success, Booking Success, Order
/// Confirmed, Delivery Completed, Issue Submitted) instead of each one
/// hand-rolling its own `AnimationController`. Runs once on mount.
class LaundryGoSuccessAnimation extends StatefulWidget {
  const LaundryGoSuccessAnimation({
    super.key,
    this.size = 110,
    this.iconSize = 34,
    this.color,
    this.icon = Icons.check,
  });

  final double size;
  final double iconSize;
  final Color? color;
  final IconData icon;

  @override
  State<LaundryGoSuccessAnimation> createState() =>
      _LaundryGoSuccessAnimationState();
}

class _LaundryGoSuccessAnimationState extends State<LaundryGoSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 0.82,
        end: 1.05,
      ).chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 65,
    ),
    TweenSequenceItem(
      tween: Tween(
        begin: 1.05,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 35,
    ),
  ]).animate(_controller);
  late final Animation<double> _haloFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0, 0.7, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    if (laundryGoReducedMotion(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = widget.color ??
        (theme.brightness == Brightness.dark
            ? LGColors.greenDark
            : LGColors.green);
    final reduced = laundryGoReducedMotion(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: reduced ? 1 : _haloFade.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Transform.scale(
            scale: reduced ? 1.0 : _scale.value,
            child: Container(
              width: widget.size * 0.62,
              height: widget.size * 0.62,
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: widget.iconSize, color: green),
            ),
          ),
        ],
      ),
    );
  }
}
