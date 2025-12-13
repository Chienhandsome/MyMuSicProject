import 'package:flutter/material.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../utils/duration_formatter.dart';

class ProgressSlider extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const ProgressSlider({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final currentSong = viewModel.currentSong;
    if (currentSong == null) return const SizedBox.shrink();

    final duration = Duration(milliseconds: currentSong.duration);
    final maxValue = duration.inMilliseconds.toDouble();

    return StreamBuilder<Duration>(
      stream: viewModel.audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final currentValue = viewModel.dragValue ??
            position.inMilliseconds.toDouble().clamp(0.0, maxValue);
        final displayPosition = viewModel.dragValue != null
            ? Duration(milliseconds: viewModel.dragValue!.toInt())
            : position;

        return Column(
          children: [
            Slider(
              value: currentValue,
              max: maxValue,
              onChangeStart: (_) => viewModel.updateDragValue(currentValue),
              onChanged: viewModel.updateDragValue,
              onChangeEnd: (value) {
                viewModel.seek(Duration(milliseconds: value.toInt()));
                viewModel.endDrag();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DurationFormatter.format(displayPosition)),
                  Text(DurationFormatter.format(duration)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}