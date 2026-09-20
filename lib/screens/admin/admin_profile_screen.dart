import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/settings_row.dart';
import '../../components/delete_account_dialog.dart';
import '../../data/mock_admin_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/admin_controller.dart';
import '../../state/theme_controller.dart';
import 'admin_customers_screen.dart';
import 'admin_disputes_screen.dart';
import 'admin_payouts_screen.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';

/// Admin Profile — account identity plus the console's real management
/// links (Customers, Disputes, Payouts sit here rather than as bottom-nav
/// tabs, same "secondary destinations live in Profile" rule as Partner's
/// Pricing/Capacity).
class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final themeController = context.watch<ThemeController>();
    final controller = context.watch<AdminController>();

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
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: const AssetImage(
                    LaundryGoAssets.customerPortraitFemale,
                  ),
                  backgroundColor: theme.colorScheme.surface,
                ),
                const SizedBox(width: LGSpacing.smd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MockAdminData.adminName,
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        MockAdminData.adminRole,
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        MockAdminData.adminEmail,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.people_outline,
                  title: 'Customers',
                  subtitle: '${controller.customers.length} registered',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminCustomersScreen(),
                    ),
                  ),
                ),
                SettingsRow(
                  icon: Icons.report_gmailerrorred_outlined,
                  title: 'Disputes',
                  subtitle:
                      '${controller.openDisputesCount} open of ${controller.disputes.length}',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminDisputesScreen(),
                    ),
                  ),
                ),
                SettingsRow(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Payouts',
                  subtitle: 'Partner earnings & commission',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminPayoutsScreen(),
                    ),
                  ),
                ),
                SettingsRow(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: 'Switch between light and dark mode',
                  trailing: Switch(
                    value: themeController.mode == ThemeMode.dark,
                    activeThumbColor: red,
                    onChanged: (v) => themeController.setMode(
                      v ? ThemeMode.dark : ThemeMode.light,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.person_outline,
                  title: 'Switch to Customer View',
                  subtitle: 'Back to the LaundryGo customer app',
                  onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.customerHome,
                    (r) => false,
                  ),
                ),
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
                  icon: Icons.logout,
                  title: 'Log Out',
                  subtitle: 'Sign out of this device',
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Log out?'),
                      content: const Text(
                        'You will need to sign back in to manage the platform.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.adminLogin,
                              (r) => false,
                            );
                          },
                          child: Text('Log Out', style: TextStyle(color: red)),
                        ),
                      ],
                    ),
                  ),
                ),
                SettingsRow(
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your admin account',
                  onTap: () => showDeleteAccountDialog(
                    context,
                    onConfirmed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account deleted.')),
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.adminLogin,
                        (r) => false,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xl),
        ],
      ),
    );
  }
}
