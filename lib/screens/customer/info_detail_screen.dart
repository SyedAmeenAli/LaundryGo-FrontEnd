import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// Generic back-header + eyebrow + headline + body-paragraph screen — reused
/// for Help Center, Contact Us, Privacy Policy and Terms & Conditions so
/// each has real, distinct content instead of a dead `onTap: () {}`.
class InfoDetailScreen extends StatelessWidget {
  const InfoDetailScreen({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.accent,
    required this.paragraphs,
    this.contactRows = const [],
  });

  final String eyebrow;
  final String title;
  final String accent;
  final List<String> paragraphs;
  final List<ContactRow> contactRows;

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
                  eyebrow,
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      TextSpan(text: title),
                      TextSpan(
                        text: accent,
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                for (final p in paragraphs) ...[
                  Text(
                    p,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: LGSpacing.smd),
                ],
                if (contactRows.isNotEmpty) ...[
                  const SizedBox(height: LGSpacing.sm),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (var i = 0; i < contactRows.length; i++) ...[
                          InkWell(
                            onTap: contactRows[i].onTap,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: LGSpacing.md,
                                vertical: LGSpacing.smd,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    contactRows[i].icon,
                                    size: 18,
                                    color: green,
                                  ),
                                  const SizedBox(width: LGSpacing.smd),
                                  Expanded(
                                    child: Text(
                                      contactRows[i].label,
                                      style: theme.textTheme.titleSmall,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (i != contactRows.length - 1)
                            Divider(
                              height: 1,
                              color: theme.colorScheme.outline,
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactRow {
  const ContactRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}
