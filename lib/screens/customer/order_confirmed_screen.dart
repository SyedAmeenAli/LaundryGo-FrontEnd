import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/status_timeline.dart';
import '../../components/customer/support_strip.dart';
import '../../components/laundrygo_button.dart';
import '../../components/motion/laundrygo_success_animation.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';
import '../../state/cart_controller.dart';
import 'notifications_screen.dart';

/// Screen — Order Confirmed. A clean success moment: scale-in check +
/// a handful of restrained confetti pieces (not a cartoon burst).
class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({super.key});

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: LGMotion.brand)
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final order = MockCustomerData.activeOrder;
    final total = context.watch<CartController>().total;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomerHeader(
                hasNotification: true,
                onNotificationTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              SizedBox(
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) => Opacity(
                        opacity: _controller.value.clamp(0, 1),
                        child: child,
                      ),
                      child: const _Confetti(),
                    ),
                    LaundryGoSuccessAnimation(color: green),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.headlineLarge,
                        children: [
                          const TextSpan(text: 'Order '),
                          TextSpan(
                            text: 'Confirmed!',
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your laundry is in good hands.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "We've received your order and will keep you updated at every step.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  LGSpacing.sm,
                ),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          LaundryGoAssets.foldedStack,
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
                            Text(
                              'Order #${order.id}',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              'Wash & Fold · 6 items',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Mon, 15 Sep 2024 · 10:00 AM',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'OMR ${total.toStringAsFixed(3)}',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(width: 4),
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: Text(
                  'What happens next?',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: StatusTimeline(
                  status: OrderStatus.inCleaning,
                  timestamps: const [
                    '10:00 AM\nMon, 15 Sep',
                    'Today, 1:30 PM',
                    'Today, 4:20 PM',
                    'Est. 5:00 PM',
                  ],
                  activeColor: theme.brightness == Brightness.dark
                      ? LGColors.redDark
                      : LGColors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: const SupportStrip(
                  subtitle: 'Thanks for choosing LaundryGo!',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  LGSpacing.xs,
                ),
                child: LaundryGoButton(
                  label: 'View Order',
                  showArrow: true,
                  onPressed: () =>
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.orderDetail),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  0,
                  LGSpacing.md,
                  LGSpacing.sm,
                ),
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil(
                        AppRoutes.customerHome,
                        (r) => false,
                      ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Confetti extends StatelessWidget {
  const _Confetti();

  @override
  Widget build(BuildContext context) {
    final colors = [
      LGColors.red,
      LGColors.green,
      LGColors.red.withValues(alpha: 0.4),
      LGColors.green.withValues(alpha: 0.4),
    ];
    final rnd = Random(7);
    return SizedBox(
      width: 220,
      height: 140,
      child: Stack(
        children: List.generate(8, (i) {
          final angle = rnd.nextDouble() * 2 * pi;
          final dist = 50 + rnd.nextDouble() * 28;
          final dx = 110 + cos(angle) * dist;
          final dy = 70 + sin(angle) * dist;
          return Positioned(
            left: dx,
            top: dy,
            child: Transform.rotate(
              angle: rnd.nextDouble() * pi,
              child: Container(
                width: 8,
                height: 12,
                decoration: BoxDecoration(
                  color: colors[i % colors.length],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
