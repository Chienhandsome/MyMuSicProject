import 'package:flutter/material.dart';
import '../models/shared_preferences_helper.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('vi'); // Default locale

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = SharedPreferencesHelper.getString('language_code') ?? 'vi';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    await SharedPreferencesHelper.setString('language_code', locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('vi');
    notifyListeners();
  }
}

