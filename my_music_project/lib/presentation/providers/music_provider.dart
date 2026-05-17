import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/music_repository.dart';
import '../../data/services/music_query_service.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/usecases/load_songs_usecase.dart';
import 'audio_provider.dart';

class MusicState {
  final List<Song> songs;
  final bool isLoading;
  final String? errorMessage;

  const MusicState({
    this.songs = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  MusicState copyWith({
    List<Song>? songs,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MusicState(
      songs: songs ?? this.songs,
      isLoading: isLoading ?? this.isLoading,
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
      final songs = await _loadSongsUseCase();
      await _audioNotifier.setPlaylist(songs);
      state = state.copyWith(songs: songs, isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load songs: $e',
      );
    }
  }
}

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl(MusicQueryService());
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
