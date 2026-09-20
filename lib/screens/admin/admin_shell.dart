import 'package:flutter/material.dart';

import '../../components/app_bottom_nav.dart';
import 'admin_dashboard_screen.dart';
import 'admin_drivers_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_partners_screen.dart';
import 'admin_profile_screen.dart';

/// Tab shell for the Admin product — Dashboard/Orders/Partners/Drivers
/// /Profile. Entirely separate navigation stack from Customer/Partner
/// /Driver, same floating-pill chrome as every other role.
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  static const _pages = [
    AdminDashboardScreen(),
    AdminOrdersScreen(),
    AdminPartnersScreen(),
    AdminDriversScreen(),
    AdminProfileScreen(),
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
      outline: Icons.storefront_outlined,
      filled: Icons.storefront,
      label: 'Partners',
    ),
    AppNavItem(
      outline: Icons.local_shipping_outlined,
      filled: Icons.local_shipping,
      label: 'Drivers',
    ),
    AppNavItem(
      outline: Icons.person_outline,
      filled: Icons.person,
      label: 'Profile',
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
