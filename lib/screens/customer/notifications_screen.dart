import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import 'notification_detail_screen.dart';

class _Notification {
  _Notification({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.read = false,
    this.orderRelated = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  bool read;
  final bool orderRelated;
}

/// Real notification state — tapping one marks it read and the unread dot
/// disappears immediately; "Mark all read" clears every dot at once and
/// confirms with a SnackBar.
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _items = [
    _Notification(
      icon: Icons.local_shipping_outlined,
      title: 'Driver is on the way',
      subtitle: 'Your order #LG2201 will arrive by 4:20 PM today.',
      time: '10m ago',
      orderRelated: true,
    ),
    _Notification(
      icon: Icons.local_laundry_service_outlined,
      title: 'Order in cleaning',
      subtitle: 'FreshFold Laundry started processing your items.',
      time: '2h ago',
      orderRelated: true,
    ),
    _Notification(
      icon: Icons.card_giftcard_outlined,
      title: 'New offer available',
      subtitle: 'Use LAUNDRY10 for 10% off your next order.',
      time: 'Yesterday',
    ),
    _Notification(
      icon: Icons.check_circle_outline,
      title: 'Order delivered',
      subtitle: 'Order #LG2188 was delivered and marked complete.',
      time: '3 days ago',
      read: true,
      orderRelated: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _items) {
        n.read = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read.')),
    );
  }

  void _clearAll() {
    setState(() => _items.clear());
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Notifications cleared.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final unreadCount = _items.where((n) => !n.read).length;

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
                    if (unreadCount > 0)
                      TextButton(
                        onPressed: _markAllRead,
                        child: Text(
                          'Mark all read',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: red,
                          ),
                        ),
                      ),
                    if (_items.isNotEmpty)
                      IconButton(
                        onPressed: _clearAll,
                        icon: Icon(
                          Icons.delete_sweep_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Text(
                  'UPDATES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Notifi'),
                      TextSpan(
                        text: 'cations',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                if (_items.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: LGSpacing.xl,
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              LaundryGoAssets.noNotifications,
                              height: 160,
                              width: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: LGSpacing.lg),
                          Text(
                            "You're all caught up",
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'New updates about your orders will show up here.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                for (var i = 0; i < _items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        setState(() => _items[i].read = true);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NotificationDetailScreen(
                              icon: _items[i].icon,
                              title: _items[i].title,
                              body: _items[i].subtitle,
                              time: _items[i].time,
                              isOrderUpdate: _items[i].orderRelated,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: LGMotion.component,
                        padding: const EdgeInsets.all(LGSpacing.md),
                        decoration: BoxDecoration(
                          color: _items[i].read
                              ? theme.colorScheme.surface
                              : green.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _items[i].icon,
                                size: 18,
                                color: green,
                              ),
                            ),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _items[i].title,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  Text(
                                    _items[i].subtitle,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _items[i].time,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedOpacity(
                              duration: LGMotion.micro,
                              opacity: _items[i].read ? 0 : 1,
                              child: Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: red,
                                  shape: BoxShape.circle,
                                ),
                              ),
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
      ),
    );
  }
}
