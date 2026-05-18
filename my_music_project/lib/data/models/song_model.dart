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

  factory SongModel.fromSong(Song song) {
    return SongModel(
      id: song.id,
      title: song.title,
      lyric: song.lyric,
      artist: song.artist,
      path: song.path,
      uri: song.uri,
      duration: song.duration,
      size: song.size,
      extension: song.extension,
      dateAddedMs: song.dateAddedMs,
      dateModifiedMs: song.dateModifiedMs,
      lastPlay: song.lastPlay,
      numberOfTimesPlayed: song.numberOfTimesPlayed,
    );
  }

  factory SongModel.fromMap(Map<dynamic, dynamic> map) {
    return SongModel(
      id: _readInt(map['id']) ?? 0,
      title: map['title'] as String,
      lyric: map['lyric'] as String?,
      artist: map['artist'] as String?,
      path: map['path'] as String,
      uri: map['uri'] as String?,
      duration: _readInt(map['duration']) ?? 0,
      size: _readInt(map['size']),
      extension: map['extension'] as String?,
      dateAddedMs: _readInt(map['date_added_ms']),
      dateModifiedMs: _readInt(map['date_modified_ms']),
      lastPlay: _readInt(map['last_play']),
      numberOfTimesPlayed: _readInt(map['number_of_times_played']),
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

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
