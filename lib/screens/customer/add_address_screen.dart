import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import '../../state/addresses_controller.dart';
import 'map_location_picker_screen.dart';

/// Real add/edit address form. With [editIndex] set it pre-fills from the
/// existing [SavedAddress] and saves via `updateAt` instead of `add` — the
/// same screen genuinely serves both #19 Add and #19 Edit.
class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key, this.editIndex, this.existing});

  final int? editIndex;
  final SavedAddress? existing;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late final _labelController = TextEditingController(
    text: widget.existing?.label ?? '',
  );
  late final _line1Controller = TextEditingController(
    text: widget.existing?.line1 ?? '',
  );
  late final _line2Controller = TextEditingController(
    text: widget.existing?.line2 ?? '',
  );
  late IconData _icon = widget.existing?.icon ?? Icons.home_outlined;
  String? _error;

  bool get _isEdit => widget.editIndex != null;

  static const _iconChoices = [
    Icons.home_outlined,
    Icons.apartment_outlined,
    Icons.business_outlined,
    Icons.fitness_center_outlined,
  ];

  @override
  void dispose() {
    _labelController.dispose();
    _line1Controller.dispose();
    _line2Controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_labelController.text.trim().isEmpty ||
        _line1Controller.text.trim().isEmpty) {
      setState(() => _error = 'Label and address line are required');
      return;
    }
    final label = _labelController.text.trim();
    final line1 = _line1Controller.text.trim();
    final line2 = _line2Controller.text.trim().isEmpty
        ? 'Muscat, Oman'
        : _line2Controller.text.trim();
    if (_isEdit) {
      context.read<AddressesController>().updateAt(
        widget.editIndex!,
        icon: _icon,
        label: label,
        line1: line1,
        line2: line2,
      );
    } else {
      context.read<AddressesController>().add(
        icon: _icon,
        label: label,
        line1: line1,
        line2: line2,
      );
    }
    Navigator.of(context).pop(label);
  }

  InputDecoration _decoration(ThemeData theme, String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      TextSpan(text: _isEdit ? 'Edit ' : 'New '),
                      TextSpan(
                        text: 'Address',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Save a pickup or delivery location.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Label', style: theme.textTheme.titleSmall),
                const SizedBox(height: LGSpacing.sm),
                Row(
                  children: [
                    for (final icon in _iconChoices) ...[
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => setState(() => _icon = icon),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _icon == icon
                                ? green.withValues(alpha: 0.15)
                                : theme.colorScheme.surfaceContainerHighest,
                            shape: BoxShape.circle,
                            border: _icon == icon
                                ? Border.all(color: green, width: 1.4)
                                : null,
                          ),
                          child: Icon(
                            icon,
                            size: 18,
                            color: _icon == icon
                                ? green
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: LGSpacing.sm),
                    ],
                  ],
                ),
                const SizedBox(height: LGSpacing.md),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final picked = await Navigator.of(context)
                        .push<PickedLocation>(
                          MaterialPageRoute(
                            builder: (_) => const MapLocationPickerScreen(),
                          ),
                        );
                    if (picked != null) {
                      _line1Controller.text = picked.address;
                      _line2Controller.text = 'Muscat, Oman';
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(LGSpacing.smd),
                    decoration: BoxDecoration(
                      color: green.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, size: 18, color: green),
                        const SizedBox(width: LGSpacing.sm),
                        Text(
                          'Pick location on map',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: green,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right, size: 18, color: green),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                TextField(
                  controller: _labelController,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(
                    theme,
                    'e.g. Home, Office',
                    Icons.label_outline,
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                TextField(
                  controller: _line1Controller,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(
                    theme,
                    'Street / building / villa',
                    Icons.location_on_outlined,
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                TextField(
                  controller: _line2Controller,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(
                    theme,
                    'Area, city (optional)',
                    Icons.map_outlined,
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: LGSpacing.sm),
                  Text(
                    _error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.brightness == Brightness.dark
                          ? LGColors.redDark
                          : LGColors.red,
                    ),
                  ),
                ],
                const SizedBox(height: LGSpacing.lg),
                LaundryGoButton(
                  label: _isEdit ? 'Save Changes' : 'Save Address',
                  showArrow: true,
                  onPressed: _submit,
                ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
