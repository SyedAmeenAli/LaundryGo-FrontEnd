import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';

/// Compact page-progress dots (rule: "do not use giant dots") — the
/// selected dot widens and turns brand red, others stay a soft neutral.
/// Reused wherever a flow has a small, known number of steps (onboarding
/// today; any future multi-step flow later).
class LaundryGoPageIndicator extends StatelessWidget {
  const LaundryGoPageIndicator({
    super.key,
    required this.count,
    required this.index,
  });

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final red = brightness == Brightness.dark ? LGColors.redDark : LGColors.red;
    final inactive = brightness == Brightness.dark
        ? LGColors.borderDark
        : LGColors.cloud;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final selected = i == index;
        return AnimatedContainer(
          duration: LGMotion.component,
          curve: LGMotion.curve,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: selected ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: selected ? red : inactive,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
