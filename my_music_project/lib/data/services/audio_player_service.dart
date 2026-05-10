import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_project/core/constants/media_keys.dart';
import 'package:my_music_project/data/services/shared_preferences_service.dart';
import '../models/song_model.dart';

enum PlayMode { sequential, repeat, shuffle }

class AudioPlayerService {

  final AudioPlayer _audioPlayer = AudioPlayer();

  final Random _random = Random();

  bool _isContinuePlay = false;

  List<SongModel> _playlist = [];

  int _currentIndex = -1;

  PlayMode _playMode = PlayMode.sequential;

  AudioPlayer get audioPlayer => _audioPlayer;

  SongModel? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  PlayMode get playMode => _playMode;

  int get currentIndex => _currentIndex;

  AudioPlayerService() {
    _setupPlayerStateListener();
  }

  void _setupPlayerStateListener() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _handleSongComplete();
      }
    });
  }

  Future<void> _restoreLastSong() async {
    String lastSongPath =
        SharedPreferencesService.instance.getString(MediaKeys.lastSongPath) ?? '';

    if (_currentIndex == -1 && lastSongPath.isNotEmpty) {
      final index = _playlist.indexWhere((song) => song.path == lastSongPath);

      if (index != -1) {
        _currentIndex = index;

        await _audioPlayer.setFilePath(_playlist[index].path); // QUAN TRỌNG
      }
    }
  }

  Future<void> _handleSongComplete() async {
    // If continue-play is disabled, do not auto-advance or replay.
    if (!_isContinuePlay) {
      debugPrint('Continue play disabled: not advancing to next song.');
      await seek(Duration.zero);
      await pause();
      return;
    }

    switch (_playMode) {
      case PlayMode.repeat:
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
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

  Future<void> setPlaylist(List<SongModel> songs) async {
    _playlist = songs;
    await _restoreLastSong();
  }

  void setPlayMode(PlayMode mode) {
    _playMode = mode;
  }

  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    try {
      await _audioPlayer.setFilePath(song.path);
      await _audioPlayer.play();

      await SharedPreferencesService.instance.setString(
          MediaKeys.lastSongPath,
          _playlist[_currentIndex].path
      );
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();

    await SharedPreferencesService.instance.setString(
        MediaKeys.lastSongPath,
        _playlist[_currentIndex].path
    );
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    int nextIndex = (_currentIndex + 1) % _playlist.length;
    await playSongAt(nextIndex);
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    int prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSongAt(prevIndex);
  }

  setContinuePlay(bool isContinuePlay) {
    _isContinuePlay = isContinuePlay;
  }
  bool getContinuePlay() {
    return _isContinuePlay;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
