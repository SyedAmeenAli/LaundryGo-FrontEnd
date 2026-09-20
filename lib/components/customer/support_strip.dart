import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// The pale-green "A cleaner, brighter you awaits." strip that closes
/// Orders/Cart/Payment/Order Confirmed — compact, never a full card.
class SupportStrip extends StatelessWidget {
  const SupportStrip({
    super.key,
    this.title = 'A cleaner, brighter you awaits.',
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return Container(
      padding: const EdgeInsets.all(LGSpacing.md),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: green.withValues(alpha: 0.15),
            child: Icon(Icons.eco_outlined, size: 16, color: green),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final l in const ['CLEAN', 'CLOTHES', 'HAPPIER', 'PEOPLE'])
                Text(
                  l,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
