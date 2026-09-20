import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/driver_controller.dart';
import 'driver_active_job_screen.dart';
import 'widgets/driver_header.dart';
import 'widgets/job_card.dart';

/// #63 Driver Today — "what do I need to do right now": new job requests
/// to accept/decline, then today's already-accepted jobs.
class DriverTodayScreen extends StatelessWidget {
  const DriverTodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final controller = context.watch<DriverController>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const DriverHeader(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              0,
              LGSpacing.md,
              LGSpacing.md,
            ),
            child: Text("Today's Route", style: theme.textTheme.headlineLarge),
          ),
          if (controller.pending.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                0,
                LGSpacing.md,
                LGSpacing.sm,
              ),
              child: Text('New Requests', style: theme.textTheme.titleLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
              child: Column(
                children: [
                  for (final job in controller.pending)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: JobCard(
                        job: job,
                        onTap: () {},
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                controller.decline(job.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Job declined.'),
                                  ),
                                );
                              },
                              icon: Icon(Icons.close, size: 18, color: red),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.accept(job.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Job accepted — added to your route.',
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.check, size: 18, color: green),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.fromLTRB(
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.md,
              LGSpacing.sm,
            ),
            child: Text('Your Jobs', style: theme.textTheme.titleLarge),
          ),
          if (controller.active.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: LGSpacing.md,
                vertical: LGSpacing.lg,
              ),
              child: Center(
                child: Text(
                  'No active jobs — accept a request above to get started.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                0,
                LGSpacing.md,
                LGSpacing.xl,
              ),
              child: Column(
                children: [
                  for (final job in controller.active)
                    Padding(
                      padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                      child: JobCard(
                        job: job,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                DriverActiveJobScreen(jobId: job.id),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
