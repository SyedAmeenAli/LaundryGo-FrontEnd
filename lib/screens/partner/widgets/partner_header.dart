import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/motion/laundrygo_pressable.dart';
import '../../../data/mock_partner_data.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';

/// Shared Partner top bar — logo, business name, notification bell. Only
/// tab roots show the logo; screens reached by push show a back arrow
/// instead, same rule as Customer's header.
class PartnerHeader extends StatelessWidget {
  const PartnerHeader({
    super.key,
    this.showBack = false,
    this.onBack,
    this.onNotificationTap,
  });

  final bool showBack;
  final VoidCallback? onBack;
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
          if (showBack)
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.arrow_back,
                  size: 22,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            )
          else ...[
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
              MockPartnerData.businessName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
