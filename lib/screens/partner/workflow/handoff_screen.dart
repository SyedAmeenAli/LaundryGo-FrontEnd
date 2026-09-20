import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/partner_controller.dart';

/// #57 Ready for Driver / Handoff — the final real step: confirm the
/// order left the facility with a driver.
class HandoffScreen extends StatelessWidget {
  const HandoffScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<PartnerController>();
    final order = controller.orderById(orderId);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(
                  LaundryGoAssets.partnerHandoff,
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
                          'Driver Handoff',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #LG${order.id} · ${order.customerName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(LGSpacing.lg),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_shipping_outlined,
                            size: 40,
                            color: green,
                          ),
                          const SizedBox(height: LGSpacing.sm),
                          Text(
                            'Packaged and ready',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Confirm handoff once a driver collects this order.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          controller.advanceStage(order.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Order #LG${order.id} handed off to driver.',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check, size: 16),
                        label: const Text('Confirm Handoff'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: green,
                          shape: const StadiumBorder(),
                        ),
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
