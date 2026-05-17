import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/settings_box_keys.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/hive_storage_service.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  Box<dynamic> get _settingsBox => HiveStorageService.settingsBox;

  @override
  String? getLanguageCode() {
    return _settingsBox.get(SettingsBoxKeys.languageCode) as String?;
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await _settingsBox.put(SettingsBoxKeys.languageCode, code);
  }

  @override
  String? getLastSongPath() {
    return _settingsBox.get(SettingsBoxKeys.lastSongPath) as String?;
  }

  @override
  Future<void> setLastSongPath(String path) async {
    await _settingsBox.put(SettingsBoxKeys.lastSongPath, path);
  }

  @override
  bool getPermissionDenied() {
    return _settingsBox.get(
          SettingsBoxKeys.permissionDenied,
          defaultValue: false,
        ) as bool;
  }

  @override
  Future<void> setPermissionDenied(bool value) async {
    await _settingsBox.put(SettingsBoxKeys.permissionDenied, value);
  }
}
