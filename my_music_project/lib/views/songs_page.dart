import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../utils/file_name_handler.dart';
import 'player_page.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài hát'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MusicPlayerViewModel>().loadSongs(),
          ),
        ],
      ),
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, _) {
          if (!viewModel.hasPermission) {
            return _PermissionView(viewModel: viewModel);
          }

          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.songs.isEmpty) {
            return const Center(child: Text('Không tìm thấy bài hát nào'));
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
          const Text('Cần quyền truy cập bộ nhớ'),
          const SizedBox(height: 16),
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
      itemCount: viewModel.songs.length,
      itemBuilder: (context, index) {
        final song = viewModel.songs[index];
        final isPlaying = viewModel.currentIndex == index;

        return ListTile(
          leading: Icon(
            Icons.music_note,
            color: isPlaying ? Theme.of(context).primaryColor : null,
          ),
          title: Text(
            FileNameHandler.limit(song.title, 30),
            style: TextStyle(
              fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(song.durationText),
          onTap: () => _playSong(context, index),
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
