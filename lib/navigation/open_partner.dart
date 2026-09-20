import 'package:flutter/material.dart';

import '../models/customer_models.dart';
import '../screens/customer/states/partner_unavailable_screen.dart';
import 'app_routes.dart';

/// Single real entry point for opening a partner — every partner tap in
/// the app routes through here so the "closed partner" branch is a live
/// check, not duplicated per screen.
void openPartner(BuildContext context, Partner partner) {
  if (!partner.openStatus.startsWith('Open')) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PartnerUnavailableScreen(partnerName: partner.name),
      ),
    );
    return;
  }
  Navigator.of(context)
      .pushNamed(AppRoutes.partnerDetail, arguments: partner.id);
}
