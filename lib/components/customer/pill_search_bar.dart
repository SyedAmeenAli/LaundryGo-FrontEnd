import 'package:flutter/material.dart';

const _kSearchRadius = BorderRadius.all(Radius.circular(26));

/// Pill search field, optionally paired with a "Filters" chip button
/// (Partner Discovery reference) — reused wherever the reference shows a
/// rounded search input.
class PillSearchBar extends StatelessWidget {
  const PillSearchBar({
    super.key,
    required this.hint,
    this.onFilterTap,
    this.controller,
    this.onChanged,
  });

  final String hint;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final field = TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search,
          size: 20,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: const OutlineInputBorder(
          borderRadius: _kSearchRadius,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
    if (onFilterTap == null) return field;
    return Row(
      children: [
        Expanded(child: field),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: onFilterTap,
          icon: const Icon(Icons.tune, size: 16),
          label: const Text('Filters'),
          style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: theme.colorScheme.surface,
            side: BorderSide(color: theme.colorScheme.outline),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}
