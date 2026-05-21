import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/media_keys.dart';
import '../../data/repositories/audio_repository.dart';
import '../../data/services/audio_player_service.dart';
import '../../data/services/song_cache_service.dart';
import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';
import 'play_config_provider.dart';
import 'preferences_provider.dart';

class AudioState {
  final Song? currentSong;
  final int currentIndex;
  final bool isPlaying;
  final PlayMode playMode;
  final bool isContinuePlay;
  final DateTime? sleepTimerEnd;

  const AudioState({
    this.currentSong,
    this.currentIndex = -1,
    this.isPlaying = false,
    this.playMode = PlayMode.sequential,
    this.isContinuePlay = false,
    this.sleepTimerEnd,
  });

  AudioState copyWith({
    Song? currentSong,
    int? currentIndex,
    bool? isPlaying,
    PlayMode? playMode,
    bool? isContinuePlay,
    DateTime? sleepTimerEnd,
    bool clearSleepTimer = false,
  }) {
    return AudioState(
      currentSong: currentSong ?? this.currentSong,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playMode: playMode ?? this.playMode,
      isContinuePlay: isContinuePlay ?? this.isContinuePlay,
      sleepTimerEnd:
          clearSleepTimer ? null : (sleepTimerEnd ?? this.sleepTimerEnd),
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioRepository _repository;
  late final StreamSubscription<Song?> _currentSongSubscription;
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  Timer? _sleepTimer;

  AudioNotifier(AudioRepository repository)
      : _repository = repository,
        super(AudioState(
          playMode: repository.playMode,
          isContinuePlay: repository.continuePlay,
        )) {
    _playerStateSubscription =
        _repository.audioPlayer.playerStateStream.listen((playerState) {
      state = state.copyWith(isPlaying: playerState.playing);
    });
    _currentSongSubscription = _repository.currentSongStream.listen((song) {
      state = state.copyWith(
        currentSong: song,
        currentIndex: _repository.currentIndex,
      );
    });
  }

  AudioPlayer get audioPlayer => _repository.audioPlayer;

  Future<void> setPlaylist(List<Song> songs) async {
    await _repository.setPlaylist(songs);
    state = state.copyWith(
      currentSong: _repository.currentSong,
      currentIndex: _repository.currentIndex,
    );
  }

  Future<void> playSongAt(int index) async {
    await _repository.playSongAt(index);
    state = state.copyWith(
      currentSong: _repository.currentSong,
      currentIndex: _repository.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> play() async {
    await _repository.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    await _repository.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop() async {
    await _repository.stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> playNext() async {
    await _repository.playNext();
    state = state.copyWith(
      currentSong: _repository.currentSong,
      currentIndex: _repository.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> playPrevious() async {
    await _repository.playPrevious();
    state = state.copyWith(
      currentSong: _repository.currentSong,
      currentIndex: _repository.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> seek(Duration position) async {
    await _repository.seek(position);
  }

  Future<void> togglePlayMode() async {
    const modes = PlayMode.values;
    final next = modes[(modes.indexOf(state.playMode) + 1) % modes.length];
    await _repository.setPlayMode(next);
    state = state.copyWith(playMode: next);
  }

  String getPlayModeKey() {
    switch (state.playMode) {
      case PlayMode.repeat:
        return MediaKeys.repeatMode;
      case PlayMode.sequential:
        return MediaKeys.sequentialMode;
      case PlayMode.shuffle:
        return MediaKeys.shuffleMode;
    }
  }

  Future<void> toggleContinuePlay() async {
    final next = !state.isContinuePlay;
    await _repository.setContinuePlay(next);
    state = state.copyWith(isContinuePlay: next);
  }

  Future<void> toggleCurrentSongFavorite() async {
    final song = state.currentSong;
    if (song == null) return;

    await _repository.toggleFavorite(song);
    state = state.copyWith(currentSong: _repository.currentSong);
  }

  void startSleepTimer(BuildContext context, Duration duration) {
    _sleepTimer?.cancel();
    final endTime = DateTime.now().add(duration);
    state = state.copyWith(sleepTimerEnd: endTime);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đã đặt hẹn giờ: ${duration.inMinutes} phút'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A2A3D),
        duration: const Duration(seconds: 2),
      ),
    );

    _sleepTimer = Timer(duration, () async {
      await pause();
      state = state.copyWith(clearSleepTimer: true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tắt nhạc theo hẹn giờ'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color(0xFF2A2A3D),
          ),
        );
      }
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    state = state.copyWith(clearSleepTimer: true);
  }

  Future<void> setSpeed(double speed) async {
    await _repository.setSpeed(speed);
  }

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _playerStateSubscription.cancel();
    _currentSongSubscription.cancel();
    _repository.dispose();
    super.dispose();
  }
}

final audioServiceProvider = Provider<AudioPlayerService>((ref) {
  return audioPlayerHandler;
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  return AudioRepositoryImpl(
    ref.watch(audioServiceProvider),
    ref.watch(preferencesRepositoryProvider),
    ref.watch(playConfigRepositoryProvider),
    SongCacheService(),
  );
});

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  final repository = ref.watch(audioRepositoryProvider);
  return AudioNotifier(repository);
});
