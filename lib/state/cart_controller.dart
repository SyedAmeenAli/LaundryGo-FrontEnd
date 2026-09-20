import 'package:flutter/foundation.dart';

import '../asset_registry/laundrygo_assets.dart';

class CartLine {
  CartLine({
    required this.name,
    required this.descriptor,
    required this.image,
    required this.unitPrice,
    required this.quantity,
  });

  final String name;
  final String descriptor;
  final String image;
  final double unitPrice;
  int quantity;

  double get lineTotal => unitPrice * quantity;
}

/// Shared cart state — quantities are genuinely interactive, totals derive
/// from the data (not hardcoded per screen), used by Cart/Payment/Order
/// Confirmed and the bottom-nav badge everywhere.
class CartController extends ChangeNotifier {
  final List<CartLine> lines = [
    CartLine(
      name: 'Wash & Fold',
      descriptor: 'Everyday essentials',
      image: LaundryGoAssets.foldedStack,
      unitPrice: 3.0,
      quantity: 1,
    ),
    CartLine(
      name: 'Dry Cleaning',
      descriptor: 'Shirts & tops',
      image: LaundryGoAssets.dressShirt,
      unitPrice: 2.0,
      quantity: 2,
    ),
    CartLine(
      name: 'Ironing',
      descriptor: 'Trousers & pants',
      image: LaundryGoAssets.trousers,
      unitPrice: 1.5,
      quantity: 1,
    ),
  ];

  static const deliveryFee = 1.0;
  double _discount = 0.0;
  String? appliedPromo;

  double get subtotal => lines.fold(0.0, (sum, l) => sum + l.lineTotal);
  double get discount => _discount;
  double get total =>
      (subtotal + deliveryFee - _discount).clamp(0, double.infinity);
  int get itemCount => lines.length;

  void increment(int index) {
    lines[index].quantity++;
    notifyListeners();
  }

  void decrement(int index) {
    if (lines[index].quantity > 1) {
      lines[index].quantity--;
      notifyListeners();
    }
  }

  void removeAt(int index) {
    lines.removeAt(index);
    notifyListeners();
  }

  /// Adds a new line (e.g. from Garment Detail's "Add to Cart"), or bumps
  /// the quantity of a matching existing line rather than duplicating it.
  void addLine({
    required String name,
    required String descriptor,
    required String image,
    required double unitPrice,
    int quantity = 1,
  }) {
    final existing = lines.indexWhere(
      (l) => l.name == name && l.descriptor == descriptor,
    );
    if (existing != -1) {
      lines[existing].quantity += quantity;
    } else {
      lines.add(
        CartLine(
          name: name,
          descriptor: descriptor,
          image: image,
          unitPrice: unitPrice,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  bool applyPromo(String code) {
    if (code.trim().toUpperCase() == 'LAUNDRY10') {
      _discount = double.parse((subtotal * 0.1).toStringAsFixed(3));
      appliedPromo = code.trim().toUpperCase();
      notifyListeners();
      return true;
    }
    return false;
  }
}
