import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/partner_controller.dart';

/// #55 Quality Control — pass/flag decision per item before packaging.
class QualityControlScreen extends StatefulWidget {
  const QualityControlScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<QualityControlScreen> createState() => _QualityControlScreenState();
}

class _QualityControlScreenState extends State<QualityControlScreen> {
  late final Map<int, bool> _passed = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<PartnerController>();
    final order = controller.orderById(widget.orderId);
    final allDecided = _passed.length == order.items.length;
    final anyFlagged = _passed.values.any((p) => !p);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(
                  LaundryGoAssets.partnerQualityControl,
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
                          'Quality Control',
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
                    Text(
                      'Pass or flag each item',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < order.items.length; i++) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: LGSpacing.md,
                                vertical: LGSpacing.sm,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${order.items[i].garment} x${order.items[i].count}',
                                      style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => _passed[i] = true),
                                    icon: Icon(
                                      Icons.check_circle,
                                      color: _passed[i] == true
                                          ? green
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        setState(() => _passed[i] = false),
                                    icon: Icon(
                                      Icons.flag,
                                      color: _passed[i] == false
                                          ? (theme.brightness == Brightness.dark
                                                ? LGColors.redDark
                                                : LGColors.red)
                                          : theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (i != order.items.length - 1)
                              Divider(
                                height: 1,
                                color: theme.colorScheme.outline,
                              ),
                          ],
                        ],
                      ),
                    ),
                    if (anyFlagged) ...[
                      const SizedBox(height: LGSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(LGSpacing.md),
                        decoration: BoxDecoration(
                          color: LGColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 18,
                              color: LGColors.warning,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Flagged items will be sent back for re-processing.',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: LGSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: allDecided
                            ? () {
                                if (anyFlagged) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Flagged items sent back to Processing.',
                                      ),
                                    ),
                                  );
                                  setState(() => _passed.clear());
                                } else {
                                  controller.advanceStage(order.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Quality check passed — moved to Packaging.',
                                      ),
                                    ),
                                  );
                                  Navigator.of(context).pop();
                                }
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: theme.brightness == Brightness.dark
                              ? LGColors.redDark
                              : LGColors.red,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          anyFlagged
                              ? 'Send Flagged Items Back'
                              : 'Pass & Continue to Packaging',
                        ),
                      ),
                    ),
                    if (!allDecided)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Decide on every item to continue.',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
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
