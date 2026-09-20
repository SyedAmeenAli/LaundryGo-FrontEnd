import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import 'add_payment_method_screen.dart';

class _SavedCard {
  _SavedCard({
    required this.brand,
    required this.last4,
    this.isDefault = false,
  });
  final String brand;
  final String last4;
  bool isDefault;
}

/// Real, interactive saved-cards list — tapping a card sets it default
/// (radio behaviour), "Remove" actually removes it from local state.
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _cards = [
    _SavedCard(brand: 'Visa', last4: '4821', isDefault: true),
    _SavedCard(brand: 'Mastercard', last4: '7710'),
  ];

  void _setDefault(int i) {
    setState(() {
      for (var j = 0; j < _cards.length; j++) {
        _cards[j].isDefault = j == i;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_cards[i].brand} •••• ${_cards[i].last4} set as default.',
        ),
      ),
    );
  }

  void _remove(int i) {
    final removed = _cards[i];
    setState(() => _cards.removeAt(i));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.brand} •••• ${removed.last4} removed.'),
      ),
    );
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: LGSpacing.md),
                Text(
                  'WALLET',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Payment '),
                      TextSpan(
                        text: 'Methods',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                if (_cards.isEmpty)
                  Text(
                    'No saved cards.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                for (var i = 0; i < _cards.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => _setDefault(i),
                      child: AnimatedContainer(
                        duration: LGMotion.component,
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.all(LGSpacing.md),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: _cards[i].isDefault
                                ? green
                                : theme.colorScheme.outline,
                            width: _cards[i].isDefault ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.credit_card,
                                size: 18,
                                color: green,
                              ),
                            ),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${_cards[i].brand} •••• ${_cards[i].last4}',
                                        style: theme.textTheme.titleSmall,
                                      ),
                                      if (_cards[i].isDefault) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: green.withValues(
                                              alpha: 0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            'Default',
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                                  color: green,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    'Expires 09/28',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => _remove(i),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context)
                        .push<NewCardResult>(
                          MaterialPageRoute(
                            builder: (_) => const AddPaymentMethodScreen(),
                          ),
                        );
                    if (result == null || !context.mounted) return;
                    setState(
                      () => _cards.add(
                        _SavedCard(brand: result.brand, last4: result.last4),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${result.brand} •••• ${result.last4} added.',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(LGSpacing.md),
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: green.withValues(alpha: 0.15),
                          child: Icon(Icons.add, size: 18, color: green),
                        ),
                        const SizedBox(width: LGSpacing.smd),
                        Expanded(
                          child: Text(
                            'Add New Card',
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
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
