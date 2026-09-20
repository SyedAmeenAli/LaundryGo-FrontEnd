import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'widgets/status_pill.dart';

/// Admin Driver Detail — a driver's real standing (approve a pending
/// application, suspend/reactivate an existing one) and delivery stats.
/// Every button here genuinely mutates [AdminController]'s driver state.
class AdminDriverDetailScreen extends StatelessWidget {
  const AdminDriverDetailScreen({super.key, required this.driverId});

  final String driverId;

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
    final driver = controller.driverById(driverId);

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
                      label: driver.status.label,
                      color: driverStatusColor(context, driver.status),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(driver.image),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            driver.vehicle,
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
                                ' ${driver.rating}',
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
                      label: 'Deliveries Today',
                      value: '${driver.deliveriesToday}',
                    ),
                    _StatTile(
                      label: 'Completion Rate',
                      value: '${(driver.completionRate * 100).round()}%',
                      color: driver.completionRate >= 0.9 ? green : LGColors.warning,
                    ),
                    _StatTile(label: 'Joined', value: driver.joinedLabel),
                    _StatTile(label: 'Vehicle', value: driver.vehicle),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                _actionButton(context, controller, driver, green, red),
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
    AdminDriver driver,
    Color green,
    Color red,
  ) {
    switch (driver.status) {
      case DriverAccountStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  controller.suspendDriver(driverId);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('${driver.name} rejected.')),
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
                  controller.approveDriver(driverId);
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('${driver.name} approved.')),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const StadiumBorder(),
                  backgroundColor: green,
                ),
                child: const Text('Approve Driver'),
              ),
            ),
          ],
        );
      case DriverAccountStatus.active:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              controller.suspendDriver(driverId);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text('${driver.name} suspended.')),
              );
            },
            icon: const Icon(Icons.block, size: 16),
            label: const Text('Suspend Driver'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: const StadiumBorder(),
              foregroundColor: red,
              side: BorderSide(color: red),
            ),
          ),
        );
      case DriverAccountStatus.suspended:
        return SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () {
              controller.reactivateDriver(driverId);
              scaffoldMessengerKey.currentState?.showSnackBar(
                SnackBar(content: Text('${driver.name} reactivated.')),
              );
            },
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Reactivate Driver'),
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
