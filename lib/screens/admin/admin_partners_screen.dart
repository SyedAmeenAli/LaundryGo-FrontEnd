import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/pill_search_bar.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'admin_partner_detail_screen.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';
import 'widgets/admin_partner_row.dart';

/// Admin Partners — every partner business on the platform, real search +
/// account-status filter. Tapping a row opens the approve/suspend detail.
class AdminPartnersScreen extends StatefulWidget {
  const AdminPartnersScreen({super.key});

  @override
  State<AdminPartnersScreen> createState() => _AdminPartnersScreenState();
}

class _AdminPartnersScreenState extends State<AdminPartnersScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  PartnerAccountStatus? _filter;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<AdminController>();
    final partners = controller.partners.where((p) {
      final matchesQuery =
          _query.isEmpty ||
          p.name.toLowerCase().contains(_query) ||
          p.category.toLowerCase().contains(_query);
      final matchesFilter = _filter == null || p.status == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AdminNotificationsScreen(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text('Partners', style: theme.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: PillSearchBar(
              hint: 'Search by business name or category...',
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v.toLowerCase()),
            ),
          ),
          SizedBox(
            height: 56,
            child: ShaderMask(
              shaderCallback: (rect) => const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.transparent,
                  Colors.black,
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.0, 0.04, 0.92, 1.0],
              ).createShader(rect),
              blendMode: BlendMode.dstIn,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: LGSpacing.md,
                  vertical: 4,
                ),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filter == null,
                    onTap: () => setState(() => _filter = null),
                  ),
                  for (final s in PartnerAccountStatus.values)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(
                        label: s.label,
                        selected: _filter == s,
                        onTap: () => setState(() => _filter = s),
                      ),
                    ),
                  const SizedBox(width: LGSpacing.md),
                ],
              ),
            ),
          ),
          if (partners.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: LGSpacing.xl),
              child: Center(
                child: Text(
                  'No partners match this filter.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                LGSpacing.sm,
                LGSpacing.md,
                LGSpacing.xl,
              ),
              child: Column(
                children: [
                  for (final p in partners)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: AdminPartnerRow(
                        partner: p,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                AdminPartnerDetailScreen(partnerId: p.id),
                          ),
                        ),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? red : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? red : theme.colorScheme.outline),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
