import 'package:flutter/material.dart';

import '../data/mock_partner_data.dart';
import '../models/partner_models.dart';

/// Owns the Partner product's real operational state — orders genuinely
/// move through [PartnerOrderStage.next] when a workflow screen's primary
/// action is pressed, service pricing/availability genuinely persists,
/// capacity is a real adjustable number.
class PartnerController extends ChangeNotifier {
  final List<PartnerOrder> _orders = MockPartnerData.seedOrders();
  final List<PartnerServiceOffering> services = MockPartnerData.seedServices();

  int dailyCapacity = 40;
  int get ordersInProgress =>
      _orders.where((o) => o.stage != PartnerOrderStage.handedOff).length;
  double get utilization => (ordersInProgress / dailyCapacity).clamp(0, 1);

  List<PartnerOrder> get orders => List.unmodifiable(_orders);

  PartnerOrder orderById(String id) => _orders.firstWhere((o) => o.id == id);

  void advanceStage(String orderId) {
    final order = orderById(orderId);
    final next = order.stage.next;
    if (next != null) order.stage = next;
    notifyListeners();
  }

  /// Inspection covers both [PartnerOrderStage.received] and
  /// [PartnerOrderStage.inspecting] on one screen — completing it always
  /// lands on Processing regardless of which of those two it started from.
  void completeInspection(String orderId) {
    orderById(orderId).stage = PartnerOrderStage.processing;
    notifyListeners();
  }

  void setInspectionNotes(String orderId, String notes) {
    orderById(orderId).inspectionNotes = notes;
    notifyListeners();
  }

  void setServicePrice(int index, double price) {
    services[index].priceOmr = price;
    notifyListeners();
  }

  void toggleServiceAvailable(int index) {
    services[index].available = !services[index].available;
    notifyListeners();
  }

  void setCapacity(int value) {
    dailyCapacity = value.clamp(10, 200);
    notifyListeners();
  }
}
