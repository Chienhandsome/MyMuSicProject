import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../services/permission_service.dart';
import '../services/music_query_service.dart';

class MusicPlayerViewModel extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  final PermissionService _permissionService = PermissionService();
  final MusicQueryService _musicQueryService = MusicQueryService();

  List<SongModel> _songs = [];
  bool _isLoading = false;
  bool _hasPermission = false;

  List<SongModel> get songs => _songs;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;

  AudioPlayer get audioPlayer => _audioService.audioPlayer;
  SongModel? get currentSong => _audioService.currentSong;
  PlayMode get playMode => _audioService.playMode;
  int get currentIndex => _audioService.currentIndex;

  Future<void> init() async {
    await requestPermission();
    if (_hasPermission) {
      await loadSongs();
    }
  }

  Future<void> requestPermission() async {
    _hasPermission = await _permissionService.requestStoragePermission();
    notifyListeners();
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    _songs = await _musicQueryService.loadSongs();
    _audioService.setPlaylist(_songs);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playSongAt(int index) async {
    await _audioService.playSongAt(index);
    notifyListeners();
  }

  Future<void> play() async {
    await _audioService.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _audioService.pause();
    notifyListeners();
  }

  Future<void> playNext() async {
    await _audioService.playNext();
    notifyListeners();
  }

  Future<void> playPrevious() async {
    await _audioService.playPrevious();
    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  void togglePlayMode() {
    final modes = PlayMode.values;
    final currentModeIndex = modes.indexOf(_audioService.playMode);
    final nextMode = modes[(currentModeIndex + 1) % modes.length];
    _audioService.setPlayMode(nextMode);
    notifyListeners();
  }

  String getPlayModeIcon() {
    switch (_audioService.playMode) {
      case PlayMode.repeat:
        return '🔂';
      case PlayMode.sequential:
        return '➡️';
      case PlayMode.shuffle:
        return '🔀';
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}