import 'package:flutter/material.dart';

import '../../components/laundrygo_button.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';
import 'states/issue_submitted_screen.dart';

/// Real report form — the trigger for [IssueSubmittedScreen], reached from
/// Order Detail's `⋯` menu ("Report an issue").
class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key, required this.orderId});

  final String orderId;

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _controller = TextEditingController();
  String _category = 'Damaged item';
  static const _categories = [
    'Damaged item',
    'Missing item',
    'Late delivery',
    'Wrong item',
    'Other',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  'SUPPORT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Report an '),
                      TextSpan(
                        text: 'Issue',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order #LG${widget.orderId}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('What went wrong?', style: theme.textTheme.titleSmall),
                const SizedBox(height: LGSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final c in _categories)
                      ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                        selectedColor: green.withValues(alpha: 0.15),
                        labelStyle: theme.textTheme.labelLarge?.copyWith(
                          color: _category == c
                              ? green
                              : theme.colorScheme.onSurface,
                        ),
                        side: BorderSide(
                          color: _category == c
                              ? green
                              : theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: LGSpacing.lg),
                Text('Details', style: theme.textTheme.titleSmall),
                const SizedBox(height: LGSpacing.sm),
                TextField(
                  controller: _controller,
                  maxLines: 5,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Tell us what happened...',
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
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                LaundryGoButton(
                  label: 'Submit Report',
                  showArrow: true,
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const IssueSubmittedScreen(),
                    ),
                  ),
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
