import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/music_repository.dart';
import '../../data/services/music_file_service.dart';
import '../../data/services/music_query_service.dart';
import '../../data/services/song_cache_service.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/usecases/load_songs_usecase.dart';
import 'audio_provider.dart';

class MusicState {
  final List<Song> songs;
  final bool isLoading;
  final bool isScanning;
  final int? lastScanAt;
  final String? errorMessage;

  const MusicState({
    this.songs = const [],
    this.isLoading = false,
    this.isScanning = false,
    this.lastScanAt,
    this.errorMessage,
  });

  MusicState copyWith({
    List<Song>? songs,
    bool? isLoading,
    bool? isScanning,
    int? lastScanAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
      isScanning: isScanning ?? this.isScanning,
      lastScanAt: lastScanAt ?? this.lastScanAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MusicNotifier extends StateNotifier<MusicState> {
  final LoadSongsUseCase _loadSongsUseCase;
  final AudioNotifier _audioNotifier;

  MusicNotifier(this._loadSongsUseCase, this._audioNotifier)
      : super(const MusicState());

  Future<void> loadSongs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cachedSongs = await _loadSongsUseCase.loadCachedSongs();
      final lastScanAt = await _loadSongsUseCase.getLastScanAt();

      if (cachedSongs.isNotEmpty) {
        await _audioNotifier.setPlaylist(cachedSongs);
        state = state.copyWith(
          songs: cachedSongs,
          isLoading: false,
          isScanning: true,
          lastScanAt: lastScanAt,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          isLoading: true,
          isScanning: true,
          lastScanAt: lastScanAt,
          clearError: true,
        );
      }

      final scannedSongs = await _loadSongsUseCase.scanDeviceSongs();
      await _loadSongsUseCase.saveSongCache(scannedSongs);
      await _audioNotifier.setPlaylist(scannedSongs);
      state = state.copyWith(
        songs: scannedSongs,
        isLoading: false,
        isScanning: false,
        lastScanAt: DateTime.now().millisecondsSinceEpoch,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isScanning: false,
        errorMessage: 'Failed to load songs: $e',
      );
    }
  }

  Future<void> deleteSongFromDevice(Song song) async {
    state = state.copyWith(clearError: true);
    try {
      final isCurrentSong =
          _audioNotifier.state.currentSong?.path == song.path;
      if (isCurrentSong) {
        await _audioNotifier.stop();
      }

      await _loadSongsUseCase.deleteSongFromDevice(song);

      final updatedSongs = state.songs
          .where((currentSong) => currentSong.path != song.path)
          .toList();
      await _audioNotifier.setPlaylist(updatedSongs);
      state = state.copyWith(songs: updatedSongs, clearError: true);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete song: $e');
      rethrow;
    }
  }
}

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl(
    MusicQueryService(),
    SongCacheService(),
    MusicFileService(),
  );
});

final loadSongsUseCaseProvider = Provider<LoadSongsUseCase>((ref) {
  return LoadSongsUseCase(ref.watch(musicRepositoryProvider));
});

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier(
    ref.watch(loadSongsUseCaseProvider),
    ref.read(audioProvider.notifier),
  );
});
