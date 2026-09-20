import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../state/theme_controller.dart';

class _Option {
  const _Option({
    required this.mode,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final ThemeMode mode;
  final IconData icon;
  final String title;
  final String subtitle;
}

const _options = [
  _Option(
    mode: ThemeMode.light,
    icon: Icons.light_mode_outlined,
    title: 'Light',
    subtitle: 'Always use light appearance',
  ),
  _Option(
    mode: ThemeMode.dark,
    icon: Icons.dark_mode_outlined,
    title: 'Dark',
    subtitle: 'Always use dark appearance',
  ),
  _Option(
    mode: ThemeMode.system,
    icon: Icons.brightness_auto_outlined,
    title: 'System',
    subtitle: 'Match your device setting',
  ),
];

/// Real theme picker — tapping a row genuinely repaints the whole app
/// (via [ThemeController]) and the selected row turns green immediately,
/// so the choice is visibly confirmed, not just silently stored.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final controller = context.watch<ThemeController>();

    return Scaffold(
      body: SafeArea(
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
                'DISPLAY',
                style: theme.textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.headlineLarge,
                  children: [
                    const TextSpan(text: 'App '),
                    TextSpan(
                      text: 'Appearance',
                      style: TextStyle(color: green),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: LGSpacing.lg),
              for (final option in _options)
                Padding(
                  padding: const EdgeInsets.only(bottom: LGSpacing.sm),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      controller.setMode(option.mode);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${option.title} appearance applied.'),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: LGMotion.component,
                      padding: const EdgeInsets.all(LGSpacing.md),
                      decoration: BoxDecoration(
                        color: controller.mode == option.mode
                            ? green.withValues(alpha: 0.1)
                            : theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: controller.mode == option.mode
                              ? green
                              : theme.colorScheme.outline,
                          width: controller.mode == option.mode ? 1.4 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            option.icon,
                            size: 20,
                            color: controller.mode == option.mode
                                ? green
                                : theme.colorScheme.onSurface,
                          ),
                          const SizedBox(width: LGSpacing.smd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.title,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  option.subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedSwitcher(
                            duration: LGMotion.micro,
                            child: controller.mode == option.mode
                                ? Icon(
                                    Icons.check_circle,
                                    key: const ValueKey(true),
                                    size: 20,
                                    color: green,
                                  )
                                : Icon(
                                    Icons.circle_outlined,
                                    key: const ValueKey(false),
                                    size: 20,
                                    color: theme.colorScheme.outline,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
