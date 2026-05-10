import '../models/song_model.dart';
import '../services/music_query_service.dart';

/// Repository interface for music-related operations
abstract class MusicRepository {
  /// Load all songs from device storage
  Future<List<SongModel>> loadSongs();
  
  /// Get songs filtered by specific criteria
  Future<List<SongModel>> searchSongs(String query);
}

/// Implementation of MusicRepository
class MusicRepositoryImpl implements MusicRepository {
  final MusicQueryService _musicQueryService;

  MusicRepositoryImpl(this._musicQueryService);

  @override
  Future<List<SongModel>> loadSongs() async {
    return await _musicQueryService.loadSongs();
  }

  @override
  Future<List<SongModel>> searchSongs(String query) async {
    final allSongs = await _musicQueryService.loadSongs();
    
    if (query.isEmpty) {
      return allSongs;
    }

    final lowerQuery = query.toLowerCase();
    return allSongs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}