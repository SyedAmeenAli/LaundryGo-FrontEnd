import 'package:flutter/material.dart';

import '../../../design_system/colors.dart';
import '../../../design_system/spacing.dart';
import '../../../navigation/app_routes.dart';

/// Mock Google account picker — the real system sheet Google's own
/// "Sign in with Google" shows, reduced to what a demo can genuinely
/// drive: pick an account, sign in with it.
class GoogleAuthScreen extends StatefulWidget {
  const GoogleAuthScreen({super.key});

  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  String? _signingInEmail;

  static const _accounts = [
    (name: 'Alex Al Balushi', email: 'alex.albalushi@gmail.com'),
    (name: 'Alex (Work)', email: 'alex.work@gmail.com'),
  ];

  Future<void> _signIn(String email) async {
    setState(() => _signingInEmail = email);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.customerHome, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.45),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.lg),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 380),
              padding: const EdgeInsets.all(LGSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const _GoogleLogo(),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.md),
                  const Text(
                    'Choose an account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'to continue to LaundryGo',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: LGSpacing.md),
                  for (final a in _accounts)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _signingInEmail == null ? () => _signIn(a.email) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: LGSpacing.sm,
                          vertical: LGSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: LGColors.green.withValues(
                                alpha: 0.15,
                              ),
                              child: Text(
                                a.name[0],
                                style: const TextStyle(
                                  color: LGColors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    a.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    a.email,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_signingInEmail == a.email)
                              const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: LGColors.green,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const Divider(height: LGSpacing.lg),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _signingInEmail == null
                        ? () => _signIn('alex@example.com')
                        : null,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: LGSpacing.sm,
                        vertical: LGSpacing.sm,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person_add_alt_outlined,
                            size: 20,
                            color: Colors.black54,
                          ),
                          SizedBox(width: LGSpacing.smd),
                          Text(
                            'Use another account',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Google',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    );
  }
}
