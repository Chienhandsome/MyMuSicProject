import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart' hide SongModel;
import 'package:permission_handler/permission_handler.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';

class MusicPlayerViewModel extends ChangeNotifier {
  final AudioPlayerService _audioService = AudioPlayerService();
  final OnAudioQuery _audioQuery = OnAudioQuery();

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

  double? _dragValue;
  double? get dragValue => _dragValue;

  Future<void> init() async {
    await requestPermission();
    if (_hasPermission) {
      await loadSongs();
    }
  }

  // Xin quyền truy cập storage
  Future<void> requestPermission() async {
    if (await Permission.storage.isGranted ||
        await Permission.audio.isGranted) {
      _hasPermission = true;
    } else {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        final audioStatus = await Permission.audio.request();
        _hasPermission = audioStatus.isGranted;
      } else {
        _hasPermission = status.isGranted;
      }
    }
    notifyListeners();
  }

  // Quét và load tất cả file mp3
  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<SongModel> audioFiles = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      ).then((songs) {
        return songs.map((song) => SongModel(
          id: song.id.toString(),
          title: song.title,
          path: song.data,
          duration: song.duration ?? 0,
        )).toList();
      });

      _songs = audioFiles;
      _audioService.setPlaylist(_songs);
    } catch (e) {
      debugPrint('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Phát bài hát tại index
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

  // Chuyển đổi chế độ phát
  void togglePlayMode() {
    final modes = PlayMode.values;
    final currentModeIndex = modes.indexOf(_audioService.playMode);
    final nextMode = modes[(currentModeIndex + 1) % modes.length];
    _audioService.setPlayMode(nextMode);
    notifyListeners();
  }

  void updateDragValue(double value) {
    _dragValue = value;
    notifyListeners();
  }

  void endDrag() {
    _dragValue = null;
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

