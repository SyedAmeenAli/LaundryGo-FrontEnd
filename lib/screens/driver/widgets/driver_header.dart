import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/motion/laundrygo_pressable.dart';
import '../../../data/mock_driver_data.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';

/// Shared Driver top bar — logo + driver name + notification bell. Kept
/// even simpler than Partner's: the driver never needs a search field
/// here, just "am I working, and is anything waiting for me."
class DriverHeader extends StatelessWidget {
  const DriverHeader({super.key, this.onNotificationTap});
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LGSpacing.md,
        LGSpacing.sm,
        LGSpacing.md,
        LGSpacing.sm,
      ),
      child: Row(
        children: [
          LaundryGoPressable(
            borderRadius: BorderRadius.circular(15),
            longPressScale: 1.025,
            haloColor: theme.colorScheme.primary,
            child: Image.asset(
              LaundryGoAssets.logoMark,
              height: 30,
              width: 30,
            ),
          ),
          const SizedBox(width: LGSpacing.sm),
          Text(
            MockDriverData.driverName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          LaundryGoPressable(
            borderRadius: BorderRadius.circular(20),
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 22,
                  color: theme.colorScheme.onSurface,
                ),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: LGColors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
