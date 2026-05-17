import '../entities/play_mode.dart';

abstract class PlayConfigRepository {
  PlayMode getPlayMode();

  Future<void> setPlayMode(PlayMode playMode);

  bool getContinuePlay();

  Future<void> setContinuePlay(bool value);
}
