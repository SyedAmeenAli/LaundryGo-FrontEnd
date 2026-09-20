import 'package:flutter/material.dart';

import '../data/mock_customer_data.dart';
import '../models/customer_models.dart';

/// Owns the saved-address list so Addresses screen actions (add, delete,
/// set default) are real state changes, not static decoration.
class AddressesController extends ChangeNotifier {
  AddressesController() : _addresses = List.of(MockCustomerData.addresses);

  final List<SavedAddress> _addresses;
  List<SavedAddress> get addresses => List.unmodifiable(_addresses);

  void add({
    required IconData icon,
    required String label,
    required String line1,
    required String line2,
  }) {
    _addresses.add(
      SavedAddress(
        icon: icon,
        label: label,
        isDefault: _addresses.isEmpty,
        line1: line1,
        line2: line2,
      ),
    );
    notifyListeners();
  }

  void updateAt(
    int index, {
    required IconData icon,
    required String label,
    required String line1,
    required String line2,
  }) {
    final wasDefault = _addresses[index].isDefault;
    _addresses[index] = SavedAddress(
      icon: icon,
      label: label,
      isDefault: wasDefault,
      line1: line1,
      line2: line2,
    );
    notifyListeners();
  }

  void removeAt(int index) {
    final wasDefault = _addresses[index].isDefault;
    _addresses.removeAt(index);
    if (wasDefault && _addresses.isNotEmpty) {
      final a = _addresses[0];
      _addresses[0] = SavedAddress(
        icon: a.icon,
        label: a.label,
        isDefault: true,
        line1: a.line1,
        line2: a.line2,
      );
    }
    notifyListeners();
  }

  void setDefault(int index) {
    for (var i = 0; i < _addresses.length; i++) {
      final a = _addresses[i];
      _addresses[i] = SavedAddress(
        icon: a.icon,
        label: a.label,
        isDefault: i == index,
        line1: a.line1,
        line2: a.line2,
      );
    }
    notifyListeners();
  }
}
