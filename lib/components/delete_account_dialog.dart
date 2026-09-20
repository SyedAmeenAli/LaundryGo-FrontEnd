import 'package:flutter/material.dart';

import '../design_system/colors.dart';

/// Real type-to-confirm account deletion — the Delete button stays
/// disabled until the user types "delete account" exactly, so this can
/// never be a stray double-tap.
Future<void> showDeleteAccountDialog(
  BuildContext context, {
  required VoidCallback onConfirmed,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => _DeleteAccountDialog(onConfirmed: onConfirmed),
  );
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog({required this.onConfirmed});
  final VoidCallback onConfirmed;

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _controller = TextEditingController();
  bool _canDelete = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return AlertDialog(
      title: const Text('Delete account?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This permanently deletes your account and all associated data. '
            'This cannot be undone.',
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              text: 'Type ',
              children: [
                const TextSpan(
                  text: 'delete account',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(text: ' to confirm.'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'delete account',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(
              () => _canDelete = v.trim().toLowerCase() == 'delete account',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _canDelete
              ? () {
                  Navigator.of(context).pop();
                  widget.onConfirmed();
                }
              : null,
          child: Text('Delete Account', style: TextStyle(color: red)),
        ),
      ],
    );
  }
}
