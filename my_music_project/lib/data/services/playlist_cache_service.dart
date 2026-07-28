import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/cached_song_record.dart';
import '../models/playlist_record.dart';
import 'isar_storage_service.dart';

class PlaylistCacheService {
  static const String _currentPlaylistKey = 'current_playlist';
  static const String _favoritesPlaylistId = 'favorites';
  static const _uuid = Uuid();

  String get favoritesPlaylistId => _favoritesPlaylistId;

  Future<List<PlaylistRecord>> getPlaylists() async {
    return IsarStorageService.instance.playlistRecords
        .where()
        .sortByCreatedAt()
        .findAll();
  }

  Future<PlaylistRecord?> getPlaylistById(String id) async {
    return IsarStorageService.instance.playlistRecords
        .filter()
        .idEqualTo(id)
        .findFirst();
  }

  Future<PlaylistRecord> createPlaylist(String name) async {
    final isar = IsarStorageService.instance;
    final record = PlaylistRecord()
      ..id = _uuid.v4()
      ..name = name
      ..songPaths = []
      ..createdAt = DateTime.now().millisecondsSinceEpoch
      ..isDefault = false;

    await isar.writeTxn(() async {
      await isar.playlistRecords.put(record);
    });

    return record;
  }

  Future<void> deletePlaylist(String id) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      await isar.playlistRecords.filter().idEqualTo(id).deleteFirst();
    });
  }

  Future<void> addSongToPlaylist(String playlistId, String songPath) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await isar.playlistRecords
          .filter()
          .idEqualTo(playlistId)
          .findFirst();
      if (record == null || record.isDefault) return;

      if (!record.songPaths.contains(songPath)) {
        record.songPaths = [...record.songPaths, songPath];
        record.updatedAt = DateTime.now().millisecondsSinceEpoch;
        await isar.playlistRecords.put(record);
      }
    });
  }

  Future<void> removeSongFromPlaylist(
      String playlistId, String songPath) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await isar.playlistRecords
          .filter()
          .idEqualTo(playlistId)
          .findFirst();
      if (record == null || record.isDefault) return;

      record.songPaths =
          record.songPaths.where((p) => p != songPath).toList();
      record.updatedAt = DateTime.now().millisecondsSinceEpoch;
      await isar.playlistRecords.put(record);
    });
  }

  Future<void> updateSongPaths(String playlistId, List<String> paths) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await isar.playlistRecords
          .filter()
          .idEqualTo(playlistId)
          .findFirst();
      if (record == null) return;

      record.songPaths = paths;
      record.updatedAt = DateTime.now().millisecondsSinceEpoch;
      await isar.playlistRecords.put(record);
    });
  }

  Future<String?> getCurrentPlaylistId() async {
    final record = await IsarStorageService.instance.appSettingRecords
        .filter()
        .keyEqualTo(_currentPlaylistKey)
        .findFirst();
    return record?.stringValue;
  }

  Future<void> setCurrentPlaylistId(String? playlistId) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final existing = await isar.appSettingRecords
          .filter()
          .keyEqualTo(_currentPlaylistKey)
          .findFirst();
      final record = existing ?? AppSettingRecord();
      record
        ..key = _currentPlaylistKey
        ..stringValue = playlistId;
      await isar.appSettingRecords.put(record);
    });
  }

  Future<void> initDefaultPlaylists() async {
    final isar = IsarStorageService.instance;
    final existing = await isar.playlistRecords
        .filter()
        .idEqualTo(_favoritesPlaylistId)
        .findFirst();

    if (existing != null) {
      // Đảm bảo songPaths luôn rỗng cho playlist mặc định
      if (existing.songPaths.isNotEmpty) {
        await isar.writeTxn(() async {
          existing.songPaths = [];
          await isar.playlistRecords.put(existing);
        });
      }
      return;
    }

    await isar.writeTxn(() async {
      final record = PlaylistRecord()
        ..id = _favoritesPlaylistId
        ..name = 'Yêu thích'
        ..songPaths = []
        ..createdAt = DateTime.now().millisecondsSinceEpoch
        ..isDefault = true;
      await isar.playlistRecords.put(record);
    });
  }
}
