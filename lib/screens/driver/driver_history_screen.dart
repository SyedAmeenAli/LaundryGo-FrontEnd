import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/charts.dart';
import '../../data/mock_driver_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/driver_controller.dart';
import 'widgets/driver_header.dart';
import 'widgets/job_card.dart';

/// #70 Driver History — completed jobs plus a real weekly earnings chart.
class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final history = context.watch<DriverController>().history;
    final totalEarnings = history.fold<double>(
      0,
      (sum, j) => sum + j.payoutOmr,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DriverHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text('History', style: theme.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '${history.length}',
                    label: 'Completed Jobs',
                    icon: Icons.check_circle_outline,
                    accent: green,
                  ),
                ),
                const SizedBox(width: LGSpacing.sm),
                Expanded(
                  child: StatCard(
                    value: 'OMR ${totalEarnings.toStringAsFixed(2)}',
                    label: 'Total Earned',
                    icon: Icons.payments_outlined,
                    accent: green,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: ChartCard(
              title: 'Earnings This Week (OMR)',
              child: LGLineChart(
                color: green,
                values: MockDriverData.weeklyEarningsOmr,
                labels: MockDriverData.weekLabels,
                valueFormatter: (v) => v.toStringAsFixed(1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.sm,
            ),
            child: Text('Completed', style: theme.textTheme.titleLarge),
          ),
          if (history.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LGSpacing.md,
                vertical: LGSpacing.lg,
              ),
              child: Center(
                child: Text(
                  'No completed jobs yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                0,
                LGSpacing.md,
                LGSpacing.xl,
              ),
              child: Column(
                children: [
                  for (final job in history)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: JobCard(
                        job: job,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${job.customerName} · ${job.itemsSummary} · Delivered ${job.windowLabel}',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
