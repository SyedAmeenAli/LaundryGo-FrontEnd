import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/partner_controller.dart';

/// #54 Processing — the wash/dry-clean/iron step itself. A simple
/// real timer-style progress affordance, then advance to Quality Control.
class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<PartnerController>();
    final order = controller.orderById(widget.orderId);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(
                  LaundryGoAssets.partnerProcessing,
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
                          'Processing',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #LG${order.id} · ${order.service}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(LGSpacing.lg),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _started
                                ? Icons.local_laundry_service
                                : Icons.local_laundry_service_outlined,
                            size: 48,
                            color: LGColors.warning,
                          ),
                          const SizedBox(height: LGSpacing.sm),
                          Text(
                            _started
                                ? '${order.service} in progress...'
                                : 'Ready to start ${order.service.toLowerCase()}',
                            style: theme.textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.itemCount} items · ${order.customerName}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          if (!_started) {
                            setState(() => _started = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${order.service} started.'),
                              ),
                            );
                            return;
                          }
                          controller.advanceStage(order.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Processing complete — moved to Quality Control.',
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.brightness == Brightness.dark
                              ? LGColors.redDark
                              : LGColors.red,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          _started
                              ? 'Mark Processing Complete'
                              : 'Start ${order.service}',
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
