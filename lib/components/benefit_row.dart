import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';

/// One benefit line: circular icon badge + bold title + supporting
/// sentence — the Welcome/Location screens' vertical benefit list (as
/// opposed to Onboarding's compact 3-across icon row).
class BenefitListItem extends StatelessWidget {
  const BenefitListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final badgeColor = dark ? LGColors.surfaceElevatedDark : LGColors.cloud;
    final iconColor = dark ? LGColors.textPrimaryDark : LGColors.graphite;
    return Padding(
      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: LGSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
