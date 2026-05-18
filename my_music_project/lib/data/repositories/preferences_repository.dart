import '../../core/constants/settings_box_keys.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/app_settings_service.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppSettingsService _settingsService;

  PreferencesRepositoryImpl(this._settingsService);

  @override
  String? getLanguageCode() {
    return _settingsService.getString(SettingsBoxKeys.languageCode);
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await _settingsService.setString(SettingsBoxKeys.languageCode, code);
  }

  @override
  String? getLastSongPath() {
    return _settingsService.getString(SettingsBoxKeys.lastSongPath);
  }

  @override
  Future<void> setLastSongPath(String path) async {
    await _settingsService.setString(SettingsBoxKeys.lastSongPath, path);
  }

  @override
  bool getPermissionDenied() {
    return _settingsService.getBool(SettingsBoxKeys.permissionDenied);
  }

  @override
  Future<void> setPermissionDenied(bool value) async {
    await _settingsService.setBool(SettingsBoxKeys.permissionDenied, value);
  }
}
