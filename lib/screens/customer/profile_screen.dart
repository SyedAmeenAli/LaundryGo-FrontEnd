import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/customer_header.dart';
import '../../components/customer/settings_row.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/theme_controller.dart';
import '../admin/admin_login_screen.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final order = MockCustomerData.activeOrder;
    final themeController = context.watch<ThemeController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomerHeader(
            onNotificationTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundImage: AssetImage(order.driverImage),
                    ),
                    Positioned(
                      right: -2,
                      bottom: -2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Photo library coming soon.'),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: LGSpacing.smd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.driverName, style: theme.textTheme.titleLarge),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 13,
                            color: LGColors.ratingGold,
                          ),
                          Text(
                            ' ${order.driverRating}  (${order.driverDeliveries} deliveries)',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        'ahmed.balushi@gmail.com',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '+968 9123 4567',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const EditProfileScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Edit Profile'),
                  style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(LGSpacing.md),
              decoration: BoxDecoration(
                color: green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: green.withValues(alpha: 0.15),
                    child: Icon(
                      Icons.workspace_premium_outlined,
                      size: 16,
                      color: green,
                    ),
                  ),
                  const SizedBox(width: LGSpacing.smd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LaundryGo Plus',
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'Get exclusive offers, faster delivery and more.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.offers),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: green,
                      side: BorderSide(color: green),
                      shape: const StadiumBorder(),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Learn More'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  subtitle: 'Manage your pickup and delivery addresses',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.addresses),
                ),
                SettingsRow(
                  icon: Icons.description_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Cards, wallets and more',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.paymentMethods),
                ),
                SettingsRow(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Offers & Rewards',
                  subtitle: 'View your coupons and benefits',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.offers),
                ),
                SettingsRow(
                  icon: Icons.history,
                  title: 'Order History',
                  subtitle: 'Track and reorder previous orders',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.orderHistory),
                ),
                SettingsRow(
                  icon: Icons.favorite_border,
                  title: 'Saved Items',
                  subtitle: 'Your favourite services and items',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.savedItems),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              0,
            ),
            child: Text('Help & Support', style: theme.textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.sm,
              LGSpacing.md,
              0,
            ),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.forum_outlined,
                  title: 'Help Center',
                  subtitle: 'FAQs and support',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.helpCenter),
                ),
                SettingsRow(
                  icon: Icons.call_outlined,
                  title: 'Contact Us',
                  subtitle: 'Get in touch with our team',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.contactUs),
                ),
                SettingsRow(
                  icon: Icons.verified_user_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.privacyPolicy),
                ),
                SettingsRow(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Our terms of service',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.terms),
                ),
                SettingsRow(
                  icon: Icons.info_outline,
                  title: 'About LaundryGo',
                  subtitle: 'Our story and stats',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.lg,
              LGSpacing.md,
              0,
            ),
            child: Text('App Settings', style: theme.textTheme.titleLarge),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.sm,
              LGSpacing.md,
              LGSpacing.xl,
            ),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark mode',
                  trailing: Switch(
                    value: themeController.mode == ThemeMode.dark,
                    activeThumbColor: red,
                    onChanged: (v) {
                      themeController.setMode(
                        v ? ThemeMode.dark : ThemeMode.light,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(v ? 'Dark mode on.' : 'Light mode on.'),
                        ),
                      );
                    },
                  ),
                ),
                SettingsRow(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  subtitle: 'Appearance, notifications, account',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
              LGSpacing.xl,
            ),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.storefront_outlined,
                  title: 'Switch to Partner View',
                  subtitle: "Preview FreshFold Laundry's operations app",
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.partnerHome,
                    (r) => false,
                  ),
                ),
                SettingsRow(
                  icon: Icons.local_shipping_outlined,
                  title: 'Switch to Driver View',
                  subtitle: "Preview a driver's delivery app",
                  onTap: () => Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.driverHome, (r) => false),
                ),
                SettingsRow(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Switch to Admin View',
                  subtitle: 'Preview the platform operations console',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminLoginScreen(),
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
