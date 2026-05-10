import 'package:shared_preferences/shared_preferences.dart';

/// Helper class for managing SharedPreferences operations
/// Provides type-safe methods for storing and retrieving data
///
enum RepeatMode {
  repeat,
  sequential,
  shuffle,
}

enum UIMode {
  light,
  dark,
}


class SharedPreferencesService {
  static SharedPreferences? _prefs;

  ///is repeat - bool
  final String _isRepeat = 'isRepeat';

  ///repeat mode - enum
  final String _repeatMode = 'repeatMode';

  ///mini player last played song
  final String _lastPlayedSong = 'lastPlayedSong';

  ///UI mode
  final String _uiMode = 'uiMode';

  final String _lastPlayedSongPath = 'lastPlayedSongPath';

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance (throws if not initialized)
  static SharedPreferences get instance {
    if (_prefs == null) {
      throw Exception(
        'SharedPreferencesService not initialized. Call init() first.',
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
}
