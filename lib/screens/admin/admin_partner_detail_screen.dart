import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'admin_order_detail_screen.dart';
import 'widgets/admin_order_row.dart';
import 'widgets/status_pill.dart';

/// Admin Partner Detail — a partner's real standing (approve a pending
/// application, suspend/reactivate an existing one), stats, and their
/// most recent orders. Every button here genuinely mutates
/// [AdminController]'s partner state.
class AdminPartnerDetailScreen extends StatelessWidget {
  const AdminPartnerDetailScreen({super.key, required this.partnerId});

  final String partnerId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<AdminController>();
    final partner = controller.partnerById(partnerId);
    final recentOrders = controller.orders
        .where((o) => o.partnerName == partner.name)
        .take(3)
        .toList();

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
                      label: partner.status.label,
                      color: partnerStatusColor(context, partner.status),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        partner.image,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            partner.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            partner.category,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 13,
                                color: LGColors.ratingGold,
                              ),
                              Text(
                                ' ${partner.rating}',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: LGSpacing.sm,
                  crossAxisSpacing: LGSpacing.sm,
                  childAspectRatio: 2.1,
                  children: [
                    _StatTile(
                      label: 'Orders Today',
                      value: '${partner.ordersToday}',
                    ),
                    _StatTile(
                      label: 'Revenue (Month)',
                      value: 'OMR ${partner.revenueOmrMonth.toStringAsFixed(1)}',
                      color: green,
                    ),
                    _StatTile(label: 'Joined', value: partner.joinedLabel),
                    _StatTile(label: 'Address', value: partner.address),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Recent Orders', style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                if (recentOrders.isEmpty)
                  Text(
                    'No orders yet.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Column(
                    children: [
                      for (final o in recentOrders)
                        Padding(
                          padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                          child: AdminOrderRow(
                            order: o,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminOrderDetailScreen(orderId: o.id),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: LGSpacing.lg),
                _actionButton(context, controller, partner, theme, green, red),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    AdminController controller,
    AdminPartner partner,
    ThemeData theme,
    Color green,
    Color red,
  ) {
    switch (partner.status) {
      case PartnerAccountStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  controller.suspendPartner(partnerId);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('${partner.name} rejected.')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  foregroundColor: red,
                  side: BorderSide(color: red),
                ),
                child: const Text('Reject'),
              ),
            ),
            const SizedBox(width: LGSpacing.sm),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  controller.approvePartner(partnerId);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('${partner.name} approved.')),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  backgroundColor: green,
                ),
                child: const Text('Approve Partner'),
              ),
            ),
          ],
        );
      case PartnerAccountStatus.active:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              controller.suspendPartner(partnerId);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text('${partner.name} suspended.')),
              );
            },
            icon: const Icon(Icons.block, size: 16),
            label: const Text('Suspend Partner'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              foregroundColor: red,
              side: BorderSide(color: red),
            ),
          ),
        );
      case PartnerAccountStatus.suspended:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              controller.reactivatePartner(partnerId);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text('${partner.name} reactivated.')),
              );
            },
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Reactivate Partner'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              backgroundColor: green,
            ),
          ),
        );
    }
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
