import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/benefit_row.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Screen 08 — Account Created / Welcome. Reference: completion moment,
/// no back/skip/step-progress (this is the destination, not a step), the
/// branded pickup-bag-at-doorway asset as the celebratory visual.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return AuthScaffold(
      heroImage: LaundryGoAssets.brandedBagAtOmaniDoorway,
      heroHeight: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ALL SET',
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
                const TextSpan(text: 'Welcome\nto '),
                TextSpan(
                  text: 'LaundryGo!',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text(
            'Your account has been created successfully.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text(
            "You're ready to experience hassle-free laundry, delivered to your doorstep.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.smd),
          const BenefitListItem(
            icon: Icons.checkroom_outlined,
            title: 'Easy Ordering',
            subtitle: 'Choose from a range of laundry services',
          ),
          const BenefitListItem(
            icon: Icons.local_shipping_outlined,
            title: 'Reliable Pickup & Delivery',
            subtitle: 'We collect, clean and bring it back to you',
          ),
          const BenefitListItem(
            icon: Icons.eco_outlined,
            title: 'More Time for You',
            subtitle: 'Fresh clothes, more time for what matters',
          ),
          const SizedBox(height: LGSpacing.sm),
          LaundryGoButton(
            label: 'Start Using LaundryGo',
            showArrow: true,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.location),
          ),
          const SizedBox(height: LGSpacing.xs),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.customerHome),
              child: const Text('Explore the App Later'),
            ),
          ),
        ],
      ),
    );
  }
}
