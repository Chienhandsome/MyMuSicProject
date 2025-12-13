import 'package:flutter/material.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../utils/duration_formatter.dart';

class ProgressSlider extends StatefulWidget {
  final MusicPlayerViewModel viewModel;

  const ProgressSlider({super.key, required this.viewModel});

  @override
  State<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends State<ProgressSlider> {
  double? _localDragValue;

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.viewModel.currentSong;
    if (currentSong == null) return const SizedBox.shrink();

    final duration = Duration(milliseconds: currentSong.duration);
    final maxValue = duration.inMilliseconds.toDouble();

    return StreamBuilder<Duration>(
      stream: widget.viewModel.audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final currentValue = _localDragValue ??
            position.inMilliseconds.toDouble().clamp(0.0, maxValue);
        final displayPosition = _localDragValue != null
            ? Duration(milliseconds: _localDragValue!.toInt())
            : position;

        return Column(
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: currentValue,
                max: maxValue,
                activeColor: Colors.deepPurpleAccent,
                inactiveColor: Colors.white24,
                onChangeStart: (value) {
                  setState(() => _localDragValue = value);
                },
                onChanged: (value) {
                  setState(() => _localDragValue = value);
                },
                onChangeEnd: (value) {
                  widget.viewModel.seek(Duration(milliseconds: value.toInt()));
                  setState(() => _localDragValue = null);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DurationFormatter.format(displayPosition),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    DurationFormatter.format(duration),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
