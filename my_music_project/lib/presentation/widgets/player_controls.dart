import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:my_music_project/core/constants/media_keys.dart';
import '../providers/audio_provider.dart';

class PlayerControls extends ConsumerWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final notifier = ref.read(audioProvider.notifier);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _PlayModeButton(playModeKey: notifier.getPlayModeKey(), onPressed: notifier.togglePlayMode),

        _SkipButton(
          icon: Icons.skip_previous,
          onPressed: notifier.playPrevious,
        ),
        _PlayPauseButton(audioPlayer: notifier.audioPlayer, notifier: notifier),

        _SkipButton(
          icon: Icons.skip_next,
          onPressed: notifier.playNext,
        ),

        _ContinuePlayButton(
          icon: audioState.isContinuePlay ? Icons.repeat_on_rounded : Icons.repeat,
          onPressed: notifier.toggleContinuePlay,
        ),
      ],
    );
  }
}

class _PlayModeButton extends StatelessWidget {
  final String playModeKey;
  final VoidCallback onPressed;

  const _PlayModeButton({required this.playModeKey, required this.onPressed});

  Icon _mapModeToIcon(String mode) {
    switch (mode) {
      case MediaKeys.repeatMode:
        return const Icon(Icons.repeat_one, size: 30);
      case MediaKeys.sequentialMode:
        return const Icon(Icons.arrow_forward, size: 30);
      case MediaKeys.shuffleMode:
        return const Icon(Icons.shuffle, size: 30);
      default:
        return const Icon(Icons.skip_next, size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _mapModeToIcon(playModeKey),
      onPressed: onPressed,
    );
  }
}

class _SkipButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SkipButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 48),
      onPressed: onPressed,
    );
  }
}

class _ContinuePlayButton extends StatelessWidget{

  final IconData icon;
  final VoidCallback onPressed;


  const _ContinuePlayButton({
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 30)
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final AudioNotifier notifier;

  const _PlayPauseButton({required this.audioPlayer, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;

        return IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            size: 64,
          ),
          onPressed: isPlaying ? notifier.pause : notifier.play,
        );
      },
    );
  }
}

