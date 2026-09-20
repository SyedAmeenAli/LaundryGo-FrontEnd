import '../asset_registry/laundrygo_assets.dart';
import '../models/admin_models.dart';

/// Local mock data for the Admin product — internally coherent with the
/// Customer/Partner/Driver mock data (same partner names, same customers).
class MockAdminData {
  MockAdminData._();

  static const adminName = 'Noor Al Balushi';
  static const adminRole = 'Operations Manager';
  static const adminEmail = 'noor.albalushi@laundrygo.om';

  static List<AdminPartner> seedPartners() => [
    AdminPartner(
      id: 'freshfold',
      name: 'FreshFold Laundry',
      image: LaundryGoAssets.partnerStorefront1,
      category: 'Wash & Fold · Dry Cleaning',
      address: 'Al Mouj Boulevard, Bldg. 6, Muscat',
      rating: 4.8,
      ordersToday: 6,
      revenueOmrMonth: 842.500,
      joinedLabel: 'Jan 2024',
      status: PartnerAccountStatus.active,
    ),
    AdminPartner(
      id: 'pureclean',
      name: 'PureClean Services',
      image: LaundryGoAssets.partnerStorefront2,
      category: 'Dry Cleaning · Ironing',
      address: 'Qurum Street, Muscat',
      rating: 4.6,
      ordersToday: 4,
      revenueOmrMonth: 610.000,
      joinedLabel: 'Mar 2024',
      status: PartnerAccountStatus.active,
    ),
    AdminPartner(
      id: 'laundryhub',
      name: 'LaundryHub',
      image: LaundryGoAssets.partnerStorefront3,
      category: 'Wash & Fold · Special Care',
      address: 'Ghubra North, Muscat',
      rating: 4.4,
      ordersToday: 0,
      revenueOmrMonth: 128.000,
      joinedLabel: 'Aug 2026',
      status: PartnerAccountStatus.pending,
    ),
    AdminPartner(
      id: 'cleanlab',
      name: 'The Clean Lab',
      image: LaundryGoAssets.partnerStorefront4,
      category: 'Ironing · Bedding & Linen',
      address: 'Azaiba, Muscat',
      rating: 3.9,
      ordersToday: 1,
      revenueOmrMonth: 245.500,
      joinedLabel: 'Nov 2023',
      status: PartnerAccountStatus.suspended,
    ),
  ];

  static List<AdminDriver> seedDrivers() => [
    AdminDriver(
      id: 'drv-1',
      name: 'Yousuf Al Habsi',
      image: LaundryGoAssets.driverPortrait,
      vehicle: 'Toyota Hiace · Van · OM 4521',
      rating: 4.9,
      deliveriesToday: 8,
      completionRate: 0.98,
      joinedLabel: 'Feb 2024',
      status: DriverAccountStatus.active,
    ),
    AdminDriver(
      id: 'drv-2',
      name: 'Salim Al Kindi',
      image: LaundryGoAssets.driverPortrait,
      vehicle: 'Suzuki Every · Van · OM 7712',
      rating: 4.7,
      deliveriesToday: 5,
      completionRate: 0.95,
      joinedLabel: 'May 2024',
      status: DriverAccountStatus.active,
    ),
    AdminDriver(
      id: 'drv-3',
      name: 'Huda Al Riyami',
      image: LaundryGoAssets.driverPortraitFemale,
      vehicle: 'Honda Activa · Scooter · OM 2290',
      rating: 4.8,
      deliveriesToday: 6,
      completionRate: 0.97,
      joinedLabel: 'Jul 2026',
      status: DriverAccountStatus.pending,
    ),
    AdminDriver(
      id: 'drv-4',
      name: 'Rashid Al Lawati',
      image: LaundryGoAssets.driverPortrait,
      vehicle: 'Nissan Urvan · Van · OM 3387',
      rating: 3.6,
      deliveriesToday: 0,
      completionRate: 0.81,
      joinedLabel: 'Sep 2023',
      status: DriverAccountStatus.suspended,
    ),
  ];

  static List<AdminCustomer> seedCustomers() => [
    AdminCustomer(
      id: 'cus-1',
      name: 'Ahmed Al Balushi',
      image: LaundryGoAssets.customerAhmed,
      ordersCount: 14,
      totalSpentOmr: 118.500,
      joinedLabel: 'Jan 2025',
    ),
    AdminCustomer(
      id: 'cus-2',
      name: 'Fatima Al Rawahi',
      image: LaundryGoAssets.customerFatima,
      ordersCount: 9,
      totalSpentOmr: 76.200,
      joinedLabel: 'Mar 2025',
    ),
    AdminCustomer(
      id: 'cus-3',
      name: 'Sultan Al Habsi',
      image: LaundryGoAssets.customerSultan,
      ordersCount: 21,
      totalSpentOmr: 204.000,
      joinedLabel: 'Aug 2024',
    ),
    AdminCustomer(
      id: 'cus-4',
      name: 'Layla Al Farsi',
      image: LaundryGoAssets.customerLayla,
      ordersCount: 3,
      totalSpentOmr: 27.000,
      joinedLabel: 'Jun 2026',
    ),
    AdminCustomer(
      id: 'cus-5',
      name: 'Yousuf Al Harthy',
      image: LaundryGoAssets.customerYousuf,
      ordersCount: 6,
      totalSpentOmr: 51.800,
      joinedLabel: 'Feb 2026',
    ),
    AdminCustomer(
      id: 'cus-6',
      name: 'Mariam Al Zadjali',
      image: LaundryGoAssets.customerMariam,
      ordersCount: 1,
      totalSpentOmr: 9.000,
      joinedLabel: 'Sep 2026',
      status: CustomerAccountStatus.blocked,
    ),
  ];

