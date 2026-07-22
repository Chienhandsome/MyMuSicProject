import '../repositories/preferences_repository.dart';

class LocaleUseCases {
  final PreferencesRepository _preferencesRepository;

  LocaleUseCases(this._preferencesRepository);

  String? loadLanguageCode() => _preferencesRepository.getLanguageCode();

  Future<void> saveLanguageCode(String code) {
    return _preferencesRepository.setLanguageCode(code);
  }
}
