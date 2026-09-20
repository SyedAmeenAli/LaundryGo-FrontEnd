import 'package:flutter/material.dart';

import '../../../design_system/colors.dart';
import '../../../models/partner_models.dart';

Color stageColor(BuildContext context, PartnerOrderStage stage) {
  final theme = Theme.of(context);
  final green = theme.brightness == Brightness.dark
      ? LGColors.greenDark
      : LGColors.green;
  final red = theme.brightness == Brightness.dark
      ? LGColors.redDark
      : LGColors.red;
  switch (stage) {
    case PartnerOrderStage.received:
      return theme.colorScheme.onSurfaceVariant;
    case PartnerOrderStage.inspecting:
    case PartnerOrderStage.processing:
      return LGColors.warning;
    case PartnerOrderStage.qualityControl:
      return LGColors.info;
    case PartnerOrderStage.packaging:
      return red;
    case PartnerOrderStage.readyForHandoff:
    case PartnerOrderStage.handedOff:
      return green;
  }
}

/// The real status pill reused across every Partner Orders list and detail
/// screen — one color/label source, no per-screen re-derivation.
class StageChip extends StatelessWidget {
  const StageChip({super.key, required this.stage});
  final PartnerOrderStage stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = stageColor(context, stage);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        stage.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
