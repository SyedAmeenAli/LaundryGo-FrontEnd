import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/location_controller.dart';
import '../motion/laundrygo_pressable.dart';

/// Shared top bar across Home/Services/Partner Discovery: logo lockup,
/// location dropdown, notification bell with badge. Kept short — the
/// reference header is compact, never a tall banner.
///
/// Only tab roots (Home/Orders/Cart/Profile) show the logo. Every screen
/// reached by `pushNamed` — i.e. anything with a way back — shows a Back
/// button in that same slot instead: [showBack] swaps it in.
class CustomerHeader extends StatelessWidget {
  const CustomerHeader({
    super.key,
    this.showLocation = true,
    this.hasNotification = true,
    this.onNotificationTap,
    this.showBack = false,
    this.onBack,
    this.onPhoto = false,
  });

  final bool showLocation;
  final bool hasNotification;
  final VoidCallback? onNotificationTap;
  final bool showBack;
  final VoidCallback? onBack;

  /// True when this header floats over a photo hero (Services, Partner
  /// Discovery) rather than a plain background — the back button then
  /// gets a real elevated chip instead of a bare icon, so it never
  /// disappears against a light or dark patch of the photo.
  final bool onPhoto;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locationController = context.watch<LocationController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        LGSpacing.md,
        LGSpacing.sm,
        LGSpacing.md,
        LGSpacing.sm,
      ),
      child: Row(
        children: [
          if (showBack)
            onPhoto
                ? Material(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onBack ?? () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_back,
                          size: 18,
                          color: LGColors.midnight,
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onBack ?? () => Navigator.of(context).maybePop(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  )
          else
            LaundryGoPressable(
              borderRadius: BorderRadius.circular(8),
              longPressScale: 1.025,
              haloColor: theme.colorScheme.primary,
              child: Image.asset(LaundryGoAssets.logoHorizontal, height: 30),
            ),
          const Spacer(),
          if (showLocation) ...[
            LaundryGoPressable(
              borderRadius: BorderRadius.circular(20),
              onTap: () => showCityPicker(context, locationController),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      locationController.city,
                      style: theme.textTheme.labelLarge,
                    ),
                    const Icon(Icons.expand_more, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(width: LGSpacing.sm),
          ],
          LaundryGoPressable(
            borderRadius: BorderRadius.circular(20),
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  size: 22,
                  color: theme.colorScheme.onSurface,
                ),
                if (hasNotification)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: LGColors.red,
                        shape: BoxShape.circle,
                      ),
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

/// A red-accented "Section heading" row with an optional "View all →" /
/// "See all →" trailing action — reused by every section of Home/Services.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Row(
      children: [
        Expanded(child: Text(title, style: theme.textTheme.headlineSmall)),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: theme.textTheme.labelLarge?.copyWith(color: red),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 14, color: red),
              ],
            ),
          ),
      ],
    );
  }
}
