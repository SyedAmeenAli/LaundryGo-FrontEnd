import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/cards.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../navigation/open_partner.dart';
import '../../state/favorites_controller.dart';

/// Reads real favorites state — heart a service or partner anywhere in the
/// app and it shows up here; un-heart it and it's gone. Falls back to an
/// honest empty state only when nothing has been favorited yet.
class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final favorites = context.watch<FavoritesController>();
    final allServices = [
      ...MockCustomerData.services,
      ...MockCustomerData.popularServices,
    ];
    final favServices = allServices
        .where((s) => favorites.isServiceFavorite(s.name))
        .toList();
    final favPartners = MockCustomerData.partners
        .where((p) => favorites.isPartnerFavorite(p.id))
        .toList();
    final isEmpty = favServices.isEmpty && favPartners.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: isEmpty
            ? Padding(
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
                    const Spacer(),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: green.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: green,
                            ),
                          ),
                          const SizedBox(height: LGSpacing.md),
                          Text(
                            'No saved items yet',
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the heart on a service or partner to save it here.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: LGSpacing.lg),
                          LaundryGoButton(
                            label: 'Browse Services',
                            expand: false,
                            onPressed: () =>
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.services),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )
            : SingleChildScrollView(
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
                        'FAVORITES',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.headlineLarge,
                          children: [
                            const TextSpan(text: 'Saved '),
                            TextSpan(
                              text: 'Items',
                              style: TextStyle(color: green),
                            ),
                          ],
                        ),
                      ),
                      if (favServices.isNotEmpty) ...[
                        const SizedBox(height: LGSpacing.lg),
                        Text('Services', style: theme.textTheme.titleLarge),
                        const SizedBox(height: LGSpacing.sm),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: LGSpacing.sm,
                                crossAxisSpacing: LGSpacing.sm,
                                mainAxisExtent: 190,
                              ),
                          itemCount: favServices.length,
                          itemBuilder: (context, i) => ServiceCard(
                            service: favServices[i],
                            imageHeight: 110,
                            showArrowButton: true,
                            onTap: () =>
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.partnerDiscovery),
                          ),
                        ),
                      ],
                      if (favPartners.isNotEmpty) ...[
                        const SizedBox(height: LGSpacing.lg),
                        Text('Partners', style: theme.textTheme.titleLarge),
                        const SizedBox(height: LGSpacing.sm),
                        for (final p in favPartners)
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: LGSpacing.md,
                            ),
                            child: PartnerRow(
                              partner: p,
                              onTap: () => openPartner(context, p),
                            ),
                          ),
                      ],
                      const SizedBox(height: LGSpacing.xl),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
