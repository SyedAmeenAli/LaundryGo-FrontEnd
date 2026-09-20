import 'package:flutter/material.dart';

import '../../../design_system/spacing.dart';
import '../../../navigation/app_routes.dart';

/// Mock "Sign in with Apple" sheet — Apple's real system prompt reduced to
/// what a demo can genuinely drive: confirm identity, continue.
class AppleAuthScreen extends StatefulWidget {
  const AppleAuthScreen({super.key});

  @override
  State<AppleAuthScreen> createState() => _AppleAuthScreenState();
}

class _AppleAuthScreenState extends State<AppleAuthScreen> {
  bool _authenticating = false;

  Future<void> _continue() async {
    setState(() => _authenticating = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.customerHome, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.apple, size: 56, color: Colors.white),
              const SizedBox(height: LGSpacing.lg),
              const Text(
                'Sign in with Apple ID',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: LGSpacing.sm),
              Text(
                'alex@icloud.com',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
              const SizedBox(height: LGSpacing.sm),
              Text(
                'LaundryGo will receive your name and email address.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _authenticating ? null : _continue,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: _authenticating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Continue with Face ID'),
                ),
              ),
              const SizedBox(height: LGSpacing.sm),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
