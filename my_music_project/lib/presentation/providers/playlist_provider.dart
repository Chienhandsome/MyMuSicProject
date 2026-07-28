import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/app_providers.dart';
import '../../domain/entities/playlist.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/playback_usecases.dart';
import '../../domain/usecases/playlist_usecases.dart';
import 'music_provider.dart';

class PlaylistState {
  final List<Playlist> playlists;
  final String? currentPlaylistId;
  final bool isLoading;
  final String? errorMessage;

  const PlaylistState({
    this.playlists = const [],
    this.currentPlaylistId,
    this.isLoading = false,
    this.errorMessage,
  });

  PlaylistState copyWith({
    List<Playlist>? playlists,
    String? currentPlaylistId,
    bool? isLoading,
    String? errorMessage,
    bool clearPlaylistId = false,
    bool clearError = false,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      currentPlaylistId:
          clearPlaylistId ? null : (currentPlaylistId ?? this.currentPlaylistId),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  Playlist? get currentPlaylist {
    if (currentPlaylistId == null) return null;
    try {
      return playlists.firstWhere((p) => p.id == currentPlaylistId);
    } catch (_) {
      return null;
    }
  }
}

class PlaylistNotifier extends StateNotifier<PlaylistState> {
  final PlaylistUseCases _playlistUseCases;
  final PlaybackUseCases _playbackUseCases;
  final List<Song> Function() _getAllSongs;

  PlaylistNotifier(
    this._playlistUseCases,
    this._playbackUseCases,
    this._getAllSongs,
  ) : super(const PlaylistState());

  Future<void> loadPlaylists() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final playlists = await _playlistUseCases.loadPlaylists();
      final currentId = await _playlistUseCases.getCurrentPlaylistId();
      state = state.copyWith(
        playlists: playlists,
        currentPlaylistId: currentId,
        isLoading: false,
        clearError: true,
        clearPlaylistId: currentId == null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load playlists: $e',
      );
    }
  }

  Future<void> createPlaylist(String name) async {
    try {
      final playlist = await _playlistUseCases.createPlaylist(name);
      state = state.copyWith(
        playlists: [...state.playlists, playlist],
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to create playlist: $e');
    }
  }

  Future<void> deletePlaylist(String id) async {
    try {
      await _playlistUseCases.deletePlaylist(id);
      final updatedPlaylists =
          state.playlists.where((p) => p.id != id).toList();

      final clearCurrent = state.currentPlaylistId == id;
      if (clearCurrent) {
        await _playlistUseCases.setCurrentPlaylistId(null);
      }

      state = state.copyWith(
        playlists: updatedPlaylists,
        clearPlaylistId: clearCurrent,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete playlist: $e');
    }
  }

  Future<void> addSongToPlaylist(String playlistId, String songPath) async {
    try {
      await _playlistUseCases.addSongToPlaylist(playlistId, songPath);
      await _refreshPlaylist(playlistId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to add song: $e');
    }
  }

  Future<void> removeSongFromPlaylist(
      String playlistId, String songPath) async {
    try {
      await _playlistUseCases.removeSongFromPlaylist(playlistId, songPath);
      await _refreshPlaylist(playlistId);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to remove song: $e');
    }
  }

  Future<void> selectPlaylist(String playlistId) async {
    await _playlistUseCases.setCurrentPlaylistId(playlistId);
    state = state.copyWith(currentPlaylistId: playlistId);
    await _syncAudioPlaylist();
  }

  Future<void> clearSelection() async {
    await _playlistUseCases.setCurrentPlaylistId(null);
    state = state.copyWith(clearPlaylistId: true);
    await _syncAudioPlaylist();
  }

  /// Lọc songs theo playlist hiện tại
  List<Song> filterSongs(List<Song> allSongs) {
    final playlist = state.currentPlaylist;
    if (playlist == null) return allSongs;
    return _playlistUseCases.filterSongsByPlaylist(playlist, allSongs);
  }

  /// Đồng bộ audio player playlist với playlist đang chọn
  Future<void> _syncAudioPlaylist() async {
    final allSongs = _getAllSongs();
    final filtered = filterSongs(allSongs);
    await _playbackUseCases.setPlaylist(filtered);
  }

  Future<void> _refreshPlaylist(String playlistId) async {
    final updated = await _playlistUseCases.getPlaylistById(playlistId);
    if (updated == null) return;

    final playlists = state.playlists.map((p) {
      return p.id == playlistId ? updated : p;
    }).toList();

    state = state.copyWith(playlists: playlists);
  }
}

final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  return PlaylistNotifier(
    ref.watch(playlistUseCasesProvider),
    ref.watch(playbackUseCasesProvider),
    () => ref.read(musicProvider).songs,
  );
});
