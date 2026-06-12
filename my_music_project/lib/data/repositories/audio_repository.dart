import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/play_mode.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/audio_repository.dart';
import '../../domain/repositories/play_config_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../services/audio_player_service.dart';
import '../services/song_cache_service.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioPlayerService _audioService;
  final PreferencesRepository _preferencesRepository;
  final PlayConfigRepository _playConfigRepository;
  final SongCacheService _songCacheService;
  final StreamController<Song?> _currentSongController =
      StreamController<Song?>.broadcast();
  late final StreamSubscription<PlayerState> _playerStateSubscription;
  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<int?> _currentIndexSubscription;
  late final StreamSubscription<PositionDiscontinuity>
      _positionDiscontinuitySubscription;

  List<Song> _playlist = [];
  int _currentIndex = -1;
  PlayMode _playMode = PlayMode.sequential;
  bool _isContinuePlay = false;
  bool _isAudioPlaylistLoaded = false;
  bool _isBlockingAutoAdvance = false;
  bool _isManualIndexChange = false;
  bool _isStoppingAtSongEnd = false;
  int? _manualIndexChangeTarget;

  AudioRepositoryImpl(
    this._audioService,
    this._preferencesRepository,
    this._playConfigRepository,
    this._songCacheService,
  ) {
    _playMode = _playConfigRepository.getPlayMode();
    _isContinuePlay = _playConfigRepository.getContinuePlay();
    _audioService.setNotificationCallbacks(
      onSkipToNext: playNext,
      onSkipToPrevious: playPrevious,
    );
    unawaited(
      _audioService.setPlayMode(_playMode, continuePlay: _isContinuePlay),
    );

    _playerStateSubscription =
        _audioService.audioPlayer.playerStateStream.listen((state) {
      if (!_isContinuePlay &&
          state.processingState == ProcessingState.completed) {
        unawaited(_stopAtCurrentSongStart());
      }
    });
    _positionSubscription =
        _audioService.audioPlayer.positionStream.listen((position) {
      unawaited(_stopAtSongEndIfNeeded(position));
    });
    _currentIndexSubscription =
        _audioService.audioPlayer.currentIndexStream.listen((index) {
      if (_isBlockingAutoAdvance) return;
      unawaited(_handlePlayerIndexChanged(index));
    });
    _positionDiscontinuitySubscription =
        _audioService.audioPlayer.positionDiscontinuityStream.listen(
      (discontinuity) {
        unawaited(_handlePositionDiscontinuity(discontinuity));
      },
    );
  }

  @override
  Future<void> setPlaylist(List<Song> songs) async {
    _playlist = songs;
    _isAudioPlaylistLoaded = false;

    if (_playlist.isEmpty) {
      _currentIndex = -1;
      await _audioService.setPlaylist(const []);
      _currentSongController.add(null);
      return;
    }

    if (_currentIndex >= _playlist.length) {
      _currentIndex = _playlist.length - 1;
    }

    await _restoreLastSong();
    if (_playlist.isNotEmpty && _currentIndex != -1) {
      await _audioService.setPlaylist(
        _playlist,
        initialIndex: _currentIndex,
      );
      await _audioService.setPlayMode(
        _playMode,
        continuePlay: _isContinuePlay,
      );
      _isAudioPlaylistLoaded = true;
    }
  }

  @override
  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    if (_isAudioPlaylistLoaded) {
      await _runManualIndexChange(() async {
        await _audioService.seekToIndex(index);
        _manualIndexChangeTarget = index;
      });
    } else {
      await _audioService.setPlaylist(_playlist, initialIndex: index);
      await _audioService.setPlayMode(
        _playMode,
        continuePlay: _isContinuePlay,
      );
      _isAudioPlaylistLoaded = true;
    }
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    await _audioService.setCurrentSong(song);
    _currentSongController.add(currentSong);
    _startPlayback();
  }

  @override
  Future<void> play() async {
    if (currentSong == null) return;

    final song = currentSong!;
    await _preferencesRepository.setLastSongPath(song.path);
    await _recordPlayback(song);
    _startPlayback();
  }

  void _startPlayback() {
    unawaited(
      _audioService.play().catchError((Object error, StackTrace stackTrace) {
        debugPrint('Error starting audio playback: $error');
      }),
    );
  }

  Future<void> _recordPlayback(Song song) async {
    final lastPlay = DateTime.now().millisecondsSinceEpoch;
    final numberOfTimesPlayed = (song.numberOfTimesPlayed ?? 0) + 1;

    song
      ..lastPlay = lastPlay
      ..numberOfTimesPlayed = numberOfTimesPlayed;

    try {
      await _songCacheService.updatePlaybackStats(
        song: song,
        lastPlay: lastPlay,
        numberOfTimesPlayed: numberOfTimesPlayed,
      );
    } catch (error, stackTrace) {
      debugPrint('Error updating playback stats: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Future<void> pause() async {
    await _audioService.pause();
  }

  @override
  Future<void> stop() async {
    await _audioService.stop();
  }

  @override
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    if (!_isAudioPlaylistLoaded) {
      await playSongAt((_currentIndex + 1) % _playlist.length);
      return;
    }

    await _runManualIndexChange(() async {
      await _audioService.seekToNext();
      _manualIndexChangeTarget = _audioService.audioPlayer.currentIndex;
    });
    final index = _audioService.audioPlayer.currentIndex;
    if (index != null) {
      await _handleCurrentIndexChanged(index, forceRecord: true);
    }
    _startPlayback();
  }

  @override
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    if (!_isAudioPlaylistLoaded) {
      final previousIndex =
          (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await playSongAt(previousIndex);
      return;
    }

    await _runManualIndexChange(() async {
      await _audioService.seekToPrevious();
      _manualIndexChangeTarget = _audioService.audioPlayer.currentIndex;
    });
    final index = _audioService.audioPlayer.currentIndex;
    if (index != null) {
      await _handleCurrentIndexChanged(index, forceRecord: true);
    }
    _startPlayback();
  }

  @override
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  @override
  Future<void> setPlayMode(PlayMode mode) async {
    _playMode = mode;
    await _audioService.setPlayMode(mode, continuePlay: _isContinuePlay);
    await _playConfigRepository.setPlayMode(mode);
  }

  @override
  Future<void> setContinuePlay(bool isContinuePlay) async {
    _isContinuePlay = isContinuePlay;
    await _audioService.setPlayMode(_playMode, continuePlay: _isContinuePlay);
    await _playConfigRepository.setContinuePlay(isContinuePlay);
  }

  @override
  Future<void> toggleFavorite(Song song) async {
    final next = !song.isFavorite;
    song.isFavorite = next;

    try {
      await _songCacheService.updateFavorite(
        song: song,
        isFavorite: next,
      );
      _currentSongController.add(currentSong);
    } catch (error, stackTrace) {
      song.isFavorite = !next;
      debugPrint('Error updating favorite: $error');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> _restoreLastSong() async {
    final lastSongPath = _preferencesRepository.getLastSongPath();
    if (_currentIndex != -1 || lastSongPath == null || lastSongPath.isEmpty) {
      return;
    }

    final index = _playlist.indexWhere((song) => song.path == lastSongPath);
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

    await _audioService.setCurrentSong(song);
    await _preferencesRepository.setLastSongPath(song.path);
    if (forceRecord) {
      await _recordPlayback(song);
    }
  }

  Future<void> _handlePlayerIndexChanged(int? index) async {
    if (index == null || index < 0 || index >= _playlist.length) return;

    final isAllowedManualChange =
        _isManualIndexChange || index == _manualIndexChangeTarget;
    if (index == _manualIndexChangeTarget) {
      _manualIndexChangeTarget = null;
    }

    if (!_isContinuePlay && !isAllowedManualChange && index != _currentIndex) {
      await _blockAutoAdvance(_currentIndex);
      return;
    }

    await _handleCurrentIndexChanged(index);
  }

  Future<void> _handlePositionDiscontinuity(
    PositionDiscontinuity discontinuity,
  ) async {
    if (discontinuity.reason != PositionDiscontinuityReason.autoAdvance) {
      return;
    }

    if (_isContinuePlay) {
      await _handleCurrentIndexChanged(
        discontinuity.event.currentIndex,
        forceRecord: true,
      );
      return;
    }

    final previousIndex = discontinuity.previousEvent.currentIndex;
    if (previousIndex == null ||
        previousIndex < 0 ||
        previousIndex >= _playlist.length) {
      return;
    }

    await _blockAutoAdvance(previousIndex);
  }

  Future<void> _blockAutoAdvance(int indexToRestore) async {
    if (indexToRestore < 0 || indexToRestore >= _playlist.length) return;

    debugPrint('Continue play disabled: blocking auto advance.');
    _isBlockingAutoAdvance = true;
    try {
      await _audioService.seekToIndex(indexToRestore);
      await _audioService.seek(Duration.zero);
      await _audioService.pause();
      _currentIndex = indexToRestore;
      final song = currentSong;
      _currentSongController.add(song);
      if (song != null) {
        await _audioService.setCurrentSong(song);
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
    debugPrint('Continue play disabled: stopping at current song start.');
    await _audioService.seek(Duration.zero);
    await _audioService.pause();
  }

  Future<void> _stopAtSongEndIfNeeded(Duration position) async {
    if (_isContinuePlay ||
        _isStoppingAtSongEnd ||
        !_audioService.audioPlayer.playing) {
      return;
    }

    final duration = _audioService.audioPlayer.duration;
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

  @override
  Stream<Song?> get currentSongStream => _currentSongController.stream;

  @override
  int get currentIndex => _currentIndex;

  @override
  PlayMode get playMode => _playMode;

  @override
  bool get continuePlay => _isContinuePlay;

  @override
  AudioPlayer get audioPlayer => _audioService.audioPlayer;

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _currentIndexSubscription.cancel();
    _positionDiscontinuitySubscription.cancel();
    _currentSongController.close();
    _audioService.dispose();
  }

  @override
  Future<void> setSpeed(double speed) {
    return _audioService.setSpeed(speed);
  }
}
