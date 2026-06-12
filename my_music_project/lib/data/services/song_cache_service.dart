import 'package:isar/isar.dart';

import '../../domain/entities/song.dart';
import '../models/cached_song_record.dart';
import '../models/song_model.dart';
import 'isar_storage_service.dart';

class SongCacheService {
  static const String _lastScanAtKey = 'last_scan_at';

  Future<List<SongModel>> getCachedSongs() async {
    final records = await IsarStorageService.instance.cachedSongRecords
        .where()
        .sortByTitle()
        .findAll();
    return records.map(_recordToSongModel).toList();
  }

  Future<void> saveSongs(List<SongModel> songs) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      await isar.cachedSongRecords.clear();
      await isar.cachedSongRecords.putAll(songs.map(_songModelToRecord).toList());
    });
  }

  Future<int?> getLastScanAt() async {
    final record = await IsarStorageService.instance.songCacheMetadataRecords
        .filter()
        .keyEqualTo(_lastScanAtKey)
        .findFirst();
    return record?.value;
  }

  Future<void> setLastScanAt(int value) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final existing = await isar.songCacheMetadataRecords
          .filter()
          .keyEqualTo(_lastScanAtKey)
          .findFirst();
      final record = existing ?? SongCacheMetadataRecord();
      record
        ..key = _lastScanAtKey
        ..value = value;
      await isar.songCacheMetadataRecords.put(record);
    });
  }

  Future<void> updatePlaybackStats({
    required Song song,
    required int lastPlay,
    required int numberOfTimesPlayed,
  }) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await isar.cachedSongRecords
          .filter()
          .pathEqualTo(song.path)
          .findFirst();

      final updatedRecord = record ?? _songToRecord(song);
      updatedRecord
        ..lastPlay = lastPlay
        ..numberOfTimesPlayed = numberOfTimesPlayed;

      await isar.cachedSongRecords.put(updatedRecord);
    });
  }

  Future<void> updateFavorite({
    required Song song,
    required bool isFavorite,
  }) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      final record = await isar.cachedSongRecords
          .filter()
          .pathEqualTo(song.path)
          .findFirst();

      final updatedRecord = record ?? _songToRecord(song);
      updatedRecord.isFavorite = isFavorite;

      await isar.cachedSongRecords.put(updatedRecord);
    });
  }

  Future<void> deleteSongByPath(String path) async {
    final isar = IsarStorageService.instance;
    await isar.writeTxn(() async {
      await isar.cachedSongRecords.deleteByPath(path);
    });
  }

  SongModel _recordToSongModel(CachedSongRecord record) {
    return SongModel(
      id: record.sourceId,
      title: record.title,
      lyric: record.lyric,
      artist: record.artist,
      path: record.path,
      uri: record.uri,
      duration: record.duration,
      size: record.size,
      extension: record.extension,
      dateAddedMs: record.dateAddedMs,
      dateModifiedMs: record.dateModifiedMs,
      lastPlay: record.lastPlay,
      numberOfTimesPlayed: record.numberOfTimesPlayed,
      isFavorite: record.isFavorite,
    );
  }

  CachedSongRecord _songModelToRecord(SongModel song) {
    return _songToRecord(song);
  }

  CachedSongRecord _songToRecord(Song song) {
    return CachedSongRecord()
      ..sourceId = song.id
      ..title = song.title
      ..lyric = song.lyric
      ..artist = song.artist
      ..path = song.path
      ..uri = song.uri
      ..duration = song.duration
      ..size = song.size
      ..extension = song.extension
      ..dateAddedMs = song.dateAddedMs
      ..dateModifiedMs = song.dateModifiedMs
      ..lastPlay = song.lastPlay
      ..numberOfTimesPlayed = song.numberOfTimesPlayed
      ..isFavorite = song.isFavorite
      ..schemaVersion = SongModel.currentSchemaVersion;
  }
}
