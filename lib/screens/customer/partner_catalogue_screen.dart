import 'package:flutter/material.dart';

import '../../components/customer/cards.dart';
import '../../components/customer/customer_header.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../navigation/open_partner.dart';

/// Browse-by-category counterpart to Partner Discovery: instead of one
/// proximity-sorted list, partners are grouped by the service they
/// specialize in — a genuinely different way to shop the same partner
/// network, not a re-skin of Discovery.
class PartnerCatalogueScreen extends StatelessWidget {
  const PartnerCatalogueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final byService = <String, List<Partner>>{};
    for (final p in MockCustomerData.partners) {
      for (final s in p.services) {
        byService.putIfAbsent(s, () => []).add(p);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomerHeader(
                showLocation: false,
                showBack: true,
                onBack: () => Navigator.of(context).maybePop(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  0,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BY CATEGORY',
                      style: theme.textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.headlineLarge,
                        children: [
                          const TextSpan(text: 'Partner '),
                          TextSpan(
                            text: 'Catalogue',
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Browse partners by what they specialize in.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              for (final entry in byService.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LGSpacing.md,
                    LGSpacing.sm,
                    LGSpacing.md,
                    0,
                  ),
                  child: Text(entry.key, style: theme.textTheme.titleLarge),
                ),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: LGSpacing.md,
                      vertical: LGSpacing.sm,
                    ),
                    itemCount: entry.value.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: LGSpacing.sm),
                    itemBuilder: (context, i) => PartnerCardCompact(
                      partner: entry.value[i],
                      onTap: () => openPartner(context, entry.value[i]),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: LGSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
