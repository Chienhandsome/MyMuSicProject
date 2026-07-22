import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/language_keys.dart';
import '../../di/app_providers.dart';
import '../../domain/usecases/locale_usecases.dart';

class LocaleState {
  final Locale locale;
  final bool isInitialized;

  const LocaleState({
    required this.locale,
    this.isInitialized = false,
  });
}

class LocaleNotifier extends StateNotifier<LocaleState> {
  final LocaleUseCases _localeUseCases;

  LocaleNotifier(this._localeUseCases)
      : super(
          const LocaleState(
            locale: Locale(LanguageKeys.vietnameseCode),
          ),
        );

  void restoreLanguageCode(String? languageCode) {
    final code = languageCode ?? LanguageKeys.vietnameseCode;
    state = LocaleState(locale: Locale(code), isInitialized: true);
  }

  Future<void> setLocale(Locale locale) async {
    if (state.locale == locale && state.isInitialized) return;
    await _localeUseCases.saveLanguageCode(locale.languageCode);
    state = LocaleState(locale: locale, isInitialized: true);
  }
}

final localeProvider =
    StateNotifierProvider<LocaleNotifier, LocaleState>((ref) {
  return LocaleNotifier(ref.watch(localeUseCasesProvider));
});
