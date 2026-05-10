class SongModel {
  final String id;
  final String title;
  final String path;
  final int duration; // milliseconds

  SongModel({
    required this.id,
    required this.title,
    required this.path,
    required this.duration,
  });

  String get durationText {
    final minutes = (duration / 60000).floor();
    final seconds = ((duration % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

