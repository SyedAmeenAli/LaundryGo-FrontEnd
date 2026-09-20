import 'package:flutter/material.dart';

import 'laundrygo_pressable.dart';

/// Long-press-only layer around a bottom-nav item's icon — tap keeps
/// going straight to the parent's own `GestureDetector.onTap`, so it can
/// never delay or intercept normal navigation (rule: "long press must not
/// break UX"). Holding the icon scales it 1.00 → 1.08 with a soft halo;
/// neighboring items stay put since each icon owns its own controller.
/// Shared by every role's bottom nav (Customer/Partner/Driver/Admin).
class LaundryGoAnimatedNavItem extends StatefulWidget {
  const LaundryGoAnimatedNavItem({
    super.key,
    required this.child,
    required this.haloColor,
  });

  final Widget child;
  final Color haloColor;

  @override
  State<LaundryGoAnimatedNavItem> createState() =>
      _LaundryGoAnimatedNavItemState();
}

class _LaundryGoAnimatedNavItemState extends State<LaundryGoAnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  bool _pressed = false;
  Offset? _localPos;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = laundryGoReducedMotion(context);
    return GestureDetector(
      onLongPressStart: (d) {
        if (reduced) return;
        _localPos = d.localPosition;
        setState(() => _pressed = true);
        _controller.forward();
      },
      onLongPressMoveUpdate: (d) => _localPos = d.localPosition,
      onLongPressEnd: (_) {
        _controller.reverse();
        setState(() => _pressed = false);
      },
      onLongPressCancel: () {
        _controller.reverse();
        setState(() => _pressed = false);
      },
      child: AnimatedScale(
        scale: _pressed ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (!reduced)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => LaundryGoMagnifier(
                      progress: _controller.value,
                      center: _localPos ?? const Offset(15, 15),
                      color: widget.haloColor,
                    ),
                  ),
                ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}
