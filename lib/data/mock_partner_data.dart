import '../asset_registry/laundrygo_assets.dart';
import '../models/partner_models.dart';

/// Clean local mock data for the Partner product (FreshFold Laundry's own
/// operational view) — coherent with the Customer-side mock data (same
/// partner, same order volume ballpark).
class MockPartnerData {
  MockPartnerData._();

  static const businessName = 'FreshFold Laundry';
  static const businessAddress = 'Al Mouj Boulevard, Bldg. 6, Muscat, Oman';
  static const businessHours = [
    'Sunday - Thursday   8:00 AM - 10:00 PM',
    'Friday - Saturday   9:00 AM - 11:00 PM',
  ];

  static List<PartnerOrder> seedOrders() => [
    PartnerOrder(
      id: '2456',
      customerName: 'Ahmed Al Balushi',
      customerImage: LaundryGoAssets.customerAhmed,
      service: 'Wash & Fold',
      items: const [
        PartnerOrderItem(garment: 'Shirts', count: 4),
        PartnerOrderItem(garment: 'Trousers', count: 2),
      ],
      totalOmr: 8.500,
      dueLabel: 'Today, 4:20 PM',
      stage: PartnerOrderStage.processing,
    ),
    PartnerOrder(
      id: '2457',
      customerName: 'Fatima Al Rawahi',
      customerImage: LaundryGoAssets.customerFatima,
      service: 'Dry Cleaning',
      items: const [
        PartnerOrderItem(garment: 'Abaya', count: 1),
        PartnerOrderItem(garment: 'Dress Shirt', count: 2),
      ],
      totalOmr: 6.200,
      dueLabel: 'Today, 6:00 PM',
      stage: PartnerOrderStage.received,
    ),
    PartnerOrder(
      id: '2458',
      customerName: 'Sultan Al Habsi',
      customerImage: LaundryGoAssets.customerSultan,
      service: 'Ironing',
      items: const [PartnerOrderItem(garment: 'Dishdasha', count: 3)],
      totalOmr: 4.500,
      dueLabel: 'Tomorrow, 10:00 AM',
      stage: PartnerOrderStage.qualityControl,
    ),
    PartnerOrder(
      id: '2459',
      customerName: 'Layla Al Farsi',
      customerImage: LaundryGoAssets.customerLayla,
      service: 'Special Care',
      items: const [
        PartnerOrderItem(
          garment: 'Abaya (Embroidered)',
          count: 1,
          note: 'Hand wash only',
        ),
      ],
      totalOmr: 7.000,
      dueLabel: 'Tomorrow, 2:00 PM',
      stage: PartnerOrderStage.packaging,
    ),
    PartnerOrder(
      id: '2450',
      customerName: 'Yousuf Al Harthy',
      customerImage: LaundryGoAssets.customerYousuf,
      service: 'Wash & Fold',
      items: const [
        PartnerOrderItem(garment: 'Bedsheets', count: 2),
        PartnerOrderItem(garment: 'Towels', count: 4),
      ],
      totalOmr: 5.800,
      dueLabel: 'Yesterday, 6:00 PM',
      stage: PartnerOrderStage.readyForHandoff,
    ),
    PartnerOrder(
      id: '2444',
      customerName: 'Mariam Al Zadjali',
      customerImage: LaundryGoAssets.customerMariam,
      service: 'Dry Cleaning',
      items: const [PartnerOrderItem(garment: 'Suit', count: 1)],
      totalOmr: 9.000,
      dueLabel: 'Delivered',
      stage: PartnerOrderStage.handedOff,
    ),
  ];

  static List<PartnerServiceOffering> seedServices() => [
    PartnerServiceOffering(name: 'Wash & Fold', priceOmr: 2.500),
    PartnerServiceOffering(name: 'Dry Cleaning', priceOmr: 4.000),
    PartnerServiceOffering(name: 'Ironing', priceOmr: 1.500),
    PartnerServiceOffering(name: 'Special Care', priceOmr: 5.000),
    PartnerServiceOffering(
      name: 'Shoe Care',
      priceOmr: 3.000,
      available: false,
    ),
  ];

  // Last 7 days — orders received and revenue (OMR), internally coherent
  // with the ~4 orders/day shown in the mock order list.
  static const weeklyOrders = [3, 5, 4, 6, 5, 7, 6];
  static const weeklyRevenueOmr = [18.5, 27.0, 21.0, 32.5, 26.0, 38.0, 30.5];
  static const weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const avgTurnaroundHours = 6.4;
  static const completionRate = 0.96;
}
