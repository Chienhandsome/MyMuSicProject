import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/music_player_viewmodel.dart';
import '../../widgets/scrolling_title.dart';
import '../../widgets/progress_slider.dart';
import '../../widgets/player_controls.dart';
import '../../generated/l10n/app_localizations.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("player page build");
    }
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
        title: Text(AppLocalizations.of(context)!.nowPlaying),
        actions: const [
          _PlayerMoreMenu()
        ],
      ),
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, _) {
          final currentSong = viewModel.currentSong;
          if (currentSong == null) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noSongPlaying,
                style: const TextStyle(color: Colors.white),
              ),
            );
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
                            color: Colors.black.withValues(alpha: 0.4),
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

class _PlayerMoreMenu extends StatelessWidget {
  const _PlayerMoreMenu();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _onMoreEvent(context, value),
      itemBuilder: (ctx) => [
        PopupMenuItem(
            value: 'timer',
            child: Text(l10n.sleepTimer),
        ),
        PopupMenuItem(
          value: 'favourite',
          child: Text(l10n.addToFavorites),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(
              l10n.delete,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  void _onMoreEvent(BuildContext context, String value) {
    if (value == 'timer') {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          content: const _SleepTimerSheet(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      );
    }
  }
}

class _SleepTimerSheet extends StatelessWidget {
  const _SleepTimerSheet();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<MusicPlayerViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(l10n.sleepTimer, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _item(context, vm, l10n.minutes5, const Duration(minutes: 5)),
          _item(context, vm, l10n.minutes10, const Duration(minutes: 10)),
          _item(context, vm, l10n.minutes15, const Duration(minutes: 15)),
          _item(context, vm, l10n.minutes30, const Duration(minutes: 30)),
          _item(context, vm, l10n.hour1, const Duration(hours: 1)),
          ListTile(
            title: Text(l10n.cancel, style: const TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, MusicPlayerViewModel vm, String text, Duration d) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        vm.startSleepTimer(context, d);
      },
    );
  }
}




