import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/support_strip.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';
import '../../state/cart_controller.dart';
import '../../state/orders_controller.dart';
import 'cart_screen.dart';
import 'notifications_screen.dart';

/// Screen — Orders ("Your Orders"). Segmented pill tabs (Active/Past),
/// the active-order card with a controlled (not giant) hero image, then
/// compact recent-order rows.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final order = MockCustomerData.activeOrder;
    final orders = context.watch<OrdersController>();
    final pastOrders = orders.pastOrders;
    final isEmpty = _active
        ? !orders.hasActiveOrder && pastOrders.isEmpty
        : pastOrders.isEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomerHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Your '),
                      TextSpan(
                        text: 'Orders',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Track, manage and reorder with ease.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: _SegmentedTabs(
              active: _active,
              pastCount: pastOrders.length,
              onChanged: (v) => setState(() => _active = v),
            ),
          ),
          if (isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.lg,
                LGSpacing.xl,
                LGSpacing.lg,
                LGSpacing.xl,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      LaundryGoAssets.noOrders,
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  Text(
                    _active ? 'No active orders' : 'No past orders',
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'When you book a pickup, it will show up here.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  LaundryGoButton(
                    label: 'Book a Pickup',
                    expand: false,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.services),
                  ),
                ],
              ),
            )
          else if (_active) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
              child: _ActiveOrderCard(order: order),
            ),
            if (pastOrders.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: SectionHeader(
                  title: 'Recent orders',
                  actionLabel: 'See all',
                  onAction: () => setState(() => _active = false),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Column(
                  children: [
                    for (final p in pastOrders)
                      Padding(
                        padding: const EdgeInsets.only(top: LGSpacing.sm),
                        child: _PastOrderRow(order: p),
                      ),
                  ],
                ),
              ),
            ],
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
              child: Column(
                children: [
                  for (final p in pastOrders)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: _PastOrderRow(order: p),
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              LGSpacing.xl,
            ),
            child: const SupportStrip(
              subtitle: 'Thanks for being part of a cleaner community.',
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.active,
    required this.pastCount,
    required this.onChanged,
  });

  final bool active;
  final int pastCount;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    Widget seg(String label, bool selected, VoidCallback onTap) => Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: LGMotion.component,
          padding: const EdgeInsets.symmetric(vertical: 14),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: selected ? red : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(28),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: selected
                  ? Colors.white
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
    return Row(
      children: [
        seg('Active Orders', active, () => onChanged(true)),
        seg('Past Orders ($pastCount)', !active, () => onChanged(false)),
      ],
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(LaundryGoAssets.foldedStack, fit: BoxFit.cover),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: red,
                          child: const Icon(
                            Icons.local_laundry_service_outlined,
                            size: 11,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'In Cleaning',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: LGColors.midnight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '#LG${order.id}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        LaundryGoAssets.logoMark,
                        width: 36,
                        height: 36,
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.partner.name,
                            style: theme.textTheme.titleSmall,
                          ),
                          Text(
                            'Wash & Fold · 6 items',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'OMR ${order.totalOmr.toStringAsFixed(3)}',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Total Amount',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(height: LGSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: _InfoIcon(
                        icon: Icons.calendar_today_outlined,
                        title: 'Picked Up',
                        subtitle: 'Mon, 15 Sep\n10:00 AM',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: theme.colorScheme.outline,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _InfoIcon(
                        icon: Icons.local_shipping_outlined,
                        title: 'Expected Delivery',
                        subtitle: 'Today, 4:20 PM',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.sm),
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.liveTracking),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Track Order',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: red,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 16, color: red),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  const _InfoIcon({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(icon, size: 14),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 9,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PastOrderRow extends StatelessWidget {
  const _PastOrderRow({required this.order});

  final PastOrderSummary order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final completed = order.status == PastOrderStatus.completed;
    final chipColor = completed ? green : theme.colorScheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showPastOrderSheet(context, order),
      child: Container(
      padding: const EdgeInsets.all(LGSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              order.image,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: LGSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.partnerName, style: theme.textTheme.titleSmall),
                Text(
                  '${order.service} · ${order.itemCount} items',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  order.date,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: chipColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  completed ? 'Completed' : 'Cancelled',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: chipColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'OMR ${order.priceOmr.toStringAsFixed(3)}',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: theme.brightness == Brightness.dark
                ? LGColors.redDark
                : LGColors.red,
          ),
        ],
      ),
      ),
    );
  }
}

void _showPastOrderSheet(BuildContext context, PastOrderSummary order) {
  showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      final green = theme.brightness == Brightness.dark
          ? LGColors.greenDark
          : LGColors.green;
      final completed = order.status == PastOrderStatus.completed;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      order.image,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: LGSpacing.smd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.partnerName, style: theme.textTheme.titleLarge),
                        Text(
                          '${order.service} · ${order.itemCount} items',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: LGSpacing.lg),
              _SheetRow(label: 'Date', value: order.date),
              _SheetRow(
                label: 'Status',
                value: completed ? 'Completed' : 'Cancelled',
                color: completed ? green : theme.colorScheme.onSurfaceVariant,
              ),
              _SheetRow(
                label: 'Total',
                value: 'OMR ${order.priceOmr.toStringAsFixed(3)}',
                bold: true,
              ),
              const SizedBox(height: LGSpacing.lg),
              LaundryGoButton(
                label: 'Reorder',
                showArrow: true,
                onPressed: () {
                  sheetContext.read<CartController>().addLine(
                    name: order.service,
                    descriptor: order.partnerName,
                    image: order.image,
                    unitPrice: order.priceOmr / order.itemCount,
                    quantity: order.itemCount,
                  );
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          '${order.service} from ${order.partnerName} added to cart.',
                        ),
                      ),
                    );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              const SizedBox(height: LGSpacing.sm),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
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
                (bold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
