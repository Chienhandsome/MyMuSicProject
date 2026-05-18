class Song {
  final int id;
  String title;
  final String? lyric;
  final String? artist;
  final String path;
  final String? uri;
  final int duration;
  final int? size;
  final String? extension;
  final int? dateAddedMs;
  final int? dateModifiedMs;
  int? lastPlay;
  int? numberOfTimesPlayed;

  Song({
    required this.id,
    required this.title,
    required this.path,
    required this.duration,
    this.lyric,
    this.artist,
    this.uri,
    this.size,
    this.extension,
    this.dateAddedMs,
    this.dateModifiedMs,
    this.lastPlay,
    this.numberOfTimesPlayed,
  });

  String get durationText {
    final minutes = (duration / 60000).floor();
    final seconds = ((duration % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setTitle(String newTitle) {
    title = newTitle;
  }

  int? getLastPlay() {
    return lastPlay;
  }

  void setLastPlay(int? value) {
    lastPlay = value;
  }

  int? getNumberOfTimesPlayed() {
    return numberOfTimesPlayed;
  }

  void setNumberOfTimesPlayed(int? value) {
    numberOfTimesPlayed = value;
  }
}
