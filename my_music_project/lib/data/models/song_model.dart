import '../../domain/entities/song.dart';

class SongModel extends Song {
  SongModel({
    required super.id,
    required super.title,
    required super.path,
    required super.duration,
    super.lyric,
    super.size,
    super.lastPlay = 0,
    super.numberOfTimesPlayed = 0,
  });
}
