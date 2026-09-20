import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/partner_controller.dart';

/// #56 Packaging — bag/label the finished order, then it's ready for the
/// driver.
class PackagingScreen extends StatefulWidget {
  const PackagingScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<PackagingScreen> createState() => _PackagingScreenState();
}

class _PackagingScreenState extends State<PackagingScreen> {
  bool _bagged = false;
  bool _labelled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<PartnerController>();
    final order = controller.orderById(widget.orderId);
    final ready = _bagged && _labelled;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(
                  LaundryGoAssets.partnerPackaging,
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
                        Text('Packaging', style: theme.textTheme.headlineSmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #LG${order.id} · ${order.itemCount} items',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Column(
                        children: [
                          CheckboxListTile(
                            value: _bagged,
                            onChanged: (v) =>
                                setState(() => _bagged = v ?? false),
                            title: const Text('Items bagged'),
                            activeColor: green,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          Divider(height: 1, color: theme.colorScheme.outline),
                          CheckboxListTile(
                            value: _labelled,
                            onChanged: (v) =>
                                setState(() => _labelled = v ?? false),
                            title: Text(
                              'Labelled #LG${order.id} — ${order.customerName}',
                            ),
                            activeColor: green,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: ready
                            ? () {
                                controller.advanceStage(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Packaged — ready for driver handoff.',
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
                        child: const Text('Mark Ready for Driver'),
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
