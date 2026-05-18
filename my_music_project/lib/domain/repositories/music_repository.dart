import '../entities/song.dart';

abstract class MusicRepository {
  Future<List<Song>> loadSongs();

  Future<List<Song>> loadCachedSongs();

  Future<List<Song>> scanDeviceSongs();

  Future<void> saveSongCache(List<Song> songs);

  Future<int?> getLastScanAt();

  Future<List<Song>> searchSongs(String query);
}
