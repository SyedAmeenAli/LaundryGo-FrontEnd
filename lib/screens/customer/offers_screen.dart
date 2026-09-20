import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

class _Offer {
  const _Offer({
    required this.code,
    required this.title,
    required this.subtitle,
  });
  final String code;
  final String title;
  final String subtitle;
}

const _offers = [
  _Offer(
    code: 'LAUNDRY10',
    title: '10% off your order',
    subtitle: 'Apply at checkout — valid on any service.',
  ),
  _Offer(
    code: 'WELCOME5',
    title: 'OMR 0.500 off first pickup',
    subtitle: 'New customers only.',
  ),
];

/// Real offers list — "Copy code" genuinely writes to the clipboard and
/// confirms with a SnackBar, it is not a decorative button.
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  Future<void> _copy(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$code" — apply it in Cart > Promo Code.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

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
                  'REWARDS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Offers & '),
                      TextSpan(
                        text: 'Rewards',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                for (final offer in _offers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.all(LGSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: theme.colorScheme.outline),
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
                              Icons.card_giftcard,
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
                                  offer.title,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  offer.subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: LGSpacing.sm),
                          OutlinedButton(
                            onPressed: () => _copy(context, offer.code),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: green,
                              side: BorderSide(color: green),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                            ),
                            child: Text(offer.code),
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
      ),
    );
  }
}
