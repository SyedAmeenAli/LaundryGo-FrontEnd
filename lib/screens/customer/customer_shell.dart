import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/bottom_nav.dart';
import '../../state/cart_controller.dart';
import 'cart_screen.dart';
import 'customer_home_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

/// Tab shell for Home/Orders/Cart/Profile.
class CustomerShell extends StatefulWidget {
  const CustomerShell({super.key});

  @override
  State<CustomerShell> createState() => _CustomerShellState();
}

class _CustomerShellState extends State<CustomerShell> {
  int _index = 0;

  static const _pages = [
    CustomerHomeScreen(),
    OrdersScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cartCount = context.watch<CartController>().itemCount;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _pages),
      ),
      bottomNavigationBar: LaundryGoBottomNav(
        currentIndex: _index,
        cartCount: cartCount,
        onSelect: (i) => setState(() => _index = i),
      ),
    );
  }
}
