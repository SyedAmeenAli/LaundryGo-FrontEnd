import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/cards.dart';
import '../../components/customer/map_panel.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';
import '../../state/favorites_controller.dart';

class PartnerDetailScreen extends StatefulWidget {
  const PartnerDetailScreen({super.key, required this.partnerId});

  final String partnerId;

  @override
  State<PartnerDetailScreen> createState() => _PartnerDetailScreenState();
}

class _PartnerDetailScreenState extends State<PartnerDetailScreen> {
  int _tab = 0;

  Partner get _partner => MockCustomerData.partners.firstWhere(
    (p) => p.id == widget.partnerId,
    orElse: () => MockCustomerData.partners.first,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final partner = _partner;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final favorites = context.watch<FavoritesController>();
    final isFavorite = favorites.isPartnerFavorite(partner.id);
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Storefront hero — fixed proportion, back/favorite/share overlaid.
              SizedBox(
                height: 260,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(partner.image, fit: BoxFit.cover),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.all(LGSpacing.md),
                        child: Row(
                          children: [
                            _ChromeButton(
                              icon: Icons.arrow_back,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            const Spacer(),
                            _ChromeButton(
                              icon: isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              iconColor: isFavorite ? red : null,
                              onTap: () {
                                final added = context
                                    .read<FavoritesController>()
                                    .togglePartner(partner.id);
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        added
                                            ? 'Added to favorites'
                                            : 'Removed from favorites',
                                      ),
                                    ),
                                  );
                              },
                            ),
                            const SizedBox(width: 8),
                            _ChromeButton(
                              icon: Icons.ios_share,
                              onTap: () => ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${partner.name} link copied.',
                                      ),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -28),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              LaundryGoAssets.logoMark,
                              width: 48,
                              height: 48,
                            ),
                          ),
                          const SizedBox(width: LGSpacing.smd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        partner.name,
                                        style: theme.textTheme.titleLarge,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: green.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        partner.openStatus,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color: green,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  partner.subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 14,
                                      color: LGColors.ratingGold,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${partner.rating} (${partner.reviewCount} reviews)',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    Text(
                                      '${partner.distanceKm} km',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: LGSpacing.md),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.85,
                        children: [
                          for (final s in MockCustomerData.services)
                            _MiniService(service: s),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          for (var i = 0; i < 3; i++)
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _tab = i),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        [
                                          'About',
                                          'Services',
                                          'Reviews (${partner.reviewCount})',
                                        ][i],
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              color: _tab == i
                                                  ? theme.colorScheme.onSurface
                                                  : theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: LGMotion.component,
                                      curve: Curves.easeOut,
                                      height: 2,
                                      color: _tab == i
                                          ? theme.colorScheme.primary
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Divider(height: 1),
                      const SizedBox(height: LGSpacing.md),
                      if (_tab == 0) _AboutTab(partner: partner),
                      if (_tab == 1)
                        Column(
                          children: [
                            for (final s in MockCustomerData.services)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: LGSpacing.sm,
                                ),
                                child: ServiceCard(
                                  service: s,
                                  imageHeight: 90,
                                  showArrowButton: true,
                                ),
                              ),
                          ],
                        ),
                      if (_tab == 2)
                        Column(
                          children: [
                            for (final r in MockCustomerData.reviewsFor(
                              partner.id,
                            ))
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: LGSpacing.md,
                                ),
                                child: _ReviewCard(review: r),
                              ),
                          ],
                        ),
                      const SizedBox(height: LGSpacing.lg),
                      LaundryGoButton(
                        label: 'Select Partner',
                        showArrow: true,
                        onPressed: () => Navigator.of(context).pushNamed(
                          AppRoutes.schedulePickup,
                          arguments: partner.id,
                        ),
                      ),
                      const SizedBox(height: LGSpacing.lg),
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

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.partner});

  final Partner partner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('About ${partner.name}', style: theme.textTheme.titleLarge),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${partner.name} brings professional care and modern convenience to your neighbourhood. We use advanced cleaning techniques and eco-friendly products to keep your clothes fresh, clean and looking their best.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: LGSpacing.smd),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                LaundryGoAssets.partnerAboutPhoto,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        const SizedBox(height: LGSpacing.md),
        Row(
          children: [
            Expanded(
              child: _TrustBadge(
                icon: Icons.verified_outlined,
                label: 'Trusted &\nProfessional',
                color: green,
              ),
            ),
            Expanded(
              child: _TrustBadge(
                icon: Icons.eco_outlined,
                label: 'Eco-Friendly\nProducts',
                color: green,
              ),
            ),
            Expanded(
              child: _TrustBadge(
                icon: Icons.groups_outlined,
                label: 'Local Team\nYou Can Rely On',
                color: green,
              ),
            ),
          ],
        ),
        const SizedBox(height: LGSpacing.lg),
        Text('Location', style: theme.textTheme.titleLarge),
        const SizedBox(height: LGSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          partner.address,
                          style: theme.textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      partner.addressLine,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: LGSpacing.sm),
        MapPanel(
          center: LatLng(partner.lat, partner.lng),
          height: 150,
          interactive: false,
        ),
        const SizedBox(height: LGSpacing.lg),
        Row(
          children: [
            const Icon(Icons.schedule, size: 16),
            const SizedBox(width: 6),
            Text('Opening Hours', style: theme.textTheme.titleLarge),
          ],
        ),
        for (final h in partner.hours)
          Padding(
            padding: const EdgeInsets.only(left: 22, top: 2),
            child: Text(
              h,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        const SizedBox(height: LGSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: LGSpacing.md,
            vertical: LGSpacing.smd,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.outline),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.call_outlined, size: 18),
              const SizedBox(width: LGSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Call', style: theme.textTheme.titleSmall),
                    Text(partner.phone, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _MiniService extends StatelessWidget {
  const _MiniService({required this.service});

  final ServiceType service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(_iconFor(service.name), size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          service.name,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall,
          maxLines: 2,
        ),
      ],
    );
  }

  IconData _iconFor(String name) => switch (name) {
    'Wash & Fold' => Icons.local_laundry_service_outlined,
    'Dry Cleaning' => Icons.checkroom_outlined,
    'Ironing' => Icons.iron_outlined,
    _ => Icons.eco_outlined,
  };
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final PartnerReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(review.customerImage),
              ),
              const SizedBox(width: LGSpacing.smd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.customerName, style: theme.textTheme.titleSmall),
                    Row(
                      children: [
                        for (var i = 0; i < 5; i++)
                          Icon(
                            i < review.rating ? Icons.star : Icons.star_border,
                            size: 13,
                            color: LGColors.ratingGold,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          review.date,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: LGSpacing.sm),
          Text(review.comment, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _ChromeButton extends StatelessWidget {
  const _ChromeButton({
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: iconColor ?? LGColors.midnight),
        ),
      ),
    );
  }
}
