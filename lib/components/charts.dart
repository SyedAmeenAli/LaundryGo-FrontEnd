import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';

/// LaundryGoChartCard — a labelled card wrapping a real, data-driven
/// Flutter chart (never a generated chart image). Bar and line variants
/// cover every Partner/Admin analytics need in this app.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(LGSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: LGSpacing.md),
          child,
        ],
      ),
    );
  }
}

class BarDatum {
  const BarDatum(this.label, this.value);
  final String label;
  final double value;
}

/// Real bar chart — bars are painted from actual [BarDatum] values, never
/// a pre-rendered image.
class LGBarChart extends StatelessWidget {
  const LGBarChart({
    super.key,
    required this.data,
    this.height = 140,
    this.color,
    this.valueFormatter,
  });

  final List<BarDatum> data;
  final double height;
  final Color? color;
  final String Function(double)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor =
        color ??
        (theme.brightness == Brightness.dark ? LGColors.redDark : LGColors.red);
    final maxVal = data
        .map((d) => d.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return SizedBox(
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in data)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      valueFormatter?.call(d.value) ??
                          d.value.toStringAsFixed(0),
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: maxVal == 0 ? 0 : d.value / maxVal,
                      ),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      builder: (context, t, _) => Container(
                        height: (height - 40) * t.clamp(0.02, 1.0),
                        decoration: BoxDecoration(
                          color: barColor.withValues(alpha: 0.85),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      d.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Real line chart via `CustomPaint` — plots actual values, no image asset.
/// Optional [labels] (one per value, e.g. weekday names) render below the
/// line, and every point's own value renders above it — a bare unlabeled
/// squiggle reads as decoration, not data.
class LGLineChart extends StatelessWidget {
  const LGLineChart({
    super.key,
    required this.values,
    this.height = 100,
    this.color,
    this.labels,
    this.valueFormatter,
  });

  final List<double> values;
  final double height;
  final Color? color;
  final List<String>? labels;
  final String Function(double)? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor =
        color ??
        (theme.brightness == Brightness.dark
            ? LGColors.greenDark
            : LGColors.green);
    final maxVal = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    final minVal = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);
    final fmt = valueFormatter ?? (v) => v.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final dx = values.length > 1 ? w / (values.length - 1) : w;
              return Stack(
                children: [
                  CustomPaint(
                    size: Size(w, height),
                    painter: _LinePainter(values: values, color: lineColor),
                  ),
                  for (var i = 0; i < values.length; i++)
                    Positioned(
                      left: (dx * i - 20).clamp(0, w - 40),
                      top:
                          (height -
                                  ((values[i] - minVal) / range) *
                                      (height - 8) -
                                  4 -
                                  22)
                              .clamp(0, height),
                      width: 40,
                      child: Text(
                        fmt(values[i]),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: lineColor,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        if (labels != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              for (final l in labels!)
                Expanded(
                  child: Text(
                    l,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({required this.values, required this.color});
  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final minVal = values.reduce((a, b) => a < b ? a : b);
    final range = (maxVal - minVal) == 0 ? 1 : (maxVal - minVal);
    final dx = values.length > 1
        ? size.width / (values.length - 1)
        : size.width;

    final points = <Offset>[
      for (var i = 0; i < values.length; i++)
        Offset(
          dx * i,
          size.height - ((values[i] - minVal) / range) * (size.height - 8) - 4,
        ),
    ];

    final fillPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      fillPath.lineTo(p.dx, p.dy);
    }
    fillPath.lineTo(points.last.dx, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, Paint()..color = color.withValues(alpha: 0.12));

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      linePath.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = color
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    for (final p in points) {
      canvas.drawCircle(p, 3, Paint()..color = color);
      canvas.drawCircle(p, 5, Paint()..color = color.withValues(alpha: 0.2));
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// Compact KPI tile — LaundryGoStatCard. Value + label + optional trend.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.icon,
    this.trend,
    this.trendUp = true,
    this.accent,
  });

  final String value;
  final String label;
  final IconData? icon;
  final String? trend;
  final bool trendUp;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final color = accent ?? red;
    return Container(
      padding: const EdgeInsets.all(LGSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 14, color: color),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: theme.textTheme.headlineSmall),
          if (trend != null) ...[
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  trendUp ? Icons.trending_up : Icons.trending_down,
                  size: 12,
                  color: trendUp ? green : red,
                ),
                const SizedBox(width: 2),
                Text(
                  trend!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: trendUp ? green : red,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
