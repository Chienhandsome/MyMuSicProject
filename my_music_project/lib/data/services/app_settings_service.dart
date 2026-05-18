import 'package:isar/isar.dart';

import '../models/cached_song_record.dart';
import 'isar_storage_service.dart';

class AppSettingsService {
  String? getString(String key) {
    return IsarStorageService.instance.appSettingRecords
        .filter()
        .keyEqualTo(key)
        .findFirstSync()
        ?.stringValue;
  }

  Future<void> setString(String key, String value) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await _getOrCreate(key);
      record
        ..stringValue = value
        ..boolValue = null
        ..intValue = null;
      await isar.appSettingRecords.put(record);
    });
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return IsarStorageService.instance.appSettingRecords
            .filter()
            .keyEqualTo(key)
            .findFirstSync()
            ?.boolValue ??
        defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await _getOrCreate(key);
      record
        ..stringValue = null
        ..boolValue = value
        ..intValue = null;
      await isar.appSettingRecords.put(record);
    });
  }

  int? getInt(String key) {
    return IsarStorageService.instance.appSettingRecords
        .filter()
        .keyEqualTo(key)
        .findFirstSync()
        ?.intValue;
  }

  Future<void> setInt(String key, int value) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await _getOrCreate(key);
      record
        ..stringValue = null
        ..boolValue = null
        ..intValue = value;
      await isar.appSettingRecords.put(record);
    });
  }

  Future<AppSettingRecord> _getOrCreate(String key) async {
    return await IsarStorageService.instance.appSettingRecords
            .filter()
            .keyEqualTo(key)
            .findFirst() ??
        (AppSettingRecord()..key = key);
  }
}
