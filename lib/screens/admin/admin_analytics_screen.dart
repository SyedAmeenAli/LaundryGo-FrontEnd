import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/charts.dart';
import '../../data/mock_admin_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/admin_controller.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';

/// Admin Analytics — deeper platform reporting than the Dashboard's quick
/// glance: revenue trend, order volume, new-customer growth, and a
/// partner performance leaderboard, all from real (mock) data.
class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<AdminController>();
    final weekRevenue = MockAdminData.weeklyRevenueOmr.fold<double>(
      0,
      (a, b) => a + b,
    );
    final weekOrders = MockAdminData.weeklyOrders.fold<int>(0, (a, b) => a + b);
    final sortedPartners = [...controller.partners]
      ..sort((a, b) => b.revenueOmrMonth.compareTo(a.revenueOmrMonth));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminHeader(
                showBack: true,
                onBack: () => Navigator.of(context).maybePop(),
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
                child: Text('Analytics', style: theme.textTheme.headlineLarge),
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
                      value: 'OMR ${weekRevenue.toStringAsFixed(0)}',
                      label: 'Revenue (7d)',
                      icon: Icons.payments_outlined,
                      accent: green,
                      trend: '+11%',
                    ),
                    StatCard(
                      value: '$weekOrders',
                      label: 'Orders (7d)',
                      icon: Icons.receipt_long_outlined,
                      trend: '+8%',
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
                  title: 'Revenue Trend — Last 7 Days',
                  child: LGLineChart(
                    values: MockAdminData.weeklyRevenueOmr,
                    labels: MockAdminData.weekLabels,
                    valueFormatter: (v) => v.toStringAsFixed(0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.sm,
                ),
                child: ChartCard(
                  title: 'New Customers — Last 7 Days',
                  child: LGBarChart(
                    color: green,
                    data: [
                      for (var i = 0; i < MockAdminData.weekLabels.length; i++)
                        BarDatum(
                          MockAdminData.weekLabels[i],
                          MockAdminData.weeklyNewCustomers[i].toDouble(),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  0,
                ),
                child: Text(
                  'Partner Leaderboard',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  children: [
                    for (var i = 0; i < sortedPartners.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                        child: Container(
                          padding: const EdgeInsets.all(LGSpacing.sm),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 26,
                                height: 26,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${i + 1}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: LGSpacing.smd),
                              Expanded(
                                child: Text(
                                  sortedPartners[i].name,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                'OMR ${sortedPartners[i].revenueOmrMonth.toStringAsFixed(0)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
