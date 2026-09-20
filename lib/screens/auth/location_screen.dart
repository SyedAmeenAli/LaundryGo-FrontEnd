import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/benefit_row.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Screen 09 — Location permission / setup.
///
/// Deliberately does NOT recreate the reference's map-with-pins graphic:
/// that would be a generated fake map, and the brief is explicit that a
/// map must come from a real map provider, with generated assets usable
/// only as marker/support visuals over it. Wiring a real map SDK
/// (`google_maps_flutter` + platform API keys) is real scope beyond a
/// single screen pass, so this screen uses real photography only and
/// defers the actual map to when that integration lands.
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return AuthScaffold(
      heroImage: LaundryGoAssets.omanMuscatHero,
      cornerLines: const ['CLEAN', 'CLOTHES', 'HAPPIER', 'PEOPLE'],
      heroHeight: 190,
      showBack: true,
      onBack: () => Navigator.of(context).pop(),
      showSkip: true,
      onSkip: () =>
          Navigator.of(context).pushReplacementNamed(AppRoutes.customerHome),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'YOUR LOCATION',
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
                const TextSpan(text: 'Find the\nBest Laundry\n'),
                TextSpan(
                  text: 'Near You',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          Text(
            'Allow location access to show nearby laundry partners, faster pickup and delivery options.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.lg),
          const BenefitListItem(
            icon: Icons.location_on_outlined,
            title: 'Nearby Partners',
            subtitle: 'See trusted laundry services close to you.',
          ),
          const BenefitListItem(
            icon: Icons.schedule_outlined,
            title: 'Faster Service',
            subtitle: 'Get quicker pickup and delivery times.',
          ),
          const BenefitListItem(
            icon: Icons.near_me_outlined,
            title: 'Better Experience',
            subtitle: 'Personalized for your location.',
          ),
          const SizedBox(height: LGSpacing.md),
          LaundryGoButton(
            label: 'Allow Location Access',
            showArrow: true,
            onPressed: () =>
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.customerHome),
          ),
          const SizedBox(height: LGSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () =>
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.customerHome),
              child: const Text("I'll do this later"),
            ),
          ),
        ],
      ),
    );
  }
}
