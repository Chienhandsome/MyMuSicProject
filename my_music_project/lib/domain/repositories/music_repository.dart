import '../entities/song.dart';

abstract class MusicRepository {
  Future<List<Song>> loadSongs();

  Future<List<Song>> searchSongs(String query);
}
