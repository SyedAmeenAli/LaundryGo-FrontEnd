import 'dart:async';

import 'package:flutter/material.dart';

import '../../../components/laundrygo_button.dart';
import '../../../components/otp_field_group.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../navigation/app_routes.dart';

/// OTP step of the phone sign-in flow — same tactile 6-digit entry as
/// email Verify, but confirming a phone number and landing straight in
/// the app (phone sign-in skips the separate Account Details step).
class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  static const _resendSeconds = 45;
  int _remaining = _resendSeconds;
  Timer? _timer;
  String _code = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remaining = _resendSeconds;
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.of(context).maybePop(),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.arrow_back,
                    size: 22,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: LGSpacing.md),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineLarge,
                  children: [
                    const TextSpan(text: 'Verify\nYour '),
                    TextSpan(text: 'Phone', style: TextStyle(color: green)),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.sm),
              Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  children: [
                    const TextSpan(text: "We've sent a 6-digit code to\n"),
                    TextSpan(
                      text: widget.phoneNumber,
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
                      onTap: _startTimer,
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
                    ? () => Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.customerHome,
                        (r) => false,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
