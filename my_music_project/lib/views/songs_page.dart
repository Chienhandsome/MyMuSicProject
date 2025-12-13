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
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => context.read<MusicPlayerViewModel>().loadSongs(),
        ),
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
          color: isPlaying
              ? const Color(0xFF2A2A3D)
              : const Color(0xFF1C1C2E),
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
}