import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/bottom_nav.dart';
import '../../components/customer/map_panel.dart';
import '../../components/customer/status_timeline.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/cart_controller.dart';
import '../../models/customer_models.dart';
import 'driver_chat_screen.dart';
import 'notifications_screen.dart';

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final order = MockCustomerData.activeOrder;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final driverPos = LatLng(23.6050, 58.4550);
    final destination = LatLng(23.6180, 58.4700);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 280,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(LaundryGoAssets.driverHero, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
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
                      height: 80,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        LGSpacing.md,
                        LGSpacing.sm,
                        LGSpacing.md,
                        0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back,
                                size: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const NotificationsScreen(),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              for (final line in const [
                                'CLEAN',
                                'CLOTHES',
                                'HAPPIER',
                                'DAYS',
                              ])
                                Text(
                                  line,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 1.4,
                                    color: Colors.white70,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: LGSpacing.md,
                      right: LGSpacing.md,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
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
                                const TextSpan(text: 'On Its Way\nTo '),
                                TextSpan(
                                  text: 'You.',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Your fresh clothes are almost at your doorstep.',
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
                    '10:00 AM',
                    'Today, 1:30 PM',
                    'Today, 4:20 PM',
                    'Est. 5:00 PM',
                  ],
                  activeColor: red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  0,
                ),
                child: Stack(
                  children: [
                    MapPanel(
                      center: driverPos,
                      height: 190,
                      zoom: 13,
                      route: [driverPos, LatLng(23.6115, 58.4625), destination],
                      driverPosition: driverPos,
                      destination: destination,
                    ),
                    Positioned(
                      left: 10,
                      top: 10,
                      child: _Pill(
                        icon: Icons.podcasts,
                        label: 'Live Tracking',
                        sub: 'Your order is on the way',
                      ),
                    ),
                    Positioned(
                      right: 10,
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
                        child: const Text(
                          '5 min away',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: LGColors.midnight,
                          ),
                        ),
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
                child: _DriverCard(order: order),
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
              SizedBox(
                height: 74,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                  itemCount: order.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: LGSpacing.sm),
                  itemBuilder: (context, i) {
                    final item = order.items[i];
                    return Container(
                      width: 140,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item.image,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${item.count} items',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  item.label,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: green.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: green.withValues(alpha: 0.15),
                        radius: 18,
                        child: Icon(Icons.eco_outlined, color: green),
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
                ),
              ),
              const SizedBox(height: LGSpacing.xl),
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

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.smd),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(order.driverImage),
          ),
          const SizedBox(width: LGSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.driverName, style: theme.textTheme.titleSmall),
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
                Text(
                  'Your delivery partner',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(
            icon: Icons.call_outlined,
            label: 'Call',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Calling ${order.driverName}...')),
            ),
          ),
          const SizedBox(width: LGSpacing.sm),
          _RoundIconButton(
            icon: Icons.message_outlined,
            label: 'Message',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DriverChatScreen(order: order),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(icon, size: 16, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.sub});

  final IconData icon;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: LGColors.red),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: LGColors.midnight,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(fontSize: 9, color: LGColors.slate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
