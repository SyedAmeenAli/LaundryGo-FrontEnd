import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/laundrygo_button.dart';
import '../../components/laundrygo_text_field.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Screen 07 — Account Details. Reference: step progress (Login/Verify
/// done, Your Details current), full name / email / phone (with +968
/// country code) / pickup address / city, terms checkbox.
class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return AuthScaffold(
      heroImage: LaundryGoAssets.omanCoastline,
      cornerLines: const ['CLEAN', 'CLOTHES', 'HAPPIER', 'PEOPLE'],
      heroHeight: 92,
      showBack: true,
      onBack: () => Navigator.of(context).pop(),
      showSkip: true,
      onSkip: () => Navigator.of(context).pushNamed(AppRoutes.welcome),
      stepProgress: const AuthStepProgress(
        steps: ['Login', 'Verify', 'Your Details'],
        currentIndex: 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ALMOST DONE',
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
                const TextSpan(text: 'Tell Us\nAbout '),
                TextSpan(
                  text: 'You',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text(
            'A few details to personalize your LaundryGo experience.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          const LaundryGoTextField(
            hint: 'Full name',
            icon: Icons.person_outline,
            dense: true,
          ),
          const SizedBox(height: LGSpacing.sm),
          LaundryGoTextField(
            hint: 'alex@example.com',
            icon: Icons.mail_outline,
            enabled: false,
            dense: true,
          ),
          const SizedBox(height: LGSpacing.sm),
          const LaundryGoTextField(
            hint: 'Phone number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            dense: true,
          ),
          const SizedBox(height: LGSpacing.sm),
          const LaundryGoTextField(
            hint: 'Pickup address',
            icon: Icons.location_on_outlined,
            dense: true,
          ),
          const SizedBox(height: LGSpacing.sm),
          const LaundryGoTextField(
            hint: 'City',
            icon: Icons.location_city_outlined,
            trailing: Icon(Icons.expand_more, size: 20),
            dense: true,
          ),
          const SizedBox(height: LGSpacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _agreed,
                onChanged: (v) => setState(() => _agreed = v ?? false),
                activeColor: red,
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodySmall,
                    children: const [
                      TextSpan(text: 'I agree to the '),
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LGSpacing.sm),
          LaundryGoButton(
            label: 'Create Account',
            showArrow: true,
            onPressed: _agreed
                ? () => Navigator.of(context).pushNamed(AppRoutes.welcome)
                : null,
          ),
          const SizedBox(height: LGSpacing.xs),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back'),
            ),
          ),
        ],
      ),
    );
  }
}
