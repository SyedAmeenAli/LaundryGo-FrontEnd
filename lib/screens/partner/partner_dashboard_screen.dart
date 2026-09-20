import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/charts.dart';
import '../../data/mock_partner_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/partner_models.dart';
import '../../state/partner_controller.dart';
import 'partner_order_detail_screen.dart';
import 'widgets/partner_header.dart';
import 'widgets/partner_order_row.dart';

/// #50 Partner Dashboard — the operations command center: today's volume,
/// capacity, alerts, and the orders that actually need attention right
/// now. Data first, photography only as a small supporting strip.
class PartnerDashboardScreen extends StatelessWidget {
  const PartnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<PartnerController>();
    final needsAttention = controller.orders
        .where(
          (o) =>
              o.stage != PartnerOrderStage.handedOff &&
              o.stage != PartnerOrderStage.readyForHandoff,
        )
        .take(3)
        .toList();
    final readyForPickup = controller.orders
        .where((o) => o.stage == PartnerOrderStage.readyForHandoff)
        .length;
    final todayRevenue = MockPartnerData.weeklyRevenueOmr.last;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PartnerHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text(
              'Here\'s what needs your attention today.',
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
                  value: '${controller.ordersInProgress}',
                  label: 'In Progress',
                  icon: Icons.local_laundry_service_outlined,
                  trend: '+2 vs yesterday',
                ),
                StatCard(
                  value: 'OMR ${todayRevenue.toStringAsFixed(1)}',
                  label: "Today's Revenue",
                  icon: Icons.payments_outlined,
                  accent: theme.brightness == Brightness.dark
                      ? LGColors.greenDark
                      : LGColors.green,
                  trend: '+12%',
                ),
                StatCard(
                  value: '$readyForPickup',
                  label: 'Ready for Pickup',
                  icon: Icons.inventory_2_outlined,
                  accent: theme.brightness == Brightness.dark
                      ? LGColors.greenDark
                      : LGColors.green,
                ),
                StatCard(
                  value: '${(controller.utilization * 100).round()}%',
                  label: 'Capacity Used',
                  icon: Icons.speed_outlined,
                  trendUp: controller.utilization < 0.85,
                  trend: controller.utilization >= 0.85
                      ? 'Near limit'
                      : 'Healthy',
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
              title: 'Orders — Last 7 Days',
              child: LGBarChart(
                data: [
                  for (var i = 0; i < MockPartnerData.weekLabels.length; i++)
                    BarDatum(
                      MockPartnerData.weekLabels[i],
                      MockPartnerData.weeklyOrders[i].toDouble(),
                    ),
                ],
              ),
            ),
          ),
          if (needsAttention.isNotEmpty) ...[
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
              padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
              child: Column(
                children: [
                  for (final o in needsAttention)
                    Padding(
                      padding: const EdgeInsets.only(top: LGSpacing.sm),
                      child: PartnerOrderRow(
                        order: o,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                PartnerOrderDetailScreen(orderId: o.id),
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
                  LaundryGoAssets.partnerStaffOperating,
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
