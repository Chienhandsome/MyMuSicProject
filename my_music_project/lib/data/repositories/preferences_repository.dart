import '../../core/constants/media_keys.dart';
import '../../core/constants/permission_keys.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/shared_preferences_service.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  @override
  String? getLastSongPath() {
    return SharedPreferencesService.getString(MediaKeys.lastSongPath);
  }

  @override
  Future<void> setLastSongPath(String path) async {
    await SharedPreferencesService.setString(MediaKeys.lastSongPath, path);
  }

  @override
  bool getPermissionDenied() {
    return SharedPreferencesService.getBool(
          PermissionKeys.permissionDenied,
        ) ??
        false;
  }

  @override
  Future<void> setPermissionDenied(bool value) async {
    await SharedPreferencesService.setBool(
      PermissionKeys.permissionDenied,
      value,
    );
  }
}
