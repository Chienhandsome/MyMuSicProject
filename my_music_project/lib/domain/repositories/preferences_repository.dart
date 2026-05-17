abstract class PreferencesRepository {
  String? getLastSongPath();

  Future<void> setLastSongPath(String path);

  bool getPermissionDenied();

  Future<void> setPermissionDenied(bool value);
}
