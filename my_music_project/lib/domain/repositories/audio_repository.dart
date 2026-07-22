import '../entities/play_mode.dart';
import '../entities/playback_event.dart';
import '../entities/song.dart';

abstract class AudioRepository {
  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0});

  Future<void> setCurrentSong(Song song);

  Future<void> seekToIndex(int index);

  Future<void> seekToNext();

  Future<void> seekToPrevious();

  Future<void> play();

  Future<void> pause();

  Future<void> stop();

  Future<void> seek(Duration position);

  Future<void> setSpeed(double speed);

  Future<void> setPlayMode(PlayMode mode, {required bool continuePlay});

  void setNotificationCallbacks({
    required Future<void> Function() onSkipToNext,
    required Future<void> Function() onSkipToPrevious,
  });

  int? get currentIndex;

  bool get isPlaying;

  Duration? get duration;

  double get speed;

  Stream<bool> get playingStream;

  Stream<PlaybackProcessingState> get processingStateStream;

  Stream<Duration> get positionStream;

  Stream<int?> get currentIndexStream;

  Stream<PlaybackDiscontinuity> get discontinuityStream;

  void dispose();
}
