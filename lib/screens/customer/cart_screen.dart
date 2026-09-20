import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/support_strip.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/cart_controller.dart';
import 'notifications_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();
  String? _promoError;

  void _applyPromo(CartController cart) {
    final ok = cart.applyPromo(_promoController.text);
    setState(() => _promoError = ok ? null : 'Invalid code');
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '"${_promoController.text.trim().toUpperCase()}" applied — 10% off.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartController>();
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    if (cart.lines.isEmpty) {
      return Column(
        children: [
          CustomerHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(LGSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        LaundryGoAssets.emptyCart,
                        height: 180,
                        width: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Text(
                      'Your cart is empty',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a service to get your laundry moving.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    LaundryGoButton(
                      label: 'Browse Services',
                      expand: false,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.services),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }

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
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Your '),
                      TextSpan(
                        text: 'Cart',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Review your items and proceed to checkout.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < cart.lines.length; i++)
                    AnimatedSize(
                      duration: LGMotion.component,
                      child: Column(
                        children: [
                          _CartRow(index: i, cart: cart),
                          if (i != cart.lines.length - 1)
                            Divider(
                              height: 1,
                              color: theme.colorScheme.outline,
                            ),
                        ],
                      ),
                    ),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.services),
                    child: Container(
                      padding: const EdgeInsets.all(LGSpacing.md),
                      decoration: BoxDecoration(
                        color: green.withValues(alpha: 0.08),
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 18, color: green),
                          const SizedBox(width: LGSpacing.sm),
                          Expanded(
                            child: Text(
                              'Add more items',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: green,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 18, color: green),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Text('Promo Code', style: theme.textTheme.titleLarge),
                ),
                GestureDetector(
                  onTap: () => _applyPromo(cart),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Apply',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.brightness == Brightness.dark
                              ? LGColors.redDark
                              : LGColors.red,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: theme.brightness == Brightness.dark
                            ? LGColors.redDark
                            : LGColors.red,
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
              LGSpacing.sm,
              LGSpacing.md,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      errorText: _promoError,
                      prefixIcon: Icon(
                        Icons.local_offer_outlined,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.6,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: LGSpacing.sm),
                ElevatedButton(
                  onPressed: () => _applyPromo(cart),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    foregroundColor: theme.colorScheme.onSurface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Apply'),
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
            child: Text('Order Summary', style: theme.textTheme.titleLarge),
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
                  _SummaryRow(
                    label: 'Subtotal',
                    value: 'OMR ${cart.subtotal.toStringAsFixed(3)}',
                  ),
                  _SummaryRow(
                    label: 'Delivery Fee',
                    value:
                        'OMR ${CartController.deliveryFee.toStringAsFixed(3)}',
                  ),
                  _SummaryRow(
                    label: 'Discount',
                    value: '- OMR ${cart.discount.toStringAsFixed(3)}',
                    valueColor: green,
                  ),
                  const Divider(height: LGSpacing.lg),
                  _SummaryRow(
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
              LGSpacing.xl,
            ),
            child: LaundryGoButton(
              label: 'Checkout',
              showArrow: true,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.payment),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.index, required this.cart});

  final int index;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = cart.lines[index];
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Padding(
      padding: const EdgeInsets.all(LGSpacing.smd),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              line.image,
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
                Text(line.name, style: theme.textTheme.titleSmall),
                Text(
                  line.descriptor,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _QuantityStepper(
            value: line.quantity,
            onMinus: () => cart.decrement(index),
            onPlus: () => cart.increment(index),
          ),
          const SizedBox(width: LGSpacing.sm),
          SizedBox(
            width: 72,
            child: Text(
              'OMR ${line.lineTotal.toStringAsFixed(3)}',
              textAlign: TextAlign.right,
              style: theme.textTheme.titleSmall,
            ),
          ),
          IconButton(
            onPressed: () {
              final name = line.name;
              cart.removeAt(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$name removed from cart.')),
              );
            },
            icon: Icon(Icons.delete_outline, size: 20, color: red),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.only(left: 4),
          ),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget btn(IconData icon, VoidCallback onTap) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 16),
      ),
    );
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(Icons.remove, onMinus),
          SizedBox(
            width: 22,
            child: AnimatedSwitcher(
              duration: LGMotion.micro,
              transitionBuilder: (child, anim) => ScaleTransition(
                scale: anim,
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Text(
                '$value',
                key: ValueKey(value),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          btn(Icons.add, onPlus),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = bold
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: bold ? theme.textTheme.titleMedium : style,
            ),
          ),
          Text(
            value,
            style: (bold ? theme.textTheme.headlineSmall : style)?.copyWith(
              color: valueColor ?? style?.color,
            ),
          ),
        ],
      ),
    );
  }
}
