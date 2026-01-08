import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing SharedPreferences operations
/// Provides type-safe methods for storing and retrieving data
class SharedPreferencesHelper {
  static SharedPreferences? _prefs;

  // Keys for music player settings
  static const String _keyLastPlayedSongId = 'last_played_song_id';
  static const String _keyLastPosition = 'last_position';
  static const String _keyRepeatMode = 'repeat_mode';
  static const String _keyShuffleMode = 'shuffle_mode';
  static const String _keyPlaybackSpeed = 'playback_speed';
  static const String _keyVolume = 'volume';
  static const String _keyFavorites = 'favorites';
  static const String _keyPlaylists = 'playlists';
  static const String _keyRecentlyPlayed = 'recently_played';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyFirstLaunch = 'first_launch';



  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance (throws if not initialized)
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferencesHelper not initialized. Call init() first.',
      );
    }
    return _prefs!;
  }

  // ============================================
  // Generic methods for any key
  // ============================================

  /// Save string value
  static Future<bool> setString(String key, String value) async {
    return await instance.setString(key, value);
  }

  /// Get string value
  static String? getString(String key, {String? defaultValue}) {
    return instance.getString(key) ?? defaultValue;
  }

  /// Save int value
  static Future<bool> setInt(String key, int value) async {
    return await instance.setInt(key, value);
  }

  /// Get int value
  static int? getInt(String key, {int? defaultValue}) {
    return instance.getInt(key) ?? defaultValue;
  }

  /// Save double value
  static Future<bool> setDouble(String key, double value) async {
    return await instance.setDouble(key, value);
  }

  /// Get double value
  static double? getDouble(String key, {double? defaultValue}) {
    return instance.getDouble(key) ?? defaultValue;
  }

  /// Save bool value
  static Future<bool> setBool(String key, bool value) async {
    return await instance.setBool(key, value);
  }

  /// Get bool value
  static bool? getBool(String key, {bool? defaultValue}) {
    return instance.getBool(key) ?? defaultValue;
  }

  /// Save list of strings
  static Future<bool> setStringList(String key, List<String> value) async {
    return await instance.setStringList(key, value);
  }

  /// Get list of strings
  static List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return instance.getStringList(key) ?? defaultValue;
  }

  /// Remove a specific key
  static Future<bool> remove(String key) async {
    return await instance.remove(key);
  }

  /// Clear all data
  static Future<bool> clear() async {
    return await instance.clear();
  }

  /// Check if key exists
  static bool containsKey(String key) {
    return instance.containsKey(key);
  }

  /// Get all keys
  static Set<String> getKeys() {
    return instance.getKeys();
  }

  // ============================================
  // Music Player specific methods
  // ============================================

  /// Save last played song ID
  static Future<bool> setLastPlayedSongId(String songId) async {
    return await setString(_keyLastPlayedSongId, songId);
  }

  /// Get last played song ID
  static String? getLastPlayedSongId() {
    return getString(_keyLastPlayedSongId);
  }

  /// Save last playback position (in milliseconds)
  static Future<bool> setLastPosition(int positionMs) async {
    return await setInt(_keyLastPosition, positionMs);
  }

  /// Get last playback position (in milliseconds)
  static int getLastPosition() {
    return getInt(_keyLastPosition, defaultValue: 0) ?? 0;
  }

  /// Save repeat mode (0: off, 1: one, 2: all)
  static Future<bool> setRepeatMode(int mode) async {
    return await setInt(_keyRepeatMode, mode);
  }

  /// Get repeat mode (0: off, 1: one, 2: all)
  static int getRepeatMode() {
    return getInt(_keyRepeatMode, defaultValue: 0) ?? 0;
  }

  /// Save shuffle mode
  static Future<bool> setShuffleMode(bool isShuffled) async {
    return await setBool(_keyShuffleMode, isShuffled);
  }

  /// Get shuffle mode
  static bool getShuffleMode() {
    return getBool(_keyShuffleMode, defaultValue: false) ?? false;
  }

  /// Save playback speed
  static Future<bool> setPlaybackSpeed(double speed) async {
    return await setDouble(_keyPlaybackSpeed, speed);
  }

  /// Get playback speed
  static double getPlaybackSpeed() {
    return getDouble(_keyPlaybackSpeed, defaultValue: 1.0) ?? 1.0;
  }

  /// Save volume (0.0 to 1.0)
  static Future<bool> setVolume(double volume) async {
    return await setDouble(_keyVolume, volume);
  }

  /// Get volume (0.0 to 1.0)
  static double getVolume() {
    return getDouble(_keyVolume, defaultValue: 1.0) ?? 1.0;
  }

  /// Save favorite song IDs
  static Future<bool> setFavorites(List<String> favorites) async {
    return await setStringList(_keyFavorites, favorites);
  }

  /// Get favorite song IDs
  static List<String> getFavorites() {
    return getStringList(_keyFavorites, defaultValue: []) ?? [];
  }

  /// Add song to favorites
  static Future<bool> addToFavorites(String songId) async {
    final favorites = getFavorites();
    if (!favorites.contains(songId)) {
      favorites.add(songId);
      return await setFavorites(favorites);
    }
    return true;
  }

  /// Remove song from favorites
  static Future<bool> removeFromFavorites(String songId) async {
    final favorites = getFavorites();
    favorites.remove(songId);
    return await setFavorites(favorites);
  }

  /// Check if song is favorite
  static bool isFavorite(String songId) {
    return getFavorites().contains(songId);
  }

  /// Save recently played song IDs (max 20)
  static Future<bool> addToRecentlyPlayed(String songId) async {
    final recentlyPlayed = getRecentlyPlayed();
    recentlyPlayed.remove(songId); // Remove if already exists
    recentlyPlayed.insert(0, songId); // Add to beginning

    // Keep only last 20 songs
    if (recentlyPlayed.length > 20) {
      recentlyPlayed.removeRange(20, recentlyPlayed.length);
    }

    return await setStringList(_keyRecentlyPlayed, recentlyPlayed);
  }

  /// Get recently played song IDs
  static List<String> getRecentlyPlayed() {
    return getStringList(_keyRecentlyPlayed, defaultValue: []) ?? [];
  }

  /// Clear recently played
  static Future<bool> clearRecentlyPlayed() async {
    return await remove(_keyRecentlyPlayed);
  }

  /// Save theme mode (0: system, 1: light, 2: dark)
  static Future<bool> setThemeMode(int mode) async {
    return await setInt(_keyThemeMode, mode);
  }

  /// Get theme mode (0: system, 1: light, 2: dark)
  static int getThemeMode() {
    return getInt(_keyThemeMode, defaultValue: 0) ?? 0;
  }

  /// Check if this is first launch
  static bool isFirstLaunch() {
    return getBool(_keyFirstLaunch, defaultValue: true) ?? true;
  }

  /// Set first launch flag to false
  static Future<bool> setNotFirstLaunch() async {
    return await setBool(_keyFirstLaunch, false);
  }

  /// Reset all settings to default
  static Future<bool> resetAllSettings() async {
    final keys = [
      _keyLastPlayedSongId,
      _keyLastPosition,
      _keyRepeatMode,
      _keyShuffleMode,
      _keyPlaybackSpeed,
      _keyVolume,
      _keyFavorites,
      _keyPlaylists,
      _keyRecentlyPlayed,
      _keyThemeMode,
    ];

    bool success = true;
    for (final key in keys) {
      success = success && await remove(key);
    }
    return success;
  }
}

