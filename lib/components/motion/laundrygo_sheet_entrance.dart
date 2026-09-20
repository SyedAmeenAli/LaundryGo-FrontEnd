import 'package:flutter/material.dart';

import 'laundrygo_pressable.dart';

/// The shared LaundryGo bottom-sheet entrance — a soft spring-like settle
/// (fade + slight upward translation + scale 0.985 → 1.0) layered on top
/// of `showModalBottomSheet`'s own slide-up, rather than each sheet
/// hand-rolling its own reveal. Wrap a sheet's `builder` content in this;
/// dismissal stays the framework's own (already a smooth slide-down).
class LaundryGoSheetEntrance extends StatefulWidget {
  const LaundryGoSheetEntrance({super.key, required this.child});

  final Widget child;

  @override
  State<LaundryGoSheetEntrance> createState() =>
      _LaundryGoSheetEntranceState();
}

class _LaundryGoSheetEntranceState extends State<LaundryGoSheetEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
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
    return AnimatedBuilder(
      animation: _curve,
      builder: (context, child) => Opacity(
        opacity: _curve.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _curve.value) * 14),
          child: Transform.scale(
            scale: 0.985 + 0.015 * _curve.value,
            child: child,
          ),
        ),
      ),
      child: widget.child,
    );
  }
}
