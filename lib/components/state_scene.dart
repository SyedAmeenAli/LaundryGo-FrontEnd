import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'laundrygo_button.dart';

/// LaundryGoEmptyState / LaundryGoErrorState / LaundryGoSuccessState in one
/// shared shape — a real state asset (never an icon substitute), a headline,
/// a short explanation, one dominant primary action and an optional quiet
/// secondary one. Every Customer States screen in the app is built from
/// this single component so they all read as one family, not 10 one-offs.
class StateScene extends StatelessWidget {
  const StateScene({
    super.key,
    required this.image,
    required this.headline,
    required this.body,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.showBack = true,
    this.imageHeight = 220,
  });

  final String image;
  final String headline;
  final String body;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final bool showBack;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showBack)
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
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            image,
                            height: imageHeight,
                            width: imageHeight,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: LGSpacing.lg),
                        Text(
                          headline,
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (primaryLabel != null) ...[
                          const SizedBox(height: LGSpacing.lg),
                          LaundryGoButton(
                            label: primaryLabel!,
                            expand: false,
                            onPressed: onPrimary,
                          ),
                        ],
                        if (secondaryLabel != null) ...[
                          const SizedBox(height: LGSpacing.sm),
                          TextButton(
                            onPressed: onSecondary,
                            child: Text(
                              secondaryLabel!,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.brightness == Brightness.dark
                                    ? LGColors.redDark
                                    : LGColors.red,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
