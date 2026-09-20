import 'package:flutter/material.dart';

import '../../components/customer/cards.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/app_routes.dart';

/// Service Detail — the full story behind one [ServiceType]: hero photo,
/// benefits, real partners who offer it, and the supported garments,
/// following the same hero-into-ivory-panel technique as Services/Home.
class ServiceDetailScreen extends StatelessWidget {
  const ServiceDetailScreen({super.key, required this.service});

  final ServiceType service;

  static const _benefitsByService = {
    'Wash & Fold': [
      'Machine-washed with premium detergent',
      'Neatly folded, ready to put away',
      'Fabric-safe temperature control',
    ],
    'Dry Cleaning': [
      'Gentle solvent cleaning for delicate fabrics',
      'Stain treatment included',
      'Pressed and hung on delivery',
    ],
    'Ironing': [
      'Crisp, wrinkle-free finish',
      'Steam-pressed by hand',
      'Ready to wear same day',
    ],
    'Special Care': [
      'Hand-inspected before treatment',
      'Suited for embellished and delicate items',
      'Extra care instructions honored',
    ],
    'Bedding & Linen': [
      'Deep-cleaned for allergens and dust',
      'Fresh, hotel-quality finish',
      'Handles bulky items with ease',
    ],
    'Shoes Cleaning': [
      'Sole and upper deep clean',
      'Odor and stain treatment',
      'Restores like-new appearance',
    ],
    'Bags & Accessories': [
      'Safe for leather and fabric',
      'Hardware polished on request',
      'Careful handling, always',
    ],
  };

  static const _turnaroundByService = {
    'Wash & Fold': '24 hours',
    'Dry Cleaning': '48 hours',
    'Ironing': 'Same day',
    'Special Care': '48-72 hours',
    'Bedding & Linen': '48 hours',
    'Shoes Cleaning': '48 hours',
    'Bags & Accessories': '24-48 hours',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final benefits = _benefitsByService[service.name] ??
        const ['Professional care, every time.'];
    final turnaround = _turnaroundByService[service.name] ?? '24-48 hours';
    final partners = MockCustomerData.partners
        .where((p) => p.services.contains(service.name))
        .toList();
    final garments = MockCustomerData.garments.take(5).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 260,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(service.image, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 100,
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
                      height: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            LGSpacing.md,
                            LGSpacing.sm,
                            LGSpacing.md,
                            0,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              color: Colors.white.withValues(alpha: 0.9),
                              shape: const CircleBorder(),
                              elevation: 3,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => Navigator.of(context).maybePop(),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 18,
                                    color: LGColors.midnight,
                                  ),
                                ),
                              ),
                            ),
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
                            service.descriptor.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(service.name, style: theme.textTheme.headlineLarge),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Row(
                  children: [
                    _InfoChip(
                      icon: Icons.schedule,
                      label: turnaround,
                      color: green,
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    if (service.price != null)
                      _InfoChip(
                        icon: Icons.payments_outlined,
                        label: 'From OMR ${service.price!.toStringAsFixed(3)}',
                        color: red,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Text(
                  'Professional ${service.name.toLowerCase()} care, handled by '
                  'vetted local partners and delivered right to your door.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Text("What's included", style: theme.textTheme.titleLarge),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  children: [
                    for (final b in benefits)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check_circle, size: 18, color: green),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Text(b, style: theme.textTheme.bodyMedium),
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
                  0,
                ),
                child: Text('Supported items', style: theme.textTheme.titleLarge),
              ),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LGSpacing.md,
                    vertical: LGSpacing.sm,
                  ),
                  itemCount: garments.length,
                  separatorBuilder: (_, _) => const SizedBox(width: LGSpacing.md),
                  itemBuilder: (context, i) => GarmentCircle(
                    garment: garments[i],
                    diameter: 56,
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
                child: Text(
                  'Available from ${partners.length} partner${partners.length == 1 ? '' : 's'}',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  children: [
                    if (partners.isEmpty)
                      Text(
                        'No partners currently offer this service.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    for (final p in partners)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                        child: PartnerRow(
                          partner: p,
                          rowHeight: 100,
                          imageWidth: 100,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.partnerDetail,
                            arguments: p.id,
                          ),
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
                  LGSpacing.lg,
                ),
                child: LaundryGoButton(
                  label: 'Find Partners for ${service.name}',
                  showArrow: true,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.partnerDiscovery),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
