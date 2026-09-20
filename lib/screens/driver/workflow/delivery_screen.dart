import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/driver_controller.dart';
import 'completion_screen.dart';

/// #68 Delivery — confirm handoff to the customer at their door.
class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key, required this.jobId});
  final String jobId;

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  bool _handedOver = false;

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
                  LaundryGoAssets.driverAtCustomerHome,
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
                          'Confirm Delivery',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${job.customerName} · Order #LG${job.id}',
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
                      child: Row(
                        children: [
                          Icon(Icons.home_outlined, size: 18, color: green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              job.deliveryAddress,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    CheckboxListTile(
                      value: _handedOver,
                      onChanged: (v) =>
                          setState(() => _handedOver = v ?? false),
                      title: const Text('Order handed to the customer'),
                      activeColor: green,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: LGSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _handedOver
                            ? () {
                                controller.confirmDelivery(job.id);
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CompletionScreen(jobId: job.id),
                                  ),
                                );
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: green,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('Complete Delivery'),
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
