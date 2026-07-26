import 'package:flutter_test/flutter_test.dart';
import 'package:my_music_project/domain/repositories/preferences_repository.dart';
import 'package:my_music_project/domain/usecases/locale_usecases.dart';

void main() {
  group('LocaleUseCases', () {
    test('loadLanguageCode returns null when no language is saved', () {
      final repo = _FakePreferencesRepository();
      final useCases = LocaleUseCases(repo);

      expect(useCases.loadLanguageCode(), isNull);
    });

    test('loadLanguageCode returns saved language code', () {
      final repo = _FakePreferencesRepository(languageCode: 'vi');
      final useCases = LocaleUseCases(repo);

      expect(useCases.loadLanguageCode(), 'vi');
    });

    test('saveLanguageCode persists the code', () async {
      final repo = _FakePreferencesRepository();
      final useCases = LocaleUseCases(repo);

      await useCases.saveLanguageCode('en');

      expect(repo.languageCode, 'en');
    });

    test('saveLanguageCode overwrites previous value', () async {
      final repo = _FakePreferencesRepository(languageCode: 'vi');
      final useCases = LocaleUseCases(repo);

      await useCases.saveLanguageCode('en');

      expect(repo.languageCode, 'en');
    });
  });
}

class _FakePreferencesRepository implements PreferencesRepository {
  bool permissionDenied;
  String? languageCode;
  String? lastSongPath;

  _FakePreferencesRepository({
    this.permissionDenied = false,
    this.languageCode,
    this.lastSongPath,
  });

  @override
  bool getPermissionDenied() => permissionDenied;

  @override
  Future<void> setPermissionDenied(bool value) async {
    permissionDenied = value;
  }

  @override
  String? getLanguageCode() => languageCode;

  @override
  Future<void> setLanguageCode(String code) async {
    languageCode = code;
  }

  @override
  String? getLastSongPath() => lastSongPath;

  @override
  Future<void> setLastSongPath(String path) async {
    lastSongPath = path;
  }
}
