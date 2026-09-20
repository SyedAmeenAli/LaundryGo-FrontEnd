import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/pill_search_bar.dart';
import '../../design_system/spacing.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'admin_customer_detail_screen.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';
import 'widgets/status_pill.dart';

/// Admin Customers — every registered customer, real search over the live
/// list. Tapping a row opens the block/unblock detail.
class AdminCustomersScreen extends StatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  State<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends State<AdminCustomersScreen> {
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
    final controller = context.watch<AdminController>();
    final customers = controller.customers
        .where((c) => _query.isEmpty || c.name.toLowerCase().contains(_query))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminHeader(
                showBack: true,
                onBack: () => Navigator.of(context).maybePop(),
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
                child: Text('Customers', style: theme.textTheme.headlineLarge),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: PillSearchBar(
                  hint: 'Search by customer name...',
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.toLowerCase()),
                ),
              ),
              const SizedBox(height: LGSpacing.sm),
              if (customers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: LGSpacing.xl),
                  child: Center(
                    child: Text(
                      'No customers match this search.',
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
                    0,
                    LGSpacing.md,
                    LGSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      for (final c in customers)
                        Padding(
                          padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminCustomerDetailScreen(customerId: c.id),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(LGSpacing.sm),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundImage: AssetImage(c.image),
                                  ),
                                  const SizedBox(width: LGSpacing.smd),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          c.name,
                                          style: theme.textTheme.titleSmall,
                                        ),
                                        Text(
                                          '${c.ordersCount} orders · OMR ${c.totalSpentOmr.toStringAsFixed(1)} spent',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  StatusPill(
                                    label: c.status.label,
                                    color: customerStatusColor(
                                      context,
                                      c.status,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
