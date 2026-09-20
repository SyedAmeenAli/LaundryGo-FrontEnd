import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/cards.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/partner_filter_sheet.dart';
import '../../components/customer/pill_search_bar.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/open_partner.dart';
import 'notifications_screen.dart';
import 'partner_catalogue_screen.dart';

/// Screen — Partner Discovery. Hero + search + filters, then a vertical
/// list of COMPACT HORIZONTAL rows (image left, details right) — never
/// full-width vertical cards (rule 16).
class PartnerDiscoveryScreen extends StatefulWidget {
  const PartnerDiscoveryScreen({super.key});

  @override
  State<PartnerDiscoveryScreen> createState() => _PartnerDiscoveryScreenState();
}

class _PartnerDiscoveryScreenState extends State<PartnerDiscoveryScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  PartnerFilterState _filter = const PartnerFilterState();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showFilters() async {
    final services = <String>{
      for (final p in MockCustomerData.partners) ...p.services,
    }.toList()
      ..sort();
    final result = await showPartnerFilterSheet(
      context,
      current: _filter,
      availableServices: services,
    );
    if (result != null) setState(() => _filter = result);
  }

  List<Partner> _applyFilter(List<Partner> partners) {
    var result = partners.where((p) {
      if (_filter.services.isNotEmpty &&
          !_filter.services.any(p.services.contains)) {
        return false;
      }
      if (p.rating < _filter.minRating) return false;
      if (p.distanceKm > _filter.maxDistanceKm) return false;
      if (_filter.openNowOnly && !p.openStatus.startsWith('Open')) {
        return false;
      }
      if (_filter.pickupTodayOnly && p.pickupTiming != 'Pickup today') {
        return false;
      }
      return true;
    }).toList();

    switch (_filter.sort) {
      case PartnerSort.nearest:
        result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      case PartnerSort.highestRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case PartnerSort.fastestPickup:
        result.sort((a, b) {
          final aToday = a.pickupTiming == 'Pickup today' ? 0 : 1;
          final bToday = b.pickupTiming == 'Pickup today' ? 0 : 1;
          if (aToday != bToday) return aToday.compareTo(bToday);
          return a.distanceKm.compareTo(b.distanceKm);
        });
      case PartnerSort.recommended:
        result.sort(
          (a, b) => (b.rating * 10 - b.distanceKm)
              .compareTo(a.rating * 10 - a.distanceKm),
        );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final searched = MockCustomerData.partners
        .where(
          (p) =>
              p.name.toLowerCase().contains(_query) ||
              p.services.any((s) => s.toLowerCase().contains(_query)),
        )
        .toList();
    final partners = _applyFilter(searched);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 230,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      LaundryGoAssets.omanArchitecturalArch,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              background.withValues(alpha: 0.85),
                              background.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: CustomerHeader(
                        showBack: true,
                        onPhoto: true,
                        onBack: () => Navigator.of(context).maybePop(),
                        onNotificationTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: LGSpacing.md,
                      right: LGSpacing.md,
                      bottom: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PARTNERS NEAR YOU',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineSmall,
                              children: [
                                const TextSpan(
                                  text: 'Trusted Laundry Partners\n',
                                ),
                                TextSpan(
                                  text: 'Near You.',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.sm,
                ),
                child: PillSearchBar(
                  hint: 'Search by area, partner or service...',
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                  onFilterTap: _showFilters,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  0,
                  LGSpacing.md,
                  LGSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text(
                      '${partners.length} partner${partners.length == 1 ? '' : 's'} found',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (!_filter.isDefault)
                      InkWell(
                        onTap: () =>
                            setState(() => _filter = const PartnerFilterState()),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.close,
                              size: 12,
                              color: theme.brightness == Brightness.dark
                                  ? LGColors.redDark
                                  : LGColors.red,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Clear filters',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.brightness == Brightness.dark
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
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  0,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerCatalogueScreen(),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grid_view_rounded,
                        size: 15,
                        color: theme.brightness == Brightness.dark
                            ? LGColors.redDark
                            : LGColors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Browse by category',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.brightness == Brightness.dark
                              ? LGColors.redDark
                              : LGColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Column(
                  children: [
                    if (partners.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: LGSpacing.lg,
                        ),
                        child: Text(
                          'No partners match "$_query".',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    for (final partner in partners) ...[
                      PartnerRow(
                        partner: partner,
                        onTap: () => openPartner(context, partner),
                      ),
                      const SizedBox(height: LGSpacing.md),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
