import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/cards.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/pill_search_bar.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../navigation/open_partner.dart';
import 'garment_catalogue_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';

/// Screen — Customer Home. Hero keeps the reference's text-left/photo-right
/// balance (fixed 320px height, never a full-screen image) via a left-to-
/// right tonal fade into the photo, the same technique Onboarding uses
/// vertically.
class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomerHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.sm,
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SearchScreen())),
              child: AbsorbPointer(
                child: PillSearchBar(
                  hint: 'Search services, partners, garments...',
                ),
              ),
            ),
          ),
          _Hero(background: background),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              0,
            ),
            child: SectionHeader(
              title: 'What do you need?',
              actionLabel: 'View all',
              onAction: () =>
                  Navigator.of(context).pushNamed(AppRoutes.services),
            ),
          ),
          SizedBox(
            height: 168,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: LGSpacing.md,
                vertical: LGSpacing.sm,
              ),
              itemCount: MockCustomerData.services.length,
              separatorBuilder: (_, _) => const SizedBox(width: LGSpacing.sm),
              itemBuilder: (context, i) => SizedBox(
                width: 150,
                child: ServiceCard(
                  service: MockCustomerData.services[i],
                  imageHeight: 90,
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.services),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
              0,
            ),
            child: SectionHeader(
              title: 'We care for all of it',
              actionLabel: 'View all',
              onAction: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const GarmentCatalogueScreen(),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: LGSpacing.md,
                vertical: LGSpacing.sm,
              ),
              itemCount: MockCustomerData.garments.length,
              separatorBuilder: (_, _) => const SizedBox(width: 4),
              itemBuilder: (context, i) => GarmentCircle(
                garment: MockCustomerData.garments[i],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Finding partners for ${MockCustomerData.garments[i].name}...',
                      ),
                    ),
                  );
                  Navigator.of(context).pushNamed(AppRoutes.partnerDiscovery);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
              0,
            ),
            child: SectionHeader(
              title: 'Laundry partners near you',
              actionLabel: 'See all',
              onAction: () =>
                  Navigator.of(context).pushNamed(AppRoutes.partnerDiscovery),
            ),
          ),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: LGSpacing.md,
                vertical: LGSpacing.sm,
              ),
              itemCount: MockCustomerData.partners.length,
              separatorBuilder: (_, _) => const SizedBox(width: LGSpacing.sm),
              itemBuilder: (context, i) => PartnerCardCompact(
                partner: MockCustomerData.partners[i],
                onTap: () => openPartner(context, MockCustomerData.partners[i]),
              ),
            ),
          ),
          const SizedBox(height: LGSpacing.huge),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.background});

  final Color background;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return SizedBox(
      height: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.72,
              heightFactor: 1,
              child: Image.asset(
                LaundryGoAssets.foldedStack,
                fit: BoxFit.cover,
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0, 0.45, 0.62],
                colors: [
                  background,
                  background,
                  background.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Fresh\nclothes.\n'),
                      TextSpan(
                        text: 'More time.',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                Text(
                  'Pickup, care and delivery —\nmade simple.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                SizedBox(
                  width: 180,
                  child: LaundryGoButton(
                    label: 'Start an order',
                    showArrow: true,
                    expand: false,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.services),
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
