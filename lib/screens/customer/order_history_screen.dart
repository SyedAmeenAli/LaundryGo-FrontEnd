import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';
import '../../state/orders_controller.dart';
import 'states/delivery_completed_screen.dart';

/// Full past-orders list with a real back header — reached from Profile,
/// distinct from the Orders tab's Active/Past toggle (this is history-only).
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final orders = context.watch<OrdersController>().pastOrders;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: theme.colorScheme.surface,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                Text(
                  'HISTORY',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Order '),
                      TextSpan(
                        text: 'History',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                if (orders.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: LGSpacing.xl),
                    child: Center(
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              LaundryGoAssets.noOrders,
                              height: 180,
                              width: 180,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: LGSpacing.lg),
                          Text(
                            'No order history yet',
                            style: theme.textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Completed and cancelled orders will show up here.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: LGSpacing.lg),
                          LaundryGoButton(
                            label: 'Book a Pickup',
                            expand: false,
                            onPressed: () =>
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.services),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  for (final o in orders)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: _HistoryRow(order: o),
                    ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.order});

  final PastOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final completed = order.status == PastOrderStatus.completed;
    final chipColor = completed ? green : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: completed
          ? () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DeliveryCompletedScreen(order: order),
              ),
            )
          : () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${order.partnerName} · ${order.service} · Cancelled',
                ),
              ),
            ),
      child: Container(
        padding: const EdgeInsets.all(LGSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                order.image,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.partnerName, style: theme.textTheme.titleSmall),
                  Text(
                    '${order.service} · ${order.itemCount} items',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    order.date,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: chipColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completed ? 'Completed' : 'Cancelled',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: chipColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'OMR ${order.priceOmr.toStringAsFixed(3)}',
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
