import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../components/customer/map_panel.dart';
import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// A real address picked on the map — what this screen hands back via
/// `Navigator.pop`.
class PickedLocation {
  const PickedLocation({
    required this.address,
    required this.lat,
    required this.lng,
  });
  final String address;
  final double lat;
  final double lng;
}

/// Map Location Picker — a genuine interactive map (the same real Google
/// Maps embed [MapPanel] uses everywhere else in the app, never a fake
/// map image). Center/zoom/GPS stay code-driven; this screen only adds
/// the pick-a-point UI around it.
class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({super.key, this.initial});

  final LatLng? initial;

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  static const _areas = <(String, double, double)>[
    ('Al Mouj, Muscat', 23.6165, 58.4390),
    ('Qurum, Muscat', 23.6140, 58.4780),
    ('Al Khuwair, Muscat', 23.5930, 58.4080),
    ('Bausher, Muscat', 23.5780, 58.4210),
    ('Ghubra, Muscat', 23.6050, 58.4270),
    ('Madinat Qaboos, Muscat', 23.5980, 58.4390),
    ('Ruwi, Muscat', 23.5880, 58.5420),
    ('Seeb, Muscat', 23.6700, 58.1890),
  ];

  final _searchController = TextEditingController();
  late LatLng _center = widget.initial ?? const LatLng(23.6165, 58.4390);
  late String _addressLabel = _areas.first.$1;
  bool _locating = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectArea((String, double, double) area) {
    setState(() {
      _center = LatLng(area.$2, area.$3);
      _addressLabel = area.$1;
    });
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locating = true);
    try {
      final geolocation = html.window.navigator.geolocation;
      final position = await geolocation.getCurrentPosition();
      final lat = position.coords?.latitude?.toDouble();
      final lng = position.coords?.longitude?.toDouble();
      if (lat != null && lng != null && mounted) {
        setState(() {
          _center = LatLng(lat, lng);
          _addressLabel = 'Your current location';
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not access location — allow location permission and try again.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final matches = _searchController.text.isEmpty
        ? const <(String, double, double)>[]
        : _areas
            .where(
              (a) => a.$1.toLowerCase().contains(
                _searchController.text.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                LGSpacing.sm,
                LGSpacing.md,
                LGSpacing.sm,
              ),
              child: Row(
                children: [
                  Material(
                    color: theme.colorScheme.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: theme.textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search area in Muscat...',
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(26)),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: MapPanel(center: _center, height: double.infinity, zoom: 15),
                  ),
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 44,
                      color: LGColors.red,
                    ),
                  ),
                  Positioned(
                    right: LGSpacing.md,
                    bottom: LGSpacing.md,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      elevation: 3,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: _locating ? null : _useCurrentLocation,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: _locating
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(
                                  Icons.my_location,
                                  size: 20,
                                  color: theme.brightness == Brightness.dark
                                      ? LGColors.redDark
                                      : LGColors.red,
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (matches.isNotEmpty)
                    Positioned(
                      left: LGSpacing.md,
                      right: LGSpacing.md,
                      top: LGSpacing.sm,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final a in matches)
                              ListTile(
                                dense: true,
                                leading: const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                ),
                                title: Text(a.$1, style: theme.textTheme.bodyMedium),
                                onTap: () {
                                  _selectArea(a);
                                  _searchController.clear();
                                  FocusScope.of(context).unfocus();
                                  setState(() {});
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(LGSpacing.md),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: red, size: 20),
                      const SizedBox(width: LGSpacing.smd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery Location',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            Text(_addressLabel, style: theme.textTheme.titleSmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.md),
                  LaundryGoButton(
                    label: 'Confirm Location',
                    showArrow: true,
                    onPressed: () => Navigator.of(context).pop(
                      PickedLocation(
                        address: _addressLabel,
                        lat: _center.latitude,
                        lng: _center.longitude,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
