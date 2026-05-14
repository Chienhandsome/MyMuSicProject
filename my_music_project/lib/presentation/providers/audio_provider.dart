import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../core/constants/media_keys.dart';
import '../../data/models/song_model.dart';
import '../../data/services/audio_player_service.dart';

class AudioState {
  final SongModel? currentSong;
  final int currentIndex;
  final bool isPlaying;
  final PlayMode playMode;
  final bool isContinuePlay;

  const AudioState({
    this.currentSong,
    this.currentIndex = -1,
    this.isPlaying = false,
    this.playMode = PlayMode.sequential,
    this.isContinuePlay = false,
  });

  AudioState copyWith({
    SongModel? currentSong,
    int? currentIndex,
    bool? isPlaying,
    PlayMode? playMode,
    bool? isContinuePlay,
  }) {
    return AudioState(
      currentSong: currentSong ?? this.currentSong,
      currentIndex: currentIndex ?? this.currentIndex,
      isPlaying: isPlaying ?? this.isPlaying,
      playMode: playMode ?? this.playMode,
      isContinuePlay: isContinuePlay ?? this.isContinuePlay,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  final AudioPlayerService _service;

  AudioNotifier(this._service) : super(const AudioState()) {
    _service.audioPlayer.playerStateStream.listen((playerState) {
      state = state.copyWith(isPlaying: playerState.playing);
    });
  }

  AudioPlayer get audioPlayer => _service.audioPlayer;

  Future<void> setPlaylist(List<SongModel> songs) async {
    await _service.setPlaylist(songs);
    state = state.copyWith(
      currentSong: _service.currentSong,
      currentIndex: _service.currentIndex,
    );
  }

  Future<void> playSongAt(int index) async {
    await _service.playSongAt(index);
    state = state.copyWith(
      currentSong: _service.currentSong,
      currentIndex: _service.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> play() async {
    await _service.play();
    state = state.copyWith(isPlaying: true);
  }

  Future<void> pause() async {
    await _service.pause();
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
    await _service.playNext();
    state = state.copyWith(
      currentSong: _service.currentSong,
      currentIndex: _service.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> playPrevious() async {
    await _service.playPrevious();
    state = state.copyWith(
      currentSong: _service.currentSong,
      currentIndex: _service.currentIndex,
      isPlaying: true,
    );
  }

  Future<void> seek(Duration position) async {
    await _service.seek(position);
  }

  void togglePlayMode() {
    const modes = PlayMode.values;
    final next = modes[(modes.indexOf(state.playMode) + 1) % modes.length];
    _service.setPlayMode(next);
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

  void toggleContinuePlay() {
    final next = !state.isContinuePlay;
    _service.setContinuePlay(next);
    state = state.copyWith(isContinuePlay: next);
  }

  void startSleepTimer(BuildContext context, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã đặt hẹn giờ: ${duration.inMinutes} phút')),
    );
    Future.delayed(duration, () async {
      await pause();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tắt nhạc theo hẹn giờ')),
        );
      }
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}

final audioServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  final service = ref.watch(audioServiceProvider);
  return AudioNotifier(service);
});
