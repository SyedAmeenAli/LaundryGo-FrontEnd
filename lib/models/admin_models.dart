import 'customer_models.dart' show OrderStatus;

export 'customer_models.dart' show OrderStatus;

/// Partner onboarding/standing state — a real lifecycle Admin genuinely
/// moves partners through (approve/suspend/reactivate), not a label.
enum PartnerAccountStatus { pending, active, suspended }

extension PartnerAccountStatusX on PartnerAccountStatus {
  String get label => switch (this) {
    PartnerAccountStatus.pending => 'Pending Approval',
    PartnerAccountStatus.active => 'Active',
    PartnerAccountStatus.suspended => 'Suspended',
  };
}

/// Driver onboarding/standing state — same real lifecycle shape as
/// [PartnerAccountStatus].
enum DriverAccountStatus { pending, active, suspended }

extension DriverAccountStatusX on DriverAccountStatus {
  String get label => switch (this) {
    DriverAccountStatus.pending => 'Pending Approval',
    DriverAccountStatus.active => 'Active',
    DriverAccountStatus.suspended => 'Suspended',
  };
}

enum CustomerAccountStatus { active, blocked }

extension CustomerAccountStatusX on CustomerAccountStatus {
  String get label => switch (this) {
    CustomerAccountStatus.active => 'Active',
    CustomerAccountStatus.blocked => 'Blocked',
  };
}

enum DisputeType { damagedItem, lateDelivery, missingItem, billing, other }

extension DisputeTypeX on DisputeType {
  String get label => switch (this) {
    DisputeType.damagedItem => 'Damaged Item',
    DisputeType.lateDelivery => 'Late Delivery',
    DisputeType.missingItem => 'Missing Item',
    DisputeType.billing => 'Billing Issue',
    DisputeType.other => 'Other',
  };
}

enum DisputeStatus { open, investigating, resolved, rejected }

extension DisputeStatusX on DisputeStatus {
  String get label => switch (this) {
    DisputeStatus.open => 'Open',
    DisputeStatus.investigating => 'Investigating',
    DisputeStatus.resolved => 'Resolved',
    DisputeStatus.rejected => 'Rejected',
  };
}

class AdminPartner {
  AdminPartner({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.address,
    required this.rating,
    required this.ordersToday,
    required this.revenueOmrMonth,
    required this.joinedLabel,
    this.status = PartnerAccountStatus.active,
  });

  final String id;
  final String name;
  final String image;
  final String category;
  final String address;
  final double rating;
  final int ordersToday;
  final double revenueOmrMonth;
  final String joinedLabel;
  PartnerAccountStatus status;
}

class AdminDriver {
  AdminDriver({
    required this.id,
    required this.name,
    required this.image,
    required this.vehicle,
    required this.rating,
    required this.deliveriesToday,
    required this.completionRate,
    required this.joinedLabel,
    this.status = DriverAccountStatus.active,
  });

  final String id;
  final String name;
  final String image;
  final String vehicle;
  final double rating;
  final int deliveriesToday;
  final double completionRate;
  final String joinedLabel;
  DriverAccountStatus status;
}

class AdminCustomer {
  AdminCustomer({
    required this.id,
    required this.name,
    required this.image,
    required this.ordersCount,
    required this.totalSpentOmr,
    required this.joinedLabel,
    this.status = CustomerAccountStatus.active,
  });

  final String id;
  final String name;
  final String image;
  final int ordersCount;
  final double totalSpentOmr;
  final String joinedLabel;
  CustomerAccountStatus status;
}

class AdminOrderSummary {
  AdminOrderSummary({
    required this.id,
    required this.customerName,
    required this.customerImage,
    required this.partnerName,
    required this.totalOmr,
    required this.placedLabel,
    this.status = OrderStatus.pickedUp,
    this.refunded = false,
  });

  final String id;
  final String customerName;
  final String customerImage;
  final String partnerName;
  final double totalOmr;
  final String placedLabel;
  OrderStatus status;
  bool refunded;
}

class AdminDispute {
  AdminDispute({
    required this.id,
    required this.orderId,
    required this.customerName,
    required this.customerImage,
    required this.type,
    required this.description,
    required this.openedLabel,
    this.status = DisputeStatus.open,
  });

  final String id;
  final String orderId;
  final String customerName;
  final String customerImage;
  final DisputeType type;
  final String description;
  final String openedLabel;
  DisputeStatus status;
}
