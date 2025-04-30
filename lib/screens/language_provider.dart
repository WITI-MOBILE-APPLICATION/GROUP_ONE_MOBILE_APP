// @dart=2.17
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  // Initialize locale from saved preferences
  Future<void> initLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');

    if (languageCode != null) {
      _locale = Locale(languageCode);
    }

    notifyListeners();
  }

  // Change locale and save to preferences
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    notifyListeners();
  }
}
