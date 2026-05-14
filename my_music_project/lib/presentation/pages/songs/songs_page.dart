import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/music_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/song_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../search/search_page.dart';


class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.songs,
      scrollableAppBar: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white70),
          onPressed: () => ref.read(musicProvider.notifier).loadSongs(),
        ),
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.white70,
          ),
          onPressed: () => onSearchEvent(context),
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white70,
          ),
          onPressed: () => onMoreEvent(context),
        )
      ],
      body: Consumer(builder: (context, ref, _) {
        final musicState = ref.watch(musicProvider);

        if (musicState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (musicState.songs.isEmpty) {
          return Center(
            child: Text(
              l10n.noSongs,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        return _SongsList(songs: musicState.songs);
      }),
    );
  }

  void onSearchEvent(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPage())
    );
  }

  void onMoreEvent(BuildContext context) {
    // More actions menu - to be implemented
  }

}

class _SongsList extends ConsumerWidget {
  final List songs;

  const _SongsList({required this.songs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SongItem(index: index, song: song, currentIndex: audioState.currentIndex);
      },
    );
  }
}
