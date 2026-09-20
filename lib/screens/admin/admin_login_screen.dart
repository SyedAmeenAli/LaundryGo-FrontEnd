import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/laundrygo_button.dart';
import '../../components/laundrygo_text_field.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Admin Login — a distinct auth entry point from Customer/Partner/Driver
/// (different credentials, same visual language). Reached from any role's
/// "Switch to Admin View" row; on success replaces the stack with
/// [AdminRoutes.adminHome] the same way every other role's login does.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return AuthScaffold(
      heroImage: LaundryGoAssets.adminAtmosphericBackground,
      cornerLines: const ['CLEAN', 'CLOTHES', 'HAPPIER', 'DAYS'],
      heroHeight: 100,
      showBack: true,
      onBack: () => Navigator.of(context).maybePop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ADMIN ACCESS',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          RichText(
            text: TextSpan(
              style: theme.textTheme.headlineLarge,
              children: [
                const TextSpan(text: 'Operations\n'),
                TextSpan(
                  text: 'Console.',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text(
            'Sign in with your LaundryGo admin credentials.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          const LaundryGoTextField(
            hint: 'Admin email',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: LGSpacing.smd),
          LaundryGoTextField(
            hint: 'Password',
            icon: Icons.lock_outline,
            obscureText: _obscure,
            trailing: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          const SizedBox(height: LGSpacing.md),
          LaundryGoButton(
            label: 'Log In',
            showArrow: true,
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(AppRoutes.adminHome, (r) => false),
          ),
          const SizedBox(height: LGSpacing.sm),
          Center(
            child: Text(
              'Restricted to authorized LaundryGo staff only.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
