import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.offline,
      headline: "You're offline",
      body: 'Check your connection — pickups, tracking and payments need internet to sync.',
      primaryLabel: 'Retry',
      onPrimary: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Reconnected.')));
        Navigator.of(context).maybePop();
      },
    );
  }
}
