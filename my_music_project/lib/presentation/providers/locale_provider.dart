import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/language_keys.dart';
import '../../domain/repositories/preferences_repository.dart';
import 'preferences_provider.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final PreferencesRepository _preferencesRepository;

  LocaleNotifier(this._preferencesRepository)
      : super(const Locale(LanguageKeys.vietnameseCode)) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = _preferencesRepository.getLanguageCode() ??
        LanguageKeys.vietnameseCode;
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    await _preferencesRepository.setLanguageCode(locale.languageCode);
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(preferencesRepositoryProvider));
});
