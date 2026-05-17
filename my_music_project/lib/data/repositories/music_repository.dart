import '../../domain/entities/song.dart';
import '../../domain/repositories/music_repository.dart';
import '../services/music_query_service.dart';

/// Implementation of MusicRepository
class MusicRepositoryImpl implements MusicRepository {
  final MusicQueryService _musicQueryService;

  MusicRepositoryImpl(this._musicQueryService);

  @override
  Future<List<Song>> loadSongs() async {
    return await _musicQueryService.loadSongs();
  }

  @override
  Future<List<Song>> searchSongs(String query) async {
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
