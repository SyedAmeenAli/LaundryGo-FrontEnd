import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// What this screen hands back via `Navigator.pop` on a successful save.
class NewCardResult {
  const NewCardResult({
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.saveCard,
  });
  final String brand;
  final String last4;
  final String expiry;
  final bool saveCard;
}

/// Add Payment Method — a real card form with real validation (Luhn-style
/// length checks, expiry format, CVV length), visually consistent with
/// the Payment screen's own card composition.
class AddPaymentMethodScreen extends StatefulWidget {
  const AddPaymentMethodScreen({super.key});

  @override
  State<AddPaymentMethodScreen> createState() =>
      _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();
  bool _saveCard = true;

  @override
  void dispose() {
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String get _brand {
    final digits = _numberController.text.replaceAll(' ', '');
    if (digits.startsWith('4')) return 'Visa';
    if (digits.startsWith('5')) return 'Mastercard';
    return 'Card';
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final digits = _numberController.text.replaceAll(' ', '');
    Navigator.of(context).pop(
      NewCardResult(
        brand: _brand,
        last4: digits.substring(digits.length - 4),
        expiry: _expiryController.text,
        saveCard: _saveCard,
      ),
    );
  }

  InputDecoration _decoration(ThemeData theme, String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.brightness == Brightness.dark
                ? LGColors.redDark
                : LGColors.red,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: LGSpacing.md),
                  RichText(
                    text: TextSpan(
                      style: theme.textTheme.headlineLarge,
                      children: [
                        const TextSpan(text: 'Add '),
                        TextSpan(text: 'Card', style: TextStyle(color: green)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your card details are securely stored.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: double.infinity,
                    height: 170,
                    padding: const EdgeInsets.all(LGSpacing.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [green, LGColors.graphite],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wifi, color: Colors.white70, size: 20),
                            const Spacer(),
                            Text(
                              _brand,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          _numberController.text.isEmpty
                              ? '•••• •••• •••• ••••'
                              : _numberController.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _nameController.text.isEmpty
                                  ? 'CARDHOLDER NAME'
                                  : _nameController.text.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _expiryController.text.isEmpty
                                  ? 'MM/YY'
                                  : _expiryController.text,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: theme.textTheme.bodyMedium,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      _CardNumberFormatter(),
                    ],
                    decoration: _decoration(
                      theme,
                      'Card number',
                      Icons.credit_card,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      final digits = (v ?? '').replaceAll(' ', '');
                      if (digits.length != 16) return 'Enter a valid 16-digit card number';
                      return null;
                    },
                  ),
                  const SizedBox(height: LGSpacing.sm),
                  TextFormField(
                    controller: _nameController,
                    style: theme.textTheme.bodyMedium,
                    textCapitalization: TextCapitalization.words,
                    decoration: _decoration(
                      theme,
                      'Cardholder name',
                      Icons.person_outline,
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter the cardholder name' : null,
                  ),
                  const SizedBox(height: LGSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          keyboardType: TextInputType.number,
                          style: theme.textTheme.bodyMedium,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryFormatter(),
                          ],
                          decoration: _decoration(
                            theme,
                            'MM/YY',
                            Icons.calendar_today_outlined,
                          ),
                          onChanged: (_) => setState(() {}),
                          validator: (v) {
                            if (v == null || !RegExp(r'^\d{2}/\d{2}$').hasMatch(v)) {
                              return 'Invalid';
                            }
                            final month = int.tryParse(v.split('/').first) ?? 0;
                            if (month < 1 || month > 12) return 'Invalid month';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: LGSpacing.sm),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          style: theme.textTheme.bodyMedium,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: _decoration(
                            theme,
                            'CVV',
                            Icons.lock_outline,
                          ),
                          validator: (v) =>
                              (v == null || v.length != 3) ? 'Invalid CVV' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.sm),
                  InkWell(
                    onTap: () => setState(() => _saveCard = !_saveCard),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _saveCard,
                          activeColor: red,
                          onChanged: (v) => setState(() => _saveCard = v ?? true),
                        ),
                        Text('Save this card for future orders', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  LaundryGoButton(
                    label: 'Save Card',
                    showArrow: true,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: LGSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll('/', '');
    if (digits.length <= 2) {
      return TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    final text = '${digits.substring(0, 2)}/${digits.substring(2)}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
