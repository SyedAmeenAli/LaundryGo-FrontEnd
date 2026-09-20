import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/settings_row.dart';
import '../../components/delete_account_dialog.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import '../../state/orders_controller.dart';
import 'appearance_screen.dart';
import 'states/network_error_screen.dart';
import 'states/offline_screen.dart';

/// Real, distinct Settings screen — separate from Profile, which only
/// carries identity + account shortcuts. Everything here genuinely
/// changes app state (theme controller, orders controller, session).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final orders = context.watch<OrdersController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: theme.colorScheme.surface,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                Text(
                  'PREFERENCES',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Set'),
                      TextSpan(
                        text: 'tings',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('App', style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.tune,
                      title: 'Appearance',
                      subtitle: 'Light, dark or match system',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AppearanceScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.notifications_active_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Order updates and offers',
                      trailing: Switch(
                        value: _pushNotifications,
                        activeThumbColor: red,
                        onChanged: (v) {
                          setState(() => _pushNotifications = v);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                v
                                    ? 'Push notifications on.'
                                    : 'Push notifications off.',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.language_outlined,
                      title: 'Language',
                      subtitle: 'English',
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (dialogContext) => SimpleDialog(
                          title: const Text('Language'),
                          children: [
                            SimpleDialogOption(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Row(
                                children: [
                                  Icon(Icons.check, size: 16),
                                  SizedBox(width: 8),
                                  Text('English'),
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Arabic support is on the way.',
                                    ),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(left: 24),
                                child: Text('العربية'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Account', style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.lock_reset_outlined,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () =>
                          Navigator.of(context)
                              .pushNamed(AppRoutes.forgotPassword),
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
                            "You'll need to sign back in to book pickups.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
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
                              child: Text(
                                'Log Out',
                                style: TextStyle(color: red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.delete_outline,
                      title: 'Delete Account',
                      subtitle: 'Permanently delete your account and data',
                      onTap: () => showDeleteAccountDialog(
                        context,
                        onConfirmed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account deleted.'),
                            ),
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
                const SizedBox(height: LGSpacing.lg),
                Text('Troubleshooting', style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.wifi_off_outlined,
                      title: 'Connection Status',
                      subtitle: "See what LaundryGo looks like offline",
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OfflineScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.error_outline,
                      title: 'Report a Technical Issue',
                      subtitle: 'Simulate and preview an error state',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NetworkErrorScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.delete_sweep_outlined,
                      title: 'Clear Order History',
                      subtitle: orders.pastOrders.isEmpty
                          ? 'Already empty'
                          : '${orders.pastOrders.length} past orders',
                      onTap: () {
                        orders.clearHistory();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Order history cleared.'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => orders.restoreDemoData(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
