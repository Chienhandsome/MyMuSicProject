import 'package:just_audio/just_audio.dart';

import '../entities/play_mode.dart';
import '../entities/song.dart';

abstract class AudioRepository {
  Future<void> setPlaylist(List<Song> songs);

  Future<void> playSongAt(int index);

  Future<void> play();

  Future<void> pause();

  Future<void> stop();

  Future<void> playNext();

  Future<void> playPrevious();

  Future<void> seek(Duration position);

  Future<void> setSpeed(double speed);

  Future<void> setPlayMode(PlayMode mode);

  Future<void> setContinuePlay(bool isContinuePlay);

  Future<void> toggleFavorite(Song song);

  Song? get currentSong;

  Stream<Song?> get currentSongStream;

  int get currentIndex;

  PlayMode get playMode;

  bool get continuePlay;

  AudioPlayer get audioPlayer;

  void dispose();
}
