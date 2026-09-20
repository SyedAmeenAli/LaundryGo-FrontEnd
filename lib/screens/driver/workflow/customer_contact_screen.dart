import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/driver_controller.dart';

/// #67 Customer / Contact — call or message the customer for this job.
class CustomerContactScreen extends StatelessWidget {
  const CustomerContactScreen({super.key, required this.jobId});
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

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: LGSpacing.lg),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(job.customerImage),
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    Text(
                      job.customerName,
                      style: theme.textTheme.headlineSmall,
                    ),
                    Text(
                      job.customerPhone,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: _ContactAction(
                      icon: Icons.call,
                      label: 'Call',
                      color: green,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Calling ${job.customerPhone}...'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: LGSpacing.md),
                  Expanded(
                    child: _ContactAction(
                      icon: Icons.chat_bubble_outline,
                      label: 'Message',
                      color: red,
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Opening chat with ${job.customerName}...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LGSpacing.xl),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(LGSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #LG${job.id}',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job.itemsSummary,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      job.deliveryAddress,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactAction extends StatelessWidget {
  const _ContactAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: LGSpacing.lg),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
