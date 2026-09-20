import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// A REAL, live Google Maps embed — a genuine `<iframe>` onto
/// `google.com/maps`, not a generated/fake map image and not a
/// third-party tile substitute. No API key required (the keyless
/// `output=embed` endpoint). Two shapes: a static pin (Partner Detail /
/// Schedule Pickup / Location) or an actual Google-routed line between a
/// driver's current position and the destination (Live Tracking).
class MapPanel extends StatelessWidget {
  const MapPanel({
    super.key,
    required this.center,
    this.height = 160,
    this.zoom = 16,
    this.markerColor,
    this.route,
    this.driverPosition,
    this.destination,
    this.interactive = true,
  });

  final LatLng center;
  final double height;
  final double zoom;
  final Color? markerColor;
  final List<LatLng>? route;
  final LatLng? driverPosition;
  final LatLng? destination;
  final bool interactive;

  static final Set<String> _registeredViews = {};

  String get _embedUrl {
    // `maps.google.com` (not `www.google.com`) is the endpoint that
    // reliably honours `z` on the keyless `output=embed` route — the
    // `www` host was falling back to a near-zero zoom, which is why the
    // map rendered as a flat, featureless ocean-blue rectangle instead of
    // real street-level tiles. `t=m` pins it to the roadmap style.
    if (driverPosition != null && destination != null) {
      return 'https://maps.google.com/maps?saddr=${driverPosition!.latitude},${driverPosition!.longitude}'
          '&daddr=${destination!.latitude},${destination!.longitude}&t=m&output=embed';
    }
    return 'https://maps.google.com/maps?q=${center.latitude},${center.longitude}&z=${zoom.round()}&t=m&output=embed';
  }

  @override
  Widget build(BuildContext context) {
    final url = _embedUrl;
    final viewType = 'laundrygo-google-map-${url.hashCode}';
    if (!_registeredViews.contains(viewType)) {
      _registeredViews.add(viewType);
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
        final iframe = html.IFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allowFullscreen = true;
        if (!interactive) {
          iframe.style.pointerEvents = 'none';
        }
        return iframe;
      });
    }
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: HtmlElementView(viewType: viewType),
      ),
    );
  }
}
