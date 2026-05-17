abstract class PreferencesRepository {
  String? getLanguageCode();

  Future<void> setLanguageCode(String code);

  String? getLastSongPath();

  Future<void> setLastSongPath(String path);

  bool getPermissionDenied();

  Future<void> setPermissionDenied(bool value);
}
