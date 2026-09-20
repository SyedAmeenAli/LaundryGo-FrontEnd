import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/charts.dart';
import '../../data/mock_admin_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../state/admin_controller.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';

/// Admin Payouts — real per-partner payout amounts (revenue minus the
/// platform commission), each with a genuine "Mark as Paid" action.
class AdminPayoutsScreen extends StatelessWidget {
  const AdminPayoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<AdminController>();
    final totalPayout = controller.partners.fold<double>(
      0,
      (sum, p) => sum + controller.payoutFor(p),
    );

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
                child: Text('Payouts', style: theme.textTheme.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Owed This Month',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'OMR ${totalPayout.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'After ${(MockAdminData.platformCommissionRate * 100).round()}% platform commission',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
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
                  title: 'Platform Revenue — Last 7 Days',
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
                  0,
                ),
                child: Text('Per Partner', style: theme.textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  children: [
                    for (final p in controller.partners)
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
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  p.image,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: LGSpacing.smd),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: theme.textTheme.titleSmall,
                                    ),
                                    Text(
                                      'OMR ${controller.payoutFor(p).toStringAsFixed(2)}',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(color: green),
                                    ),
                                  ],
                                ),
                              ),
                              controller.isPayoutPaid(p.id)
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: green.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(
                                          20,
                                        ),
                                      ),
                                      child: Text(
                                        'Paid',
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        controller.markPayoutPaid(p.id);
                                        scaffoldMessengerKey.currentState
                                            ?.showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${p.name} marked as paid.',
                                                ),
                                              ),
                                            );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 8,
                                        ),
                                        shape: const StadiumBorder(),
                                      ),
                                      child: const Text('Mark Paid'),
                                    ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 110,
                    child: Image.asset(
                      LaundryGoAssets.adminPaymentsSupport,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
