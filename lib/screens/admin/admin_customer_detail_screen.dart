import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'widgets/status_pill.dart';

/// Admin Customer Detail — account standing (block/unblock) and lifetime
/// order stats. Every button genuinely mutates [AdminController]'s
/// customer state.
class AdminCustomerDetailScreen extends StatelessWidget {
  const AdminCustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<AdminController>();
    final customer = controller.customerById(customerId);
    final blocked = customer.status == CustomerAccountStatus.blocked;

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
                    StatusPill(
                      label: customer.status.label,
                      color: customerStatusColor(context, customer.status),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: AssetImage(customer.image),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            'Customer since ${customer.joinedLabel}',
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
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: LGSpacing.sm,
                  crossAxisSpacing: LGSpacing.sm,
                  childAspectRatio: 2.1,
                  children: [
                    _StatTile(
                      label: 'Total Orders',
                      value: '${customer.ordersCount}',
                    ),
                    _StatTile(
                      label: 'Lifetime Spend',
                      value: 'OMR ${customer.totalSpentOmr.toStringAsFixed(1)}',
                      color: green,
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                SizedBox(
                  width: double.infinity,
                  child: blocked
                      ? FilledButton.icon(
                          onPressed: () {
                            controller.unblockCustomer(customerId);
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text('${customer.name} unblocked.'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.check_circle_outline,
                            size: 16,
                          ),
                          label: const Text('Unblock Customer'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(),
                            backgroundColor: green,
                          ),
                        )
                      : OutlinedButton.icon(
                          onPressed: () {
                            controller.blockCustomer(customerId);
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text('${customer.name} blocked.'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.block, size: 16),
                          label: const Text('Block Customer'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(),
                            foregroundColor: red,
                            side: BorderSide(color: red),
                          ),
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
