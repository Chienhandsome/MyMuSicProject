import 'package:flutter/foundation.dart';

import '../../core/constants/songs_box_keys.dart';
import '../models/song_model.dart';
import 'hive_storage_service.dart';

class SongCacheService {
  Future<List<SongModel>> getCachedSongs() async {
    final rawSongs = HiveStorageService.songsBox.get(SongsBoxKeys.cachedSongs);
    if (rawSongs is! List) {
      return [];
    }

    final songs = <SongModel>[];
    for (final rawSong in rawSongs) {
      try {
        if (rawSong is Map) {
          songs.add(SongModel.fromMap(rawSong));
        }
      } catch (error) {
        debugPrint('Skipping invalid cached song: $error');
      }
    }

    return songs;
  }

  Future<void> saveSongs(List<SongModel> songs) async {
    final payload = songs.map((song) => song.toMap()).toList();
    await HiveStorageService.songsBox.put(SongsBoxKeys.cachedSongs, payload);
  }

  Future<int?> getLastScanAt() async {
    final value = HiveStorageService.songsBox.get(SongsBoxKeys.lastScanAt);
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<void> setLastScanAt(int value) async {
    await HiveStorageService.songsBox.put(SongsBoxKeys.lastScanAt, value);
  }
}
