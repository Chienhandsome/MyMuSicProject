import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';

/// Repository interface for audio player operations
abstract class AudioRepository {
  /// Set the playlist for the audio player
  Future<void> setPlaylist(List<SongModel> songs);
  
  /// Play a song at specific index
  Future<void> playSongAt(int index);
  
  /// Play current song
  Future<void> play();
  
  /// Pause current song
  Future<void> pause();
  
  /// Play next song
  Future<void> playNext();
  
  /// Play previous song
  Future<void> playPrevious();
  
  /// Seek to specific position
  Future<void> seek(Duration position);
  
  /// Toggle continue play mode
  Future<void> toggleContinuePlay();
  
  /// Get continue play status
  bool getContinuePlay();
  
  /// Toggle play mode (sequential, repeat, shuffle)
  void togglePlayMode();
  
  /// Get current play mode as string
  String getPlayMode();
  
  /// Get current song
  SongModel? get currentSong;
  
  /// Get current index
  int get currentIndex;
  
  /// Get play mode enum
  PlayMode get playMode;
  
  /// Check if player is playing
  bool get isPlaying;
  
  /// Get the audio player instance for UI binding
  AudioPlayer get audioPlayer;
  
  /// Dispose resources
  void dispose();
}

/// Implementation of AudioRepository
class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayerService _audioService;

  AudioRepositoryImpl(this._audioService);

  @override
  Future<void> setPlaylist(List<SongModel> songs) async {
    await _audioService.setPlaylist(songs);
  }

  @override
  Future<void> playSongAt(int index) async {
    await _audioService.playSongAt(index);
  }

  @override
  Future<void> play() async {
    await _audioService.play();
  }

  @override
  Future<void> pause() async {
    await _audioService.pause();
  }

  @override
  Future<void> playNext() async {
    await _audioService.playNext();
  }

  @override
  Future<void> playPrevious() async {
    await _audioService.playPrevious();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  @override
  Future<void> toggleContinuePlay() async {
    final current = _audioService.getContinuePlay();
    _audioService.setContinuePlay(!current);
  }

  @override
  bool getContinuePlay() {
    return _audioService.getContinuePlay();
  }

  @override
  void togglePlayMode() {
    const modes = PlayMode.values;
    final currentModeIndex = modes.indexOf(_audioService.playMode);
    final nextMode = modes[(currentModeIndex + 1) % modes.length];
    _audioService.setPlayMode(nextMode);
  }

  @override
  String getPlayMode() {
    switch (_audioService.playMode) {
      case PlayMode.repeat:
        return 'repeat';
      case PlayMode.sequential:
        return 'sequential';
      case PlayMode.shuffle:
        return 'shuffle';
    }
  }

  @override
  SongModel? get currentSong => _audioService.currentSong;

  @override
  int get currentIndex => _audioService.currentIndex;

  @override
  PlayMode get playMode => _audioService.playMode;

  @override
  bool get isPlaying => _audioService.audioPlayer.playing;

  @override
  AudioPlayer get audioPlayer => _audioService.audioPlayer;

  @override
  void dispose() {
    _audioService.dispose();
  }
}