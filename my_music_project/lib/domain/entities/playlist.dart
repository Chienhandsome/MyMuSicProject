class Playlist {
  final String id;
  final String name;
  final List<String> songPaths;
  final bool isDefault;
  final int createdAt;
  final int? updatedAt;

  const Playlist({
    required this.id,
    required this.name,
    required this.songPaths,
    required this.createdAt,
    this.isDefault = false,
    this.updatedAt,
  });

  Playlist copyWith({
    String? name,
    List<String>? songPaths,
    int? updatedAt,
  }) {
    return Playlist(
      id: id,
      name: name ?? this.name,
      songPaths: songPaths ?? this.songPaths,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get songCount => songPaths.length;
}
