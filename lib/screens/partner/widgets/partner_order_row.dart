import 'package:flutter/material.dart';

import '../../../design_system/spacing.dart';
import '../../../models/partner_models.dart';
import 'stage_chip.dart';

/// Compact order row shared by Dashboard and Orders — customer avatar,
/// service, item count, due time, stage chip. Tapping opens Order Detail.
class PartnerOrderRow extends StatelessWidget {
  const PartnerOrderRow({super.key, required this.order, required this.onTap});

  final PartnerOrder order;
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
            CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(order.customerImage),
            ),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          order.customerName,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '#LG${order.id}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${order.service} · ${order.itemCount} items',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        order.dueLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StageChip(stage: order.stage),
                const SizedBox(height: 4),
                Text(
                  'OMR ${order.totalOmr.toStringAsFixed(3)}',
                  style: theme.textTheme.titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
