import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../components/customer/map_panel.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../models/driver_models.dart';
import '../../../state/driver_controller.dart';
import 'customer_contact_screen.dart';
import 'delivery_screen.dart';
import 'pickup_screen.dart';

/// #66 Navigation — a real Google Maps route to wherever the driver needs
/// to go next (pickup or delivery, depending on the job's current stage).
class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key, required this.jobId});
  final String jobId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<DriverController>();
    final job = controller.jobById(jobId);
    final toPickup = job.stage == DriverJobStage.accepted;
    final destination = toPickup ? job.pickupLatLng : job.deliveryLatLng;
    final destinationLabel = toPickup ? job.pickupAddress : job.deliveryAddress;
    // Fixed nearby "current position" for the demo route — a real app
    // would use the device's live GPS.
    final driverPos = LatLng(
      destination.latitude - 0.008,
      destination.longitude - 0.006,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                LGSpacing.sm,
                LGSpacing.md,
                LGSpacing.sm,
              ),
              child: Row(
                children: [
                  Material(
                    color: theme.colorScheme.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: Text(
                      toPickup ? 'Navigate to Pickup' : 'Navigate to Delivery',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MapPanel(
                center: destination,
                route: [driverPos, destination],
                driverPosition: driverPos,
                destination: destination,
                height: double.infinity,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(LGSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        toPickup
                            ? Icons.storefront_outlined
                            : Icons.home_outlined,
                        size: 18,
                        color: red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          destinationLabel,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  CustomerContactScreen(jobId: jobId),
                            ),
                          ),
                          icon: const Icon(Icons.phone_outlined, size: 16),
                          label: const Text('Contact'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: LGSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => toPickup
                                      ? PickupScreen(jobId: jobId)
                                      : DeliveryScreen(jobId: jobId),
                                ),
                              ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: red,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            toPickup
                                ? "I've Arrived — Pickup"
                                : "I've Arrived — Deliver",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
