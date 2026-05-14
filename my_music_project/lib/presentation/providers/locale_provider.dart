import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/language_keys.dart';
import '../../data/services/shared_preferences_service.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier()
      : super(const Locale(LanguageKeys.vietnameseCode)) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = SharedPreferencesService.getString(LanguageKeys.languageCode) ??
        LanguageKeys.vietnameseCode;
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    await SharedPreferencesService.setString(
        LanguageKeys.languageCode, locale.languageCode);
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
