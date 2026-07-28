import '../entities/playlist.dart';
import '../entities/song.dart';
import '../repositories/playlist_repository.dart';

class PlaylistUseCases {
  final PlaylistRepository _playlistRepository;

  PlaylistUseCases(this._playlistRepository);

  Future<List<Playlist>> loadPlaylists() {
    return _playlistRepository.getPlaylists();
  }

  Future<Playlist?> getPlaylistById(String id) {
    return _playlistRepository.getPlaylistById(id);
  }

  Future<Playlist> createPlaylist(String name) {
    return _playlistRepository.createPlaylist(name);
  }

  Future<void> deletePlaylist(String id) {
    return _playlistRepository.deletePlaylist(id);
  }

  Future<void> addSongToPlaylist(String playlistId, String songPath) {
    return _playlistRepository.addSong(playlistId, songPath);
  }

  Future<void> removeSongFromPlaylist(String playlistId, String songPath) {
    return _playlistRepository.removeSong(playlistId, songPath);
  }

  Future<String?> getCurrentPlaylistId() {
    return _playlistRepository.getCurrentPlaylistId();
  }

  Future<void> setCurrentPlaylistId(String? id) {
    return _playlistRepository.setCurrentPlaylistId(id);
  }

  Future<void> initDefaultPlaylists() {
    return _playlistRepository.initDefaultPlaylists();
  }

  /// Lọc bài hát theo playlist.
  /// - Playlist "Yêu thích" (isDefault): filter theo isFavorite == true
  /// - Playlist thường: filter theo songPaths
  List<Song> filterSongsByPlaylist(Playlist playlist, List<Song> allSongs) {
    if (playlist.isDefault) {
      // Playlist "Yêu thích" → lọc dynamic theo isFavorite
      return allSongs.where((song) => song.isFavorite).toList();
    }

    final pathSet = playlist.songPaths.toSet();
    return allSongs.where((song) => pathSet.contains(song.path)).toList();
  }

  /// Reconcile playlists sau khi scan device:
  /// - Loại bỏ path không còn tồn tại
  /// - Thử match file bị rename bằng duration + size
  Future<void> reconcilePlaylists(
    List<Song> scannedSongs,
    List<Song> cachedSongs,
  ) async {
    final validPaths = scannedSongs.map((s) => s.path).toSet();
    final playlists = await _playlistRepository.getPlaylists();

    for (final playlist in playlists) {
      if (playlist.isDefault) continue;

      final originalPaths = playlist.songPaths;
      final updatedPaths = <String>[];
      var hasChanged = false;

      for (final path in originalPaths) {
        if (validPaths.contains(path)) {
          updatedPaths.add(path);
        } else {
          // Thử match file bị rename
          final newPath = _tryMatchRenamed(
            path,
            scannedSongs,
            cachedSongs,
            validPaths,
          );
          if (newPath != null) {
            updatedPaths.add(newPath);
          }
          hasChanged = true;
        }
      }

      if (hasChanged) {
        await _playlistRepository.updateSongPaths(playlist.id, updatedPaths);
      }
    }
  }

  /// Match file bị rename bằng duration + size.
  /// Tìm bài mới có cùng duration + size nhưng path không tồn tại trong cache cũ.
  String? _tryMatchRenamed(
    String oldPath,
    List<Song> scannedSongs,
    List<Song> cachedSongs,
    Set<String> validPaths,
  ) {
    final cachedSong = cachedSongs
        .cast<Song?>()
        .firstWhere((s) => s!.path == oldPath, orElse: () => null);
    if (cachedSong == null) return null;

    final cachedPathSet = cachedSongs.map((s) => s.path).toSet();

    // Tìm bài trong scannedSongs có cùng duration + size,
    // path mới (không có trong cache cũ) và vẫn valid
    for (final song in scannedSongs) {
      if (song.duration == cachedSong.duration &&
          song.size == cachedSong.size &&
          song.size != null &&
          !cachedPathSet.contains(song.path)) {
        return song.path;
      }
    }

    return null;
  }
}
