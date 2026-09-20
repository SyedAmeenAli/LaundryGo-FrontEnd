import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/admin_models.dart';
import '../../state/admin_controller.dart';
import 'admin_dispute_detail_screen.dart';
import 'admin_notifications_screen.dart';
import 'widgets/admin_header.dart';
import 'widgets/status_pill.dart';

/// Admin Disputes — the real dispute queue every open/investigating
/// customer issue lands in, filterable by status.
class AdminDisputesScreen extends StatefulWidget {
  const AdminDisputesScreen({super.key});

  @override
  State<AdminDisputesScreen> createState() => _AdminDisputesScreenState();
}

class _AdminDisputesScreenState extends State<AdminDisputesScreen> {
  DisputeStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<AdminController>();
    final disputes = controller.disputes
        .where((d) => _filter == null || d.status == _filter)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminHeader(
                showBack: true,
                onBack: () => Navigator.of(context).maybePop(),
                onNotificationTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AdminNotificationsScreen(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  0,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                child: Text('Disputes', style: theme.textTheme.headlineLarge),
              ),
              SizedBox(
                height: 56,
                child: ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.04, 0.92, 1.0],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: LGSpacing.md,
                      vertical: 4,
                    ),
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: _filter == null,
                        onTap: () => setState(() => _filter = null),
                      ),
                      for (final s in DisputeStatus.values)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _FilterChip(
                            label: s.label,
                            selected: _filter == s,
                            onTap: () => setState(() => _filter = s),
                          ),
                        ),
                      const SizedBox(width: LGSpacing.md),
                    ],
                  ),
                ),
              ),
              if (disputes.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: LGSpacing.xl),
                  child: Center(
                    child: Text(
                      'No disputes match this filter.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    LGSpacing.md,
                    LGSpacing.sm,
                    LGSpacing.md,
                    LGSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      for (final d in disputes)
                        Padding(
                          padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    AdminDisputeDetailScreen(disputeId: d.id),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(LGSpacing.sm),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundImage: AssetImage(
                                      d.customerImage,
                                    ),
                                  ),
                                  const SizedBox(width: LGSpacing.smd),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                d.type.label,
                                                style:
                                                    theme.textTheme.titleSmall,
                                              ),
                                            ),
                                            Text(
                                              '#${d.orderId}',
                                              style: theme.textTheme.labelSmall
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${d.customerName} · ${d.openedLabel}',
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: theme
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: LGSpacing.sm),
                                  StatusPill(
                                    label: d.status.label,
                                    color: disputeStatusColor(
                                      context,
                                      d.status,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? red : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? red : theme.colorScheme.outline),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
