import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../state/partner_controller.dart';

/// #53 Inspection — the real intake step: check items against the order,
/// log any pre-existing damage, then advance the order to Processing.
class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key, required this.orderId});
  final String orderId;

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final _notesController = TextEditingController();
  final Set<int> _checked = {};

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<PartnerController>();
    final order = controller.orderById(widget.orderId);
    final allChecked = _checked.length == order.items.length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 160,
                child: Image.asset(
                  LaundryGoAssets.partnerInspection,
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
                          'Inspection',
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
                      'Check each item on intake',
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
                            CheckboxListTile(
                              value: _checked.contains(i),
                              onChanged: (v) => setState(
                                () => v == true
                                    ? _checked.add(i)
                                    : _checked.remove(i),
                              ),
                              title: Text(
                                '${order.items[i].garment} x${order.items[i].count}',
                              ),
                              activeColor: green,
                              controlAffinity: ListTileControlAffinity.leading,
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
                    const SizedBox(height: LGSpacing.lg),
                    Text(
                      'Notes (damage, stains, special instructions)',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    TextField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'e.g. small stain on collar, documented before wash',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: allChecked
                            ? () {
                                if (_notesController.text.trim().isNotEmpty)
                                  controller.setInspectionNotes(
                                    order.id,
                                    _notesController.text.trim(),
                                  );
                                controller.completeInspection(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Inspection complete — moved to Processing.',
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
                        child: const Text('Complete Inspection'),
                      ),
                    ),
                    if (!allChecked)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Check off every item to continue.',
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
