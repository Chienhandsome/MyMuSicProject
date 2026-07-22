import '../entities/song.dart';

abstract class MusicRepository {
  //Future<List<Song>> loadSongs();

  Future<List<Song>> loadCachedSongs();

  Future<List<Song>> scanDeviceSongs();

  Future<void> saveSongCache(List<Song> songs);

  Future<void> deleteSongFromDevice(Song song);

  Future<void> updatePlaybackStats(
    Song song, {
    required int lastPlay,
    required int numberOfTimesPlayed,
  });

  Future<void> updateFavorite(Song song, {required bool isFavorite});

  Future<int?> getLastScanAt();

  Future<List<Song>> searchSongs(String query);
}
