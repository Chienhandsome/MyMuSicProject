import '../../domain/entities/song.dart';
import '../../domain/repositories/music_repository.dart';
import '../models/song_model.dart';
import '../services/music_query_service.dart';
import '../services/song_cache_service.dart';

/// Implementation of MusicRepository
class MusicRepositoryImpl implements MusicRepository {
  final MusicQueryService _musicQueryService;
  final SongCacheService _songCacheService;

  MusicRepositoryImpl(this._musicQueryService, this._songCacheService);

  @override
  Future<List<Song>> loadCachedSongs() async {
    return _songCacheService.getCachedSongs();
  }

  @override
  Future<List<Song>> scanDeviceSongs() async {
    final cachedSongs = await _songCacheService.getCachedSongs();
    final cachedByPath = {
      for (final song in cachedSongs)
        if (song.path.isNotEmpty) song.path: song,
    };

    final scannedSongs = await _musicQueryService.loadSongs();
    return scannedSongs.map((song) {
      final cachedSong = cachedByPath[song.path];
      if (cachedSong == null) {
        return song;
      }

      return SongModel(
        id: song.id,
        title: song.title,
        lyric: cachedSong.lyric,
        artist: song.artist,
        path: song.path,
        uri: song.uri,
        duration: song.duration,
        size: song.size,
        extension: song.extension,
        dateAddedMs: song.dateAddedMs,
        dateModifiedMs: song.dateModifiedMs,
        lastPlay: cachedSong.lastPlay,
        numberOfTimesPlayed: cachedSong.numberOfTimesPlayed,
      );
    }).toList();
  }

  @override
  Future<void> saveSongCache(List<Song> songs) async {
    final songModels = songs.map(SongModel.fromSong).toList();
    await _songCacheService.saveSongs(songModels);
    await _songCacheService.setLastScanAt(
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  Future<int?> getLastScanAt() {
    return _songCacheService.getLastScanAt();
  }

  @override
  Future<List<Song>> searchSongs(String query) async {
    final allSongs = await _songCacheService.getCachedSongs();

    if (query.isEmpty) {
      return allSongs;
    }

    final lowerQuery = query.toLowerCase();
    return allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
