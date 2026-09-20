import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';
import '../../../navigation/app_routes.dart';

class PartnerUnavailableScreen extends StatelessWidget {
  const PartnerUnavailableScreen({super.key, required this.partnerName});

  final String partnerName;

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.partnerUnavailable,
      headline: '$partnerName is closed',
      body: "This partner isn't accepting new pickups right now. Browse other nearby partners instead.",
      primaryLabel: 'Browse Other Partners',
      onPrimary: () =>
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.partnerDiscovery),
    );
  }
}
