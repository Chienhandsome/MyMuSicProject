import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../widgets/scrolling_title.dart';
import '../widgets/progress_slider.dart';
import '../widgets/player_controls.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text('Đang phát'),
      ),
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, _) {
          final currentSong = viewModel.currentSong;
          if (currentSong == null) {
            return const Center(child: Text('Không có bài hát nào'));
          }

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E1E2C),
                  Color(0xFF121212),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),

                    // 🎵 Album Art (placeholder)
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6A5AE0),
                            Color(0xFF8F7CFF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.music_note,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 🎶 Song title
                    ScrollingTitle(
                      text: currentSong.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 32),

                    ProgressSlider(viewModel: viewModel),

                    const SizedBox(height: 32),

                    PlayerControls(viewModel: viewModel),

                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
