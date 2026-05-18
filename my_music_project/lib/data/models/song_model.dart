import '../../domain/entities/song.dart';

class SongModel extends Song {
  static const int currentSchemaVersion = 1;

  SongModel({
    required super.id,
    required super.title,
    required super.path,
    required super.duration,
    super.lyric,
    super.artist,
    super.uri,
    super.size,
    super.extension,
    super.dateAddedMs,
    super.dateModifiedMs,
    super.lastPlay = 0,
    super.numberOfTimesPlayed = 0,
  });

  factory SongModel.fromMap(Map<dynamic, dynamic> map) {
    return SongModel(
      id: map['id'] as int,
      title: map['title'] as String,
      lyric: map['lyric'] as String?,
      artist: map['artist'] as String?,
      path: map['path'] as String,
      uri: map['uri'] as String?,
      duration: map['duration'] as int? ?? 0,
      size: map['size'] as int?,
      extension: map['extension'] as String?,
      dateAddedMs: map['date_added_ms'] as int?,
      dateModifiedMs: map['date_modified_ms'] as int?,
      lastPlay: map['last_play'] as int?,
      numberOfTimesPlayed: map['number_of_times_played'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'schema_version': currentSchemaVersion,
      'id': id,
      'title': title,
      'lyric': lyric,
      'artist': artist,
      'path': path,
      'uri': uri,
      'duration': duration,
      'size': size,
      'extension': extension,
      'date_added_ms': dateAddedMs,
      'date_modified_ms': dateModifiedMs,
      'last_play': lastPlay,
      'number_of_times_played': numberOfTimesPlayed,
    };
  }
}
