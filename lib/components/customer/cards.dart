import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../state/favorites_controller.dart';
import '../glass_press.dart';

/// Heart toggle with real positive feedback: fills and turns red the
/// instant it's tapped, a glass-glow flash blooms outward, plus a
/// SnackBar confirming what just happened — so favoriting something is
/// never a silent, uncertain tap.
class FavoriteHeart extends StatefulWidget {
  const FavoriteHeart({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.compact = false,
  });

  final bool isFavorite;
  final ValueChanged<bool> onToggle;
  final bool compact;

  @override
  State<FavoriteHeart> createState() => _FavoriteHeartState();
}

class _FavoriteHeartState extends State<FavoriteHeart> {
  bool _flash = false;

  Future<void> _handleTap() async {
    final added = !widget.isFavorite;
    setState(() => _flash = true);
    widget.onToggle(added);
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(milliseconds: 1400),
            content: Text(
              added ? 'Added to favorites' : 'Removed from favorites',
            ),
          ),
        );
    }
    await Future.delayed(LGMotion.component);
    if (mounted) setState(() => _flash = false);
  }

  @override
  Widget build(BuildContext context) {
    final red = Theme.of(context).brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final size = widget.compact ? 28.0 : 32.0;
    return GestureDetector(
      onTap: _handleTap,
      child: GlassGlow(
        pressed: _flash,
        borderRadius: BorderRadius.circular(size),
        glowColor: red,
        child: AnimatedContainer(
          duration: LGMotion.micro,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            shape: BoxShape.circle,
          ),
          child: AnimatedSwitcher(
            duration: LGMotion.micro,
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              widget.isFavorite ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(widget.isFavorite),
              size: widget.compact ? 14 : 16,
              color: widget.isFavorite ? red : LGColors.midnight,
            ),
          ),
        ),
      ),
    );
  }
}

/// A service tile: FIXED-HEIGHT image region on top, title/descriptor/
/// chevron below. The image height is passed explicitly by the caller
/// (Home's compact horizontal tiles vs. Services' larger grid tiles) —
/// never derived from the image's own intrinsic size, so a high-res
/// source photo can never balloon the card (rule: "do not let intrinsic
/// image dimensions determine layout size").
class ServiceCard extends StatefulWidget {
  const ServiceCard({
    super.key,
    required this.service,
    required this.imageHeight,
    this.onTap,
    this.showArrowButton = false,
  });

  final ServiceType service;
  final double imageHeight;
  final VoidCallback? onTap;
  final bool showArrowButton;

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final favorites = context.watch<FavoritesController>();
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: LGMotion.micro,
        child: GlassGlow(
          pressed: _pressed,
          borderRadius: BorderRadius.circular(18),
          glowColor: red,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: widget.imageHeight,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(widget.service.image, fit: BoxFit.cover),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: FavoriteHeart(
                          compact: true,
                          isFavorite: favorites.isServiceFavorite(
                            widget.service.name,
                          ),
                          onToggle: (_) => context
                              .read<FavoritesController>()
                              .toggleService(widget.service.name),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(LGSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.service.name,
                              style: theme.textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.service.descriptor,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (widget.showArrowButton)
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 14,
                            color: red,
                          ),
                        )
                      else
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One circular garment thumbnail + caption — fixed diameter, never scaled
/// by the source image's own resolution.
class GarmentCircle extends StatelessWidget {
  const GarmentCircle({
    super.key,
    required this.garment,
    this.diameter = 56,
    this.onTap,
  });

  final GarmentType garment;
  final double diameter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: diameter + 12,
        child: Column(
          children: [
            Container(
              width: diameter,
              height: diameter,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(garment.image, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(
              garment.name,
              style: theme.textTheme.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Home's compact partner tile — fixed image height, rating badge overlay.
class PartnerCardCompact extends StatelessWidget {
  const PartnerCardCompact({
    super.key,
    required this.partner,
    this.width = 240,
    this.imageHeight = 120,
    this.onTap,
  });

  final Partner partner;
  final double width;
  final double imageHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(partner.image, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _RatingBadge(rating: partner.rating),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: LGSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 2),
                Text(
                  '${partner.distanceKm} km',
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    partner.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            Text(
              partner.services.join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

/// Partner Discovery's compact HORIZONTAL split row: fixed-width image on
/// the left, details on the right — never a full-width vertical card
/// (rule 16: "do not enlarge the storefront image to full card width").
class PartnerRow extends StatelessWidget {
  const PartnerRow({
    super.key,
    required this.partner,
    this.rowHeight = 130,
    this.imageWidth = 140,
    this.onTap,
  });

  final Partner partner;
  final double rowHeight;
  final double imageWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final open = partner.openStatus.startsWith('Open Now');
    final statusColor = open
        ? (theme.brightness == Brightness.dark
              ? LGColors.greenDark
              : LGColors.green)
        : theme.colorScheme.onSurfaceVariant;
    final favorites = context.watch<FavoritesController>();
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: rowHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: imageWidth,
              height: rowHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(partner.image, fit: BoxFit.cover),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: FavoriteHeart(
                        compact: true,
                        isFavorite: favorites.isPartnerFavorite(partner.id),
                        onToggle: (_) => context
                            .read<FavoritesController>()
                            .togglePartner(partner.id),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          partner.openStatus,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${partner.distanceKm} km',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    partner.name,
                    style: theme.textTheme.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 13,
                        color: LGColors.ratingGold,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${partner.rating} (${partner.reviewCount})',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      for (final s in partner.services.take(3))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                          child: Text(
                            s,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          partner.pickupTiming,
                          style: theme.textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 12, color: LGColors.ratingGold),
          const SizedBox(width: 2),
          Text(
            '$rating',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: LGColors.midnight,
            ),
          ),
        ],
      ),
    );
  }
}
