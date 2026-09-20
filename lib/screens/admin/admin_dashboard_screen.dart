import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/charts.dart';
import '../../data/mock_admin_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/admin_controller.dart';
import 'admin_analytics_screen.dart';
import 'admin_disputes_screen.dart';
import 'admin_partners_screen.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';

/// Admin Dashboard — the platform command center: today's volume across
/// every partner, pending approvals, and open disputes that need action
/// right now. Data first, photography only as a small supporting strip.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<AdminController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AdminNotificationsScreen(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text(
              'Platform overview across every partner and driver.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: LGSpacing.sm,
              crossAxisSpacing: LGSpacing.sm,
              childAspectRatio: 1.5,
              children: [
                StatCard(
                  value: 'OMR ${controller.todayRevenueOmr.toStringAsFixed(1)}',
                  label: "Today's Revenue",
                  icon: Icons.payments_outlined,
                  accent: theme.brightness == Brightness.dark
                      ? LGColors.greenDark
                      : LGColors.green,
                  trend: '+9%',
                ),
                StatCard(
                  value: '${controller.todayOrders}',
                  label: "Today's Orders",
                  icon: Icons.receipt_long_outlined,
                  trend: '+6 vs yesterday',
                ),
                StatCard(
                  value: '${controller.activePartnersCount}',
                  label: 'Active Partners',
                  icon: Icons.storefront_outlined,
                ),
                StatCard(
                  value: '${controller.activeDriversCount}',
                  label: 'Active Drivers',
                  icon: Icons.local_shipping_outlined,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              LGSpacing.sm,
            ),
            child: ChartCard(
              title: 'Platform Orders — Last 7 Days',
              trailing: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AdminAnalyticsScreen(),
                  ),
                ),
                child: const Text('Full Report'),
              ),
              child: LGBarChart(
                data: [
                  for (var i = 0; i < MockAdminData.weekLabels.length; i++)
                    BarDatum(
                      MockAdminData.weekLabels[i],
                      MockAdminData.weeklyOrders[i].toDouble(),
                    ),
                ],
              ),
            ),
          ),
          if (controller.pendingApprovalsCount > 0 ||
              controller.openDisputesCount > 0) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                LGSpacing.lg,
                LGSpacing.md,
                0,
              ),
              child: Text('Needs Attention', style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.all(LGSpacing.md),
              child: Column(
                children: [
                  if (controller.pendingApprovalsCount > 0)
                    _AttentionRow(
                      icon: Icons.pending_actions_outlined,
                      color: LGColors.warning,
                      title:
                          '${controller.pendingApprovalsCount} approval${controller.pendingApprovalsCount == 1 ? '' : 's'} pending',
                      subtitle: 'New partners and drivers awaiting review',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AdminPartnersScreen(),
                        ),
                      ),
                    ),
                  if (controller.openDisputesCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: LGSpacing.sm),
                      child: _AttentionRow(
                        icon: Icons.report_gmailerrorred_outlined,
                        color: theme.brightness == Brightness.dark
                            ? LGColors.redDark
                            : LGColors.red,
                        title:
                            '${controller.openDisputesCount} open dispute${controller.openDisputesCount == 1 ? '' : 's'}',
                        subtitle: 'Customer issues awaiting resolution',
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AdminDisputesScreen(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 110,
                child: Image.asset(
                  LaundryGoAssets.adminPartnerPerformance,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttentionRow extends StatelessWidget {
  const _AttentionRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
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
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
