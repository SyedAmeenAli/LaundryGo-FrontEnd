import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../main.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'admin_order_detail_screen.dart';
import 'widgets/status_pill.dart';

/// Admin Dispute Detail — the customer's issue, the order it refers to,
/// and the real resolution actions (investigate/resolve/reject). Every
/// button genuinely mutates [AdminController]'s dispute state.
class AdminDisputeDetailScreen extends StatelessWidget {
  const AdminDisputeDetailScreen({super.key, required this.disputeId});

  final String disputeId;

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
    final dispute = controller.disputeById(disputeId);
    final resolved =
        dispute.status == DisputeStatus.resolved ||
        dispute.status == DisputeStatus.rejected;

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
                      label: dispute.status.label,
                      color: disputeStatusColor(context, dispute.status),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(dispute.customerImage),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dispute.type.label,
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            '${dispute.customerName} · Order #${dispute.orderId}',
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
                Text('Description', style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Text(
                    dispute.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          AdminOrderDetailScreen(orderId: dispute.orderId),
                    ),
                  ),
                  icon: const Icon(Icons.receipt_long_outlined, size: 16),
                  label: Text('View Order #${dispute.orderId}'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                if (resolved)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LGSpacing.md),
                    decoration: BoxDecoration(
                      color:
                          disputeStatusColor(
                            context,
                            dispute.status,
                          ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          dispute.status == DisputeStatus.resolved
                              ? Icons.check_circle
                              : Icons.cancel_outlined,
                          color: disputeStatusColor(context, dispute.status),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          dispute.status == DisputeStatus.resolved
                              ? 'Dispute resolved'
                              : 'Dispute rejected',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: disputeStatusColor(context, dispute.status),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  if (dispute.status == DisputeStatus.open)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          controller.investigateDispute(disputeId);
                          scaffoldMessengerKey.currentState?.showSnackBar(
                            const SnackBar(
                              content: Text('Dispute moved to investigating.'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.search, size: 16),
                        label: const Text('Start Investigating'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  const SizedBox(height: LGSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.rejectDispute(disputeId);
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              const SnackBar(content: Text('Dispute rejected.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(),
                            foregroundColor: red,
                            side: BorderSide(color: red),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: LGSpacing.sm),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            controller.resolveDispute(disputeId);
                            scaffoldMessengerKey.currentState?.showSnackBar(
                              const SnackBar(content: Text('Dispute resolved.')),
                            );
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(),
                            backgroundColor: green,
                          ),
                          child: const Text('Mark Resolved'),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
