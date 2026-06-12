import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/song.dart';
import '../../providers/music_provider.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/song_item.dart';
import '../../../../l10n/app_localizations.dart';
import '../search/search_page.dart';

enum SortCriteria { name, duration, recentlyAdded }

enum SortOrder { ascending, descending }

class SortOption {
  final SortCriteria criteria;
  final SortOrder order;

  const SortOption({
    required this.criteria,
    required this.order,
  });

  SortOption copyWith({
    SortCriteria? criteria,
    SortOrder? order,
  }) {
    return SortOption(
      criteria: criteria ?? this.criteria,
      order: order ?? this.order,
    );
  }
}

final sortOptionProvider = StateProvider<SortOption>((ref) {
  return const SortOption(
    criteria: SortCriteria.name,
    order: SortOrder.ascending,
  );
});

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
        final sortOption = ref.watch(sortOptionProvider);

        if (musicState.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (musicState.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    musicState.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(musicProvider.notifier).loadSongs(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            ),
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

        final sortedSongs = _sortSongEntries(musicState.songs, sortOption);

        return Column(
          children: [
            if (musicState.isScanning)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Colors.deepPurpleAccent,
                backgroundColor: Colors.transparent,
              ),
            _buildFilterBar(context, ref, musicState.songs.length),
            _SongsList(songs: sortedSongs),
          ],
        );
      }),
    );
  }

  void onSearchEvent(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const SearchPage()));
  }

  void onMoreEvent(BuildContext context) {
    // More actions menu - to be implemented
  }

  Widget _buildFilterBar(BuildContext context, WidgetRef ref, int numberOfSong) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(l10n.songsCount(numberOfSong.toString()),
            style: const TextStyle(color: Colors.white)),
        TextButton.icon(
          onPressed: () => _showSortSheet(context, ref),
          icon: const Icon(Icons.sort, color: Colors.white70),
          label:
              Text(l10n.sort, style: const TextStyle(color: Colors.white70)),
        )
      ]),
    );
  }

  void _showSortSheet(BuildContext context, WidgetRef ref) {
    final currentOption = ref.read(sortOptionProvider);
    var selectedCriteria = currentOption.criteria;
    var selectedOrder = currentOption.order;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;

        return SafeArea(
          child: StatefulBuilder(builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.sortCriteria,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RadioGroup<SortCriteria>(
                    groupValue: selectedCriteria,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedCriteria = value);
                    },
                    child: Column(
                      children: [
                        RadioListTile<SortCriteria>(
                          value: SortCriteria.name,
                          activeColor: Colors.deepPurpleAccent,
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.sortByName,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        RadioListTile<SortCriteria>(
                          value: SortCriteria.duration,
                          activeColor: Colors.deepPurpleAccent,
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.sortByDuration,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        RadioListTile<SortCriteria>(
                          value: SortCriteria.recentlyAdded,
                          activeColor: Colors.deepPurpleAccent,
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.sortByRecentlyAdded,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sortOrder,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RadioGroup<SortOrder>(
                    groupValue: selectedOrder,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => selectedOrder = value);
                    },
                    child: Column(
                      children: [
                        RadioListTile<SortOrder>(
                          value: SortOrder.ascending,
                          activeColor: Colors.deepPurpleAccent,
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.sortAscending,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        RadioListTile<SortOrder>(
                          value: SortOrder.descending,
                          activeColor: Colors.deepPurpleAccent,
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.sortDescending,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        ref.read(sortOptionProvider.notifier).state =
                            SortOption(
                          criteria: selectedCriteria,
                          order: selectedOrder,
                        );
                        Navigator.pop(ctx);
                      },
                      child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }

  List<MapEntry<int, Song>> _sortSongEntries(
    List<Song> songs,
    SortOption option,
  ) {
    final entries = songs.asMap().entries.toList();

    entries.sort((a, b) {
      final result = switch (option.criteria) {
        SortCriteria.name =>
          a.value.title.toLowerCase().compareTo(b.value.title.toLowerCase()),
        SortCriteria.duration => a.value.duration.compareTo(b.value.duration),
        SortCriteria.recentlyAdded =>
          (a.value.dateAddedMs ?? 0).compareTo(b.value.dateAddedMs ?? 0),
      };

      return option.order == SortOrder.ascending ? result : -result;
    });

    return entries;
  }
}

class _SongsList extends ConsumerWidget {
  final List<MapEntry<int, Song>> songs;

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
      final songEntry = songs[index];
      return SongItem(
        index: songEntry.key,
        song: songEntry.value,
        currentIndex: audioState.currentIndex,
      );
    },
    );

  }
}
