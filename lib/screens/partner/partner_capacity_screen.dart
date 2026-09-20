import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../state/partner_controller.dart';

/// #60 Capacity — a real, draggable daily-order-limit slider. Moving it
/// genuinely changes [PartnerController.dailyCapacity], and the
/// utilization bar recomputes live against the current in-progress count.
class PartnerCapacityScreen extends StatelessWidget {
  const PartnerCapacityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<PartnerController>();
    final utilization = controller.utilization;
    final barColor = utilization >= 0.9
        ? red
        : (utilization >= 0.7 ? LGColors.warning : green);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: LGSpacing.md),
                Text(
                  'OPERATIONS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Daily '),
                      TextSpan(
                        text: 'Capacity',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(LGSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${controller.ordersInProgress} of ${controller.dailyCapacity} orders',
                            style: theme.textTheme.titleMedium,
                          ),
                          Text(
                            '${(utilization * 100).round()}%',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: barColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: LGSpacing.sm),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: LGMotion.component,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: utilization.clamp(0.02, 1.0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: barColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        utilization >= 0.9
                            ? 'Near capacity — consider pausing new pickups.'
                            : 'Healthy capacity — accepting new orders.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Daily order limit', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Text(
                  'How many orders this facility can process per day.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: controller.dailyCapacity.toDouble(),
                        min: 10,
                        max: 200,
                        divisions: 38,
                        activeColor: red,
                        label: '${controller.dailyCapacity}',
                        onChanged: (v) => controller.setCapacity(v.round()),
                      ),
                    ),
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${controller.dailyCapacity}',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
