import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../state/admin_controller.dart';
import 'widgets/status_pill.dart';

/// Admin Order Detail — cross-partner order oversight: who ordered, which
/// partner is fulfilling it, and the two real admin interventions a
/// support order needs: issue a refund, or contact the customer directly.
class AdminOrderDetailScreen extends StatelessWidget {
  const AdminOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<AdminController>();
    final order = controller.orderById(orderId);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    const Spacer(),
                    StatusPill(
                      label: orderStatusLabel(order.status),
                      color: orderStatusColor(context, order.status),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(order.customerImage),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Order #${order.id} · ${order.partnerName}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Placed', value: order.placedLabel),
                      _SummaryRow(label: 'Partner', value: order.partnerName),
                      _SummaryRow(
                        label: 'Total',
                        value: 'OMR ${order.totalOmr.toStringAsFixed(3)}',
                        bold: true,
                        color: green,
                      ),
                      _SummaryRow(
                        label: 'Refund Status',
                        value: order.refunded ? 'Refunded' : 'Not refunded',
                        color: order.refunded
                            ? green
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => scaffoldMessengerKey.currentState
                            ?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contacting ${order.customerName}...',
                                ),
                              ),
                            ),
                        icon: const Icon(Icons.call_outlined, size: 16),
                        label: const Text('Contact Customer'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => scaffoldMessengerKey.currentState
                            ?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contacting ${order.partnerName}...',
                                ),
                              ),
                            ),
                        icon: const Icon(Icons.storefront_outlined, size: 16),
                        label: const Text('Contact Partner'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: order.refunded
                        ? null
                        : () {
                            controller.refundOrder(orderId);
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'OMR ${order.totalOmr.toStringAsFixed(3)} refunded to ${order.customerName}.',
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.replay_outlined, size: 16),
                    label: Text(
                      order.refunded ? 'Already Refunded' : 'Issue Refund',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: theme.brightness == Brightness.dark
                          ? LGColors.redDark
                          : LGColors.red,
                      shape: const StadiumBorder(),
                    ),
                  ),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style:
                (bold
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
