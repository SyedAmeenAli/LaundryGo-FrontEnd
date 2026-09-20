import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/laundrygo_button.dart';
import '../../components/laundrygo_page_indicator.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import 'onboarding_data.dart';
import 'onboarding_page.dart';

/// Screens 02-04 as ONE continuous PageView (rule 31: "one beautiful
/// editorial story, not three unrelated templates"), full-bleed from the
/// very top of the viewport — the logo/Skip chrome floats over the
/// photography with its own scrim, not in a separate bar that pushes the
/// image down. Only the bottom indicator+CTA bar sits on solid ground,
/// since floating controls over arbitrary photo content risk contrast
/// (rule: "most content should remain crisp and readable").
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  bool get _reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  void _next() {
    if (_index == kOnboardingPages.length - 1) {
      _finish();
      return;
    }
    _controller.animateToPage(
      _index + 1,
      duration: _reduceMotion ? Duration.zero : kOnboardingPageAnimation,
      curve: kOnboardingPageCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: kOnboardingPages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (context, i) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        double offset;
                        if (_controller.position.haveDimensions) {
                          offset = i - (_controller.page ?? _index.toDouble());
                        } else {
                          offset = (i - _index).toDouble();
                        }
                        return OnboardingPage(
                          data: kOnboardingPages[i],
                          pageOffset: offset,
                          reduceMotion: _reduceMotion,
                        );
                      },
                    );
                  },
                ),
                // Top chrome floats over the full-bleed photography with a
                // scrim so the logo/Skip stay legible regardless of what
                // the image underneath is doing.
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(
                        LGSpacing.md,
                        LGSpacing.sm,
                        LGSpacing.sm,
                        LGSpacing.xl,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.6, 1],
                          colors: [
                            Color(0x40000000),
                            Color(0x1A000000),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            LaundryGoAssets.logoHorizontal,
                            height: 30,
                          ),
                          const Spacer(),
                          LaundryGoQuietButton(
                            label: 'Skip',
                            onPressed: _finish,
                            lightOnDark: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.lg,
                LGSpacing.md,
                LGSpacing.lg,
                LGSpacing.md,
              ),
              child: Row(
                children: [
                  LaundryGoPageIndicator(
                    count: kOnboardingPages.length,
                    index: _index,
                  ),
                  const Spacer(),
                  LaundryGoButton(
                    label: kOnboardingPages[_index].ctaLabel,
                    onPressed: _next,
                    expand: false,
                    showArrow: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
