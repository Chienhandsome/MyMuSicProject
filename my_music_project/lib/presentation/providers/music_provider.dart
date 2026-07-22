import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/app_providers.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/load_songs_usecase.dart';

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

  MusicNotifier(this._loadSongsUseCase) : super(const MusicState());

  Future<void> loadSongs() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await for (final progress in _loadSongsUseCase.loadLibrary()) {
        state = state.copyWith(
          songs: progress.songs,
          isLoading: progress.isScanning && progress.songs.isEmpty,
          isScanning: progress.isScanning,
          lastScanAt: progress.lastScanAt,
          clearError: true,
        );
      }
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
      final updatedSongs =
          await _loadSongsUseCase.deleteSong(song, state.songs);
      state = state.copyWith(songs: updatedSongs, clearError: true);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to delete song: $e');
      rethrow;
    }
  }
}

final musicProvider = StateNotifierProvider<MusicNotifier, MusicState>((ref) {
  return MusicNotifier(
    ref.watch(loadSongsUseCaseProvider),
  );
});
