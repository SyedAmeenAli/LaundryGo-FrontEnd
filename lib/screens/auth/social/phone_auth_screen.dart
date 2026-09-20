import 'package:flutter/material.dart';

import '../../../components/laundrygo_button.dart';
import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import 'phone_otp_screen.dart';

/// Phone number entry — first step of the phone sign-in flow, sends the
/// user on to [PhoneOtpScreen] with the real number they typed.
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
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
                    const TextSpan(text: 'Sign In\nWith '),
                    TextSpan(text: 'Phone', style: TextStyle(color: green)),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.sm),
              Text(
                "We'll text you a code to verify it's you.",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: LGSpacing.md),
                      child: Text('+968', style: theme.textTheme.bodyLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: LGSpacing.sm,
                      ),
                      child: SizedBox(
                        height: 20,
                        child: VerticalDivider(
                          color: theme.colorScheme.outline,
                          thickness: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.phone,
                        style: theme.textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          hintText: '9123 4567',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              LaundryGoButton(
                label: 'Send Code',
                showArrow: true,
                onPressed: _controller.text.trim().length >= 7
                    ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PhoneOtpScreen(
                            phoneNumber: '+968 ${_controller.text.trim()}',
                          ),
                        ),
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
