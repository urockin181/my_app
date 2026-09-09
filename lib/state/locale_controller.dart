import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's current language and persists the user's choice.
/// Defaults to Arabic on first launch since this is an Arabic-first app,
/// but the device's own language is respected when it's English.
class LocaleController extends ChangeNotifier {
  static const _prefsKey = 'app_locale';

  Locale _locale = const Locale('ar');
  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      _locale = Locale(saved);
    } else {
      final deviceLanguage = WidgetsBinding
          .instance.platformDispatcher.locale.languageCode;
      _locale = deviceLanguage == 'en' ? const Locale('en') : const Locale('ar');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, locale.languageCode);
  }
}
