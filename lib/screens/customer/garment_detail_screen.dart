import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../state/cart_controller.dart';
import 'cart_screen.dart';

/// Garment Detail / Selection — one garment, its real care/service
/// options and price, a quantity stepper, and a genuine Add to Cart that
/// writes into [CartController]. Same fixed-height photography treatment
/// as Home/Catalogue (image proportion never follows the source asset).
class GarmentDetailScreen extends StatefulWidget {
  const GarmentDetailScreen({super.key, required this.garment});

  final GarmentType garment;

  @override
  State<GarmentDetailScreen> createState() => _GarmentDetailScreenState();
}

class _GarmentDetailScreenState extends State<GarmentDetailScreen> {
  int _serviceIndex = 0;
  int _quantity = 1;
  bool _adding = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final services = MockCustomerData.services;
    final service = services[_serviceIndex];
    final price = service.price ?? 2.5;
    final partners = MockCustomerData.partners
        .where((p) => p.services.contains(service.name))
        .toList();

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
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Material(
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
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(LGSpacing.lg),
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey(_serviceIndex),
                    tween: Tween(begin: 1.025, end: 1.0),
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: AnimatedContainer(
                      duration: LGMotion.component,
                      curve: LGMotion.spring,
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: green, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: green.withValues(alpha: 0.15),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        widget.garment.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.garment.name, style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 4),
                    Text(
                      'Choose a care option and quantity.',
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
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Text('Care option', style: theme.textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Wrap(
                  spacing: LGSpacing.sm,
                  runSpacing: LGSpacing.sm,
                  children: [
                    for (var i = 0; i < services.length; i++)
                      _ServiceChoiceChip(
                        label: services[i].name,
                        price: services[i].price,
                        selected: i == _serviceIndex,
                        onTap: () => setState(() => _serviceIndex = i),
                      ),
                  ],
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
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantity', style: theme.textTheme.titleSmall),
                            Text(
                              'OMR ${price.toStringAsFixed(3)} each',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                      ),
                      SizedBox(
                        width: 32,
                        child: AnimatedSwitcher(
                          duration: LGMotion.micro,
                          transitionBuilder: (child, anim) => ScaleTransition(
                            scale: anim,
                            child: FadeTransition(opacity: anim, child: child),
                          ),
                          child: Text(
                            '$_quantity',
                            key: ValueKey(_quantity),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () => setState(() => _quantity++),
                      ),
                    ],
                  ),
                ),
              ),
              if (partners.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LGSpacing.md,
                    LGSpacing.lg,
                    LGSpacing.md,
                    0,
                  ),
                  child: Text(
                    'Available from ${partners.length} nearby partner${partners.length == 1 ? '' : 's'}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: AnimatedScale(
                  scale: _adding ? LGMotion.pressedScale : 1.0,
                  duration: LGMotion.micro,
                  child: GestureDetector(
                    onTapDown: (_) => setState(() => _adding = true),
                    onTapUp: (_) => setState(() => _adding = false),
                    onTapCancel: () => setState(() => _adding = false),
                    onTap: () {
                      context.read<CartController>().addLine(
                        name: service.name,
                        descriptor: widget.garment.name,
                        image: widget.garment.image,
                        unitPrice: price,
                        quantity: _quantity,
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              '$_quantity × ${widget.garment.name} (${service.name}) added to cart.',
                            ),
                            action: SnackBarAction(
                              label: 'View Cart',
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CartScreen(),
                                ),
                              ),
                            ),
                          ),
                        );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Add to Cart · OMR ${(price * _quantity).toStringAsFixed(3)}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceChoiceChip extends StatelessWidget {
  const _ServiceChoiceChip({
    required this.label,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double? price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: LGMotion.micro,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? red : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? red : theme.colorScheme.outline),
        ),
        child: Text(
          price != null ? '$label · OMR ${price!.toStringAsFixed(2)}' : label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
