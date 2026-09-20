import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/cards.dart';
import '../../components/customer/partner_filter_sheet.dart';
import '../../components/customer/pill_search_bar.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../navigation/open_partner.dart';
import 'garment_detail_screen.dart';

/// Universal search — one field, real results across services, partners
/// and garments, filtered live as you type (not a static list).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  PartnerSort _sort = PartnerSort.recommended;

  Future<void> _showSort() async {
    final result = await showPartnerFilterSheet(
      context,
      current: PartnerFilterState(sort: _sort),
      availableServices: const [],
    );
    if (result != null) setState(() => _sort = result.sort);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => FocusScope.of(context).requestFocus(_focusNode),
    );
  }

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.toLowerCase();
    final services = q.isEmpty
        ? const <dynamic>[]
        : [
            ...MockCustomerData.services,
            ...MockCustomerData.popularServices,
          ].where((s) => s.name.toLowerCase().contains(q)).toList();
    final partners = q.isEmpty
        ? const <dynamic>[]
        : (MockCustomerData.partners
              .where(
                (p) =>
                    p.name.toLowerCase().contains(q) ||
                    p.services.any((s) => s.toLowerCase().contains(q)),
              )
              .toList()
            ..sort((a, b) => switch (_sort) {
                  PartnerSort.nearest => a.distanceKm.compareTo(b.distanceKm),
                  PartnerSort.highestRated => b.rating.compareTo(a.rating),
                  PartnerSort.fastestPickup => (a.pickupTiming == 'Pickup today'
                          ? 0
                          : 1)
                      .compareTo(b.pickupTiming == 'Pickup today' ? 0 : 1),
                  PartnerSort.recommended => (b.rating * 10 - b.distanceKm)
                      .compareTo(a.rating * 10 - a.distanceKm),
                }));
    final garments = q.isEmpty
        ? const <dynamic>[]
        : MockCustomerData.garments
              .where((g) => g.name.toLowerCase().contains(q))
              .toList();
    final noResults =
        q.isNotEmpty &&
        services.isEmpty &&
        partners.isEmpty &&
        garments.isEmpty;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: PillSearchBar(
                      hint: 'Search services, partners, garments...',
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: LGSpacing.md),
              Expanded(
                child: q.isEmpty
                    ? Center(
                        child: Text(
                          'Start typing to search LaundryGo.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : noResults
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                LaundryGoAssets.noSearchResults,
                                height: 160,
                                width: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: LGSpacing.lg),
                            Text(
                              'No results found',
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'No matches for "$_query". Try a different search.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: LGSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${services.length + partners.length + garments.length} results',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const Spacer(),
                                if (partners.isNotEmpty)
                                  InkWell(
                                    onTap: _showSort,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.swap_vert,
                                          size: 14,
                                          color: theme.brightness ==
                                                  Brightness.dark
                                              ? LGColors.redDark
                                              : LGColors.red,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          _sort.label,
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: theme.brightness ==
                                                        Brightness.dark
                                                    ? LGColors.redDark
                                                    : LGColors.red,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (services.isNotEmpty) ...[
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
                              itemCount: services.length,
                              itemBuilder: (context, i) => ServiceCard(
                                service: services[i],
                                imageHeight: 110,
                                showArrowButton: true,
                                onTap: () =>
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.partnerDiscovery),
                              ),
                            ),
                            const SizedBox(height: LGSpacing.lg),
                          ],
                          if (partners.isNotEmpty) ...[
                            Text('Partners', style: theme.textTheme.titleLarge),
                            const SizedBox(height: LGSpacing.sm),
                            for (final p in partners)
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
                          if (garments.isNotEmpty) ...[
                            Text('Garments', style: theme.textTheme.titleLarge),
                            const SizedBox(height: LGSpacing.sm),
                            Wrap(
                              spacing: LGSpacing.md,
                              runSpacing: LGSpacing.md,
                              children: [
                                for (final g in garments)
                                  GarmentCircle(
                                    garment: g,
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            GarmentDetailScreen(garment: g),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
