import 'package:flutter/material.dart';

import '../data/mock_admin_data.dart';
import '../models/admin_models.dart';

/// Owns the Admin product's real operational state — partner/driver
/// approvals, customer blocking, dispute resolution and order refunds all
/// genuinely mutate this state when an admin action button is pressed.
class AdminController extends ChangeNotifier {
  final List<AdminPartner> _partners = MockAdminData.seedPartners();
  final List<AdminDriver> _drivers = MockAdminData.seedDrivers();
  final List<AdminCustomer> _customers = MockAdminData.seedCustomers();
  final List<AdminOrderSummary> _orders = MockAdminData.seedOrders();
  final List<AdminDispute> _disputes = MockAdminData.seedDisputes();
  final Set<String> _paidPartnerIds = {};

  List<AdminPartner> get partners => List.unmodifiable(_partners);
  List<AdminDriver> get drivers => List.unmodifiable(_drivers);
  List<AdminCustomer> get customers => List.unmodifiable(_customers);
  List<AdminOrderSummary> get orders => List.unmodifiable(_orders);
  List<AdminDispute> get disputes => List.unmodifiable(_disputes);

  AdminPartner partnerById(String id) => _partners.firstWhere((p) => p.id == id);
  AdminDriver driverById(String id) => _drivers.firstWhere((d) => d.id == id);
  AdminCustomer customerById(String id) =>
      _customers.firstWhere((c) => c.id == id);
  AdminOrderSummary orderById(String id) => _orders.firstWhere((o) => o.id == id);
  AdminDispute disputeById(String id) => _disputes.firstWhere((d) => d.id == id);

  // ---- KPIs ----
  double get todayRevenueOmr => MockAdminData.weeklyRevenueOmr.last;
  int get todayOrders => MockAdminData.weeklyOrders.last;
  int get activePartnersCount =>
      _partners.where((p) => p.status == PartnerAccountStatus.active).length;
  int get activeDriversCount =>
      _drivers.where((d) => d.status == DriverAccountStatus.active).length;
  int get pendingApprovalsCount =>
      _partners.where((p) => p.status == PartnerAccountStatus.pending).length +
      _drivers.where((d) => d.status == DriverAccountStatus.pending).length;
  int get openDisputesCount => _disputes
      .where(
        (d) =>
            d.status == DisputeStatus.open ||
            d.status == DisputeStatus.investigating,
      )
      .length;

  // ---- Partner actions ----
  void approvePartner(String id) {
    partnerById(id).status = PartnerAccountStatus.active;
    notifyListeners();
  }

  void suspendPartner(String id) {
    partnerById(id).status = PartnerAccountStatus.suspended;
    notifyListeners();
  }

  void reactivatePartner(String id) {
    partnerById(id).status = PartnerAccountStatus.active;
    notifyListeners();
  }

  // ---- Driver actions ----
  void approveDriver(String id) {
    driverById(id).status = DriverAccountStatus.active;
    notifyListeners();
  }

  void suspendDriver(String id) {
    driverById(id).status = DriverAccountStatus.suspended;
    notifyListeners();
  }

  void reactivateDriver(String id) {
    driverById(id).status = DriverAccountStatus.active;
    notifyListeners();
  }

  // ---- Customer actions ----
  void blockCustomer(String id) {
    customerById(id).status = CustomerAccountStatus.blocked;
    notifyListeners();
  }

  void unblockCustomer(String id) {
    customerById(id).status = CustomerAccountStatus.active;
    notifyListeners();
  }

  // ---- Order actions ----
  void refundOrder(String id) {
    orderById(id).refunded = true;
    notifyListeners();
  }

  // ---- Dispute actions ----
  void resolveDispute(String id) {
    disputeById(id).status = DisputeStatus.resolved;
    notifyListeners();
  }

  void rejectDispute(String id) {
    disputeById(id).status = DisputeStatus.rejected;
    notifyListeners();
  }

  void investigateDispute(String id) {
    disputeById(id).status = DisputeStatus.investigating;
    notifyListeners();
  }

  // ---- Payouts ----
  bool isPayoutPaid(String partnerId) => _paidPartnerIds.contains(partnerId);

  void markPayoutPaid(String partnerId) {
    _paidPartnerIds.add(partnerId);
    notifyListeners();
  }

  double payoutFor(AdminPartner partner) =>
      partner.revenueOmrMonth * (1 - MockAdminData.platformCommissionRate);
}