  static List<AdminOrderSummary> seedOrders() => [
    AdminOrderSummary(
      id: 'LG2456',
      customerName: 'Ahmed Al Balushi',
      customerImage: LaundryGoAssets.customerAhmed,
      partnerName: 'FreshFold Laundry',
      totalOmr: 9.500,
      placedLabel: 'Today, 10:00 AM',
      status: OrderStatus.inCleaning,
    ),
    AdminOrderSummary(
      id: 'LG2457',
      customerName: 'Fatima Al Rawahi',
      customerImage: LaundryGoAssets.customerFatima,
      partnerName: 'PureClean Services',
      totalOmr: 6.200,
      placedLabel: 'Today, 9:15 AM',
      status: OrderStatus.pickedUp,
    ),
    AdminOrderSummary(
      id: 'LG2458',
      customerName: 'Sultan Al Habsi',
      customerImage: LaundryGoAssets.customerSultan,
      partnerName: 'FreshFold Laundry',
      totalOmr: 4.500,
      placedLabel: 'Yesterday, 4:00 PM',
      status: OrderStatus.outForDelivery,
    ),
    AdminOrderSummary(
      id: 'LG2459',
      customerName: 'Layla Al Farsi',
      customerImage: LaundryGoAssets.customerLayla,
      partnerName: 'The Clean Lab',
      totalOmr: 7.000,
      placedLabel: 'Yesterday, 1:20 PM',
      status: OrderStatus.delivered,
    ),
    AdminOrderSummary(
      id: 'LG2450',
      customerName: 'Yousuf Al Harthy',
      customerImage: LaundryGoAssets.customerYousuf,
      partnerName: 'PureClean Services',
      totalOmr: 5.800,
      placedLabel: 'Mon, 15 Sep',
      status: OrderStatus.delivered,
    ),
    AdminOrderSummary(
      id: 'LG2444',
      customerName: 'Mariam Al Zadjali',
      customerImage: LaundryGoAssets.customerMariam,
      partnerName: 'FreshFold Laundry',
      totalOmr: 9.000,
      placedLabel: 'Sun, 14 Sep',
      status: OrderStatus.delivered,
      refunded: true,
    ),
  ];

  static List<AdminDispute> seedDisputes() => [
    AdminDispute(
      id: 'DP-101',
      orderId: 'LG2444',
      customerName: 'Mariam Al Zadjali',
      customerImage: LaundryGoAssets.customerMariam,
      type: DisputeType.damagedItem,
      description:
          'Suit jacket returned with a burn mark near the left cuff that '
          'was not present at drop-off.',
      openedLabel: '2 days ago',
      status: DisputeStatus.resolved,
    ),
    AdminDispute(
      id: 'DP-102',
      orderId: 'LG2459',
      customerName: 'Layla Al Farsi',
      customerImage: LaundryGoAssets.customerLayla,
      type: DisputeType.lateDelivery,
      description:
          'Order was marked "Out for Delivery" at 2:00 PM but arrived '
          'almost 3 hours past the estimated window.',
      openedLabel: '5 hours ago',
      status: DisputeStatus.investigating,
    ),
    AdminDispute(
      id: 'DP-103',
      orderId: 'LG2450',
      customerName: 'Yousuf Al Harthy',
      customerImage: LaundryGoAssets.customerYousuf,
      type: DisputeType.missingItem,
      description:
          'Customer reports one bath towel missing from the delivered '
          'Wash & Fold bag (2 bedsheets, 4 towels ordered — 3 received).',
      openedLabel: '1 hour ago',
      status: DisputeStatus.open,
    ),
    AdminDispute(
      id: 'DP-104',
      orderId: 'LG2456',
      customerName: 'Ahmed Al Balushi',
      customerImage: LaundryGoAssets.customerAhmed,
      type: DisputeType.billing,
      description:
          'Charged OMR 9.500 but the in-app estimate at checkout showed '
          'OMR 8.500 — requesting a refund of the difference.',
      openedLabel: 'Just now',
      status: DisputeStatus.open,
    ),
  ];

  // Platform-wide last 7 days — orders and revenue across every partner.
  static const weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const weeklyOrders = [38, 45, 41, 52, 47, 61, 55];
  static const weeklyRevenueOmr = [
    286.5,
    340.0,
    312.5,
    398.0,
    356.5,
    468.0,
    421.0,
  ];
  static const weeklyNewCustomers = [4, 6, 3, 8, 5, 11, 9];
  static const platformCommissionRate = 0.12;
}
