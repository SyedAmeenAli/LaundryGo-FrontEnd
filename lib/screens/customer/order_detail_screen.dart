import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/bottom_nav.dart';
import '../../components/customer/status_timeline.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/cart_controller.dart';
import 'driver_chat_screen.dart';
import 'driver_contact_screen.dart';
import 'notifications_screen.dart';
import 'report_issue_screen.dart';
import 'states/cancellation_completed_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final order = MockCustomerData.activeOrder;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(LaundryGoAssets.foldedStack, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        LGSpacing.sm,
                        LGSpacing.sm,
                        LGSpacing.sm,
                        0,
                      ),
                      child: Row(
                        children: [
                          _Chrome(
                            icon: Icons.arrow_back,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            LaundryGoAssets.logoHorizontal,
                            height: 24,
                          ),
                          const Spacer(),
                          _Chrome(
                            icon: Icons.notifications_outlined,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            ),
                            badge: true,
                          ),
                          const SizedBox(width: 4),
                          _Chrome(
                            icon: Icons.more_horiz,
                            onTap: () => showModalBottomSheet<void>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (sheetContext) => SafeArea(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.share_outlined),
                                      title: const Text('Share order'),
                                      onTap: () {
                                        Navigator.of(sheetContext).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Order #${order.id} link copied.',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.support_agent_outlined,
                                      ),
                                      title: const Text('Contact support'),
                                      onTap: () {
                                        Navigator.of(sheetContext).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Connecting you to support...',
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.report_gmailerrorred_outlined,
                                      ),
                                      title: const Text('Report an issue'),
                                      onTap: () {
                                        Navigator.of(sheetContext).pop();
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ReportIssueScreen(
                                              orderId: order.id,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.cancel_outlined,
                                        color:
                                            theme.brightness == Brightness.dark
                                            ? LGColors.redDark
                                            : LGColors.red,
                                      ),
                                      title: const Text('Cancel order'),
                                      onTap: () {
                                        Navigator.of(sheetContext).pop();
                                        showDialog<void>(
                                          context: context,
                                          builder: (dialogContext) => AlertDialog(
                                            title: const Text(
                                              'Cancel this order?',
                                            ),
                                            content: const Text(
                                              'Any payment made will be refunded within 5 business days.',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(dialogContext)
                                                        .pop(),
                                                child: const Text('Keep Order'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                  Navigator.of(
                                                    context,
                                                  ).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CancellationCompletedScreen(
                                                            orderId: order.id,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'Cancel Order',
                                                  style: TextStyle(
                                                    color:
                                                        theme.brightness ==
                                                            Brightness.dark
                                                        ? LGColors.redDark
                                                        : LGColors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER #LG${order.id}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.headlineMedium,
                        children: [
                          TextSpan(
                            text: 'In ',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text: 'Cleaning',
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Your clothes are in good hands.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  0,
                ),
                child: StatusTimeline(
                  status: order.status,
                  timestamps: const [
                    '10:00 AM\nMon, 15 Sep',
                    'Today, 1:30 PM',
                    'Expected\nToday, 4:20 PM',
                    'Est. 5:00 PM',
                  ],
                  activeColor: green,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: green.withValues(alpha: 0.15),
                        child: Icon(Icons.auto_awesome, size: 16, color: green),
                      ),
                      const SizedBox(width: LGSpacing.smd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your items are being professionally cleaned and cared for.',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              "We'll notify you as soon as they're out for delivery.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Order Details',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward, size: 14),
                      label: const Text('View all'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Column(
                  children: [
                    for (final item in order.items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                item.image,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.count} items',
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Text(
                                    item.label,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'OMR ${item.price!.toStringAsFixed(3)}',
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          'Total Amount',
                          style: theme.textTheme.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          'OMR ${order.totalOmr.toStringAsFixed(3)}',
                          style: theme.textTheme.headlineSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Text(
                  'Pickup & Delivery',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _AddressCard(
                        icon: Icons.location_on_outlined,
                        title: 'Pickup Address',
                        body: '${order.pickupAddress}\n${order.pickupTime}',
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: _AddressCard(
                        icon: Icons.home_outlined,
                        title: 'Delivery Address',
                        body: '${order.deliveryAddress}\n${order.deliveryEta}',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  0,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DriverContactScreen(order: order),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(LGSpacing.smd),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(order.driverImage),
                        ),
                        const SizedBox(width: LGSpacing.smd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.driverName,
                                style: theme.textTheme.titleSmall,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: LGColors.ratingGold,
                                  ),
                                  Text(
                                    ' ${order.driverRating} (${order.driverDeliveries} deliveries)',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Calling ${order.driverName}...',
                                    ),
                                  ),
                                ),
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Icon(
                                Icons.call_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: LGSpacing.sm),
                        Material(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DriverChatScreen(order: order),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(9),
                              child: Icon(
                                Icons.message_outlined,
                                size: 16,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color:
                        (theme.brightness == Brightness.dark
                                ? LGColors.redDark
                                : LGColors.red)
                            .withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                (theme.brightness == Brightness.dark
                                        ? LGColors.redDark
                                        : LGColors.red)
                                    .withValues(alpha: 0.12),
                            child: Icon(
                              Icons.eco_outlined,
                              color: theme.brightness == Brightness.dark
                                  ? LGColors.redDark
                                  : LGColors.red,
                            ),
                          ),
                          const SizedBox(width: LGSpacing.smd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'A cleaner, brighter you awaits.',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  'Thanks for choosing LaundryGo!',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: LGSpacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(
                            const SnackBar(
                              content: Text('Connecting you to support...'),
                            ),
                          ),
                          icon: const Icon(
                            Icons.support_agent_outlined,
                            size: 16,
                          ),
                          label: const Text('Need Help?'),
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: LGSpacing.md),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LaundryGoBottomNav(
        currentIndex: 1,
        cartCount: context.watch<CartController>().itemCount,
        onSelect: (i) => Navigator.of(context).pop(),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return Container(
      padding: const EdgeInsets.all(LGSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: green),
          const SizedBox(height: 4),
          Text(title, style: theme.textTheme.titleSmall),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Chrome extends StatelessWidget {
  const _Chrome({required this.icon, required this.onTap, this.badge = false});

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 16, color: LGColors.midnight),
              if (badge)
                const Positioned(
                  right: -2,
                  top: -2,
                  child: CircleAvatar(radius: 3, backgroundColor: LGColors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
