import '../entities/song.dart';
import '../repositories/music_repository.dart';
import 'playback_usecases.dart';
import 'playlist_usecases.dart';

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
  final PlaylistUseCases _playlistUseCases;

  LoadSongsUseCase(
    this._musicRepository,
    this._playbackUseCases,
    this._playlistUseCases,
  );

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

    // Reconcile playlists: loại path chết, match file rename
    await _playlistUseCases.reconcilePlaylists(scannedSongs, cachedSongs);

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
