import 'dart:async';

import '../entities/play_mode.dart';
import '../entities/playback_event.dart';
import '../entities/song.dart';
import '../repositories/audio_repository.dart';
import '../repositories/music_repository.dart';
import '../repositories/play_config_repository.dart';
import '../repositories/preferences_repository.dart';

abstract class LibraryPlaybackController {
  Future<void> setPlaylist(List<Song> songs);

  Future<void> stop();

  Song? get currentSong;
}

class PlaybackUseCases implements LibraryPlaybackController {
  final AudioRepository _audioRepository;
  final PreferencesRepository _preferencesRepository;
  final PlayConfigRepository _playConfigRepository;
  final MusicRepository _musicRepository;
  final StreamController<Song?> _currentSongController =
      StreamController<Song?>.broadcast();

  late final StreamSubscription<PlaybackProcessingState>
      _processingStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<int?> _currentIndexSubscription;
  late final StreamSubscription<PlaybackDiscontinuity>
      _discontinuitySubscription;

  List<Song> _playlist = [];
  int _currentIndex = -1;
  late PlayMode _playMode;
  late bool _continuePlay;
  bool _isAudioPlaylistLoaded = false;
  bool _isBlockingAutoAdvance = false;
  bool _isManualIndexChange = false;
  bool _isStoppingAtSongEnd = false;
  int? _manualIndexChangeTarget;

  PlaybackUseCases(
    this._audioRepository,
    this._preferencesRepository,
    this._playConfigRepository,
    this._musicRepository,
  ) {
    _playMode = _playConfigRepository.getPlayMode();
    _continuePlay = _playConfigRepository.getContinuePlay();
    _audioRepository.setNotificationCallbacks(
      onSkipToNext: playNext,
      onSkipToPrevious: playPrevious,
    );
    unawaited(
      _audioRepository.setPlayMode(
        _playMode,
        continuePlay: _continuePlay,
      ),
    );

    _processingStateSubscription =
        _audioRepository.processingStateStream.listen((state) {
      if (!_continuePlay && state == PlaybackProcessingState.completed) {
        unawaited(_stopAtCurrentSongStart());
      }
    });
    _positionSubscription = _audioRepository.positionStream.listen((position) {
      unawaited(_stopAtSongEndIfNeeded(position));
    });
    _currentIndexSubscription =
        _audioRepository.currentIndexStream.listen((index) {
      if (_isBlockingAutoAdvance) return;
      unawaited(_handlePlayerIndexChanged(index));
    });
    _discontinuitySubscription =
        _audioRepository.discontinuityStream.listen((event) {
      unawaited(_handleDiscontinuity(event));
    });
  }

