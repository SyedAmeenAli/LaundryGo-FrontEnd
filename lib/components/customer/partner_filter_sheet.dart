import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../motion/laundrygo_sheet_entrance.dart';

enum PartnerSort { nearest, highestRated, fastestPickup, recommended }

extension PartnerSortX on PartnerSort {
  String get label => switch (this) {
    PartnerSort.nearest => 'Nearest',
    PartnerSort.highestRated => 'Highest rated',
    PartnerSort.fastestPickup => 'Fastest pickup',
    PartnerSort.recommended => 'Recommended',
  };
}

/// Real, immutable filter/sort state — what [PartnerFilterSheet] hands
/// back via `Navigator.pop` on Apply, and what Partner Discovery applies
/// to its live result list.
class PartnerFilterState {
  const PartnerFilterState({
    this.services = const <String>{},
    this.minRating = 0,
    this.maxDistanceKm = 10,
    this.openNowOnly = false,
    this.pickupTodayOnly = false,
    this.sort = PartnerSort.recommended,
  });

  final Set<String> services;
  final double minRating;
  final double maxDistanceKm;
  final bool openNowOnly;
  final bool pickupTodayOnly;
  final PartnerSort sort;

  bool get isDefault =>
      services.isEmpty &&
      minRating == 0 &&
      maxDistanceKm == 10 &&
      !openNowOnly &&
      !pickupTodayOnly &&
      sort == PartnerSort.recommended;

  PartnerFilterState copyWith({
    Set<String>? services,
    double? minRating,
    double? maxDistanceKm,
    bool? openNowOnly,
    bool? pickupTodayOnly,
    PartnerSort? sort,
  }) {
    return PartnerFilterState(
      services: services ?? this.services,
      minRating: minRating ?? this.minRating,
      maxDistanceKm: maxDistanceKm ?? this.maxDistanceKm,
      openNowOnly: openNowOnly ?? this.openNowOnly,
      pickupTodayOnly: pickupTodayOnly ?? this.pickupTodayOnly,
      sort: sort ?? this.sort,
    );
  }
}

/// Shows the premium filter/sort bottom sheet and resolves to the applied
/// [PartnerFilterState] (or `null` if dismissed without applying) — a
/// modal overlay over Partner Discovery, never its own route (rule: not a
/// separate screen in the master inventory).
Future<PartnerFilterState?> showPartnerFilterSheet(
  BuildContext context, {
  required PartnerFilterState current,
  required List<String> availableServices,
}) {
  return showModalBottomSheet<PartnerFilterState>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => PartnerFilterSheet(
      initial: current,
      availableServices: availableServices,
    ),
  );
}

class PartnerFilterSheet extends StatefulWidget {
  const PartnerFilterSheet({
    super.key,
    required this.initial,
    required this.availableServices,
  });

  final PartnerFilterState initial;
  final List<String> availableServices;

  @override
  State<PartnerFilterSheet> createState() => _PartnerFilterSheetState();
}

class _PartnerFilterSheetState extends State<PartnerFilterSheet> {
  late PartnerFilterState _state = widget.initial;

  void _reset() => setState(() => _state = const PartnerFilterState());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return LaundryGoSheetEntrance(
      child: DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
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
                      'Filter & Sort',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  TextButton(
                    onPressed: _state.isDefault ? null : _reset,
                    child: Text('Reset', style: TextStyle(color: red)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  LGSpacing.md,
                  LGSpacing.sm,
                  LGSpacing.md,
                  LGSpacing.md,
                ),
                children: [
                  Text('Sort by', style: theme.textTheme.titleLarge),
                  const SizedBox(height: LGSpacing.sm),
                  Wrap(
                    spacing: LGSpacing.sm,
                    runSpacing: LGSpacing.sm,
                    children: [
                      for (final s in PartnerSort.values)
                        _Choice(
                          label: s.label,
                          selected: _state.sort == s,
                          onTap: () => setState(
                            () => _state = _state.copyWith(sort: s),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  Text('Service', style: theme.textTheme.titleLarge),
                  const SizedBox(height: LGSpacing.sm),
                  Wrap(
                    spacing: LGSpacing.sm,
                    runSpacing: LGSpacing.sm,
                    children: [
                      for (final s in widget.availableServices)
                        _Choice(
                          label: s,
                          selected: _state.services.contains(s),
                          onTap: () => setState(() {
                            final next = Set<String>.from(_state.services);
                            if (!next.remove(s)) next.add(s);
                            _state = _state.copyWith(services: next);
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: LGSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Minimum rating',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: LGColors.ratingGold),
                          Text(
                            _state.minRating == 0
                                ? 'Any'
                                : _state.minRating.toStringAsFixed(1),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Slider(
                    value: _state.minRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    activeColor: red,
                    label: _state.minRating == 0
                        ? 'Any'
                        : _state.minRating.toStringAsFixed(1),
                    onChanged: (v) =>
                        setState(() => _state = _state.copyWith(minRating: v)),
                  ),
                  const SizedBox(height: LGSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Max distance',
                          style: theme.textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        '${_state.maxDistanceKm.toStringAsFixed(0)} km',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Slider(
                    value: _state.maxDistanceKm,
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: red,
                    label: '${_state.maxDistanceKm.toStringAsFixed(0)} km',
                    onChanged: (v) => setState(
                      () => _state = _state.copyWith(maxDistanceKm: v),
                    ),
                  ),
                  const SizedBox(height: LGSpacing.sm),
                  Text('Availability', style: theme.textTheme.titleLarge),
                  const SizedBox(height: LGSpacing.sm),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _state.openNowOnly,
                    activeThumbColor: green,
                    title: const Text('Open now only'),
                    onChanged: (v) => setState(
                      () => _state = _state.copyWith(openNowOnly: v),
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _state.pickupTodayOnly,
                    activeThumbColor: green,
                    title: const Text('Pickup available today'),
                    onChanged: (v) => setState(
                      () => _state = _state.copyWith(pickupTodayOnly: v),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.md,
                0,
                LGSpacing.md,
                LGSpacing.md,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_state),
                  style: FilledButton.styleFrom(
                    backgroundColor: red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Apply'),
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

class _Choice extends StatelessWidget {
  const _Choice({
    required this.label,
    required this.selected,
    required this.onTap,
  });

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
      child: AnimatedContainer(
        duration: LGMotion.micro,
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? red : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? red : theme.colorScheme.outline),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
