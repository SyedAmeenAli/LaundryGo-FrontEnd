import 'package:flutter/material.dart';

import '../../../design_system/spacing.dart';
import '../../../models/admin_models.dart';
import 'status_pill.dart';

/// Compact order row shared by Admin's Dashboard and Orders — customer
/// avatar, partner name, total, status pill. Tapping opens Order Detail.
class AdminOrderRow extends StatelessWidget {
  const AdminOrderRow({super.key, required this.order, required this.onTap});

  final AdminOrderSummary order;
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
                        '#${order.id}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '${order.partnerName} · ${order.placedLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (order.refunded)
                    Text(
                      'Refunded',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusPill(
                  label: orderStatusLabel(order.status),
                  color: orderStatusColor(context, order.status),
                ),
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