  @override
  Future<void> setPlaylist(List<Song> songs) async {
    _playlist = List<Song>.of(songs);
    _isAudioPlaylistLoaded = false;

    if (_playlist.isEmpty) {
      _currentIndex = -1;
      await _audioRepository.setPlaylist(const []);
      _currentSongController.add(null);
      return;
    }

    if (_currentIndex >= _playlist.length) {
      _currentIndex = _playlist.length - 1;
    }

    await _restoreLastSong();
    if (_currentIndex != -1) {
      await _audioRepository.setPlaylist(
        _playlist,
        initialIndex: _currentIndex,
      );
      await _audioRepository.setPlayMode(
        _playMode,
        continuePlay: _continuePlay,
      );
      _isAudioPlaylistLoaded = true;
    }

    final song = currentSong;
    if (song != null) {
      await _audioRepository.setCurrentSong(song);
    }
    _currentSongController.add(song);
  }

  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    if (_isAudioPlaylistLoaded) {
      await _runManualIndexChange(() async {
        await _audioRepository.seekToIndex(index);
        _manualIndexChangeTarget = index;
      });
    } else {
      await _audioRepository.setPlaylist(_playlist, initialIndex: index);
      await _audioRepository.setPlayMode(
        _playMode,
        continuePlay: _continuePlay,
      );
      _isAudioPlaylistLoaded = true;
    }
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    await _audioRepository.setCurrentSong(song);
    _currentSongController.add(currentSong);
    _startPlayback();
  }

  Future<void> play() async {
    final song = currentSong;
    if (song == null) return;
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    _startPlayback();
  }

  void _startPlayback() {
    unawaited(_audioRepository.play().catchError((_) {}));
  }

  Future<void> _recordPlayback(Song song) async {
    final lastPlay = DateTime.now().millisecondsSinceEpoch;
    final playCount = (song.numberOfTimesPlayed ?? 0) + 1;
    song
      ..lastPlay = lastPlay
      ..numberOfTimesPlayed = playCount;

    try {
      await _musicRepository.updatePlaybackStats(
        song,
        lastPlay: lastPlay,
        numberOfTimesPlayed: playCount,
      );
    } catch (_) {
      // Playback should continue even when recording analytics fails.
    }
  }

  Future<void> pause() => _audioRepository.pause();

  @override
  Future<void> stop() => _audioRepository.stop();

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    if (!_isAudioPlaylistLoaded) {
      await playSongAt((_currentIndex + 1) % _playlist.length);
      return;
    }

    await _runManualIndexChange(() async {
      await _audioRepository.seekToNext();
      _manualIndexChangeTarget = _audioRepository.currentIndex;
    });
    final index = _audioRepository.currentIndex;
    if (index != null) {
      await _handleCurrentIndexChanged(index, forceRecord: true);
    }
    _startPlayback();
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    if (!_isAudioPlaylistLoaded) {
      final index = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await playSongAt(index);
      return;
    }

    await _runManualIndexChange(() async {
      await _audioRepository.seekToPrevious();
      _manualIndexChangeTarget = _audioRepository.currentIndex;
    });
    final index = _audioRepository.currentIndex;
    if (index != null) {
      await _handleCurrentIndexChanged(index, forceRecord: true);
    }
    _startPlayback();
  }

  Future<void> seek(Duration position) => _audioRepository.seek(position);

  Future<void> setSpeed(double speed) => _audioRepository.setSpeed(speed);

  Future<void> setPlayMode(PlayMode mode) async {
    _playMode = mode;
    await _audioRepository.setPlayMode(mode, continuePlay: _continuePlay);
    await _playConfigRepository.setPlayMode(mode);
  }

  Future<void> setContinuePlay(bool continuePlay) async {
    _continuePlay = continuePlay;
    await _audioRepository.setPlayMode(
      _playMode,
      continuePlay: _continuePlay,
    );
    await _playConfigRepository.setContinuePlay(continuePlay);
  }

  Future<void> toggleFavorite(Song song) async {
    final next = !song.isFavorite;
    song.isFavorite = next;
    try {
      await _musicRepository.updateFavorite(song, isFavorite: next);
      _currentSongController.add(currentSong);
    } catch (_) {
      song.isFavorite = !next;
      rethrow;
    }
  }

  Future<void> _restoreLastSong() async {
    final path = _preferencesRepository.getLastSongPath();
    if (_currentIndex != -1 || path == null || path.isEmpty) return;
    final index = _playlist.indexWhere((song) => song.path == path);
    if (index == -1) return;
    _currentIndex = index;
    _currentSongController.add(currentSong);
  }

  Future<void> _handleCurrentIndexChanged(
    int? index, {
    bool forceRecord = false,
  }) async {
    if (index == null || index < 0 || index >= _playlist.length) return;
    if (index == _currentIndex && !forceRecord) return;

    _currentIndex = index;
    final song = currentSong;
    _currentSongController.add(song);
    if (song == null) return;

    await _audioRepository.setCurrentSong(song);
    await _preferencesRepository.setLastSongPath(song.path);
    if (forceRecord) await _recordPlayback(song);
  }

  Future<void> _handlePlayerIndexChanged(int? index) async {
    if (index == null || index < 0 || index >= _playlist.length) return;
    final allowed = _isManualIndexChange || index == _manualIndexChangeTarget;
    if (index == _manualIndexChangeTarget) _manualIndexChangeTarget = null;

    if (!_continuePlay && !allowed && index != _currentIndex) {
      await _blockAutoAdvance(_currentIndex);
      return;
    }
    await _handleCurrentIndexChanged(index);
  }

  Future<void> _handleDiscontinuity(PlaybackDiscontinuity event) async {
    if (!event.isAutoAdvance) return;
    if (_continuePlay) {
      await _handleCurrentIndexChanged(event.currentIndex, forceRecord: true);
      return;
    }

    final previousIndex = event.previousIndex;
    if (previousIndex == null ||
        previousIndex < 0 ||
        previousIndex >= _playlist.length) {
      return;
    }
    await _blockAutoAdvance(previousIndex);
  }

  Future<void> _blockAutoAdvance(int indexToRestore) async {
    if (indexToRestore < 0 || indexToRestore >= _playlist.length) return;
    if (_isBlockingAutoAdvance) return;

    _isBlockingAutoAdvance = true;
    try {
      await Future<void>.delayed(Duration.zero);
      await _audioRepository.seekToIndex(indexToRestore);
      await _audioRepository.seek(Duration.zero);
      await _audioRepository.pause();
      _currentIndex = indexToRestore;
      final song = currentSong;
      _currentSongController.add(song);
      if (song != null) {
        await _audioRepository.setCurrentSong(song);
        await _preferencesRepository.setLastSongPath(song.path);
      }
    } finally {
      _isBlockingAutoAdvance = false;
    }
  }

  Future<void> _runManualIndexChange(Future<void> Function() change) async {
    _isManualIndexChange = true;
    try {
      await change();
    } finally {
      _isManualIndexChange = false;
    }
  }

  Future<void> _stopAtCurrentSongStart() async {
    await Future<void>.delayed(Duration.zero);
    await _audioRepository.seek(Duration.zero);
    await _audioRepository.pause();
  }

  Future<void> _stopAtSongEndIfNeeded(Duration position) async {
    if (_continuePlay || _isStoppingAtSongEnd || !_audioRepository.isPlaying) {
      return;
    }

    final duration = _audioRepository.duration;
    if (duration == null || duration == Duration.zero) return;
    if (position < duration - const Duration(milliseconds: 300)) return;

    _isStoppingAtSongEnd = true;
    try {
      await _stopAtCurrentSongStart();
    } finally {
      _isStoppingAtSongEnd = false;
    }
  }

  @override
  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  Stream<Song?> get currentSongStream => _currentSongController.stream;

  int get currentIndex => _currentIndex;

  PlayMode get playMode => _playMode;

  bool get continuePlay => _continuePlay;

  double get speed => _audioRepository.speed;

  Stream<bool> get playingStream => _audioRepository.playingStream;

  Stream<Duration> get positionStream => _audioRepository.positionStream;

  void dispose() {
    _processingStateSubscription.cancel();
    _positionSubscription.cancel();
    _currentIndexSubscription.cancel();
    _discontinuitySubscription.cancel();
    _currentSongController.close();
  }
}
