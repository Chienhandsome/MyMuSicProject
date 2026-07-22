import 'package:just_audio/just_audio.dart';

import '../../domain/entities/play_mode.dart';
import '../../domain/entities/playback_event.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';
import '../services/audio_player_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayerService _audioService;

  AudioRepositoryImpl(this._audioService);

  @override
  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0}) {
    return _audioService.setPlaylist(songs, initialIndex: initialIndex);
  }

  @override
  Future<void> setCurrentSong(Song song) => _audioService.setCurrentSong(song);

  @override
  Future<void> seekToIndex(int index) => _audioService.seekToIndex(index);

  @override
  Future<void> seekToNext() => _audioService.seekToNext();

  @override
  Future<void> seekToPrevious() => _audioService.seekToPrevious();

  @override
  Future<void> play() => _audioService.play();

  @override
  Future<void> pause() => _audioService.pause();

  @override
  Future<void> stop() => _audioService.stop();

  @override
  Future<void> seek(Duration position) => _audioService.seek(position);

  @override
  Future<void> setSpeed(double speed) => _audioService.setSpeed(speed);

  @override
  Future<void> setPlayMode(
    PlayMode mode, {
    required bool continuePlay,
  }) {
    return _audioService.setPlayMode(mode, continuePlay: continuePlay);
  }

  @override
  void setNotificationCallbacks({
    required Future<void> Function() onSkipToNext,
    required Future<void> Function() onSkipToPrevious,
  }) {
    _audioService.setNotificationCallbacks(
      onSkipToNext: onSkipToNext,
      onSkipToPrevious: onSkipToPrevious,
    );
  }

  @override
  int? get currentIndex => _audioService.audioPlayer.currentIndex;

  @override
  bool get isPlaying => _audioService.audioPlayer.playing;

  @override
  Duration? get duration => _audioService.audioPlayer.duration;

  @override
  double get speed => _audioService.audioPlayer.speed;

  @override
  Stream<bool> get playingStream {
    return _audioService.audioPlayer.playerStateStream.map(
      (state) => state.playing,
    );
  }

  @override
  Stream<PlaybackProcessingState> get processingStateStream {
    return _audioService.audioPlayer.processingStateStream.map((state) {
      return switch (state) {
        ProcessingState.idle => PlaybackProcessingState.idle,
        ProcessingState.loading => PlaybackProcessingState.loading,
        ProcessingState.buffering => PlaybackProcessingState.buffering,
        ProcessingState.ready => PlaybackProcessingState.ready,
        ProcessingState.completed => PlaybackProcessingState.completed,
      };
    });
  }

  @override
  Stream<Duration> get positionStream {
    return _audioService.audioPlayer.positionStream;
  }

  @override
  Stream<int?> get currentIndexStream {
    return _audioService.audioPlayer.currentIndexStream;
  }

  @override
  Stream<PlaybackDiscontinuity> get discontinuityStream {
    return _audioService.audioPlayer.positionDiscontinuityStream.map((event) {
      return PlaybackDiscontinuity(
        isAutoAdvance: event.reason == PositionDiscontinuityReason.autoAdvance,
        previousIndex: event.previousEvent.currentIndex,
        currentIndex: event.event.currentIndex,
      );
    });
  }

  @override
  void dispose() => _audioService.dispose();
}
