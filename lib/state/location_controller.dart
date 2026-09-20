import 'package:flutter/material.dart';

import '../components/motion/laundrygo_sheet_entrance.dart';

/// Real city state for the header's location dropdown — picking a city
/// genuinely updates every header across the app, not just a static label.
class LocationController extends ChangeNotifier {
  String _city = 'Muscat';
  String get city => _city;

  void setCity(String city) {
    _city = city;
    notifyListeners();
  }
}

const kOmanCities = ['Muscat', 'Salalah', 'Sohar', 'Nizwa', 'Sur', 'Ibri'];

Future<void> showCityPicker(
  BuildContext context,
  LocationController controller,
) {
  return showModalBottomSheet<void>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => LaundryGoSheetEntrance(
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Choose your city',
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            for (final city in kOmanCities)
              ListTile(
                leading: Icon(
                  city == controller.city
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                title: Text(city),
                onTap: () {
                  controller.setCity(city);
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Location set to $city.')),
                  );
                },
              ),
          ],
        ),
      ),
    ),
  );
}
