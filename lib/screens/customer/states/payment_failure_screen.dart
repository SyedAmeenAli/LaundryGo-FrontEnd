import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({
    super.key,
    this.reason = "Your bank didn't authorize this transfer.",
  });

  final String reason;

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.paymentFailure,
      headline: 'Payment failed',
      body: '$reason No charge was made — pick another method and try again.',
      primaryLabel: 'Choose Another Method',
      onPrimary: () => Navigator.of(context).pop(),
      secondaryLabel: 'Cancel',
      onSecondary: () => Navigator.of(context).popUntil((r) => r.isFirst),
    );
  }
}
