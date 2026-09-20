import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import '../../state/partner_controller.dart';

/// #59 Pricing — a real editable price table, not a static list. Each
/// row's price is a live `TextField` bound directly to
/// [PartnerController.setServicePrice]; Save genuinely persists.
class PartnerPricingScreen extends StatefulWidget {
  const PartnerPricingScreen({super.key});

  @override
  State<PartnerPricingScreen> createState() => _PartnerPricingScreenState();
}

class _PartnerPricingScreenState extends State<PartnerPricingScreen> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final services = context.read<PartnerController>().services;
    _controllers = [
      for (final s in services)
        TextEditingController(text: s.priceOmr.toStringAsFixed(3)),
    ];
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<PartnerController>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                const SizedBox(height: LGSpacing.md),
                Text(
                  'PRICING',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Service '),
                      TextSpan(
                        text: 'Pricing',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < controller.services.length; i++) ...[
                        Padding(
                          padding: const EdgeInsets.all(LGSpacing.md),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  controller.services[i].name,
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              Text(
                                'OMR',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 6),
                              SizedBox(
                                width: 70,
                                child: TextField(
                                  controller: _controllers[i],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  textAlign: TextAlign.right,
                                  style: theme.textTheme.titleSmall,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: theme.colorScheme.outline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (i != controller.services.length - 1)
                          Divider(height: 1, color: theme.colorScheme.outline),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                LaundryGoButton(
                  label: 'Save Pricing',
                  showArrow: true,
                  onPressed: () {
                    for (var i = 0; i < controller.services.length; i++) {
                      final parsed = double.tryParse(_controllers[i].text);
                      if (parsed != null) controller.setServicePrice(i, parsed);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pricing updated.')),
                    );
                    Navigator.of(context).pop();
                  },
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
