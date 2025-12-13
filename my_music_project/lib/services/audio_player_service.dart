import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';

enum PlayMode { repeat, sequential, shuffle }

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioHandler? _audioHandler;

  List<SongModel> _playlist = [];
  int _currentIndex = 0;
  PlayMode _playMode = PlayMode.sequential;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<SongModel> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  PlayMode get playMode => _playMode;
  SongModel? get currentSong =>
      _playlist.isEmpty ? null : _playlist[_currentIndex];

  Future<void> init() async {
    _audioHandler = await AudioService.init(
      builder: () => MyAudioHandler(_audioPlayer),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.myapp.audio',
        androidNotificationChannelName: 'Music Player',
        androidNotificationOngoing: true,
      ),
    );

    // Lắng nghe khi bài hát kết thúc
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
    });
  }

  void setPlaylist(List<SongModel> songs) {
    _playlist = songs;
  }

  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    await _audioPlayer.setFilePath(song.path);
    await _audioPlayer.play();

    // Update notification through AudioHandler
    if (_audioHandler != null && _audioHandler is MyAudioHandler) {
      (_audioHandler as MyAudioHandler).updateMediaItem(MediaItem(
        id: song.id,
        title: song.title,
        duration: Duration(milliseconds: song.duration),
      ));
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void setPlayMode(PlayMode mode) {
    _playMode = mode;
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    switch (_playMode) {
      case PlayMode.repeat:
        await playSongAt(_currentIndex);
        break;
      case PlayMode.sequential:
        final nextIndex = (_currentIndex + 1) % _playlist.length;
        await playSongAt(nextIndex);
        break;
      case PlayMode.shuffle:
        final randomIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length;
        await playSongAt(randomIndex);
        break;
    }
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    final prevIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSongAt(prevIndex);
  }

  void _onSongComplete() {
    playNext();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

// AudioHandler để quản lý background service
class MyAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player;

  MyAudioHandler(this._player);

  // Override đúng signature từ BaseAudioHandler
  @override
  Future<void> updateMediaItem(MediaItem item) async {
    mediaItem.add(item);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}
