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
            appBar: AppBar(title: const Text('Đang phát')),
            body: Consumer<MusicPlayerViewModel>(
              builder: (context, viewModel, _) {
                final currentSong = viewModel.currentSong;
                if (currentSong == null) {
                  return const Center(child: Text('Không có bài hát nào'));
                }

                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScrollingTitle(
                        text: currentSong.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 48),
                      ProgressSlider(viewModel: viewModel),
                      const SizedBox(height: 32),
                      PlayerControls(viewModel: viewModel),
                    ],
                  ),
                );
              },
            ),
          );
        }
      }