import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';

typedef PlaybackCallback = Future<void> Function();

late final AudioPlayerService audioPlayerHandler;

Future<AudioPlayerService> initAudioPlayerHandler() async {
  final handler = await AudioService.init(
    builder: AudioPlayerService.new,
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.my_music_project.audio',
      androidNotificationChannelName: 'My Music Project',
      androidNotificationChannelDescription: 'Music playback controls',
      androidNotificationIcon: 'drawable/ic_stat_music_note',
      androidNotificationOngoing: true,
    ),
  );

  audioPlayerHandler = handler;
  return audioPlayerHandler;
}

class AudioPlayerService extends BaseAudioHandler with SeekHandler {
  static const MediaControl _closeControl = MediaControl(
    androidIcon: 'drawable/ic_notification_close',
    label: 'Close',
    action: MediaAction.stop,
  );

  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;
  PlaybackCallback? _onSkipToNext;
  PlaybackCallback? _onSkipToPrevious;

  AudioPlayer get audioPlayer => _audioPlayer;

  AudioPlayerService() {
    playbackState.add(_transformEvent(_audioPlayer.playbackEvent));
    _playbackEventSubscription = _audioPlayer.playbackEventStream.listen(
      (event) => playbackState.add(_transformEvent(event)),
    );
  }

  void setNotificationCallbacks({
    required PlaybackCallback onSkipToNext,
    required PlaybackCallback onSkipToPrevious,
  }) {
    _onSkipToNext = onSkipToNext;
    _onSkipToPrevious = onSkipToPrevious;
  }

  Future<void> setPlaylist(
    List<Song> songs, {
    int initialIndex = 0,
  }) async {
    queue.add(songs.map(_songToMediaItem).toList());

    if (songs.isEmpty) {
      mediaItem.add(null);
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));
      return;
    }

    try {
      final safeInitialIndex = initialIndex.clamp(0, songs.length - 1).toInt();
      mediaItem.add(_songToMediaItem(songs[safeInitialIndex]));
      await _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(
          children: songs.map(_songToAudioSource).toList(),
        ),
        initialIndex: safeInitialIndex,
      );
    } catch (e) {
      debugPrint('Error setting audio playlist: $e');
      rethrow;
    }
  }

  Future<void> setCurrentSong(Song song) async {
    mediaItem.add(_songToMediaItem(song));
  }

  Future<void> setPlayMode(
    PlayMode mode, {
    required bool continuePlay,
  }) async {
    if (!continuePlay) {
      await _audioPlayer.setShuffleModeEnabled(mode == PlayMode.shuffle);
      await _audioPlayer.setLoopMode(LoopMode.off);
      return;
    }

    switch (mode) {
      case PlayMode.repeat:
        await _audioPlayer.setShuffleModeEnabled(false);
        await _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case PlayMode.shuffle:
        await _audioPlayer.setShuffleModeEnabled(true);
        await _audioPlayer.setLoopMode(LoopMode.all);
        break;
      case PlayMode.sequential:
        await _audioPlayer.setShuffleModeEnabled(false);
        await _audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  Future<void> seekToIndex(int index) async {
    await _audioPlayer.seek(Duration.zero, index: index);
  }

  Future<void> seekToNext() async {
    await _audioPlayer.seekToNext();
  }

  Future<void> seekToPrevious() async {
    await _audioPlayer.seekToPrevious();
  }

  AudioSource _songToAudioSource(Song song) {
    final item = _songToMediaItem(song);
    return AudioSource.uri(
      Uri.file(song.path),
      tag: item,
    );
  }

  MediaItem _songToMediaItem(Song song) {
    return MediaItem(
      id: song.path,
      title: song.title,
      artist: song.artist,
      duration: Duration(milliseconds: song.duration),
    );
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
        _closeControl,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekBackward,
        MediaAction.seekForward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_audioPlayer.processingState] ??
          AudioProcessingState.idle,
      playing: _audioPlayer.playing,
      updatePosition: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
      queueIndex: event.currentIndex,
    );
  }

  @override
  Future<void> play() async {
    await _audioPlayer.play();
  }

  @override
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    await _audioPlayer.stop();
    return super.stop();
  }

  @override
  Future<void> skipToNext() async {
    await _onSkipToNext?.call();
  }

  @override
  Future<void> skipToPrevious() async {
    await _onSkipToPrevious?.call();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  void dispose() {
    _playbackEventSubscription?.cancel();
    _audioPlayer.dispose();
  }
}
