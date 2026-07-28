import 'package:flutter_test/flutter_test.dart';
import 'package:my_music_project/domain/entities/playlist.dart';
import 'package:my_music_project/domain/entities/song.dart';
import 'package:my_music_project/domain/repositories/music_repository.dart';
import 'package:my_music_project/domain/repositories/playlist_repository.dart';
import 'package:my_music_project/domain/usecases/load_songs_usecase.dart';
import 'package:my_music_project/domain/usecases/playback_usecases.dart';
import 'package:my_music_project/domain/usecases/playlist_usecases.dart';

void main() {
  test('scan failure preserves cache and does not save an empty replacement',
      () async {
    final cachedSong = _song(1, 'cached.mp3');
    final repository = _FakeMusicRepository(
      cachedSongs: [cachedSong],
      scanError: StateError('scan failed'),
    );
    final playback = _FakeLibraryPlaybackController();
    final useCase = LoadSongsUseCase(repository, playback, PlaylistUseCases(_FakePlaylistRepository()));

    await expectLater(
      useCase.loadLibrary().toList(),
      throwsA(isA<StateError>()),
    );

    expect(repository.savedPlaylists, isEmpty);
    expect(playback.playlists, [
      [cachedSong],
    ]);
  });

  test('successful scan persists and synchronizes the refreshed library',
      () async {
    final cachedSong = _song(1, 'cached.mp3');
    final scannedSong = _song(2, 'scanned.mp3');
    final repository = _FakeMusicRepository(
      cachedSongs: [cachedSong],
      scannedSongs: [scannedSong],
    );
    final playback = _FakeLibraryPlaybackController();
    final useCase = LoadSongsUseCase(repository, playback, PlaylistUseCases(_FakePlaylistRepository()));

    final progress = await useCase.loadLibrary().toList();

    expect(progress, hasLength(2));
    expect(progress.first.isScanning, isTrue);
    expect(progress.last.isScanning, isFalse);
    expect(repository.savedPlaylists, [
      [scannedSong],
    ]);
    expect(playback.playlists, [
      [cachedSong],
      [scannedSong],
    ]);
  });
}

Song _song(int id, String path) {
  return Song(id: id, title: path, path: path, duration: 1000);
}

class _FakeLibraryPlaybackController implements LibraryPlaybackController {
  final List<List<Song>> playlists = [];

  @override
  Song? get currentSong => null;

  @override
  Future<void> setPlaylist(List<Song> songs) async {
    playlists.add(List<Song>.of(songs));
  }

  @override
  Future<void> stop() async {}
}

class _FakeMusicRepository implements MusicRepository {
  final List<Song> cachedSongs;
  final List<Song> scannedSongs;
  final Object? scanError;
  final List<List<Song>> savedPlaylists = [];

  _FakeMusicRepository({
    this.cachedSongs = const [],
    this.scannedSongs = const [],
    this.scanError,
  });

  @override
  Future<List<Song>> loadCachedSongs() async => List<Song>.of(cachedSongs);

  @override
  Future<List<Song>> scanDeviceSongs() async {
    final error = scanError;
    if (error != null) throw error;
    return List<Song>.of(scannedSongs);
  }

  @override
  Future<void> saveSongCache(List<Song> songs) async {
    savedPlaylists.add(List<Song>.of(songs));
  }

  @override
  Future<void> deleteSongFromDevice(Song song) async {}

  @override
  Future<int?> getLastScanAt() async => 123;

  @override
  Future<List<Song>> searchSongs(String query) async => const [];

  @override
  Future<void> updateFavorite(Song song, {required bool isFavorite}) async {}

  @override
  Future<void> updatePlaybackStats(
    Song song, {
    required int lastPlay,
    required int numberOfTimesPlayed,
  }) async {}
}

class _FakePlaylistRepository implements PlaylistRepository {
  @override
  Future<List<Playlist>> getPlaylists() async => const [];

  @override
  Future<Playlist?> getPlaylistById(String id) async => null;

  @override
  Future<Playlist> createPlaylist(String name) async {
    return Playlist(
      id: 'fake',
      name: name,
      songPaths: const [],
      createdAt: 0,
    );
  }

  @override
  Future<void> deletePlaylist(String id) async {}

  @override
  Future<void> addSong(String playlistId, String songPath) async {}

  @override
  Future<void> removeSong(String playlistId, String songPath) async {}

  @override
  Future<void> updateSongPaths(String playlistId, List<String> paths) async {}

  @override
  Future<String?> getCurrentPlaylistId() async => null;

  @override
  Future<void> setCurrentPlaylistId(String? id) async {}

  @override
  Future<void> initDefaultPlaylists() async {}
}
