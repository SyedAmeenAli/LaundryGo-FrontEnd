import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/driver_models.dart';
import '../../state/driver_controller.dart';
import 'workflow/customer_contact_screen.dart';
import 'workflow/navigation_screen.dart';

/// #64 Active Job — customer, addresses, items, and the one action that
/// actually matters right now: navigate to wherever this job needs the
/// driver next.
class DriverActiveJobScreen extends StatelessWidget {
  const DriverActiveJobScreen({super.key, required this.jobId});
  final String jobId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final job = context.watch<DriverController>().jobById(jobId);
    final toPickup = job.stage == DriverJobStage.accepted;

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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (toPickup ? LGColors.warning : green).withValues(
                          alpha: 0.12,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        toPickup ? 'Heading to Pickup' : 'Heading to Delivery',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: toPickup ? LGColors.warning : green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(job.customerImage),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.customerName,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Order #LG${job.id} · ${job.itemsSummary}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CustomerContactScreen(jobId: jobId),
                        ),
                      ),
                      icon: Icon(Icons.call_outlined, color: red),
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
                      _Stop(
                        icon: Icons.storefront_outlined,
                        label: 'Pickup',
                        address: job.pickupAddress,
                        done: !toPickup,
                        color: green,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: SizedBox(
                          height: 16,
                          child: VerticalDivider(
                            width: 1,
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                      _Stop(
                        icon: Icons.home_outlined,
                        label: 'Delivery',
                        address: job.deliveryAddress,
                        done: false,
                        color: red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          job.windowLabel,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        'OMR ${job.payoutOmr.toStringAsFixed(3)}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: green,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NavigationScreen(jobId: jobId),
                      ),
                    ),
                    icon: const Icon(Icons.navigation_outlined, size: 16),
                    label: Text(
                      toPickup ? 'Navigate to Pickup' : 'Navigate to Delivery',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: red,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stop extends StatelessWidget {
  const _Stop({
    required this.icon,
    required this.label,
    required this.address,
    required this.done,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String address;
  final bool done;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(done ? Icons.check : icon, size: 14, color: color),
        ),
        const SizedBox(width: LGSpacing.smd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(address, style: theme.textTheme.bodyMedium, maxLines: 2),
            ],
          ),
        ),
      ],
    );
  }
}
