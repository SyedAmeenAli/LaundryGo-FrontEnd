import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/support_strip.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/cart_controller.dart';
import '../../state/location_controller.dart';
import 'notifications_screen.dart';
import 'states/payment_failure_screen.dart';

enum _PaymentMethod { card, wallet, bank, cash }

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentMethod _method = _PaymentMethod.card;

  static const _options = [
    (
      _PaymentMethod.card,
      Icons.credit_card,
      'Credit / Debit Card',
      'Visa, Mastercard, Maestro',
    ),
    (
      _PaymentMethod.wallet,
      Icons.account_balance_wallet_outlined,
      'Mobile Wallet',
      'Apple Pay, Google Pay',
    ),
    (
      _PaymentMethod.bank,
      Icons.account_balance_outlined,
      'Bank Transfer',
      'Direct bank transfer',
    ),
    (
      _PaymentMethod.cash,
      Icons.payments_outlined,
      'Cash on Delivery',
      'Pay when we deliver',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartController>();
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Material(
                      color: theme.colorScheme.surface,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Image.asset(LaundryGoAssets.logoHorizontal, height: 28),
                    const Spacer(),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => showCityPicker(
                        context,
                        context.read<LocationController>(),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            context.watch<LocationController>().city,
                            style: theme.textTheme.labelLarge,
                          ),
                          const Icon(Icons.expand_more, size: 16),
                        ],
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 20,
                        color: theme.colorScheme.onSurface,
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CHECKOUT',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineLarge,
                              children: [
                                const TextSpan(text: 'Payment\n'),
                                TextSpan(
                                  text: 'Method.',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Choose a secure and convenient way to pay.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    // Controlled payment-card visual — a small icon composition, not a photo hero.
                    SizedBox(
                      width: 96,
                      height: 96,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 10,
                            child: Container(
                              width: 66,
                              height: 44,
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 14,
                            top: 0,
                            child: Container(
                              width: 66,
                              height: 44,
                              decoration: BoxDecoration(
                                color: red,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.wifi,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                              ),
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
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < _options.length; i++) ...[
                        _PaymentOptionRow(
                          icon: _options[i].$2,
                          title: _options[i].$3,
                          subtitle: _options[i].$4,
                          selected: _method == _options[i].$1,
                          onTap: () => setState(() => _method = _options[i].$1),
                        ),
                        if (i != _options.length - 1)
                          Divider(height: 1, color: theme.colorScheme.outline),
                      ],
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
                child: Text(
                  'Billing Summary',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      _Row(
                        label: 'Subtotal',
                        value: 'OMR ${cart.subtotal.toStringAsFixed(3)}',
                      ),
                      _Row(
                        label: 'Delivery Fee',
                        value:
                            'OMR ${CartController.deliveryFee.toStringAsFixed(3)}',
                      ),
                      _Row(
                        label: 'Discount',
                        value: '- OMR ${cart.discount.toStringAsFixed(3)}',
                        color: green,
                      ),
                      const Divider(height: LGSpacing.lg),
                      _Row(
                        label: 'Total Amount',
                        value: 'OMR ${cart.total.toStringAsFixed(3)}',
                        bold: true,
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
                child: const SupportStrip(
                  subtitle: 'Thanks for choosing LaundryGo!',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  LGSpacing.lg,
                ),
                child: LaundryGoButton(
                  label: 'Pay OMR ${cart.total.toStringAsFixed(3)}',
                  showArrow: true,
                  onPressed: () {
                    // Bank Transfer is held for manual reconciliation in
                    // this demo — every other method succeeds instantly.
                    if (_method == _PaymentMethod.bank) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaymentFailureScreen(),
                        ),
                      );
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.orderConfirmed);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOptionRow extends StatelessWidget {
  const _PaymentOptionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LGSpacing.md,
          vertical: LGSpacing.smd,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? red : theme.colorScheme.outline,
                  width: 1.6,
                ),
              ),
              alignment: Alignment.center,
              child: selected
                  ? Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: red,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: LGSpacing.smd),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? red.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 18,
                color: selected ? red : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: red),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
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
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold
                  ? theme.textTheme.titleMedium
                  : theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
            ),
          ),
          Text(
            value,
            style:
                (bold
                        ? theme.textTheme.headlineSmall
                        : theme.textTheme.bodyMedium)
                    ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
