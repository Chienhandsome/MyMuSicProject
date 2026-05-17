import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/audio_player_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayerService _audioService;
  final PreferencesRepository _preferencesRepository;
  final Random _random = Random();
  final StreamController<Song?> _currentSongController =
      StreamController<Song?>.broadcast();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  List<Song> _playlist = [];
  int _currentIndex = -1;
  PlayMode _playMode = PlayMode.sequential;
  bool _isContinuePlay = false;

  AudioRepositoryImpl(this._audioService, this._preferencesRepository) {
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
    await _audioService.play();
    await _preferencesRepository.setLastSongPath(song.path);
    _currentSongController.add(currentSong);
  }

  @override
  Future<void> play() async {
    if (currentSong == null) return;

    await _audioService.play();
    await _preferencesRepository.setLastSongPath(currentSong!.path);
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
  void setPlayMode(PlayMode mode) {
    _playMode = mode;
  }

  @override
  void setContinuePlay(bool isContinuePlay) {
    _isContinuePlay = isContinuePlay;
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
}
