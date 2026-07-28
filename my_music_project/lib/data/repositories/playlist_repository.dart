import '../../domain/entities/playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../models/playlist_record.dart';
import '../services/playlist_cache_service.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistCacheService _playlistCacheService;

  PlaylistRepositoryImpl(this._playlistCacheService);

  @override
  Future<List<Playlist>> getPlaylists() async {
    final records = await _playlistCacheService.getPlaylists();
    return records.map(_recordToPlaylist).toList();
  }

  @override
  Future<Playlist?> getPlaylistById(String id) async {
    final record = await _playlistCacheService.getPlaylistById(id);
    if (record == null) return null;
    return _recordToPlaylist(record);
  }

  @override
  Future<Playlist> createPlaylist(String name) async {
    final record = await _playlistCacheService.createPlaylist(name);
    return _recordToPlaylist(record);
  }

  @override
  Future<void> deletePlaylist(String id) {
    return _playlistCacheService.deletePlaylist(id);
  }

  @override
  Future<void> addSong(String playlistId, String songPath) {
    return _playlistCacheService.addSongToPlaylist(playlistId, songPath);
  }

  @override
  Future<void> removeSong(String playlistId, String songPath) {
    return _playlistCacheService.removeSongFromPlaylist(playlistId, songPath);
  }

  @override
  Future<void> updateSongPaths(String playlistId, List<String> paths) {
    return _playlistCacheService.updateSongPaths(playlistId, paths);
  }

  @override
  Future<String?> getCurrentPlaylistId() {
    return _playlistCacheService.getCurrentPlaylistId();
  }

  @override
  Future<void> setCurrentPlaylistId(String? id) {
    return _playlistCacheService.setCurrentPlaylistId(id);
  }

  @override
  Future<void> initDefaultPlaylists() {
    return _playlistCacheService.initDefaultPlaylists();
  }

  Playlist _recordToPlaylist(PlaylistRecord record) {
    return Playlist(
      id: record.id,
      name: record.name,
      songPaths: record.songPaths,
      isDefault: record.isDefault,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
    );
  }
}
