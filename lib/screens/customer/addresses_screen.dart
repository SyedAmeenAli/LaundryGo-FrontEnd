import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../state/addresses_controller.dart';
import 'add_address_screen.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<AddressesController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: theme.colorScheme.surface,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back, size: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADDRESSES',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineLarge,
                              children: [
                                const TextSpan(text: 'Your '),
                                TextSpan(
                                  text: 'Addresses',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Manage your pickup and delivery addresses.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: LGSpacing.sm),
                    SizedBox(
                      width: 84,
                      height: 84,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            width: 84,
                            height: 60,
                            margin: const EdgeInsets.only(top: 24),
                          ),
                          Positioned(
                            top: 0,
                            child: Icon(
                              Icons.location_on,
                              size: 36,
                              color: theme.brightness == Brightness.dark
                                  ? LGColors.redDark
                                  : LGColors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(LGSpacing.md),
                child: Column(
                  children: [
                    if (controller.addresses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: LGSpacing.lg,
                        ),
                        child: Text(
                          'No saved addresses yet.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    for (var i = 0; i < controller.addresses.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                        child: _AddressCard(
                          index: i,
                          address: controller.addresses[i],
                        ),
                      ),
                    InkWell(
                      onTap: () async {
                        final label = await Navigator.of(context).push<String>(
                          MaterialPageRoute(
                            builder: (_) => const AddAddressScreen(),
                          ),
                        );
                        if (label != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$label address saved.')),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(LGSpacing.md),
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: green.withValues(alpha: 0.15),
                              child: Icon(Icons.add, size: 18, color: green),
                            ),
                            const SizedBox(width: LGSpacing.smd),
                            Expanded(
                              child: Text(
                                'Add New Address',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: green,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right, size: 18, color: green),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: LGSpacing.lg),
                    LaundryGoButton(
                      label: 'Continue',
                      showArrow: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.index, required this.address});

  final int index;
  final SavedAddress address;

  void _showMenu(BuildContext context) {
    final controller = context.read<AddressesController>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit address'),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final label = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) =>
                        AddAddressScreen(editIndex: index, existing: address),
                  ),
                );
                if (label != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$label address updated.')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.star_outline),
              title: const Text('Set as default'),
              enabled: !address.isDefault,
              onTap: () {
                controller.setDefault(index);
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${address.label} set as default.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete address'),
              onTap: () {
                controller.removeAt(index);
                Navigator.of(sheetContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${address.label} deleted.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    return Container(
      padding: const EdgeInsets.all(LGSpacing.smd),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(address.icon, size: 18, color: green),
          ),
          const SizedBox(width: LGSpacing.smd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(address.label, style: theme.textTheme.titleSmall),
                    if (address.isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Default',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  address.line1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  address.line2,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _showMenu(context),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.more_vert, size: 18),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.read<AddressesController>().setDefault(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${address.label} set as default.')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.chevron_right,
                size: 18,
                color: theme.brightness == Brightness.dark
                    ? LGColors.redDark
                    : LGColors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
