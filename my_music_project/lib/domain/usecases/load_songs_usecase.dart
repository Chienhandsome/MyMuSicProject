import '../entities/song.dart';
import '../repositories/music_repository.dart';
import 'playback_usecases.dart';

class LibraryLoadProgress {
  final List<Song> songs;
  final int? lastScanAt;
  final bool isScanning;

  const LibraryLoadProgress({
    required this.songs,
    required this.lastScanAt,
    required this.isScanning,
  });
}

class LoadSongsUseCase {
  final MusicRepository _musicRepository;
  final LibraryPlaybackController _playbackUseCases;

  LoadSongsUseCase(this._musicRepository, this._playbackUseCases);

  Stream<LibraryLoadProgress> loadLibrary() async* {
    final cachedSongs = await _musicRepository.loadCachedSongs();
    final lastScanAt = await _musicRepository.getLastScanAt();

    if (cachedSongs.isNotEmpty) {
      await _playbackUseCases.setPlaylist(cachedSongs);
    }
    yield LibraryLoadProgress(
      songs: cachedSongs,
      lastScanAt: lastScanAt,
      isScanning: true,
    );

    final scannedSongs = await _musicRepository.scanDeviceSongs();
    await _musicRepository.saveSongCache(scannedSongs);
    await _playbackUseCases.setPlaylist(scannedSongs);
    yield LibraryLoadProgress(
      songs: scannedSongs,
      lastScanAt: DateTime.now().millisecondsSinceEpoch,
      isScanning: false,
    );
  }

  Future<List<Song>> deleteSong(
    Song song,
    List<Song> currentSongs,
  ) async {
    if (_playbackUseCases.currentSong?.path == song.path) {
      await _playbackUseCases.stop();
    }

    await _musicRepository.deleteSongFromDevice(song);
    final updatedSongs = currentSongs
        .where((currentSong) => currentSong.path != song.path)
        .toList();
    await _playbackUseCases.setPlaylist(updatedSongs);
    return updatedSongs;
  }
}
