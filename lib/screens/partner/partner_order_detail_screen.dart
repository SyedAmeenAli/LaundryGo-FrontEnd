import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/partner_models.dart';
import '../../state/partner_controller.dart';
import 'widgets/stage_chip.dart';
import 'workflow/handoff_screen.dart';
import 'workflow/inspection_screen.dart';
import 'workflow/packaging_screen.dart';
import 'workflow/processing_screen.dart';
import 'workflow/quality_control_screen.dart';

/// #52 Partner Order Detail — customer, garments, services, and the real
/// entry point into whichever workflow stage (#53-57) the order is
/// currently at. The primary action always maps to the order's actual
/// next stage, never a generic "Next".
class PartnerOrderDetailScreen extends StatelessWidget {
  const PartnerOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  Widget? _workflowFor(PartnerOrderStage stage, String orderId) {
    switch (stage) {
      case PartnerOrderStage.received:
      case PartnerOrderStage.inspecting:
        return InspectionScreen(orderId: orderId);
      case PartnerOrderStage.processing:
        return ProcessingScreen(orderId: orderId);
      case PartnerOrderStage.qualityControl:
        return QualityControlScreen(orderId: orderId);
      case PartnerOrderStage.packaging:
        return PackagingScreen(orderId: orderId);
      case PartnerOrderStage.readyForHandoff:
        return HandoffScreen(orderId: orderId);
      case PartnerOrderStage.handedOff:
        return null;
    }
  }

  String _actionLabel(PartnerOrderStage stage) {
    switch (stage) {
      case PartnerOrderStage.received:
      case PartnerOrderStage.inspecting:
        return 'Start Inspection';
      case PartnerOrderStage.processing:
        return 'Go to Processing';
      case PartnerOrderStage.qualityControl:
        return 'Go to Quality Control';
      case PartnerOrderStage.packaging:
        return 'Go to Packaging';
      case PartnerOrderStage.readyForHandoff:
        return 'Hand Off to Driver';
      case PartnerOrderStage.handedOff:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final order = context.watch<PartnerController>().orderById(orderId);
    final workflow = _workflowFor(order.stage, orderId);

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
                    StageChip(stage: order.stage),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(order.customerImage),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.customerName,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Order #LG${order.id} · ${order.service}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Items', style: theme.textTheme.titleLarge),
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
                        ListTile(
                          leading: const Icon(Icons.checkroom_outlined),
                          title: Text(order.items[i].garment),
                          subtitle: order.items[i].note != null
                              ? Text(
                                  order.items[i].note!,
                                  style: TextStyle(
                                    color: theme.brightness == Brightness.dark
                                        ? LGColors.redDark
                                        : LGColors.red,
                                  ),
                                )
                              : null,
                          trailing: Text(
                            'x${order.items[i].count}',
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                        if (i != order.items.length - 1)
                          Divider(height: 1, color: theme.colorScheme.outline),
                      ],
                    ],
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
                    children: [
                      _SummaryRow(label: 'Due', value: order.dueLabel),
                      _SummaryRow(
                        label: 'Total',
                        value: 'OMR ${order.totalOmr.toStringAsFixed(3)}',
                        bold: true,
                        color: green,
                      ),
                    ],
                  ),
                ),
                if (order.inspectionNotes != null &&
                    order.inspectionNotes!.isNotEmpty) ...[
                  const SizedBox(height: LGSpacing.lg),
                  Text('Inspection Notes', style: theme.textTheme.titleLarge),
                  const SizedBox(height: LGSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LGSpacing.md),
                    decoration: BoxDecoration(
                      color: LGColors.warning.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      order.inspectionNotes!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
                const SizedBox(height: LGSpacing.lg),
                if (workflow != null)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => workflow)),
                      icon: const Icon(Icons.arrow_forward, size: 16),
                      label: Text(_actionLabel(order.stage)),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: theme.brightness == Brightness.dark
                            ? LGColors.redDark
                            : LGColors.red,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LGSpacing.md),
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: green, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Order handed off and complete',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: green,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });
  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style:
                (bold
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
