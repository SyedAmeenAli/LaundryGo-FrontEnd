import 'package:flutter/material.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/auth/auth_scaffold.dart';
import '../../components/laundrygo_button.dart';
import '../../components/laundrygo_text_field.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../navigation/app_routes.dart';
import 'forgot_password_screen.dart';
import 'social/apple_auth_screen.dart';
import 'social/google_auth_screen.dart';
import 'social/phone_auth_screen.dart';

/// Screen 05 — Login / Sign Up. Reference: coastline-through-archway hero,
/// "WELCOME BACK" eyebrow, two-tone hero headline, tab switch between Log
/// In and Sign Up, email/password, social row, Create Account callout,
/// legal footer.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.startOnSignUp = false});

  /// True when reached via the distinct Sign Up route/screen rather than
  /// Login's own tab toggle — same implementation, different entry point.
  final bool startOnSignUp;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _isLogin = !widget.startOnSignUp;
  bool _obscure = true;

  void _submit() {
    if (_isLogin) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.customerHome);
    } else {
      Navigator.of(context).pushNamed(AppRoutes.verify);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return AuthScaffold(
      heroImage: LaundryGoAssets.omanCoastline,
      cornerLines: const ['CLEAN', 'CLOTHES', 'HAPPIER', 'DAYS'],
      heroHeight: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'WELCOME BACK',
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
                const TextSpan(text: 'Fresh\nDays\n'),
                TextSpan(
                  text: 'Start Here.',
                  style: TextStyle(color: green),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text(
            'Log in to continue your laundry journey.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: LGSpacing.sm),
          _AuthTabs(
            isLogin: _isLogin,
            onChanged: (v) => setState(() => _isLogin = v),
          ),
          const SizedBox(height: LGSpacing.smd),
          const LaundryGoTextField(
            hint: 'Email address',
            icon: Icons.mail_outline,
          ),
          const SizedBox(height: LGSpacing.smd),
          LaundryGoTextField(
            hint: 'Password',
            icon: Icons.lock_outline,
            obscureText: _obscure,
            trailing: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
          if (_isLogin) ...[
            const SizedBox(height: LGSpacing.sm),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                ),
                child: const Text('Forgot password?'),
              ),
            ),
          ] else
            const SizedBox(height: LGSpacing.md),
          const SizedBox(height: LGSpacing.sm),
          LaundryGoButton(
            label: _isLogin ? 'Log In' : 'Sign Up',
            onPressed: _submit,
            showArrow: true,
          ),
          const SizedBox(height: LGSpacing.smd),
          Row(
            children: [
              Expanded(child: Divider(color: theme.colorScheme.outline)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.sm),
                child: Text(
                  'Or continue with',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Expanded(child: Divider(color: theme.colorScheme.outline)),
            ],
          ),
          const SizedBox(height: LGSpacing.smd),
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  icon: Icons.apple,
                  label: 'Apple',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AppleAuthScreen()),
                  ),
                ),
              ),
              const SizedBox(width: LGSpacing.sm),
              Expanded(
                child: _SocialButton(
                  icon: Icons.g_mobiledata,
                  label: 'Google',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GoogleAuthScreen()),
                  ),
                ),
              ),
              const SizedBox(width: LGSpacing.sm),
              Expanded(
                child: _SocialButton(
                  icon: Icons.phone_android_outlined,
                  label: 'Phone',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: LGSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: LGSpacing.smd,
              vertical: LGSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? LGColors.surfaceElevatedDark
                  : LGColors.cloud,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: green.withValues(alpha: 0.15),
                  child: Icon(Icons.eco_outlined, color: green, size: 18),
                ),
                const SizedBox(width: LGSpacing.smd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New to LaundryGo?',
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        'Join in seconds and get started.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.signUp),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Create Account'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: LGSpacing.xs),
          Text.rich(
            TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              children: const [
                TextSpan(text: 'By continuing, you agree to our '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy.',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AuthTabs extends StatelessWidget {
  const _AuthTabs({required this.isLogin, required this.onChanged});

  final bool isLogin;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    Widget tab(String label, bool selected, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: LGSpacing.sm),
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: selected
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: LGMotion.component,
                height: 2,
                color: selected ? red : Colors.transparent,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Log In', isLogin, () => onChanged(true)),
        tab('Sign Up', !isLogin, () => onChanged(false)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(fontSize: 13),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
