import 'package:flutter/material.dart';
import '../../viewmodels/music_player_viewmodel.dart';
import '../player/player_page.dart';

class SongItem extends StatelessWidget {
  final MusicPlayerViewModel viewModel;
  final int index;
  final dynamic song;

  const SongItem({
    required this.viewModel,
    required this.index,
    required this.song,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isPlaying = viewModel.currentIndex == index;

    return Card(
      elevation: isPlaying ? 6 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: isPlaying ? const Color(0xFF2A2A3D) : const Color(0xFF1C1C2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isPlaying ? Icons.equalizer : Icons.music_note,
          color: isPlaying ? Colors.deepPurpleAccent : Colors.white70,
        ),
        title: Text(
          song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          song.durationText,
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: IconButton(
            onPressed: () => _onMoreEvent(context),
            icon: const Icon(Icons.more_vert)
        ),
        onTap: () => _playSong(context),
      ),
    );
  }

  Future<void> _playSong(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayerPage()),
      );
    }

    await viewModel.playSongAt(index);
  }

  void _onMoreEvent(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.white),
                title: const Text('Play', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(ctx);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlayerPage()),
                    );
                  }
                  await viewModel.playSongAt(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.queue_music, color: Colors.white),
                title: const Text('Add to queue', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add to queue: not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text('Details', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDetails(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share: not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.white70),
                title: const Text('Cancel', style: TextStyle(color: Colors.white70)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C2E),
          title: Text(song.title, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Path: ${song.path}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('Duration: ${song.durationText}', style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }
}

