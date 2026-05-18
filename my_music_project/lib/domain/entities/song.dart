class Song {
  final String id;
  String title;
  final String path;
  final int duration;
  final String? lyric;
  final int? size;
  int? lastPlay;
  int? numberOfTimesPlayed;

  Song({
    required this.id,
    required this.title,
    required this.path,
    required this.duration,
    this.lyric,
    this.size,
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
