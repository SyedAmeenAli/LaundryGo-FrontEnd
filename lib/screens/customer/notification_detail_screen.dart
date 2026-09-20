import 'package:flutter/material.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Notification Detail — the full body of one notification plus, for
/// order-related updates, a real "View Order" CTA into Order Detail.
class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.isOrderUpdate = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool isOrderUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
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
              const SizedBox(height: LGSpacing.lg),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 26, color: green),
              ),
              const SizedBox(height: LGSpacing.md),
              Text(
                time,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: theme.textTheme.headlineMedium),
              const SizedBox(height: LGSpacing.sm),
              Text(
                body,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (isOrderUpdate)
                LaundryGoButton(
                  label: 'View Order',
                  showArrow: true,
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.orderDetail),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
