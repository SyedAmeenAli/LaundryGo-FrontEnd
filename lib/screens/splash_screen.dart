import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../asset_registry/laundrygo_assets.dart';
import '../components/laundrygo_logo.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../navigation/app_routes.dart';

/// Screen 01 — a dark cinematic brand opening, matched to the approved
/// reference screenshot: fixed dark regardless of the device's light/dark
/// setting (the reference splash is dark; the reference onboarding pages
/// are light — two different, deliberate moments, not one theme bug).
/// Kept intentionally minimal per the reference — just the fabric/water
/// atmosphere, the mark, wordmark and tagline. No extra ambient copy or
/// loading label bolted on beyond what the reference actually shows.
///
/// Background: [LaundryGoAssets.brandFabricDuotone] (red+green flowing
/// fabric, `01_Brand_Core/010`) layered under
/// [LaundryGoAssets.waterTexture] (`15_Additional_Support/008`) for the
/// water-droplet texture — both real supplied photographs; no
/// generated/fake background. `02_Splash_Onboarding_Auth` is genuinely
/// empty in the manifest, so nothing dedicated existed to use instead.
///
/// Sequence: background fades in -> fabric drifts slowly (FLOW) -> bubbles
/// drift near the mark (FLOAT, via [LaundryGoLogo]) -> logo scales in
/// (0.92 -> 1.02 -> 1.00, SPIN once formed) -> wordmark resolves -> tagline
/// appears -> hand off to Onboarding.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _markController;
  late final Animation<double> _markScale;
  late final Animation<double> _markOpacity;
  late final AnimationController _bgFade;
  late final AnimationController _drift;

  bool _showWordmark = false;
  bool _showTagline = false;

  bool get _reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void initState() {
    super.initState();
    _markController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _markScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.92,
          end: 1.02,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 65,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.02,
          end: 1.00,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35,
      ),
    ]).animate(_markController);
    _markOpacity = CurvedAnimation(
      parent: _markController,
      curve: const Interval(0, 0.5, curve: Curves.easeOut),
    );

    _bgFade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _drift = AnimationController(vsync: this, duration: LGMotion.ambient)
      ..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    if (_reduceMotion) {
      _bgFade.value = 1;
      _markController.value = 1;
      if (!mounted) return;
      setState(() {
        _showWordmark = true;
        _showTagline = true;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted)
        Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
      return;
    }

    // Stage 1: background (fabric/water atmosphere) fades in.
    _bgFade.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // Stage 2-3: fabric drift (already looping) + bubbles (via
    // LaundryGoLogo, starts once the mark exists below) run continuously.
    // Stage 4: logo fades + scales in.
    _markController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));

    // Stage 5: wordmark resolves.
    if (!mounted) return;
    setState(() => _showWordmark = true);
    await Future.delayed(const Duration(milliseconds: 300));

    // Stage 6: tagline appears.
    if (!mounted) return;
    setState(() => _showTagline = true);

    // Stage 7: hold, then hand off.
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted)
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _markController.dispose();
    _bgFade.dispose();
    _drift.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = LGColors.backgroundDark;
    const textPrimary = LGColors.textPrimaryDark;
    const textSecondary = LGColors.textSecondaryDark;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_bgFade, _drift]),
            builder: (context, child) {
              final drift = _reduceMotion ? 0.0 : (_drift.value - 0.5) * 18;
              return Opacity(
                opacity: _reduceMotion ? 1 : _bgFade.value,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const DecoratedBox(decoration: BoxDecoration(color: bg)),
                    // FLOW — flowing red/green fabric, slow horizontal drift.
                    Transform.translate(
                      offset: Offset(drift, 0),
                      child: Opacity(
                        opacity: 0.42,
                        child: Transform.scale(
                          scale: 1.08,
                          child: Image.asset(
                            LaundryGoAssets.brandFabricDuotone,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // Water-droplet texture for depth.
                    Opacity(
                      opacity: 0.14,
                      child: Image.asset(
                        LaundryGoAssets.waterTexture,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Soft top light, and darken toward the edges so the
                    // mark/type stay legible over whatever the photography
                    // is doing underneath.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x33FFFFFF), Colors.transparent],
                          stops: [0, 0.35],
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: Alignment.center,
                          radius: 1.1,
                          colors: [Colors.transparent, Color(0xCC101311)],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Center — logo, wordmark, tagline.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _markController,
                  builder: (context, child) => Opacity(
                    opacity: _reduceMotion ? 1 : _markOpacity.value,
                    child: Transform.scale(
                      scale: _reduceMotion ? 1 : _markScale.value,
                      child: child,
                    ),
                  ),
                  child: const LaundryGoLogo(size: 110),
                ),
                const SizedBox(height: 22),
                AnimatedOpacity(
                  opacity: _showWordmark ? 1 : 0,
                  duration: LGMotion.brand,
                  curve: LGMotion.curve,
                  child: AnimatedSlide(
                    offset: _showWordmark ? Offset.zero : const Offset(0, 0.15),
                    duration: LGMotion.brand,
                    curve: LGMotion.curve,
                    child: Text(
                      'LaundryGo',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedOpacity(
                  opacity: _showTagline ? 1 : 0,
                  duration: LGMotion.brand,
                  curve: LGMotion.curve,
                  child: Text(
                    'Your laundry. On the go.',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: textSecondary,
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
