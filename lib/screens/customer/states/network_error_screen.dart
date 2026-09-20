import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';

class NetworkErrorScreen extends StatelessWidget {
  const NetworkErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.networkError,
      headline: 'Something went wrong',
      body: "We couldn't reach LaundryGo's servers. Your cart and orders are safe — try again.",
      primaryLabel: 'Try Again',
      onPrimary: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Connected.')));
        Navigator.of(context).maybePop();
      },
      secondaryLabel: 'Contact Support',
      onSecondary: () => Navigator.of(context).maybePop(),
    );
  }
}
