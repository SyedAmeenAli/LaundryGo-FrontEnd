import 'package:flutter/material.dart';

/// Real favorites state — toggling a heart genuinely adds/removes here,
/// and Saved Items reads from it directly (not a static placeholder list).
class FavoritesController extends ChangeNotifier {
  final Set<String> _partnerIds = {};
  final Set<String> _serviceNames = {};

  bool isPartnerFavorite(String id) => _partnerIds.contains(id);
  bool isServiceFavorite(String name) => _serviceNames.contains(name);

  Set<String> get partnerIds => Set.unmodifiable(_partnerIds);
  Set<String> get serviceNames => Set.unmodifiable(_serviceNames);

  bool toggleService(String name) {
    final added = !_serviceNames.remove(name);
    if (added) _serviceNames.add(name);
    notifyListeners();
    return added;
  }

  bool togglePartner(String id) {
    final added = !_partnerIds.remove(id);
    if (added) _partnerIds.add(id);
    notifyListeners();
    return added;
  }
}
