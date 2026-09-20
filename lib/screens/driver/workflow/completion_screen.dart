import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';
import '../../../navigation/app_routes.dart';
import '../../../state/driver_controller.dart';

/// #69 Job Completion — the real success state after a delivery.
class CompletionScreen extends StatelessWidget {
  const CompletionScreen({super.key, required this.jobId});
  final String jobId;

  @override
  Widget build(BuildContext context) {
    final job = context.watch<DriverController>().jobById(jobId);
    return StateScene(
      image: LaundryGoAssets.driverCompletionScene,
      headline: 'Delivered!',
      body:
          '${job.customerName}\'s order is complete. You earned OMR ${job.payoutOmr.toStringAsFixed(3)} for this job.',
      primaryLabel: 'Back to Today',
      onPrimary: () =>
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoutes.driverHome, (r) => false),
      showBack: false,
    );
  }
}
