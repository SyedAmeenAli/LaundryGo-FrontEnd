import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/driver_controller.dart';

/// #65 Pickup — confirm collection from the partner facility.
class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key, required this.jobId});
  final String jobId;

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<DriverController>();
    final job = controller.jobById(widget.jobId);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 180,
                child: Image.asset(
                  LaundryGoAssets.driverPickupScene,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
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
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.arrow_back, size: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: LGSpacing.sm),
                        Text(
                          'Confirm Pickup',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job.partnerName} · Order #LG${job.id}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.itemsSummary,
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'for ${job.customerName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    CheckboxListTile(
                      value: _confirmed,
                      onChanged: (v) => setState(() => _confirmed = v ?? false),
                      title: const Text(
                        'I have collected the bagged order from the partner',
                      ),
                      activeColor: green,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: LGSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _confirmed
                            ? () {
                                controller.confirmPickup(job.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Pickup confirmed — heading to delivery.',
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.brightness == Brightness.dark
                              ? LGColors.redDark
                              : LGColors.red,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Confirm Pickup'),
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
