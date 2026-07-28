import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/playlist.dart';
import '../providers/playlist_provider.dart';

class PlaylistHorizontalList extends ConsumerWidget {
  const PlaylistHorizontalList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistState = ref.watch(playlistProvider);
    final playlists = playlistState.playlists;
    final currentId = playlistState.currentPlaylistId;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: playlists.length + 1, // +1 cho chip "Tất cả"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _PlaylistChip(
              label: 'Tất cả',
              icon: Icons.music_note,
              isSelected: currentId == null,
              onTap: () {
                ref.read(playlistProvider.notifier).clearSelection();
              },
            );
          }

          final playlist = playlists[index - 1];
          return _PlaylistChip(
            label: playlist.name,
            icon: playlist.isDefault ? Icons.favorite : Icons.playlist_play,
            iconColor: playlist.isDefault ? Colors.redAccent : null,
            isSelected: currentId == playlist.id,
            onTap: () {
              ref.read(playlistProvider.notifier).selectPlaylist(playlist.id);
            },
          );
        },
      ),
    );
  }
}

class _PlaylistChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlaylistChip({
    required this.label,
    required this.icon,
    this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.deepPurpleAccent
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (iconColor ?? Colors.white70),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
