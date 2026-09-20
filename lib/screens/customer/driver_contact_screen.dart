import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import 'driver_chat_screen.dart';

/// Driver Contact / Detail — a compact real-time card for the driver
/// handling this order: photo, rating, live status, and genuine Call /
/// Message actions.
class DriverContactScreen extends StatelessWidget {
  const DriverContactScreen({super.key, required this.order});

  final LaundryOrder order;

  static const _statusLabel = {
    OrderStatus.pickedUp: 'Picked up your order',
    OrderStatus.inCleaning: 'At the laundry facility',
    OrderStatus.outForDelivery: 'On the way to you',
    OrderStatus.delivered: 'Delivered your order',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final statusText = _statusLabel[order.status] ?? 'On the way';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: LGSpacing.lg),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(order.driverImage),
                    ),
                    const SizedBox(height: LGSpacing.sm),
                    Text(order.driverName, style: theme.textTheme.headlineSmall),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: LGColors.ratingGold),
                        Text(
                          ' ${order.driverRating} · ${order.driverDeliveries} deliveries',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(LGSpacing.md),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: green.withValues(alpha: 0.15),
                      child: Icon(Icons.local_shipping_outlined, color: green),
                    ),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Delivery status', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          Text(statusText, style: theme.textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(LGSpacing.md),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(Icons.two_wheeler_outlined, size: 20, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: LGSpacing.smd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vehicle', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          Text('Delivery scooter · OM 2290', style: theme.textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Calling ${order.driverName}...')),
                      ),
                      icon: const Icon(Icons.call_outlined, size: 18),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DriverChatScreen(order: order),
                        ),
                      ),
                      icon: const Icon(Icons.message_outlined, size: 18),
                      label: const Text('Message'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: red,
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
