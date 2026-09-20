import 'package:flutter/material.dart';

import '../asset_registry/laundrygo_asset_library.dart';
import '../asset_registry/laundrygo_assets.dart';
import '../models/customer_models.dart';

/// Clean local mock data for the Customer flow (Home/Services/Partner
/// Discovery/Partner Detail/Schedule/Tracking/Order Detail) — no backend
/// exists yet, per the project's "use clean local mock data" rule.
/// Photography is real supplied assets throughout; a few categories (shoes,
/// bags) have no dedicated real asset in the library, so they reuse the
/// closest real photo rather than fabricate one — documented at each spot.
class MockCustomerData {
  MockCustomerData._();

  static const services = <ServiceType>[
    ServiceType(
      name: 'Wash & Fold',
      descriptor: 'Everyday essentials',
      image: LaundryGoAssets.foldedStack,
      price: 5.0,
    ),
    ServiceType(
      name: 'Dry Cleaning',
      descriptor: 'Premium care',
      image: LaundryGoAssets.dressShirt,
      price: 4.0,
    ),
    ServiceType(
      name: 'Ironing',
      descriptor: 'Crisp & ready',
      image: LaundryGoAssets.steamIron,
      price: 1.5,
    ),
    ServiceType(
      name: 'Special Care',
      descriptor: 'For delicate items',
      image: LaundryGoAssets.abayaEmbroidered,
    ),
  ];

  /// GAP — no dedicated bag photography exists in the library; that one
  /// reuses the closest real asset. Shoes Cleaning uses a user-supplied
  /// photo (`LaundryGoAssets.shoesCleaning`), not a library asset.
  static const popularServices = <ServiceType>[
    ServiceType(
      name: 'Bedding & Linen',
      descriptor: 'Fresh and clean',
      image: LaundryGoAssets.bedsheet,
    ),
    ServiceType(
      name: 'Shoes Cleaning',
      descriptor: 'Look new again',
      image: LaundryGoAssets.shoesCleaning,
    ),
    ServiceType(
      name: 'Bags & Accessories',
      descriptor: 'Expert care',
      image: LaundryGoAssetLibrary.driverDeliveryBag,
    ),
  ];

  static const garments = <GarmentType>[
    GarmentType(name: 'T-shirt', image: LaundryGoAssets.tshirt),
    GarmentType(name: 'Dress Shirt', image: LaundryGoAssets.dressShirt),
    GarmentType(name: 'Trousers', image: LaundryGoAssets.trousers),
    GarmentType(name: 'Abaya', image: LaundryGoAssets.abaya),
    GarmentType(name: 'Dishdasha', image: LaundryGoAssets.dishdasha),
    GarmentType(name: 'Dress', image: LaundryGoAssets.foldedStack),
    GarmentType(name: 'Towel', image: LaundryGoAssets.towel),
  ];

  static const partners = <Partner>[
    Partner(
      id: 'freshfold',
      name: 'FreshFold Laundry',
      subtitle: 'Premium care for a fresher you.',
      image: LaundryGoAssets.partnerStorefront1,
      rating: 4.8,
      reviewCount: 320,
      distanceKm: 1.2,
      services: ['Wash & Fold', 'Dry Cleaning', 'Ironing'],
      openStatus: 'Open Now',
      pickupTiming: 'Pickup today',
      address: 'Al Mouj, Muscat',
      addressLine: 'Al Mouj Boulevard, Bldg. 6\nMuscat, Oman',
      phone: '+968 9123 4567',
      hours: [
        'Sunday - Thursday   8:00 AM - 10:00 PM',
        'Friday - Saturday   9:00 AM - 11:00 PM',
      ],
      // Al Mouj Boulevard is on-land, inland of the marina — the previous
      // 23.6270 sat out over the Gulf of Oman itself, which is why the
      // embedded map rendered as flat open water.
      lat: 23.6165,
      lng: 58.4390,
    ),
    Partner(
      id: 'pureclean',
      name: 'PureClean Services',
      subtitle: 'Spotless results, every time.',
      image: LaundryGoAssets.partnerStorefront2,
      rating: 4.6,
      reviewCount: 128,
      distanceKm: 2.4,
      services: ['Dry Cleaning', 'Special Care', 'Ironing'],
      openStatus: 'Open Now',
      pickupTiming: 'Pickup today',
      address: 'Qurum, Muscat',
      addressLine: 'Qurum Heights Road 12\nMuscat, Oman',
      phone: '+968 9234 5678',
      hours: [
        'Sunday - Thursday   8:00 AM - 9:00 PM',
        'Friday - Saturday   9:00 AM - 10:00 PM',
      ],
      lat: 23.6140,
      lng: 58.4780,
    ),
    Partner(
      id: 'laundryhub',
      name: 'LaundryHub',
      subtitle: 'Neighborhood laundry, done right.',
      image: LaundryGoAssets.partnerStorefront3,
      rating: 4.5,
      reviewCount: 96,
      distanceKm: 3.1,
      services: ['Wash & Fold', 'Ironing', 'Bedding'],
      openStatus: 'Open until 8 PM',
      pickupTiming: 'Pickup today',
      address: 'Al Khuwair, Muscat',
      addressLine: 'Al Khuwair Street 4\nMuscat, Oman',
      phone: '+968 9345 6789',
      hours: ['Daily   9:00 AM - 8:00 PM'],
      lat: 23.5930,
      lng: 58.4080,
    ),
    Partner(
      id: 'cleanlab',
      name: 'The Clean Lab',
      subtitle: 'Modern care, meticulous detail.',
      image: LaundryGoAssets.partnerStorefront4,
      rating: 4.7,
      reviewCount: 210,
      distanceKm: 4.7,
      services: ['Dry Cleaning', 'Special Care', 'Shoe Care'],
      openStatus: 'Closed Today',
      pickupTiming: 'Pickup tomorrow',
      address: 'Bausher, Muscat',
      addressLine: 'Bausher Main Road 21\nMuscat, Oman',
      phone: '+968 9456 7890',
      hours: [
        'Sunday - Thursday   8:00 AM - 10:00 PM',
        'Friday - Saturday   Closed',
      ],
      lat: 23.5780,
      lng: 58.4210,
    ),
  ];

