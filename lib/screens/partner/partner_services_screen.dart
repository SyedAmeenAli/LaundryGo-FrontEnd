import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/partner_controller.dart';
import 'partner_capacity_screen.dart';
import 'partner_pricing_screen.dart';
import 'widgets/partner_header.dart';

/// #58 Services — the real catalogue this partner offers, with genuine
/// availability toggles (turning one off actually removes it from what
/// Customer sees as offered by this partner in a real backend).
class PartnerServicesScreen extends StatelessWidget {
  const PartnerServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<PartnerController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PartnerHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text('Services', style: theme.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                LaundryGoAssets.partnerServiceScene,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Column(
              children: [
                const SizedBox(height: LGSpacing.md),
                for (var i = 0; i < controller.services.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                    child: Container(
                      padding: const EdgeInsets.all(LGSpacing.md),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.local_laundry_service_outlined,
                              size: 18,
                              color: red,
                            ),
                          ),
                          const SizedBox(width: LGSpacing.smd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.services[i].name,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  'OMR ${controller.services[i].priceOmr.toStringAsFixed(3)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: controller.services[i].available,
                            activeThumbColor: green,
                            onChanged: (_) {
                              controller.toggleServiceAvailable(i);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${controller.services[i].name} ${controller.services[i].available ? 'enabled' : 'disabled'}.',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: LGSpacing.sm),
                _ActionTile(
                  icon: Icons.sell_outlined,
                  label: 'Manage Pricing',
                  subtitle: 'Edit prices for every service',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerPricingScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                _ActionTile(
                  icon: Icons.speed_outlined,
                  label: 'Capacity',
                  subtitle: 'Set your daily order limit',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerCapacityScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(LGSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: LGSpacing.smd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.titleSmall),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
