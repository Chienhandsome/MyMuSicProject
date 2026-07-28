import '../entities/playlist.dart';

abstract class PlaylistRepository {
  Future<List<Playlist>> getPlaylists();

  Future<Playlist?> getPlaylistById(String id);

  Future<Playlist> createPlaylist(String name);

  Future<void> deletePlaylist(String id);

  Future<void> addSong(String playlistId, String songPath);

  Future<void> removeSong(String playlistId, String songPath);

  Future<void> updateSongPaths(String playlistId, List<String> paths);

  Future<String?> getCurrentPlaylistId();

  Future<void> setCurrentPlaylistId(String? id);

  Future<void> initDefaultPlaylists();
}
