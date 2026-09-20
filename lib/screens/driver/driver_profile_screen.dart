import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/settings_row.dart';
import '../../components/delete_account_dialog.dart';
import '../../data/mock_driver_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/theme_controller.dart';
import '../admin/admin_login_screen.dart';
import '../customer/appearance_screen.dart';
import '../customer/info_detail_screen.dart';
import 'widgets/driver_header.dart';

/// #71 Driver Profile/Settings — identity, vehicle, appearance, support.
class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final themeController = context.watch<ThemeController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DriverHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(MockDriverData.driverImage),
                ),
                const SizedBox(width: LGSpacing.smd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        MockDriverData.driverName,
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 13,
                            color: LGColors.ratingGold,
                          ),
                          Text(
                            ' ${MockDriverData.rating}  (${MockDriverData.totalDeliveries} deliveries)',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Text(
                        MockDriverData.vehicle,
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
                SettingsRow(
                  icon: Icons.tune,
                  title: 'Appearance',
                  subtitle: 'Light, dark or match system',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AppearanceScreen()),
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
                  icon: Icons.support_agent_outlined,
                  title: 'Support',
                  subtitle: 'Get help from the LaundryGo team',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const InfoDetailScreen(
                        eyebrow: 'SUPPORT',
                        title: 'Driver ',
                        accent: 'Support',
                        paragraphs: [
                          'Our driver support line is open every day, 7 AM to 11 PM, for anything from a locked pickup gate to a payout question.',
                        ],
                        contactRows: [],
                      ),
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
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Switch to Admin View',
                  subtitle: 'Preview the platform operations console',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AdminLoginScreen(),
                    ),
                  ),
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
                        'You will need to sign back in to see your jobs.',
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
                              AppRoutes.login,
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
                  subtitle: 'Permanently delete your driver account',
                  onTap: () => showDeleteAccountDialog(
                    context,
                    onConfirmed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Account deleted.')),
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login,
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
