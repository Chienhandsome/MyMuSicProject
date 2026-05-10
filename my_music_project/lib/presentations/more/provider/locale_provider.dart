import 'package:flutter/material.dart';
import 'package:my_music_project/core/constants/language_keys.dart';
import '../../../data/models/shared_preferences_helper.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale(LanguageKeys.vietnameseCode); // Default locale

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = SharedPreferencesHelper.getString(LanguageKeys.languageCode) ?? LanguageKeys.vietnameseCode;
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await SharedPreferencesHelper.setString(LanguageKeys.vietnameseCode, locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale(LanguageKeys.vietnameseCode);
    notifyListeners();
  }
}

