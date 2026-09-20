import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../asset_registry/laundrygo_assets.dart';
import '../../components/customer/map_panel.dart';
import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';
import 'order_review_screen.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({super.key, required this.partnerId});

  final String partnerId;

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  int _dateIndex = 0;
  int _timeIndex = 0;
  bool _morning = true;

  static const _days = [
    ('Mon', '15', 'Sep'),
    ('Tue', '16', 'Sep'),
    ('Wed', '17', 'Sep'),
    ('Thu', '18', 'Sep'),
    ('Fri', '19', 'Sep'),
    ('Sat', '20', 'Sep'),
    ('Sun', '21', 'Sep'),
  ];
  static const _morningTimes = ['8:00 AM', '9:00 AM', '10:00 AM', '11:00 AM'];
  static const _afternoonTimes = ['12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM'];

  Partner get _partner => MockCustomerData.partners.firstWhere(
    (p) => p.id == widget.partnerId,
    orElse: () => MockCustomerData.partners.first,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.scaffoldBackgroundColor;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final partner = _partner;
    final times = _morning ? _morningTimes : _afternoonTimes;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 230,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(partner.image, fit: BoxFit.cover),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              background.withValues(alpha: 0),
                              background,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 70,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.35),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            LGSpacing.md,
                            LGSpacing.sm,
                            LGSpacing.md,
                            0,
                          ),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: const CircleBorder(),
                                elevation: 3,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => Navigator.of(context).pop(),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: 18,
                                      color: LGColors.midnight,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: LGSpacing.sm),
                              Image.asset(
                                LaundryGoAssets.logoHorizontal,
                                height: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: LGSpacing.md,
                      right: LGSpacing.md,
                      bottom: 14,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'BOOK A SERVICE',
                            style: theme.textTheme.labelSmall?.copyWith(
                              letterSpacing: 1.6,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              style: theme.textTheme.headlineMedium,
                              children: [
                                const TextSpan(text: 'Schedule\nYour '),
                                TextSpan(
                                  text: 'Pickup.',
                                  style: TextStyle(color: green),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.md,
                  LGSpacing.md,
                  0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          LaundryGoAssets.logoMark,
                          width: 44,
                          height: 44,
                        ),
                      ),
                      const SizedBox(width: LGSpacing.smd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              partner.name,
                              style: theme.textTheme.titleSmall,
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 12,
                                  color: LGColors.ratingGold,
                                ),
                                Text(
                                  ' ${partner.rating} (${partner.reviewCount} reviews)',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            Text(
                              partner.address,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: MapPanel(
                          center: LatLng(partner.lat, partner.lng),
                          height: 70,
                          zoom: 13,
                          interactive: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Text('Select a date', style: theme.textTheme.titleLarge),
              ),
              SizedBox(
                height: 76,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: LGSpacing.md,
                    vertical: LGSpacing.sm,
                  ),
                  itemCount: _days.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final selected = i == _dateIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _dateIndex = i),
                      child: AnimatedContainer(
                        duration: LGMotion.micro,
                        width: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? red : theme.colorScheme.outline,
                            width: selected ? 1.6 : 1.2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_days[i].$1, style: theme.textTheme.bodySmall),
                            Text(
                              _days[i].$2,
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(_days[i].$3, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Select a time',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    _Toggle(
                      icon: Icons.wb_sunny_outlined,
                      label: 'Morning',
                      selected: _morning,
                      onTap: () => setState(() {
                        _morning = true;
                        _timeIndex = 0;
                      }),
                    ),
                    const SizedBox(width: 6),
                    _Toggle(
                      icon: Icons.nightlight_outlined,
                      label: 'Afternoon',
                      selected: !_morning,
                      onTap: () => setState(() {
                        _morning = false;
                        _timeIndex = 0;
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  0,
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 44,
                  ),
                  itemCount: times.length,
                  itemBuilder: (context, i) {
                    final selected = i == _timeIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _timeIndex = i),
                      child: AnimatedContainer(
                        duration: LGMotion.micro,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected ? red : theme.colorScheme.outline,
                            width: selected ? 1.6 : 1.2,
                          ),
                        ),
                        child: Text(times[i], style: theme.textTheme.bodySmall),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Your service',
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.edit_outlined, size: 14),
                      label: const Text('Edit'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: LGSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(LGSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          LaundryGoAssets.foldedStack,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: LGSpacing.smd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wash & Fold',
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              'Everyday essentials',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('OMR 5.00', style: theme.textTheme.titleMedium),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.lg,
                  LGSpacing.md,
                  LGSpacing.lg,
                ),
                child: LaundryGoButton(
                  label: 'Continue',
                  showArrow: true,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderReviewScreen(
                        partner: partner,
                        pickupDateLabel:
                            '${_days[_dateIndex].$1}, ${_days[_dateIndex].$2} ${_days[_dateIndex].$3}',
                        pickupTimeLabel: times[_timeIndex],
                      ),
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

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? red.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? red : theme.colorScheme.outline),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: selected ? red : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: selected ? red : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