  static const pastOrders = <PastOrderSummary>[
    PastOrderSummary(
      partnerName: 'PureClean Services',
      image: LaundryGoAssets.dressShirt,
      service: 'Dry Cleaning',
      itemCount: 3,
      date: 'Sat, 12 Sep 2024',
      status: PastOrderStatus.completed,
      priceOmr: 6.0,
    ),
    PastOrderSummary(
      partnerName: 'LaundryHub',
      image: LaundryGoAssets.dryCleaningRack,
      service: 'Ironing',
      itemCount: 4,
      date: 'Wed, 10 Sep 2024',
      status: PastOrderStatus.completed,
      priceOmr: 4.5,
    ),
    PastOrderSummary(
      partnerName: 'The Clean Lab',
      image: LaundryGoAssets.foldedStack,
      service: 'Wash & Fold',
      itemCount: 5,
      date: 'Sun, 7 Sep 2024',
      status: PastOrderStatus.cancelled,
      priceOmr: 5.0,
    ),
  ];

  static const addresses = <SavedAddress>[
    SavedAddress(
      icon: Icons.home_outlined,
      label: 'Home',
      isDefault: true,
      line1: 'Al Mouj, Boulevard 6\nMuscat, Oman',
      line2: 'Building 6, Apartment 203',
    ),
    SavedAddress(
      icon: Icons.business_outlined,
      label: 'Office',
      isDefault: false,
      line1: 'Al Khuwair\nMuscat, Oman',
      line2: 'Office 401, Business Tower',
    ),
    SavedAddress(
      icon: Icons.location_on_outlined,
      label: "Parents' Home",
      isDefault: false,
      line1: 'Madinat Qaboos\nMuscat, Oman',
      line2: 'Villa 12, Street 32',
    ),
    SavedAddress(
      icon: Icons.location_on_outlined,
      label: 'Gym',
      isDefault: false,
      line1: 'Al Ghubrah\nMuscat, Oman',
      line2: 'Next to Fitness First',
    ),
  ];

  static const _reviewPool = <PartnerReview>[
    PartnerReview(
      customerName: 'Ahmed Al Balushi',
      customerImage: LaundryGoAssets.customerAhmed,
      rating: 5,
      date: '2 days ago',
      comment:
          'Excellent service, my shirts came back perfectly pressed. Pickup was right on time too.',
    ),
    PartnerReview(
      customerName: 'Fatima Al Rawahi',
      customerImage: LaundryGoAssets.customerFatima,
      rating: 5,
      date: '1 week ago',
      comment:
          'They handled my abaya with real care. Will definitely order again.',
    ),
    PartnerReview(
      customerName: 'Sultan Al Habsi',
      customerImage: LaundryGoAssets.customerSultan,
      rating: 4,
      date: '2 weeks ago',
      comment: 'Good quality wash, though delivery was about 30 minutes late.',
    ),
    PartnerReview(
      customerName: 'Layla Al Farsi',
      customerImage: LaundryGoAssets.customerLayla,
      rating: 5,
      date: '3 weeks ago',
      comment: 'Friendly driver, clean-smelling clothes. Exactly what I needed.',
    ),
    PartnerReview(
      customerName: 'Mariam Al Zadjali',
      customerImage: LaundryGoAssets.customerMariam,
      rating: 4,
      date: '1 month ago',
      comment: 'Reliable and consistent every time I book them.',
    ),
  ];

  static List<PartnerReview> reviewsFor(String partnerId) {
    final offset = partnerId.hashCode.abs() % _reviewPool.length;
    return [
      for (var i = 0; i < _reviewPool.length; i++)
        _reviewPool[(offset + i) % _reviewPool.length],
    ];
  }

  static final activeOrder = LaundryOrder(
    id: 'LG2456',
    partner: partners.first,
    status: OrderStatus.inCleaning,
    items: const [
      OrderLineItem(
        image: LaundryGoAssets.foldedStack,
        count: 6,
        label: 'Wash & Fold',
        price: 3.0,
      ),
      OrderLineItem(
        image: LaundryGoAssets.dressShirt,
        count: 2,
        label: 'Dry Cleaning',
        price: 4.0,
      ),
      OrderLineItem(
        image: LaundryGoAssets.trousers,
        count: 1,
        label: 'Ironing',
        price: 1.5,
      ),
    ],
    totalOmr: 8.5,
    pickupAddress: 'Al Mouj, Boulevard 6\nMuscat, Oman',
    pickupTime: 'Mon, 15 Sep\n10:00 AM',
    deliveryAddress: 'Al Mouj, Boulevard 6\nMuscat, Oman',
    deliveryEta: 'Today\n5:00 PM (Est.)',
    driverName: 'Ahmed Al Balushi',
    driverImage: LaundryGoAssets.driverPortrait,
    driverRating: 4.9,
    driverDeliveries: 120,
  );
}
