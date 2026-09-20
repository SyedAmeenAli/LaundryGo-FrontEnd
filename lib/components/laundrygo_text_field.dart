import 'package:flutter/material.dart';

const _kFieldRadius = BorderRadius.all(Radius.circular(26));

/// Pill-shaped, icon-led text field — the auth-flow field treatment
/// (rounded, spacious, leading icon, optional trailing action).
class LaundryGoTextField extends StatelessWidget {
  const LaundryGoTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.trailing,
    this.keyboardType,
    this.enabled = true,
    this.dense = false,
  });

  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? trailing;
  final TextInputType? keyboardType;
  final bool enabled;

  /// Tighter vertical padding for forms with many stacked fields (e.g.
  /// Account Details) — same pill shape/border, just a shorter field.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        suffixIcon: trailing,
        isDense: dense,
        contentPadding: dense
            ? const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
            : null,
        border: const OutlineInputBorder(borderRadius: _kFieldRadius),
        enabledBorder: OutlineInputBorder(
          borderRadius: _kFieldRadius,
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
    );
  }
}
