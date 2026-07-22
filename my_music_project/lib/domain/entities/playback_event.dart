enum PlaybackProcessingState {
  idle,
  loading,
  buffering,
  ready,
  completed,
}

class PlaybackDiscontinuity {
  final bool isAutoAdvance;
  final int? previousIndex;
  final int? currentIndex;

  const PlaybackDiscontinuity({
    required this.isAutoAdvance,
    this.previousIndex,
    this.currentIndex,
  });
}

class ShareOrigin {
  final double left;
  final double top;
  final double width;
  final double height;

  const ShareOrigin({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}

enum ShareSongResult { success, fileNotFound, failed }
