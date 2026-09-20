import 'package:flutter/material.dart';

import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../models/admin_models.dart';
import 'status_pill.dart';

/// Compact driver row for Admin's Drivers list — avatar, vehicle, rating,
/// today's deliveries, account status. Tapping opens Driver Detail.
class AdminDriverRow extends StatelessWidget {
  const AdminDriverRow({super.key, required this.driver, required this.onTap});

  final AdminDriver driver;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(LGSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 26, backgroundImage: AssetImage(driver.image)),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    driver.vehicle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: LGColors.ratingGold,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${driver.rating} · ${driver.deliveriesToday} today',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            StatusPill(
              label: driver.status.label,
              color: driverStatusColor(context, driver.status),
            ),
          ],
        ),
      ),
    );
  }
}
