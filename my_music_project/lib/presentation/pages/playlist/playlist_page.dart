import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/playlist.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/music_provider.dart';
import '../../providers/playlist_provider.dart';

class PlaylistPage extends ConsumerStatefulWidget {
  final VoidCallback? onPlaylistSelected;

  const PlaylistPage({super.key, this.onPlaylistSelected});

  @override
  ConsumerState<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends ConsumerState<PlaylistPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playlistState = ref.watch(playlistProvider);
    final musicState = ref.watch(musicProvider);

    final filteredPlaylists = _searchQuery.isEmpty
        ? playlistState.playlists
        : playlistState.playlists
            .where((p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: playlistState.isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator(color: Colors.white),
                      )
                    : filteredPlaylists.isEmpty
                        ? _buildEmptyState()
                        : _buildPlaylistList(
                            filteredPlaylists, musicState.songs),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        onPressed: () => _showCreatePlaylistDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAppBar() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: l10n.searchPlaylists,
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onPressed: () => _showMoreOptions(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.playlist_play,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? l10n.noPlaylists
                : l10n.noPlaylistsFound,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            Text(
              l10n.tapToCreate,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPlaylistList(
      List<Playlist> playlists, List<dynamic> allSongs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        final songCount = _getSongCount(playlist, allSongs);

        return _PlaylistTile(
          playlist: playlist,
          songCount: songCount,
          onTap: () => _onPlaylistTap(playlist),
          onLongPress: () => _showPlaylistOptions(playlist),
        );
      },
    );
  }

  int _getSongCount(Playlist playlist, List<dynamic> allSongs) {
    if (playlist.isDefault) {
      // Playlist "Yêu thích" → đếm bài isFavorite
      return allSongs
          .where((song) => song.isFavorite)
          .length;
    }
    return playlist.songCount;
  }

  void _onPlaylistTap(Playlist playlist) {
    ref.read(playlistProvider.notifier).selectPlaylist(playlist.id);
    widget.onPlaylistSelected?.call();
  }

  void _showCreatePlaylistDialog() {
    final nameController = TextEditingController();
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(
          l10n.createPlaylist,
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.playlistName,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white.withOpacity(0.3)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurpleAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel,
                style: const TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(playlistProvider.notifier).createPlaylist(name);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.create,
                style: const TextStyle(color: Colors.deepPurpleAccent)),
          ),
        ],
      ),
    );
  }

  void _showPlaylistOptions(Playlist playlist) {
    if (playlist.isDefault) return;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E2C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text(l10n.deletePlaylist,
                  style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDeletePlaylist(playlist);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePlaylist(Playlist playlist) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        title: Text(l10n.deletePlaylist,
            style: const TextStyle(color: Colors.white)),
        content: Text(
          l10n.deletePlaylistConfirm(playlist.name),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              ref.read(playlistProvider.notifier).deletePlaylist(playlist.id);
              Navigator.pop(ctx);
            },
            child: Text(l10n.delete,
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    // Placeholder for more options menu
  }
}

class _PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final int songCount;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PlaylistTile({
    required this.playlist,
    required this.songCount,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: playlist.isDefault
                ? Colors.redAccent.withOpacity(0.2)
                : Colors.deepPurpleAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            playlist.isDefault ? Icons.favorite : Icons.playlist_play,
            color:
                playlist.isDefault ? Colors.redAccent : Colors.deepPurpleAccent,
          ),
        ),
        title: Text(
          playlist.isDefault ? l10n.favorites : playlist.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          l10n.playlistSongsCount(songCount.toString()),
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.white38,
        ),
      ),
    );
  }
}
