import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      LaundryGoAssets.omanArchitecturalArch,
                      fit: BoxFit.cover,
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
                              Colors.black.withValues(alpha: 0),
                              theme.scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(LaundryGoAssets.logoHorizontal, height: 28),
                    const SizedBox(height: LGSpacing.md),
                    RichText(
                      text: TextSpan(
                        style: theme.textTheme.headlineLarge,
                        children: [
                          const TextSpan(text: 'Fresh laundry,\n'),
                          TextSpan(
                            text: 'Omani hospitality.',
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: LGSpacing.md),
                    Text(
                      'LaundryGo connects Muscat households with trusted local laundry partners — real people, real facilities, real care for every garment. We started in Al Mouj with a simple idea: pickup and delivery should be as effortless as the clean clothes you get back.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.md),
                    Text(
                      "Every partner on LaundryGo is vetted for quality and reliability. Every driver is a real part of the community. We're proud to be built in Oman, for Oman.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: _StatBlock(value: '4', label: 'Partners'),
                        ),
                        Expanded(
                          child: _StatBlock(
                            value: '2.4K+',
                            label: 'Orders delivered',
                          ),
                        ),
                        Expanded(
                          child: _StatBlock(
                            value: '4.8',
                            label: 'Average rating',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    _LinkRow(
                      label: 'Privacy Policy',
                      onTap: () =>
                          Navigator.of(context)
                              .pushNamed(AppRoutes.privacyPolicy),
                    ),
                    _LinkRow(
                      label: 'Terms & Conditions',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.terms),
                    ),
                    _LinkRow(
                      label: 'Contact Us',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.contactUs),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    Center(
                      child: Text(
                        'LaundryGo Flow · Version 1.0.0',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: LGSpacing.xl),
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

class _StatBlock extends StatelessWidget {
  const _StatBlock({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(value, style: theme.textTheme.headlineSmall),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: LGSpacing.sm),
        child: Row(
          children: [
            Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
