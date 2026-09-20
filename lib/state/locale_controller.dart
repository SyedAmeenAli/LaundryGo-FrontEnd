import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's English/Arabic choice (Settings > Language) across
/// launches, same pattern as [ThemeController]. Switching locale here
/// flips the whole app to RTL automatically (Flutter mirrors layout for
/// `ar` through `Localizations`/`Directionality`) and every string routed
/// through `tr()` switches to its Arabic translation.
class LocaleController extends ChangeNotifier {
  static const _prefsKey = 'laundrygo_flow.locale';

  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    _locale = saved == 'ar' ? const Locale('ar') : const Locale('en');
    notifyListeners();
  }

  Future<void> setArabic(bool arabic) async {
    _locale = Locale(arabic ? 'ar' : 'en');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, _locale.languageCode);
  }
}
