import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../utils/file_name_handler.dart';
import '../widgets/app_scaffold.dart';
import 'player_page.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Bài hát',
      scrollableAppBar: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white70),
          onPressed: () => context.read<MusicPlayerViewModel>().loadSongs(),
        ),
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
          onPressed: () => onSearchEvent(),
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white70,
          ),
          onPressed: () => onSearchEvent(),
        )
      ],
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, _) {
          if (!viewModel.hasPermission) {
            return _PermissionView(viewModel: viewModel);
          }

          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (viewModel.songs.isEmpty) {
            return const Center(
              child: Text(
                'Không tìm thấy bài hát nào',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return _SongsList(viewModel: viewModel);
        },
      ),
    );
  }

  void onSearchEvent() {}
}

class _PermissionView extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const _PermissionView({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          const Text(
            'Cần quyền truy cập bộ nhớ',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.requestPermission,
            child: const Text('Cấp quyền'),
          ),
        ],
      ),
    );
  }
}

class _SongsList extends StatelessWidget {
  final MusicPlayerViewModel viewModel;

  const _SongsList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: viewModel.songs.length,
      itemBuilder: (context, index) {
        final song = viewModel.songs[index];
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
              FileNameHandler.limit(song.title, 28),
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
                onPressed: () => _onMoreEvent(context, index),
                icon: const Icon(Icons.more_vert)),
            onTap: () => _playSong(context, index),
          ),
        );
      },
    );
  }

  Future<void> _playSong(BuildContext context, int index) async {
    await viewModel.playSongAt(index);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayerPage()),
      );
    }
  }

  void _onMoreEvent(BuildContext context, int index) {
    final song = viewModel.songs[index];

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
                title:
                    const Text('Play', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await viewModel.playSongAt(index);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlayerPage()),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.queue_music, color: Colors.white),
                title: const Text('Add to queue',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Add to queue: not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text('Details',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDetails(context, song);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title:
                    const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share: not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.white70),
                title: const Text('Cancel',
                    style: TextStyle(color: Colors.white70)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context, dynamic song) {
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
              Text('Path: ${song.path}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('Duration: ${song.durationText}',
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child:
                  const Text('Close', style: TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }
}
