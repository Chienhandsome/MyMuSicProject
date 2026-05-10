import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../data/models/song_model.dart';
import '../../data/repositories/audio_repository.dart';
import '../../data/repositories/music_repository.dart';
import '../../core/utils/result.dart';
import '../../data/services/audio_player_service.dart';
import '../../data/services/music_query_service.dart';

class MusicPlayerViewModel extends ChangeNotifier {
  final AudioRepository _audioRepository;
  final MusicRepository _musicRepository;

  List<SongModel> _songs = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SongModel> get songs => _songs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AudioPlayer get audioPlayer => _audioRepository.audioPlayer;

  SongModel? get currentSong => _audioRepository.currentSong;
  PlayMode get playMode => _audioRepository.playMode;
  int get currentIndex => _audioRepository.currentIndex;
  bool get isPlaying => _audioRepository.isPlaying;

  MusicPlayerViewModel({
    required AudioRepository audioRepository,
    required MusicRepository musicRepository,
  })  : _audioRepository = audioRepository,
        _musicRepository = musicRepository {
    _listenPlayerState();
  }

  /// Factory constructor for default implementation
  factory MusicPlayerViewModel.create() {
    return MusicPlayerViewModel(
      audioRepository: AudioRepositoryImpl(AudioPlayerService()),
      musicRepository: MusicRepositoryImpl(MusicQueryService()),
    );
  }

  Future<void> init() async {
    await loadSongs();
  }

  Future<Result<void>> loadSongs() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final songsResult = await _musicRepository.loadSongs();
      _songs = songsResult;
      
      await _audioRepository.setPlaylist(_songs);
      
      _isLoading = false;
      notifyListeners();
      
      return Result.success(null);
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load songs: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> playSongAt(int index) async {
    try {
      await _audioRepository.playSongAt(index);
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to play song: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> play() async {
    try {
      await _audioRepository.play();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to play: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> pause() async {
    try {
      await _audioRepository.pause();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to pause: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> playNext() async {
    try {
      await _audioRepository.playNext();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to play next: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> playPrevious() async {
    try {
      await _audioRepository.playPrevious();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to play previous: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> seek(Duration position) async {
    try {
      await _audioRepository.seek(position);
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to seek: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  Future<Result<void>> toggleContinuePlay() async {
    try {
      await _audioRepository.toggleContinuePlay();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to toggle continue play: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  bool getIsContinuePlay() {
    return _audioRepository.getContinuePlay();
  }

  Future<Result<void>> togglePlayMode() async {
    try {
      _audioRepository.togglePlayMode();
      notifyListeners();
      return Result.success(null);
    } catch (e) {
      _errorMessage = 'Failed to toggle play mode: $e';
      notifyListeners();
      return Result.failure(_errorMessage!);
    }
  }

  String getPlayMode() {
    return _audioRepository.getPlayMode();
  }

  Future<Result<void>> togglePlayPause() async {
    if (isPlaying) {
      return await pause();
    } else {
      return await play();
    }
  }

  Future<Result<void>> toggleMiniPlayerPause() async {
    if (isPlaying) {
      return await pause();
    } else {
      return await play();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioRepository.dispose();
    super.dispose();
  }

  void _listenPlayerState() {
    audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  void startSleepTimer(BuildContext context, Duration duration) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(content: Text('Đã đặt hẹn giờ: ${duration.inMinutes} phút')),
    );

    Future.delayed(duration, () {
      pause();
      messenger.showSnackBar(
        const SnackBar(content: Text('Đã tắt nhạc theo hẹn giờ')),
      );
    });
  }
}