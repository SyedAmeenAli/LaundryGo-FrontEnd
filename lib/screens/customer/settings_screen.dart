import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/customer/settings_row.dart';
import '../../components/delete_account_dialog.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../i18n/strings.dart';
import '../../navigation/app_routes.dart';
import '../../state/locale_controller.dart';
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
    final localeController = context.watch<LocaleController>();

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
                Text(tr(context, 'App'), style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.tune,
                      title: tr(context, 'Appearance'),
                      subtitle: tr(context, 'Light, dark or match system'),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AppearanceScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.notifications_active_outlined,
                      title: tr(context, 'Push Notifications'),
                      subtitle: tr(context, 'Order updates and offers'),
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
                      title: tr(context, 'Language'),
                      subtitle: localeController.isArabic
                          ? 'العربية'
                          : 'English',
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (dialogContext) => SimpleDialog(
                          title: Text(tr(context, 'Language')),
                          children: [
                            SimpleDialogOption(
                              onPressed: () {
                                localeController.setArabic(false);
                                Navigator.of(dialogContext).pop();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: localeController.isArabic
                                        ? Colors.transparent
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('English'),
                                ],
                              ),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                localeController.setArabic(true);
                                Navigator.of(dialogContext).pop();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check,
                                    size: 16,
                                    color: localeController.isArabic
                                        ? null
                                        : Colors.transparent,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('العربية'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Text(tr(context, 'Account'), style: theme.textTheme.titleLarge),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.lock_reset_outlined,
                      title: tr(context, 'Change Password'),
                      subtitle: tr(context, 'Update your account password'),
                      onTap: () =>
                          Navigator.of(context)
                              .pushNamed(AppRoutes.forgotPassword),
                    ),
                    SettingsRow(
                      icon: Icons.logout,
                      title: tr(context, 'Log Out'),
                      subtitle: tr(context, 'Sign out of this device'),
                      onTap: () => showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: Text(tr(context, 'Log out?')),
                          content: Text(
                            tr(
                              context,
                              "You'll need to sign back in to book pickups.",
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text(tr(context, 'Cancel')),
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
                                tr(context, 'Log Out'),
                                style: TextStyle(color: red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.delete_outline,
                      title: tr(context, 'Delete Account'),
                      subtitle: tr(
                        context,
                        'Permanently delete your account and data',
                      ),
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
                Text(
                  tr(context, 'Troubleshooting'),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: LGSpacing.sm),
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.wifi_off_outlined,
                      title: tr(context, 'Connection Status'),
                      subtitle: "See what LaundryGo looks like offline",
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const OfflineScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.error_outline,
                      title: tr(context, 'Report a Technical Issue'),
                      subtitle: 'Simulate and preview an error state',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NetworkErrorScreen(),
                        ),
                      ),
                    ),
                    SettingsRow(
                      icon: Icons.delete_sweep_outlined,
                      title: tr(context, 'Clear Order History'),
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
