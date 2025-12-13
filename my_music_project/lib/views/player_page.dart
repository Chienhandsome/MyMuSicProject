import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import '../viewmodels/music_player_viewmodel.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang phát'),
      ),
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, child) {
          final currentSong = viewModel.currentSong;
          if (currentSong == null) {
            return const Center(child: Text('Không có bài hát nào'));
          }

          final titleStyle =
              Theme.of(context).textTheme.headlineSmall ?? const TextStyle(fontSize: 20);

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Scrolling song title using Marquee
                SizedBox(
                  height: 48,
                  child: Marquee(
                    text: currentSong.title,
                    style: titleStyle,
                    scrollAxis: Axis.horizontal,
                    blankSpace: 40.0,
                    velocity: 30.0,
                    startPadding: 8.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    fadingEdgeStartFraction: 0.1,
                    fadingEdgeEndFraction: 0.1,
                    showFadingOnlyWhenScrolling: true,
                  ),
                ),
                const SizedBox(height: 48),

                // Progress bar và thời gian - Tách thành widget riêng
                _ProgressSection(viewModel: viewModel),
                const SizedBox(height: 32),

                // Nút điều khiển
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nút chế độ phát
                    IconButton(
                      icon: Text(
                        viewModel.getPlayModeIcon(),
                        style: const TextStyle(fontSize: 24),
                      ),
                      onPressed: viewModel.togglePlayMode,
                    ),

                    // Bài trước
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 48),
                      onPressed: viewModel.playPrevious,
                    ),

                    // Play/Pause
                    StreamBuilder<PlayerState>(
                      stream: viewModel.audioPlayer.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final playing = playerState?.playing ?? false;

                        return IconButton(
                          icon: Icon(
                            playing ? Icons.pause_circle : Icons.play_circle,
                            size: 64,
                          ),
                          onPressed: () {
                            if (playing) {
                              viewModel.pause();
                            } else {
                              viewModel.play();
                            }
                          },
                        );
                      },
                    ),

                    // Bài tiếp
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 48),
                      onPressed: viewModel.playNext,
                    ),

                    // Placeholder để cân bằng layout
                    const SizedBox(width: 48),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget riêng cho Progress Section để tối ưu rebuild
class _ProgressSection extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const _ProgressSection({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final currentSong = viewModel.currentSong;
    if (currentSong == null) return const SizedBox.shrink();

    final duration = Duration(milliseconds: currentSong.duration);
    final max = duration.inMilliseconds.toDouble();

    return StreamBuilder<Duration>(
      stream: viewModel.audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;

        // Khi đang drag, dùng dragValue, không dùng position từ stream
        final currentValue = viewModel.dragValue ??
            position.inMilliseconds.toDouble().clamp(0.0, max);

        // Hiển thị thời gian: khi drag thì hiển thị dragValue
        final displayPosition = viewModel.dragValue != null
            ? Duration(milliseconds: viewModel.dragValue!.toInt())
            : position;

        return Column(
          children: [
            Slider(
              value: currentValue,
              max: max,
              onChangeStart: (_) {
                // Đánh dấu bắt đầu drag
                viewModel.updateDragValue(currentValue);
              },
              onChanged: (value) {
                // Cập nhật giá trị khi đang drag
                viewModel.updateDragValue(value);
              },
              onChangeEnd: (value) {
                // Seek và kết thúc drag
                viewModel.seek(Duration(milliseconds: value.toInt()));
                viewModel.endDrag();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(displayPosition)),
                  Text(_formatDuration(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}