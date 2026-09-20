import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';

/// One benefit cue: icon + short (up to two word) label.
class OnboardingBenefit {
  const OnboardingBenefit(this.icon, this.label);

  final IconData icon;
  final String label;
}

/// One onboarding page's content — data-driven so the screen/hero/text
/// widgets are written once and reused three times, not duplicated.
class OnboardingPageData {
  const OnboardingPageData({
    required this.eyebrow,
    required this.headlineLine1,
    required this.headlineLine2,
    this.accentLine2 = false,
    required this.body,
    required this.image,
    required this.ctaLabel,
    this.benefits,
  });

  final String eyebrow;
  final String headlineLine1;
  final String headlineLine2;

  /// When true, [headlineLine2] renders in Oman Green instead of the
  /// primary text color.
  final bool accentLine2;
  final String body;
  final String image;
  final String ctaLabel;

  /// Optional refined benefit cues — collapsed on short viewports at the
  /// call site.
  final List<OnboardingBenefit>? benefits;
}

/// Screens 02-04. Asset choices per the brief's category priority — all
/// real supplied photographs, never fabricated:
/// 02 from 08_Laundry_Process (folded clothing editorial).
/// 03 from 08_Laundry_Process (literal washing-machine subject).
/// 04 from 13_Driver_App/152 — a real photo of the branded "LAUNDRY GO"
/// pickup bag at an Omani archway doorway, a direct match for "Right to
/// Your Door" (swapped in from an earlier, weaker Muscat-coastline choice).
const List<OnboardingPageData> kOnboardingPages = [
  OnboardingPageData(
    eyebrow: 'FRESHER DAYS',
    headlineLine1: 'Fresh Laundry,',
    headlineLine2: 'Brighter Days.',
    accentLine2: true,
    body:
        'Premium care for your clothes, so you can focus on what matters most.',
    image: LaundryGoAssets.foldedStack,
    ctaLabel: 'Next',
    benefits: [
      OnboardingBenefit(Icons.eco_outlined, 'Cleaner\nClothes'),
      OnboardingBenefit(Icons.schedule_outlined, 'More\nTime'),
      OnboardingBenefit(Icons.favorite_border, 'Less\nEffort'),
    ],
  ),
  OnboardingPageData(
    eyebrow: 'CARE, DONE RIGHT',
    headlineLine1: 'Every Fabric.',
    headlineLine2: 'Properly Cared For.',
    body: 'From everyday essentials to delicate pieces, LaundryGo handles every load with care.',
    image: LaundryGoAssets.washingMachineWithLaundry,
    ctaLabel: 'Next',
  ),
  OnboardingPageData(
    eyebrow: 'MADE FOR YOU',
    headlineLine1: 'Clean Clothes.',
    headlineLine2: 'Right to Your Door.',
    accentLine2: true,
    body: 'Pickup, professional care and delivery — all in one simple experience.',
    image: LaundryGoAssets.brandedBagAtOmaniDoorway,
    ctaLabel: 'Get Started',
    benefits: [
      OnboardingBenefit(Icons.local_shipping_outlined, 'Convenient\nPickup'),
      OnboardingBenefit(Icons.auto_awesome_outlined, 'Professional\nCare'),
      OnboardingBenefit(Icons.home_outlined, 'Reliable\nDelivery'),
    ],
  ),
];
