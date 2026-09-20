import 'package:flutter/material.dart';

import '../../../design_system/colors.dart';
import '../../../models/admin_models.dart';

/// The real colored status pill reused across every Admin list/detail
/// screen — one small widget, callers just supply label + color via the
/// `*Color` helpers below so every account/order/dispute state reads the
/// same way everywhere.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

Color partnerStatusColor(BuildContext context, PartnerAccountStatus status) {
  final theme = Theme.of(context);
  switch (status) {
    case PartnerAccountStatus.pending:
      return LGColors.warning;
    case PartnerAccountStatus.active:
      return theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
    case PartnerAccountStatus.suspended:
      return theme.brightness == Brightness.dark
          ? LGColors.redDark
          : LGColors.red;
  }
}

Color driverStatusColor(BuildContext context, DriverAccountStatus status) {
  final theme = Theme.of(context);
  switch (status) {
    case DriverAccountStatus.pending:
      return LGColors.warning;
    case DriverAccountStatus.active:
      return theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
    case DriverAccountStatus.suspended:
      return theme.brightness == Brightness.dark
          ? LGColors.redDark
          : LGColors.red;
  }
}

Color customerStatusColor(BuildContext context, CustomerAccountStatus status) {
  final theme = Theme.of(context);
  switch (status) {
    case CustomerAccountStatus.active:
      return theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
    case CustomerAccountStatus.blocked:
      return theme.brightness == Brightness.dark
          ? LGColors.redDark
          : LGColors.red;
  }
}

Color disputeStatusColor(BuildContext context, DisputeStatus status) {
  final theme = Theme.of(context);
  switch (status) {
    case DisputeStatus.open:
      return theme.brightness == Brightness.dark
          ? LGColors.redDark
          : LGColors.red;
    case DisputeStatus.investigating:
      return LGColors.warning;
    case DisputeStatus.resolved:
      return theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
    case DisputeStatus.rejected:
      return theme.colorScheme.onSurfaceVariant;
  }
}

Color orderStatusColor(BuildContext context, OrderStatus status) {
  final theme = Theme.of(context);
  switch (status) {
    case OrderStatus.pickedUp:
      return theme.colorScheme.onSurfaceVariant;
    case OrderStatus.inCleaning:
      return LGColors.warning;
    case OrderStatus.outForDelivery:
      return LGColors.info;
    case OrderStatus.delivered:
      return theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
  }
}

String orderStatusLabel(OrderStatus status) => switch (status) {
  OrderStatus.pickedUp => 'Picked Up',
  OrderStatus.inCleaning => 'In Cleaning',
  OrderStatus.outForDelivery => 'Out for Delivery',
  OrderStatus.delivered => 'Delivered',
};
