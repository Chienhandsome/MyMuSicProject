import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
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
            onPressed: () {
              context.read<MusicPlayerViewModel>().loadSongs();
            },
          ),
        ],
      ),
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.hasPermission) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Cần quyền truy cập bộ nhớ'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.requestPermission(),
                    child: const Text('Cấp quyền'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.songs.isEmpty) {
            return const Center(
              child: Text('Không tìm thấy bài hát nào'),
            );
          }

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
                  limitFileName(song.title, 30),
                  style: TextStyle(
                    fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(song.durationText),
                onTap: () async {
                  await viewModel.playSongAt(index);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlayerPage(),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );

  }

  String limitFileName(String name, int numOfChars){
    return name.length > numOfChars ? '${name.substring(0, numOfChars)}...' : name;
  }
}
