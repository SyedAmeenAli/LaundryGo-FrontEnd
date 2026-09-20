import 'package:flutter/material.dart';

import '../i18n/strings.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';
import 'motion/laundrygo_animated_nav_item.dart';

/// One tab in [AppBottomNav]: outline/filled icon pair, label, and an
/// optional badge count (only Customer's Cart tab uses it today).
class AppNavItem {
  const AppNavItem({
    required this.outline,
    required this.filled,
    required this.label,
    this.badge = 0,
  });
  final IconData outline;
  final IconData filled;
  final String label;
  final int badge;
}

/// The shared floating pill bottom nav — same chrome for every role
/// (Customer/Partner/Driver/Admin), just a different item set per shell.
/// Never a stock `BottomNavigationBar` (rule 9).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    required this.items,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final List<AppNavItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          LGSpacing.md,
          0,
          LGSpacing.md,
          LGSpacing.sm,
        ),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => onSelect(i),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LaundryGoAnimatedNavItem(
                          haloColor: red,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Icon(
                                i == currentIndex
                                    ? items[i].filled
                                    : items[i].outline,
                                size: 22,
                                color: i == currentIndex
                                    ? red
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              if (items[i].badge > 0)
                                Positioned(
                                  right: -8,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 1,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: LGColors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${items[i].badge}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tr(context, items[i].label),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: i == currentIndex
                                ? red
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: i == currentIndex
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        AnimatedContainer(
                          duration: LGMotion.component,
                          margin: const EdgeInsets.only(top: 2),
                          width: i == currentIndex ? 16 : 0,
                          height: 2,
                          decoration: BoxDecoration(
                            color: red,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ],
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

