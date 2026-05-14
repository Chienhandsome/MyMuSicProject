import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import '../../data/models/song_model.dart';
import '../providers/audio_provider.dart';
import '../pages/player/player_page.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final currentSong = audioState.currentSong;

    if (currentSong == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlayerPage()),
        );
      },
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C2E),
          border: Border(
            top: BorderSide(color: Colors.white12, width: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildMusicSymbol(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomTitle(currentSong, audioState.isPlaying),
                    const SizedBox(height: 2),
                    Text(
                      currentSong.durationText,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildControlButton(audioState.isPlaying, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton(bool isPlaying, WidgetRef ref) {
    return IconButton(
      onPressed: () => ref.read(audioProvider.notifier).togglePlayPause(),
      icon: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildCustomTitle(SongModel currentSong, bool isPlaying) {
    return SizedBox(
      height: 20,
      child: isPlaying
          ? Marquee(
        text: currentSong.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 40.0,
        velocity: 30.0,
        startPadding: 8.0,
        fadingEdgeStartFraction: 0.1,
        fadingEdgeEndFraction: 0.1,
        showFadingOnlyWhenScrolling: false,
      )
          : Text(
        currentSong.title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMusicSymbol() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8F7CFF)],
        ),
      ),
      child: const Icon(
        Icons.music_note,
        color: Colors.white,
        size: 24,
      ),

    );
  }
}
