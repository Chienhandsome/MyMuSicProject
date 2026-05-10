import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../viewmodels/music_player_viewmodel.dart';

class PlayerControls extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const PlayerControls({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _PlayModeButton(viewModel: viewModel),

        _SkipButton(
          icon: Icons.skip_previous,
          onPressed: viewModel.playPrevious,
        ),
        _PlayPauseButton(viewModel: viewModel),

        _SkipButton(
          icon: Icons.skip_next,
          onPressed: viewModel.playNext,
        ),

        _ContinuePlayButton(
          icon: viewModel.getIsContinuePlay() ? Icons.repeat_on_rounded : Icons.repeat,
          onPressed: viewModel.toggleContinuePlay,
        ),
      ],
    );
  }
}

class _PlayModeButton extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const _PlayModeButton({required this.viewModel});

  Icon _mapModeToIcon(String mode) {
    switch (mode) {
      case 'repeat':
        return const Icon(Icons.repeat_one, size: 30);
      case 'sequential':
        return const Icon(Icons.arrow_forward, size: 30);
      case 'shuffle':
        return const Icon(Icons.shuffle, size: 30);
      default:
        return const Icon(Icons.skip_next, size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _mapModeToIcon(viewModel.getPlayMode()),
      onPressed: viewModel.togglePlayMode,
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
  final MusicPlayerViewModel viewModel;

  const _PlayPauseButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: viewModel.audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;

        return IconButton(
          icon: Icon(
            isPlaying ? Icons.pause_circle : Icons.play_circle,
            size: 64,
          ),
          onPressed: isPlaying ? viewModel.pause : viewModel.play,
        );
      },
    );
  }
}

