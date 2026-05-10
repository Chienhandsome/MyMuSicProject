import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../viewmodels/music_player_viewmodel.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/song_item.dart';
import '../../l10n/app_localizations.dart';
import '../search/search_page.dart';


class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppScaffold(
      title: l10n.songs,
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
      body: Consumer<MusicPlayerViewModel>(
        builder: (context, viewModel, _) {

          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (viewModel.songs.isEmpty) {
            return Center(
              child: Text(
                l10n.noSongs,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return _SongsList(viewModel: viewModel);
        },
      ),
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
        return SongItem(viewModel: viewModel, index: index, song: song);
      },
    );
  }
}
