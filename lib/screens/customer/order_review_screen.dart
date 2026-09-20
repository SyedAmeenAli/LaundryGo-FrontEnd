import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';
import '../../state/addresses_controller.dart';
import '../../state/cart_controller.dart';
import 'addresses_screen.dart';

/// Order Review — the pre-checkout summary: partner, every cart line,
/// pickup/delivery details, and the real billing breakdown, each with a
/// working Edit control before the user commits to Payment.
class OrderReviewScreen extends StatelessWidget {
  const OrderReviewScreen({
    super.key,
    required this.partner,
    required this.pickupDateLabel,
    required this.pickupTimeLabel,
  });

  final Partner partner;
  final String pickupDateLabel;
  final String pickupTimeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final cart = context.watch<CartController>();
    final addresses = context.watch<AddressesController>();
    final defaultAddress = addresses.addresses.isEmpty
        ? null
        : addresses.addresses.firstWhere(
            (a) => a.isDefault,
            orElse: () => addresses.addresses.first,
          );

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
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'REVIEW',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineLarge,
                              children: [
                                const TextSpan(text: 'Order '),
                                TextSpan(
                                  text: 'Review',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(LGSpacing.smd),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          partner.image,
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
                            Text(partner.name, style: theme.textTheme.titleSmall),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: LGColors.ratingGold,
                                ),
                                Text(
                                  ' ${partner.rating} (${partner.reviewCount})',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    0,
                    LGSpacing.lg,
                    0,
                    LGSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Items', style: theme.textTheme.titleLarge),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.edit_outlined, size: 14),
                        label: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
                for (final line in cart.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            line.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: LGSpacing.smd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${line.quantity} × ${line.name}',
                                style: theme.textTheme.titleSmall,
                              ),
                              Text(
                                line.descriptor,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'OMR ${line.lineTotal.toStringAsFixed(3)}',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: LGSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.location_on_outlined,
                        title: 'Pickup & Delivery',
                        body: defaultAddress != null
                            ? '${defaultAddress.line1}\n${defaultAddress.line2}'
                            : 'No saved address',
                        color: green,
                        onEdit: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const AddressesScreen(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.schedule,
                        title: 'Pickup Time',
                        body: '$pickupDateLabel\n$pickupTimeLabel',
                        color: green,
                        onEdit: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: LGSpacing.lg),
                  child: Text('Billing Summary', style: theme.textTheme.titleLarge),
                ),
                Container(
                  width: double.infinity,
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
                        label: 'Total',
                        value: 'OMR ${cart.total.toStringAsFixed(3)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                LaundryGoButton(
                  label: 'Continue to Payment',
                  showArrow: true,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.payment),
                ),
                const SizedBox(height: LGSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.color,
    required this.onEdit,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color color;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const Spacer(),
              InkWell(
                onTap: onEdit,
                child: Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
