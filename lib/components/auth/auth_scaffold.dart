import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';

/// Shared full-bleed composition for the Login/Verify/Account-Details/
/// Welcome/Location screens (05-09): real photography anchored at the top
/// (logo lockup + optional Back/Skip float over it, with an optional
/// tracked atmospheric corner line, matching Splash/Onboarding's language)
/// fading into an ivory content panel below — never "image card + text
/// card + button card". Scrollable end to end so nothing clips at short
/// viewports or behind the keyboard.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.heroImage,
    required this.child,
    this.cornerLines,
    this.showBack = false,
    this.onBack,
    this.showSkip = false,
    this.onSkip,
    this.heroHeight = 300,
    this.stepProgress,
  });

  final String heroImage;
  final Widget child;
  final List<String>? cornerLines;
  final bool showBack;
  final VoidCallback? onBack;
  final bool showSkip;
  final VoidCallback? onSkip;
  final double heroHeight;
  final Widget? stepProgress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: heroHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(28),
                      ),
                      child: Image.asset(heroImage, fit: BoxFit.cover),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (cornerLines != null && !showSkip)
                      Positioned(
                        top: LGSpacing.md,
                        right: LGSpacing.md,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final line in cornerLines!)
                              Text(
                                line,
                                textAlign: TextAlign.right,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.6,
                                  height: 1.5,
                                  color: LGColors.slate,
                                  shadows: const [
                                    Shadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 4),
                            Container(
                              width: 22,
                              height: 2,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    Positioned(
                      top: LGSpacing.sm,
                      left: LGSpacing.md,
                      right: LGSpacing.md,
                      child: Row(
                        children: [
                          if (showBack)
                            _ChromeIconButton(
                              icon: Icons.arrow_back,
                              onTap: onBack,
                            )
                          else
                            Image.asset(
                              LaundryGoAssets.logoHorizontal,
                              height: 30,
                            ),
                          const Spacer(),
                          if (showSkip)
                            TextButton(
                              onPressed: onSkip,
                              style: TextButton.styleFrom(
                                foregroundColor: LGColors.slate,
                              ),
                              child: const Text('Skip'),
                            ),
                        ],
                      ),
                    ),
                    if (showBack)
                      Positioned(
                        left: LGSpacing.md,
                        top: 52,
                        child: Image.asset(
                          LaundryGoAssets.logoHorizontal,
                          height: 26,
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.lg,
                  LGSpacing.sm,
                  LGSpacing.lg,
                  LGSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (stepProgress != null) ...[
                      stepProgress!,
                      const SizedBox(height: LGSpacing.smd),
                    ],
                    child,
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

class _ChromeIconButton extends StatelessWidget {
  const _ChromeIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
      ),
    );
  }
}

/// Numbered step progress (Login/Verify/... flow) — filled red for
/// done/current, hairline connectors, small caption per step.
class AuthStepProgress extends StatelessWidget {
  const AuthStepProgress({
    super.key,
    required this.steps,
    required this.currentIndex,
  });

  final List<String> steps;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Column(
            children: [
              AnimatedContainer(
                duration: LGMotion.component,
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i <= currentIndex ? red : Colors.transparent,
                  border: Border.all(
                    color: i <= currentIndex ? red : theme.colorScheme.outline,
                    width: 1.4,
                  ),
                ),
                alignment: Alignment.center,
                child: i < currentIndex
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: i == currentIndex
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[i],
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: i == currentIndex
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ],
          ),
          if (i != steps.length - 1)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Container(
                  height: 1.4,
                  color: i < currentIndex ? red : theme.colorScheme.outline,
                ),
              ),
            ),
        ],
      ],
    );
  }
}
