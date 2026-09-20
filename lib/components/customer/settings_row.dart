import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// icon + title + subtitle + chevron row — Profile/Addresses list items.
/// Rows share one container with thin dividers (rule: "do not turn each
/// row into a separate floating card").
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: LGSpacing.md,
          vertical: LGSpacing.smd,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.onSurface),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
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
    );
  }
}

/// A rounded white container holding a set of [SettingsRow]s with hairline
/// dividers between them.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              Divider(height: 1, color: theme.colorScheme.outline),
          ],
        ],
      ),
    );
  }
}
