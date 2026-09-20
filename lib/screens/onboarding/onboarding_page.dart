import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import 'onboarding_data.dart';

/// One onboarding page: full-bleed photography from the very top of the
/// viewport (the top logo/Skip chrome floats over it, drawn by the parent
/// screen) fading into a solid content panel — never a bordered card.
/// [pageOffset] is this page's distance from the PageView's current scroll
/// position (0 = centered, ±1 = fully off to a neighbor) and drives the
/// shared-transition system: a page already passed zooms slightly as it
/// recedes (scale 1.0 -> 1.04), an incoming page fades and settles in
/// (opacity 0 -> 1, scale 1.02 -> 1.0), its text drifting vertically while
/// fading. Reduced motion collapses this to a plain crossfade with no scale.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.data,
    required this.pageOffset,
    required this.reduceMotion,
  });

  final OnboardingPageData data;
  final double pageOffset;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final o = pageOffset.clamp(-1.0, 1.0);
    final incoming = o > 0;
    final magnitude = o.abs();

    final double imageScale;
    final double contentOpacity;
    final double contentDy;

    if (reduceMotion) {
      imageScale = 1.0;
      contentOpacity = 1 - magnitude;
      contentDy = 0;
    } else if (incoming) {
      imageScale = 1.02 - (0.02 * (1 - magnitude));
      contentOpacity = 1 - magnitude;
      contentDy = 16 * magnitude;
    } else {
      imageScale = 1.0 + (0.04 * magnitude);
      contentOpacity = 1 - magnitude;
      contentDy = -16 * magnitude;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final showBenefits =
            data.benefits != null && constraints.maxHeight >= 560;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Full-bleed photography — edge to edge, no card, no border.
            Transform.scale(
              scale: imageScale,
              child: Image.asset(data.image, fit: BoxFit.cover),
            ),
            // Soft tonal fade from the photo into the content panel below —
            // the transition itself, not a hard rectangular cut.
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0, 0.5, 1],
                    colors: [
                      background.withValues(alpha: 0),
                      background.withValues(alpha: 0.94),
                      background,
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: contentOpacity.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, contentDy),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      LGSpacing.lg,
                      0,
                      LGSpacing.lg,
                      LGSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.eyebrow,
                          style: theme.textTheme.labelSmall?.copyWith(
                            letterSpacing: 1.6,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: LGSpacing.sm),
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.headlineLarge,
                            children: [
                              TextSpan(text: '${data.headlineLine1}\n'),
                              TextSpan(
                                text: data.headlineLine2,
                                style: data.accentLine2
                                    ? TextStyle(
                                        color:
                                            theme.brightness == Brightness.dark
                                            ? LGColors.greenDark
                                            : LGColors.green,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: LGSpacing.sm),
                        Text(
                          data.body,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (showBenefits) ...[
                          const SizedBox(height: LGSpacing.md),
                          Row(
                            children: [
                              for (final benefit in data.benefits!) ...[
                                Expanded(child: _BenefitCue(benefit: benefit)),
                                if (benefit != data.benefits!.last)
                                  const SizedBox(width: LGSpacing.sm),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// One refined benefit cue — a soft circular badge with a hairline icon,
/// two-line label beneath. Never a generic filled icon-grid tile.
class _BenefitCue extends StatelessWidget {
  const _BenefitCue({required this.benefit});

  final OnboardingBenefit benefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final badgeColor = dark ? LGColors.surfaceElevatedDark : LGColors.cloud;
    final iconColor = dark ? LGColors.textPrimaryDark : LGColors.graphite;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          child: Icon(benefit.icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 6),
        Text(
          benefit.label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            letterSpacing: 0.8,
            height: 1.3,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Duration the PageView's own route-level animation uses when Next/Get
/// Started programmatically advances the page (250-450ms).
const kOnboardingPageAnimation = Duration(milliseconds: 380);
const kOnboardingPageCurve = LGMotion.curve;
