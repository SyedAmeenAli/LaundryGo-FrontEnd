import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../models/customer_models.dart';

const _kSteps = [
  (OrderStatus.pickedUp, Icons.check, 'Picked Up'),
  (OrderStatus.inCleaning, Icons.local_laundry_service_outlined, 'In Cleaning'),
  (
    OrderStatus.outForDelivery,
    Icons.local_shipping_outlined,
    'Out for Delivery',
  ),
  (OrderStatus.delivered, Icons.home_outlined, 'Delivered'),
];

/// The 4-stage order timeline (Picked Up / In Cleaning / Out for Delivery /
/// Delivered) shared by Live Tracking and Order Detail. [activeColor] lets
/// the two screens differ (tracking reads red/in-motion, order detail
/// reads green/reassuring) without duplicating the whole widget.
class StatusTimeline extends StatelessWidget {
  const StatusTimeline({
    super.key,
    required this.status,
    required this.timestamps,
    required this.activeColor,
  });

  final OrderStatus status;
  final List<String> timestamps;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeIndex = status.index;
    return Row(
      children: [
        for (var i = 0; i < _kSteps.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey('$i-$activeIndex'),
                  tween: Tween(
                    begin: i == activeIndex ? 1.12 : 1.0,
                    end: 1.0,
                  ),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: AnimatedContainer(
                    duration: LGMotion.component,
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i <= activeIndex
                          ? (i == activeIndex ? activeColor : LGColors.success)
                          : Colors.transparent,
                      border: Border.all(
                        color: i <= activeIndex
                            ? Colors.transparent
                            : theme.colorScheme.outline,
                        width: 1.4,
                      ),
                    ),
                    child: Icon(
                      _kSteps[i].$2,
                      size: 16,
                      color: i <= activeIndex
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _kSteps[i].$3,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: i == activeIndex
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (i < timestamps.length)
                  Text(
                    timestamps[i],
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (i != _kSteps.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  height: 2,
                  color: i < activeIndex
                      ? LGColors.success
                      : theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
