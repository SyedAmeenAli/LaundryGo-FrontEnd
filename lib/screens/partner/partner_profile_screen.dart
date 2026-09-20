import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/settings_row.dart';
import '../../components/delete_account_dialog.dart';
import '../../data/mock_partner_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/partner_controller.dart';
import '../../state/theme_controller.dart';
import '../admin/admin_login_screen.dart';
import 'partner_capacity_screen.dart';
import 'partner_pricing_screen.dart';
import 'widgets/partner_header.dart';

/// #62 Partner Profile/Settings — business identity, hours, and app
/// controls. Every row here either opens a real screen or genuinely
/// changes state (no decorative rows).
class PartnerProfileScreen extends StatelessWidget {
  const PartnerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final themeController = context.watch<ThemeController>();
    context.watch<PartnerController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PartnerHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MockPartnerData.businessName,
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 13,
                      color: LGColors.ratingGold,
                    ),
                    Text(
                      ' 4.8 (320 reviews)',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Text(
                  MockPartnerData.businessAddress,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(LGSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16),
                      const SizedBox(width: 6),
                      Text('Opening Hours', style: theme.textTheme.titleSmall),
                    ],
                  ),
                  const SizedBox(height: 4),
                  for (final h in MockPartnerData.businessHours)
                    Padding(
                      padding: const EdgeInsets.only(left: 22, top: 2),
                      child: Text(
                        h,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
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
                  icon: Icons.sell_outlined,
                  title: 'Pricing',
                  subtitle: 'Edit your service prices',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerPricingScreen(),
                    ),
                  ),
                ),
                SettingsRow(
                  icon: Icons.speed_outlined,
                  title: 'Capacity',
                  subtitle: 'Daily order limit',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PartnerCapacityScreen(),
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
                SettingsRow(
                  icon: Icons.logout,
                  title: 'Log Out',
                  subtitle: 'Sign out of this device',
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Log out?'),
                      content: const Text(
                        'You will need to sign back in to manage orders.',
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
                  subtitle: 'Permanently delete your business account',
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
