import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';

class _AdminNotification {
  _AdminNotification({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
    this.read = false,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  bool read;
}

/// Admin Notifications — real operational alerts (new partner/driver
/// applications, disputes opened, payouts due), tap to mark read.
class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _items = [
    _AdminNotification(
      icon: Icons.storefront_outlined,
      title: 'New partner application',
      subtitle: 'LaundryHub submitted a business application for review.',
      time: '20m ago',
    ),
    _AdminNotification(
      icon: Icons.local_shipping_outlined,
      title: 'New driver application',
      subtitle: 'Huda Al Riyami applied to join as a delivery driver.',
      time: '1h ago',
    ),
    _AdminNotification(
      icon: Icons.report_gmailerrorred_outlined,
      title: 'New dispute opened',
      subtitle: 'Billing issue reported on order #LG2456 by Ahmed Al Balushi.',
      time: '3h ago',
    ),
    _AdminNotification(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Payout due',
      subtitle: 'FreshFold Laundry payout of OMR 741.40 is ready to process.',
      time: 'Yesterday',
      read: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _items) {
        n.read = true;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All notifications marked as read.')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                Text('Notifications', style: theme.textTheme.headlineLarge),
                const SizedBox(height: LGSpacing.lg),
                for (var i = 0; i < _items.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _items[i].read = true),
                      child: AnimatedContainer(
                        duration: LGMotion.component,
                        padding: const EdgeInsets.all(LGSpacing.md),
                        decoration: BoxDecoration(
                          color: _items[i].read
                              ? theme.colorScheme.surface
                              : red.withValues(alpha: 0.06),
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
                                color: red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(_items[i].icon, size: 18, color: red),
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
