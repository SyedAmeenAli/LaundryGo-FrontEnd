import 'dart:async';

import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/laundrygo_button.dart';
import '../../components/otp_field_group.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// Screen 06 — Verify Email (OTP). Reference: step progress (Login done,
/// Verify current, Your Details next), 6-digit tactile code entry with a
/// resend countdown.
class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  static const _resendSeconds = 45;
  int _remaining = _resendSeconds;
  Timer? _timer;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resend() {
    setState(() => _remaining = _resendSeconds);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        return;
      }
      setState(() => _remaining--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return AuthScaffold(
      heroImage: LaundryGoAssets.omanCoastline,
      cornerLines: const ['FRESH', 'CLOTHES', 'BRIGHTER', 'DAYS'],
      heroHeight: 190,
      showBack: true,
      onBack: () => Navigator.of(context).pop(),
      stepProgress: const AuthStepProgress(
        steps: ['Login', 'Verify', 'Your Details'],
        currentIndex: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ALMOST THERE',
            style: theme.textTheme.labelSmall?.copyWith(
              letterSpacing: 1.6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          RichText(
            text: TextSpan(
              style: theme.textTheme.headlineLarge,
              children: [
                const TextSpan(text: 'Verify\nYour '),
                TextSpan(
                  text: 'Email',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          Text.rich(
            TextSpan(
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              children: const [
                TextSpan(text: "We've sent a 6-digit code to\n"),
                TextSpan(
                  text: 'alex@example.com',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.lg),
          OtpFieldGroup(onCompleted: (v) => setState(() => _code = v)),
          const SizedBox(height: LGSpacing.md),
          Row(
            children: [
              Text(
                "Didn't receive the code? ",
                style: theme.textTheme.bodySmall,
              ),
              if (_remaining > 0)
                Text(
                  'Resend in 00:${_remaining.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: red,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                GestureDetector(
                  onTap: _resend,
                  child: Text(
                    'Resend code',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: LGSpacing.lg),
          LaundryGoButton(
            label: 'Continue',
            showArrow: true,
            onPressed: _code.length == 6
                ? () =>
                      Navigator.of(context).pushNamed(AppRoutes.accountDetails)
                : null,
          ),
          const SizedBox(height: LGSpacing.md),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Change email address'),
            ),
          ),
          const SizedBox(height: LGSpacing.lg),
          Center(
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back to Login'),
            ),
          ),
        ],
      ),
    );
  }
}
