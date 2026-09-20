import 'package:flutter/material.dart';

import '../../components/customer/cards.dart';
import '../../components/customer/pill_search_bar.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import 'garment_detail_screen.dart';

/// Garment catalogue — browse by item rather than by service. Tapping a
/// garment gives real feedback (a SnackBar naming the item) before routing
/// into Partner Discovery, since there's no per-garment detail screen yet.
class GarmentCatalogueScreen extends StatefulWidget {
  const GarmentCatalogueScreen({super.key});

  @override
  State<GarmentCatalogueScreen> createState() => _GarmentCatalogueScreenState();
}

class _GarmentCatalogueScreenState extends State<GarmentCatalogueScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final garments = MockCustomerData.garments
        .where((g) => g.name.toLowerCase().contains(_query))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                  'BY ITEM',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Garment '),
                      TextSpan(
                        text: 'Catalogue',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                PillSearchBar(
                  hint: 'Search a garment...',
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
                const SizedBox(height: LGSpacing.lg),
                if (garments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: LGSpacing.lg),
                    child: Text(
                      'No garments match "$_query".',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  Wrap(
                    spacing: LGSpacing.md,
                    runSpacing: LGSpacing.md,
                    children: [
                      for (final g in garments)
                        GarmentCircle(
                          garment: g,
                          diameter: 72,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GarmentDetailScreen(garment: g),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
