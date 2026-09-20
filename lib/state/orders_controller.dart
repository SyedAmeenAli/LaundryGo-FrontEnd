import 'package:flutter/material.dart';

import '../data/mock_customer_data.dart';
import '../models/customer_models.dart';

/// Real order-history state — lets "No Orders" be an actual reachable
/// state (clearing history) rather than a screenshot no one can trigger.
class OrdersController extends ChangeNotifier {
  final List<PastOrderSummary> _pastOrders = List.of(
    MockCustomerData.pastOrders,
  );
  List<PastOrderSummary> get pastOrders => List.unmodifiable(_pastOrders);

  bool hasActiveOrder = true;

  void clearHistory() {
    _pastOrders.clear();
    notifyListeners();
  }

  void restoreDemoData() {
    _pastOrders
      ..clear()
      ..addAll(MockCustomerData.pastOrders);
    hasActiveOrder = true;
    notifyListeners();
  }
}
