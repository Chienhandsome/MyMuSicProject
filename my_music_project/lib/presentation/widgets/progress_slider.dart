import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';
import '../../core/utils/duration_formatter.dart';

class ProgressSlider extends ConsumerStatefulWidget {
  const ProgressSlider({super.key});

  @override
  ConsumerState<ProgressSlider> createState() => _ProgressSliderState();
}

class _ProgressSliderState extends ConsumerState<ProgressSlider> {
  double? _localDragValue;

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioProvider);
    final currentSong = audioState.currentSong;
    if (currentSong == null) return const SizedBox.shrink();

    final duration = Duration(milliseconds: currentSong.duration);
    final maxValue = duration.inMilliseconds.toDouble();
    final audioPlayer = ref.read(audioProvider.notifier).audioPlayer;

    return StreamBuilder<Duration>(
      stream: audioPlayer.positionStream,
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
                  ref.read(audioProvider.notifier).seek(Duration(milliseconds: value.toInt()));
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
