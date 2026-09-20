import 'package:flutter/material.dart';

import 'login_screen.dart';

/// The distinct Sign Up route — its own place in the navigation stack,
/// reachable independently of Login. Shares Login's implementation (same
/// ref-matched visual, same tab) so the two never drift apart, but opening
/// it always lands on the Sign Up tab.
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) => const LoginScreen(startOnSignUp: true);
}
