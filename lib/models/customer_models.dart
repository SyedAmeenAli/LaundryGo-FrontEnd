import 'package:flutter/material.dart' show IconData;

/// One laundry service type (Wash & Fold, Dry Cleaning, ...).
class ServiceType {
  const ServiceType({
    required this.name,
    required this.descriptor,
    required this.image,
    this.price,
  });

  final String name;
  final String descriptor;
  final String image;
  final double? price;
}

/// One garment the catalogue/explorer can reference.
class GarmentType {
  const GarmentType({required this.name, required this.image});

  final String name;
  final String image;
}

/// One partner laundry facility.
class Partner {
  const Partner({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.services,
    required this.openStatus,
    required this.pickupTiming,
    required this.address,
    required this.addressLine,
    required this.phone,
    required this.hours,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String name;
  final String subtitle;
  final String image;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final List<String> services;
  final String openStatus;
  final String pickupTiming;
  final String address;
  final String addressLine;
  final String phone;
  final List<String> hours;
  final double lat;
  final double lng;
}

/// One customer review left on a partner's profile.
class PartnerReview {
  const PartnerReview({
    required this.customerName,
    required this.customerImage,
    required this.rating,
    required this.date,
    required this.comment,
  });

  final String customerName;
  final String customerImage;
  final int rating;
  final String date;
  final String comment;
}

enum OrderStatus { pickedUp, inCleaning, outForDelivery, delivered }

/// One line item within an order (a service applied to N items).
class OrderLineItem {
  const OrderLineItem({
    required this.image,
    required this.count,
    required this.label,
    this.price,
  });

  final String image;
  final int count;
  final String label;
  final double? price;
}

enum PastOrderStatus { completed, cancelled }

/// One row in the "Recent orders" / "Past Orders" list — a summary, not
/// the full `LaundryOrder` detail model.
class PastOrderSummary {
  const PastOrderSummary({
    required this.partnerName,
    required this.image,
    required this.service,
    required this.itemCount,
    required this.date,
    required this.status,
    required this.priceOmr,
  });

  final String partnerName;
  final String image;
  final String service;
  final int itemCount;
  final String date;
  final PastOrderStatus status;
  final double priceOmr;
}

/// One saved pickup/delivery address.
class SavedAddress {
  const SavedAddress({
    required this.icon,
    required this.label,
    required this.isDefault,
    required this.line1,
    required this.line2,
  });

  final IconData icon;
  final String label;
  final bool isDefault;
  final String line1;
  final String line2;
}

/// One active/past order.
class LaundryOrder {
  const LaundryOrder({
    required this.id,
    required this.partner,
    required this.status,
    required this.items,
    required this.totalOmr,
    required this.pickupAddress,
    required this.pickupTime,
    required this.deliveryAddress,
    required this.deliveryEta,
    required this.driverName,
    required this.driverImage,
    required this.driverRating,
    required this.driverDeliveries,
  });

  final String id;
  final Partner partner;
  final OrderStatus status;
  final List<OrderLineItem> items;
  final double totalOmr;
  final String pickupAddress;
  final String pickupTime;
  final String deliveryAddress;
  final String deliveryEta;
  final String driverName;
  final String driverImage;
  final double driverRating;
  final int driverDeliveries;
}
