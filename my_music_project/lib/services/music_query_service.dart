import 'package:flutter/foundation.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
import '../models/song_model.dart';

class MusicQueryService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<SongModel>> loadSongs() async {
    try {
      final songs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );

      return songs
          .map((song) => SongModel(
                id: song.id.toString(),
                title: song.title,
                path: song.data,
                duration: song.duration ?? 0,
              ))
          .toList();
    } catch (e) {
      debugPrint('Error loading songs: $e');
      return [];
    }
  }
}