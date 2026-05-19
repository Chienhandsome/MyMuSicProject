import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/song.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> setPlaylist(
    List<Song> songs, {
    int initialIndex = 0,
  }) async {
    if (songs.isEmpty) {
      await _audioPlayer.setAudioSource(ConcatenatingAudioSource(children: []));
      return;
    }

    try {
      final safeInitialIndex = initialIndex.clamp(0, songs.length - 1);
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

  Future<void> seekToIndex(int index) async {
    await _audioPlayer.seek(Duration.zero, index: index);
  }

  AudioSource _songToAudioSource(Song song) {
    return AudioSource.uri(
      Uri.file(song.path),
      tag: MediaItem(
        id: song.path,
        title: song.title,
        artist: song.artist,
        duration: Duration(milliseconds: song.duration),
      ),
    );
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setSpeed(double speed) async {
    await _audioPlayer.setSpeed(speed);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
