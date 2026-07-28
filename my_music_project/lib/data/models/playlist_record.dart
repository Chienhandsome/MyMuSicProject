import 'package:isar/isar.dart';

part 'playlist_record.g.dart';

@collection
class PlaylistRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  late String name;
  late List<String> songPaths;
  late int createdAt;
  int? updatedAt;
  bool isDefault = false;
}
