import 'package:flutter/material.dart';

import '../../components/app_bottom_nav.dart';
import 'driver_history_screen.dart';
import 'driver_profile_screen.dart';
import 'driver_today_screen.dart';

/// Tab shell for the Driver product — Today/History/Profile. Deliberately
/// fewer tabs than Partner: the driver's job is simple and action-first.
class DriverShell extends StatefulWidget {
  const DriverShell({super.key});

  @override
  State<DriverShell> createState() => _DriverShellState();
}

class _DriverShellState extends State<DriverShell> {
  int _index = 0;

  static const _pages = [
    DriverTodayScreen(),
    DriverHistoryScreen(),
    DriverProfileScreen(),
  ];

  static const _items = [
    AppNavItem(
      outline: Icons.local_shipping_outlined,
      filled: Icons.local_shipping,
      label: 'Today',
    ),
    AppNavItem(outline: Icons.history, filled: Icons.history, label: 'History'),
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
