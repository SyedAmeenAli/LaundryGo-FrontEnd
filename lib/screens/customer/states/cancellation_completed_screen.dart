import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';
import '../../../navigation/app_routes.dart';

class CancellationCompletedScreen extends StatelessWidget {
  const CancellationCompletedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.cancellationCompleted,
      headline: 'Order cancelled',
      body:
          'Order #LG$orderId has been cancelled. Any payment made will be refunded within 5 business days.',
      primaryLabel: 'Back to Orders',
      onPrimary: () =>
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.customerHome, (r) => false),
      showBack: false,
    );
  }
}
