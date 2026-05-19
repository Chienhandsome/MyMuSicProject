import 'package:flutter/foundation.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/song.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  Future<void> setSong(Song song) async {
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.file(song.path),
          tag: MediaItem(
            id: song.path,
            title: song.title,
            artist: song.artist,
            duration: Duration(milliseconds: song.duration),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error setting audio file: $e');
      rethrow;
    }
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
