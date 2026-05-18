import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
import '../models/song_model.dart';

class MusicQueryService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  /// Android folders allowed to scan.
  static const List<String> allowedFoldersAndroid = [
    '/storage/emulated/0/Music',
    '/storage/emulated/0/Download',
  ];


  Future<List<SongModel>> loadSongs() async {
    try {
      // querySongs() runs via platform channel — already off the main thread.
      final songs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      // Yield one microtask so the framework can render a frame before
      // the synchronous filter+map runs on the main isolate.
      await Future.microtask(() {});

      //TODO: Handle IOS later
      const allowedFolders = allowedFoldersAndroid;

      return songs
          .where((song) {
            final path = song.data;
            if (path.isEmpty) return false;
            return allowedFolders.any((folder) => path.startsWith(folder));
          })
          .map((song) => SongModel(
                id: song.id,
                title: song.title,
                artist: song.artist,
                path: song.data,
                uri: song.uri,
                duration: song.duration ?? 0,
                size: song.size,
                extension: song.fileExtension,
                dateAddedMs: song.dateAdded,
                dateModifiedMs: song.dateModified,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error loading songs: $e');
      return [];
    }
  }
}
