import 'package:isar/isar.dart';

part 'cached_song_record.g.dart';

@collection
class CachedSongRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String path;

  late int sourceId;
  late String title;
  String? lyric;
  String? artist;
  String? uri;
  late int duration;
  int? size;
  String? extension;
  int? dateAddedMs;
  int? dateModifiedMs;
  int? lastPlay;
  int? numberOfTimesPlayed;
  late bool isFavorite;
  late int schemaVersion;
}

@collection
class SongCacheMetadataRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late int value;
}

@collection
class AppSettingRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  String? stringValue;
  bool? boolValue;
  int? intValue;
}
