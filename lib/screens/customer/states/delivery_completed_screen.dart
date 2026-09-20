import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';
import '../../../models/customer_models.dart';
import '../../../navigation/app_routes.dart';

class DeliveryCompletedScreen extends StatelessWidget {
  const DeliveryCompletedScreen({super.key, required this.order});

  final PastOrderSummary order;

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.deliveryCompleted,
      headline: 'Delivered',
      body:
          '${order.partnerName} delivered your ${order.service.toLowerCase()} order on ${order.date}. Total OMR ${order.priceOmr.toStringAsFixed(3)}.',
      primaryLabel: 'Reorder',
      onPrimary: () =>
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.services, (r) => r.isFirst),
      secondaryLabel: 'Done',
      onSecondary: () => Navigator.of(context).maybePop(),
    );
  }
}
