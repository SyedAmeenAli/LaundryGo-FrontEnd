import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/charts.dart';
import '../../data/mock_partner_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/partner_controller.dart';
import 'widgets/partner_header.dart';

/// #61 Analytics — real, data-driven Flutter charts (never generated chart
/// images) over orders, revenue, turnaround and completion rate.
class PartnerAnalyticsScreen extends StatefulWidget {
  const PartnerAnalyticsScreen({super.key});

  @override
  State<PartnerAnalyticsScreen> createState() => _PartnerAnalyticsScreenState();
}

class _PartnerAnalyticsScreenState extends State<PartnerAnalyticsScreen> {
  int _rangeIndex = 0;
  static const _ranges = ['7 Days', '30 Days'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    context.watch<PartnerController>();
    final scale = _rangeIndex == 0 ? 1.0 : 3.4;
    final totalOrders = MockPartnerData.weeklyOrders.fold<int>(
      0,
      (a, b) => a + b,
    );
    final totalRevenue = MockPartnerData.weeklyRevenueOmr.fold<double>(
      0,
      (a, b) => a + b,
    );

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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Analytics',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < _ranges.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () => setState(() => _rangeIndex = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _rangeIndex == i
                                  ? red
                                  : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _ranges[i],
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: _rangeIndex == i
                                    ? Colors.white
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
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
              childAspectRatio: 1.6,
              children: [
                StatCard(
                  value: '${(totalOrders * scale).round()}',
                  label: 'Total Orders',
                  icon: Icons.receipt_long_outlined,
                  trend: '+8%',
                ),
                StatCard(
                  value: 'OMR ${(totalRevenue * scale).toStringAsFixed(0)}',
                  label: 'Total Revenue',
                  icon: Icons.payments_outlined,
                  accent: green,
                  trend: '+14%',
                ),
                StatCard(
                  value: '${MockPartnerData.avgTurnaroundHours}h',
                  label: 'Avg Turnaround',
                  icon: Icons.timer_outlined,
                  trendUp: false,
                  trend: '-0.6h',
                ),
                StatCard(
                  value: '${(MockPartnerData.completionRate * 100).round()}%',
                  label: 'Completion Rate',
                  icon: Icons.check_circle_outline,
                  accent: green,
                  trend: 'Stable',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              0,
            ),
            child: ChartCard(
              title: 'Orders per Day',
              child: LGBarChart(
                color: red,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.xl,
            ),
            child: ChartCard(
              title: 'Revenue Trend (OMR)',
              child: LGLineChart(
                color: green,
                values: MockPartnerData.weeklyRevenueOmr,
                labels: MockPartnerData.weekLabels,
                valueFormatter: (v) => v.toStringAsFixed(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
