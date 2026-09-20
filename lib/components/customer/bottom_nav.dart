import 'package:flutter/material.dart';

import '../../i18n/strings.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../motion/laundrygo_animated_nav_item.dart';

/// Custom LaundryGo bottom navigation — floating ivory/white pill bar,
/// red active icon + underline, cart badge. Never a stock
/// `BottomNavigationBar` (rule 9).
class LaundryGoBottomNav extends StatelessWidget {
  const LaundryGoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    this.cartCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;
  final int cartCount;

  static const _items = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.receipt_long_outlined, Icons.receipt_long, 'Orders'),
    (Icons.shopping_cart_outlined, Icons.shopping_cart, 'Cart'),
    (Icons.person_outline, Icons.person, 'Profile'),
  ];

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
              for (var i = 0; i < _items.length; i++)
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
                                    ? _items[i].$2
                                    : _items[i].$1,
                                size: 22,
                                color: i == currentIndex
                                    ? red
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              if (i == 2 && cartCount > 0)
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
                                      '$cartCount',
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
                          tr(context, _items[i].$3),
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
