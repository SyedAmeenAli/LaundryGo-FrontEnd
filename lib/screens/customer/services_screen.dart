import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/cards.dart';
import '../../components/customer/customer_header.dart';
import '../../components/customer/pill_search_bar.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import 'notifications_screen.dart';
import 'service_detail_screen.dart';

/// Screen — Services. Full-bleed hero (same technique as Onboarding: real
/// photo fading into the ivory panel) carries the "What do you need?"
/// headline, then a controlled 2-column grid — image region is a FIXED
/// height (110px), never the card's full height.
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  bool _popularExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final services = MockCustomerData.services
        .where((s) => s.name.toLowerCase().contains(_query))
        .toList();
    final popularServices = MockCustomerData.popularServices
        .where((s) => s.name.toLowerCase().contains(_query))
        .toList();
    final background = theme.scaffoldBackgroundColor;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(LaundryGoAssets.foldedStack, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 110,
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
                        showLocation: false,
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
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'OUR SERVICES',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineLarge,
                              children: [
                                const TextSpan(text: 'What do\nyou '),
                                TextSpan(
                                  text: 'need?',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Professional care for every kind of laundry.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
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
                  0,
                ),
                child: PillSearchBar(
                  hint: 'Search services, items or clothing...',
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              if (services.isEmpty && popularServices.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(LGSpacing.lg),
                  child: Text(
                    'No services match "$_query".',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (services.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LGSpacing.md,
                    LGSpacing.md,
                    LGSpacing.md,
                    0,
                  ),
                  child: GridView.builder(
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
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ServiceDetailScreen(service: services[i]),
                        ),
                      ),
                    ),
                  ),
                ),
              if (popularServices.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LGSpacing.md,
                    LGSpacing.lg,
                    LGSpacing.md,
                    0,
                  ),
                  child: SectionHeader(
                    title: 'Popular right now',
                    actionLabel: _popularExpanded ? 'Collapse' : 'View all',
                    onAction: () =>
                        setState(() => _popularExpanded = !_popularExpanded),
                  ),
                ),
                if (_popularExpanded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      LGSpacing.md,
                      LGSpacing.sm,
                      LGSpacing.md,
                      0,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: LGSpacing.sm,
                            crossAxisSpacing: LGSpacing.sm,
                            mainAxisExtent: 190,
                          ),
                      itemCount: popularServices.length,
                      itemBuilder: (context, i) => ServiceCard(
                        service: popularServices[i],
                        imageHeight: 110,
                        showArrowButton: true,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(
                              service: popularServices[i],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 150,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: LGSpacing.md,
                        vertical: LGSpacing.sm,
                      ),
                      itemCount: popularServices.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: LGSpacing.sm),
                      itemBuilder: (context, i) => SizedBox(
                        width: 140,
                        child: ServiceCard(
                          service: popularServices[i],
                          imageHeight: 80,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                service: popularServices[i],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: LGSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
