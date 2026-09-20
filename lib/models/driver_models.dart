import 'package:latlong2/latlong.dart';

/// The real job lifecycle a driver moves through — every Driver workflow
/// screen (#65-69) is a real step in this same sequence.
enum DriverJobStage { pending, accepted, pickedUp, delivered }

class DriverJob {
  DriverJob({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.customerPhone,
    required this.partnerName,
    required this.pickupAddress,
    required this.pickupLatLng,
    required this.deliveryAddress,
    required this.deliveryLatLng,
    required this.itemsSummary,
    required this.payoutOmr,
    required this.windowLabel,
    this.stage = DriverJobStage.pending,
  });

  final String id;
  final String customerName;
  final String customerImage;
  final String customerPhone;
  final String partnerName;
  final String pickupAddress;
  final LatLng pickupLatLng;
  final String deliveryAddress;
  final LatLng deliveryLatLng;
  final String itemsSummary;
  final double payoutOmr;
  final String windowLabel;
  DriverJobStage stage;
}
