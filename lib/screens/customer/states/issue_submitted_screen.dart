import 'package:flutter/material.dart';

import '../../../asset_registry/laundrygo_assets.dart';
import '../../../components/state_scene.dart';

class IssueSubmittedScreen extends StatelessWidget {
  const IssueSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StateScene(
      image: LaundryGoAssets.issueReportSubmitted,
      headline: 'Report submitted',
      body: "Thanks — our support team will get back to you within a few hours. You'll get a notification when there's an update.",
      primaryLabel: 'Done',
      onPrimary: () => Navigator.of(context).popUntil((r) => r.isFirst),
      showBack: false,
    );
  }
}
