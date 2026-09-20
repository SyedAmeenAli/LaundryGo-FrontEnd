import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/radius.dart';
import '../design_system/typography.dart';
import 'glass_press.dart';

/// Primary filled CTA with real tactile press feedback — scales to
/// [LGMotion.pressedScale] (0.97) on press-down and springs back on
/// release, ~140ms (rule: "press 1.0 -> 0.98 -> 1.0, approximately
/// 100-160ms"). A theme `ElevatedButton` alone has no press-scale, so this
/// wraps one in a `GestureDetector` that drives it explicitly.
class LaundryGoButton extends StatefulWidget {
  const LaundryGoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expand = true,
    this.showArrow = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expand;

  /// Trailing arrow (rule: onboarding's Next/Get Started pill carries a
  /// subtle forward arrow).
  final bool showArrow;

  @override
  State<LaundryGoButton> createState() => _LaundryGoButtonState();
}

class _LaundryGoButtonState extends State<LaundryGoButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = widget.showArrow
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18),
            ],
          )
        : Text(widget.label);
    final button = AnimatedScale(
      scale: _pressed ? LGMotion.pressedScale : 1.0,
      duration: LGMotion.micro,
      curve: Curves.easeOut,
      child: GlassGlow(
        pressed: _pressed,
        borderRadius: BorderRadius.circular(999),
        glowColor: theme.brightness == Brightness.dark
            ? LGColors.redDark
            : LGColors.red,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: theme.elevatedButtonTheme.style?.copyWith(
            shape: const WidgetStatePropertyAll(StadiumBorder()),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 28),
            ),
            // The theme's default `minimumSize` is `Size.fromHeight(52)`,
            // i.e. min WIDTH = infinity — correct when this button is
            // wrapped `expand: true` in a bounded `SizedBox`, but inside a
            // `Row` (compact/pill usage) it demands infinite width and
            // renders as an invisible zero-size box. Override to a real
            // minimum instead of an infinite one.
            minimumSize: widget.expand
                ? null
                : const WidgetStatePropertyAll(Size(0, 52)),
          ),
          child: content,
        ),
      ),
    );
    final gestureWrapped = GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: button,
    );
    return widget.expand
        ? SizedBox(width: double.infinity, child: gestureWrapped)
        : gestureWrapped;
  }
}

/// Quiet secondary action (e.g. onboarding's Skip) — small, low-contrast,
/// never competing visually with the primary CTA.
class LaundryGoQuietButton extends StatelessWidget {
  const LaundryGoQuietButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.lightOnDark = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// True when this button sits over photography (e.g. onboarding's
  /// full-bleed hero) rather than a themed surface — forces a light color
  /// regardless of the app's light/dark mode, since it's legibility
  /// against the image (with its scrim) that matters here, not the theme.
  final bool lightOnDark;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = lightOnDark
        ? Colors.white.withValues(alpha: 0.92)
        : (brightness == Brightness.dark
              ? LGColors.textSecondaryDark
              : LGColors.textSecondaryLight);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: LGRadius.compactR),
      ),
      child: Text(
        label,
        style: LGTypography.button(color).copyWith(fontSize: 14),
      ),
    );
  }
}
