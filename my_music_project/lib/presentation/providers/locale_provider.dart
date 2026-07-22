import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/language_keys.dart';
import '../../di/app_providers.dart';
import '../../domain/usecases/locale_usecases.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  final LocaleUseCases _localeUseCases;

  LocaleNotifier(this._localeUseCases)
      : super(const Locale(LanguageKeys.vietnameseCode));

  void restoreLanguageCode(String? languageCode) {
    final code = languageCode ?? LanguageKeys.vietnameseCode;
    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    if (state == locale) return;
    await _localeUseCases.saveLanguageCode(locale.languageCode);
    state = locale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(localeUseCasesProvider));
});
