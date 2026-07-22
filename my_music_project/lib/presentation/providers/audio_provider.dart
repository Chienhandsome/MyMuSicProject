import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/media_keys.dart';
import '../../di/app_providers.dart';
import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';
import '../../domain/usecases/playback_usecases.dart';

class AudioState {
  final Song? currentSong;
  final int currentIndex;
  final bool isPlaying;
  final PlayMode playMode;
  final bool isContinuePlay;
  final DateTime? sleepTimerEnd;
  final int sleepTimerCompletionId;

  const AudioState({
    this.currentSong,
    this.currentIndex = -1,
    this.isPlaying = false,
    this.playMode = PlayMode.sequential,
    this.isContinuePlay = false,
    this.sleepTimerEnd,
    this.sleepTimerCompletionId = 0,
  });

  AudioState copyWith({
    Song? currentSong,
    int? currentIndex,
    bool? isPlaying,
    PlayMode? playMode,
    bool? isContinuePlay,
    DateTime? sleepTimerEnd,
    int? sleepTimerCompletionId,
    bool clearCurrentSong = false,
    bool clearSleepTimer = false,
  }) {
    return AudioState(
      currentSong: clearCurrentSong ? null : (currentSong ?? this.currentSong),
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playMode: playMode ?? this.playMode,
      isContinuePlay: isContinuePlay ?? this.isContinuePlay,
      sleepTimerEnd:
          clearSleepTimer ? null : (sleepTimerEnd ?? this.sleepTimerEnd),
      sleepTimerCompletionId:
          sleepTimerCompletionId ?? this.sleepTimerCompletionId,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final PlaybackUseCases _playbackUseCases;
  late final StreamSubscription<Song?> _currentSongSubscription;
  late final StreamSubscription<bool> _playingSubscription;
  Timer? _sleepTimer;

  AudioNotifier(PlaybackUseCases playbackUseCases)
      : _playbackUseCases = playbackUseCases,
        super(AudioState(
          currentSong: playbackUseCases.currentSong,
          currentIndex: playbackUseCases.currentIndex,
          playMode: playbackUseCases.playMode,
          isContinuePlay: playbackUseCases.continuePlay,
        )) {
    _playingSubscription = _playbackUseCases.playingStream.listen((isPlaying) {
      state = state.copyWith(isPlaying: isPlaying);
    });
    _currentSongSubscription =
        _playbackUseCases.currentSongStream.listen((song) {
      state = state.copyWith(
        currentSong: song,
        currentIndex: _playbackUseCases.currentIndex,
      );
    });
  }

  double get speed => _playbackUseCases.speed;

  Future<void> setPlaylist(List<Song> songs) async {
    await _playbackUseCases.setPlaylist(songs);
    state = state.copyWith(
      currentSong: _playbackUseCases.currentSong,
      currentIndex: _playbackUseCases.currentIndex,
      clearCurrentSong: _playbackUseCases.currentSong == null,
    );
  }

  Future<void> playSongAt(int index) async {
    await _playbackUseCases.playSongAt(index);
    state = state.copyWith(
      currentSong: _playbackUseCases.currentSong,
      currentIndex: _playbackUseCases.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> play() async {
    await _playbackUseCases.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    await _playbackUseCases.pause();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> stop() async {
    await _playbackUseCases.stop();
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
    await _playbackUseCases.playNext();
    state = state.copyWith(
      currentSong: _playbackUseCases.currentSong,
      currentIndex: _playbackUseCases.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> playPrevious() async {
    await _playbackUseCases.playPrevious();
    state = state.copyWith(
      currentSong: _playbackUseCases.currentSong,
      currentIndex: _playbackUseCases.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> seek(Duration position) => _playbackUseCases.seek(position);

  Future<void> togglePlayMode() async {
    const modes = PlayMode.values;
    final next = modes[(modes.indexOf(state.playMode) + 1) % modes.length];
    await _playbackUseCases.setPlayMode(next);
    state = state.copyWith(playMode: next);
  }

  String getPlayModeKey() {
    return switch (state.playMode) {
      PlayMode.repeat => MediaKeys.repeatMode,
      PlayMode.sequential => MediaKeys.sequentialMode,
      PlayMode.shuffle => MediaKeys.shuffleMode,
    };
  }

  Future<void> toggleContinuePlay() async {
    final next = !state.isContinuePlay;
    await _playbackUseCases.setContinuePlay(next);
    state = state.copyWith(isContinuePlay: next);
  }

  Future<void> toggleCurrentSongFavorite() async {
    final song = state.currentSong;
    if (song == null) return;
    await _playbackUseCases.toggleFavorite(song);
    state = state.copyWith(currentSong: _playbackUseCases.currentSong);
  }

  void startSleepTimer(Duration duration) {
    _sleepTimer?.cancel();
    state = state.copyWith(sleepTimerEnd: DateTime.now().add(duration));
    _sleepTimer = Timer(duration, () async {
      await pause();
      state = state.copyWith(
        clearSleepTimer: true,
        sleepTimerCompletionId: state.sleepTimerCompletionId + 1,
      );
    });
  }

  void cancelSleepTimer() {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    state = state.copyWith(clearSleepTimer: true);
  }

  Future<void> setSpeed(double speed) => _playbackUseCases.setSpeed(speed);

  @override
  void dispose() {
    _sleepTimer?.cancel();
    _playingSubscription.cancel();
    _currentSongSubscription.cancel();
    super.dispose();
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(ref.watch(playbackUseCasesProvider));
});

final playingProvider = StreamProvider<bool>((ref) {
  return ref.watch(playbackUseCasesProvider).playingStream;
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(playbackUseCasesProvider).positionStream;
});
