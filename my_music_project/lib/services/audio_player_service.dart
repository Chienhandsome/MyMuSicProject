import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

enum PlayMode { sequential, repeat, shuffle }

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

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

  Future<void> _handleSongComplete() async {
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

  void setPlaylist(List<SongModel> songs) {
    _playlist = songs;
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
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
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

  void dispose() {
    _audioPlayer.dispose();
  }
}
