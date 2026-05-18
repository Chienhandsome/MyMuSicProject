import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/play_config_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/audio_player_service.dart';
import '../services/song_cache_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayerService _audioService;
  final PreferencesRepository _preferencesRepository;
  final PlayConfigRepository _playConfigRepository;
  final SongCacheService _songCacheService;
  final Random _random = Random();
  final StreamController<Song?> _currentSongController =
      StreamController<Song?>.broadcast();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  List<Song> _playlist = [];
  int _currentIndex = -1;
  PlayMode _playMode = PlayMode.sequential;
  bool _isContinuePlay = false;

  AudioRepositoryImpl(
    this._audioService,
    this._preferencesRepository,
    this._playConfigRepository,
    this._songCacheService,
  ) {
    _playMode = _playConfigRepository.getPlayMode();
    _isContinuePlay = _playConfigRepository.getContinuePlay();

    _playerStateSubscription =
        _audioService.audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongComplete();
      }
    });
  }

  @override
  Future<void> setPlaylist(List<Song> songs) async {
    _playlist = songs;
    await _restoreLastSong();
  }

  @override
  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    await _audioService.setFilePath(song.path);
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    _currentSongController.add(currentSong);
    _startPlayback();
  }

  @override
  Future<void> play() async {
    if (currentSong == null) return;

    final song = currentSong!;
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    _startPlayback();
  }

  void _startPlayback() {
    unawaited(
      _audioService.play().catchError((Object error, StackTrace stackTrace) {
        debugPrint('Error starting audio playback: $error');
      }),
    );
  }

  Future<void> _recordPlayback(Song song) async {
    final lastPlay = DateTime.now().millisecondsSinceEpoch;
    final numberOfTimesPlayed = (song.numberOfTimesPlayed ?? 0) + 1;

    song
      ..lastPlay = lastPlay
      ..numberOfTimesPlayed = numberOfTimesPlayed;

    try {
      await _songCacheService.updatePlaybackStats(
        song: song,
        lastPlay: lastPlay,
        numberOfTimesPlayed: numberOfTimesPlayed,
      );
    } catch (error, stackTrace) {
      debugPrint('Error updating playback stats: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Future<void> pause() async {
    await _audioService.pause();
  }

  @override
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    final nextIndex = (_currentIndex + 1) % _playlist.length;
    await playSongAt(nextIndex);
  }

  @override
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    final previousIndex =
        (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSongAt(previousIndex);
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  @override
  Future<void> setPlayMode(PlayMode mode) async {
    _playMode = mode;
    await _playConfigRepository.setPlayMode(mode);
  }

  @override
  Future<void> setContinuePlay(bool isContinuePlay) async {
    _isContinuePlay = isContinuePlay;
    await _playConfigRepository.setContinuePlay(isContinuePlay);
  }

  Future<void> _restoreLastSong() async {
    final lastSongPath = _preferencesRepository.getLastSongPath();
    if (_currentIndex != -1 || lastSongPath == null || lastSongPath.isEmpty) {
      return;
    }

    final index = _playlist.indexWhere((song) => song.path == lastSongPath);
    if (index == -1) return;

    _currentIndex = index;
    await _audioService.setFilePath(_playlist[index].path);
    _currentSongController.add(currentSong);
  }

  Future<void> _handleSongComplete() async {
    if (!_isContinuePlay) {
      debugPrint('Continue play disabled: not advancing to next song.');
      await seek(Duration.zero);
      await pause();
      return;
    }

    switch (_playMode) {
      case PlayMode.repeat:
        await seek(Duration.zero);
        await play();
        break;
      case PlayMode.shuffle:
        await _playRandomSong();
        break;
      case PlayMode.sequential:
        await playNext();
        break;
    }
  }

  Future<void> _playRandomSong() async {
    if (_playlist.isEmpty) return;

    int newIndex;
    if (_playlist.length == 1) {
      newIndex = 0;
    } else {
      do {
        newIndex = _random.nextInt(_playlist.length);
      } while (newIndex == _currentIndex);
    }

    await playSongAt(newIndex);
  }

  @override
  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  @override
  Stream<Song?> get currentSongStream => _currentSongController.stream;

  @override
  int get currentIndex => _currentIndex;

  @override
  PlayMode get playMode => _playMode;

  @override
  bool get continuePlay => _isContinuePlay;

  @override
  AudioPlayer get audioPlayer => _audioService.audioPlayer;

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _currentSongController.close();
    _audioService.dispose();
  }

  @override
  Future<void> setSpeed(double speed) {
    return _audioService.setSpeed(speed);
  }
}
