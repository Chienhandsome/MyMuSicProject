import '../../domain/entities/song.dart';

class SongModel extends Song {
  const SongModel({
    required super.id,
    required super.title,
    required super.path,
    required super.duration,
    super.lyric,
  });
}

