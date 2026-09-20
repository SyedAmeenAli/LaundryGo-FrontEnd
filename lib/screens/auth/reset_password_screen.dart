import 'package:flutter/material.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';

/// New-password form — the real endpoint of the Forgot Password flow.
/// Confirms match before enabling submit, then returns to Login.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _valid =>
      _passwordController.text.length >= 8 &&
      _passwordController.text == _confirmController.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;

    InputDecoration decoration(String hint) => InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 18,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 18,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.6),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(LGSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: theme.colorScheme.surface,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.arrow_back, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              Text(
                'ACCOUNT',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineLarge,
                  children: [
                    const TextSpan(text: 'New '),
                    TextSpan(
                      text: 'Password',
                      style: TextStyle(color: green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Must be at least 8 characters.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                onChanged: (_) => setState(() {}),
                style: theme.textTheme.bodyMedium,
                decoration: decoration('New password'),
              ),
              const SizedBox(height: LGSpacing.sm),
              TextField(
                controller: _confirmController,
                obscureText: _obscure,
                onChanged: (_) => setState(() {}),
                style: theme.textTheme.bodyMedium,
                decoration: decoration('Confirm password'),
              ),
              if (_confirmController.text.isNotEmpty &&
                  _passwordController.text != _confirmController.text) ...[
                const SizedBox(height: 6),
                Text(
                  "Passwords don't match",
                  style: theme.textTheme.bodySmall?.copyWith(color: red),
                ),
              ],
              const SizedBox(height: LGSpacing.lg),
              LaundryGoButton(
                label: 'Reset Password',
                showArrow: true,
                onPressed: _valid
                    ? () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (r) => false,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Password updated — log in with your new password.',
                            ),
                          ),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
