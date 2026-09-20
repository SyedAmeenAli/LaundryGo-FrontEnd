import 'package:latlong2/latlong.dart';

import '../asset_registry/laundrygo_assets.dart';
import '../models/driver_models.dart';

/// Clean local mock data for the Driver product — same customers/partners
/// as the Customer and Partner mock data, coherent across all three roles.
class MockDriverData {
  MockDriverData._();

  static const driverName = 'Yousuf Al Habsi';
  static const driverImage = LaundryGoAssets.driverPortrait;
  static const vehicle = 'Toyota Hiace · Van · OM 4521';
  static const rating = 4.9;
  static const totalDeliveries = 1240;

  static List<DriverJob> seedJobs() => [
    DriverJob(
      id: '2460',
      customerName: 'Ahmed Al Balushi',
      customerImage: LaundryGoAssets.customerAhmed,
      customerPhone: '+968 9123 4567',
      partnerName: 'FreshFold Laundry',
      pickupAddress: 'Al Mouj Boulevard, Bldg. 6, Muscat',
      pickupLatLng: const LatLng(23.6165, 58.4390),
      deliveryAddress: 'Al Mouj Village Square, Villa 12, Muscat',
      deliveryLatLng: const LatLng(23.6190, 58.4410),
      itemsSummary: 'Wash & Fold · 6 items',
      payoutOmr: 1.200,
      windowLabel: 'Today, 4:00 - 5:00 PM',
      stage: DriverJobStage.pending,
    ),
    DriverJob(
      id: '2461',
      customerName: 'Fatima Al Rawahi',
      customerImage: LaundryGoAssets.customerFatima,
      customerPhone: '+968 9234 5678',
      partnerName: 'PureClean Services',
      pickupAddress: 'Qurum Heights Road 12, Muscat',
      pickupLatLng: const LatLng(23.6140, 58.4780),
      deliveryAddress: 'Qurum Beach Apartments, Flat 4B, Muscat',
      deliveryLatLng: const LatLng(23.6095, 58.4855),
      itemsSummary: 'Dry Cleaning · 3 items',
      payoutOmr: 1.500,
      windowLabel: 'Today, 5:30 - 6:30 PM',
      stage: DriverJobStage.pending,
    ),
    DriverJob(
      id: '2455',
      customerName: 'Sultan Al Habsi',
      customerImage: LaundryGoAssets.customerSultan,
      customerPhone: '+968 9345 6789',
      partnerName: 'LaundryHub',
      pickupAddress: 'Ghubra North Street 5, Muscat',
      pickupLatLng: const LatLng(23.5930, 58.4080),
      deliveryAddress: 'Ghubra Plaza, Bldg. 2, Muscat',
      deliveryLatLng: const LatLng(23.5955, 58.4110),
      itemsSummary: 'Ironing · 3 items',
      payoutOmr: 1.000,
      windowLabel: 'Today, 3:00 - 4:00 PM',
      stage: DriverJobStage.accepted,
    ),
    DriverJob(
      id: '2440',
      customerName: 'Mariam Al Zadjali',
      customerImage: LaundryGoAssets.customerMariam,
      customerPhone: '+968 9456 7890',
      partnerName: 'The Clean Lab',
      pickupAddress: 'Bausher Main Road 21, Muscat',
      pickupLatLng: const LatLng(23.5780, 58.4210),
      deliveryAddress: 'Bausher Heights, Villa 9, Muscat',
      deliveryLatLng: const LatLng(23.5810, 58.4245),
      itemsSummary: 'Dry Cleaning · 1 item',
      payoutOmr: 1.800,
      windowLabel: 'Yesterday, 6:00 PM',
      stage: DriverJobStage.delivered,
    ),
    DriverJob(
      id: '2432',
      customerName: 'Layla Al Farsi',
      customerImage: LaundryGoAssets.customerLayla,
      customerPhone: '+968 9567 8901',
      partnerName: 'FreshFold Laundry',
      pickupAddress: 'Al Mouj Boulevard, Bldg. 6, Muscat',
      pickupLatLng: const LatLng(23.6165, 58.4390),
      deliveryAddress: 'Shatti Al Qurum, Villa 3, Muscat',
      deliveryLatLng: const LatLng(23.6135, 58.4460),
      itemsSummary: 'Special Care · 1 item',
      payoutOmr: 1.400,
      windowLabel: '2 days ago',
      stage: DriverJobStage.delivered,
    ),
  ];

  static const weeklyDeliveries = [6, 8, 7, 9, 8, 11, 9];
  static const weeklyEarningsOmr = [7.2, 9.6, 8.4, 10.8, 9.6, 13.2, 10.8];
  static const weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
}
