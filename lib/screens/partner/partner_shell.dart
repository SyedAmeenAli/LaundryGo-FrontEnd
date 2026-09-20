import 'package:flutter/material.dart';

import '../../components/app_bottom_nav.dart';
import 'partner_analytics_screen.dart';
import 'partner_dashboard_screen.dart';
import 'partner_orders_screen.dart';
import 'partner_profile_screen.dart';
import 'partner_services_screen.dart';

/// Tab shell for the Partner product — Dashboard/Orders/Services/Analytics
/// /Profile. Entirely separate navigation stack from Customer; Partner
/// never shares Customer's bottom nav or tab set.
class PartnerShell extends StatefulWidget {
  const PartnerShell({super.key});

  @override
  State<PartnerShell> createState() => _PartnerShellState();
}

class _PartnerShellState extends State<PartnerShell> {
  int _index = 0;

  static const _pages = [
    PartnerDashboardScreen(),
    PartnerOrdersScreen(),
    PartnerServicesScreen(),
    PartnerAnalyticsScreen(),
    PartnerProfileScreen(),
  ];

  static const _items = [
    AppNavItem(
      outline: Icons.dashboard_outlined,
      filled: Icons.dashboard,
      label: 'Dashboard',
    ),
    AppNavItem(
      outline: Icons.receipt_long_outlined,
      filled: Icons.receipt_long,
      label: 'Orders',
    ),
    AppNavItem(
      outline: Icons.local_laundry_service_outlined,
      filled: Icons.local_laundry_service,
      label: 'Services',
    ),
    AppNavItem(
      outline: Icons.bar_chart_outlined,
      filled: Icons.bar_chart,
      label: 'Analytics',
    ),
    AppNavItem(
      outline: Icons.storefront_outlined,
      filled: Icons.storefront,
      label: 'Business',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _pages),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        items: _items,
        onSelect: (i) => setState(() => _index = i),
      ),
    );
  }
}
