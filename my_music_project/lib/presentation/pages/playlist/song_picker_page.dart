import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/song.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/music_provider.dart';
import '../../providers/playlist_provider.dart';

class SongPickerPage extends ConsumerStatefulWidget {
  final String playlistId;

  const SongPickerPage({super.key, required this.playlistId});

  @override
  ConsumerState<SongPickerPage> createState() => _SongPickerPageState();
}

class _SongPickerPageState extends ConsumerState<SongPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedPaths = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadExistingSongs();
  }

  void _loadExistingSongs() {
    final playlistState = ref.read(playlistProvider);
    final playlist = playlistState.playlists
        .cast<dynamic>()
        .firstWhere(
          (p) => p.id == widget.playlistId,
          orElse: () => null,
        );
    if (playlist != null && !playlist.isDefault) {
      _selectedPaths.addAll(playlist.songPaths.cast<String>());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final musicState = ref.watch(musicProvider);
    final allSongs = musicState.songs;

    final filteredSongs = _searchQuery.isEmpty
        ? allSongs
        : allSongs
            .where((s) =>
                s.title.toLowerCase().contains(_searchQuery.toLowerCase()))
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
              _buildAppBar(l10n),
              _buildSearchBar(l10n),
              Expanded(
                child: filteredSongs.isEmpty
                    ? _buildEmptyState(l10n)
                    : _buildSongList(filteredSongs),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              l10n.addSongs,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: _selectedPaths.isEmpty ? null : _onDone,
            child: Text(
              '${l10n.done} (${_selectedPaths.length})',
              style: TextStyle(
                color: _selectedPaths.isEmpty
                    ? Colors.white38
                    : Colors.deepPurpleAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            hintText: l10n.searchSongsToAdd,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white.withOpacity(0.5),
              size: 20,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Text(
        l10n.noSongs,
        style: TextStyle(color: Colors.white.withOpacity(0.6)),
      ),
    );
  }

  Widget _buildSongList(List<Song> songs) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        final isSelected = _selectedPaths.contains(song.path);

        return _SongPickerItem(
          song: song,
          isSelected: isSelected,
          onToggle: () {
            setState(() {
              if (isSelected) {
                _selectedPaths.remove(song.path);
              } else {
                _selectedPaths.add(song.path);
              }
            });
          },
        );
      },
    );
  }

  Future<void> _onDone() async {
    final notifier = ref.read(playlistProvider.notifier);

    // Lấy danh sách path hiện tại trong playlist
    final playlistState = ref.read(playlistProvider);
    final playlist = playlistState.playlists
        .cast<dynamic>()
        .firstWhere(
          (p) => p.id == widget.playlistId,
          orElse: () => null,
        );

    final existingPaths =
        playlist != null ? Set<String>.from(playlist.songPaths) : <String>{};

    // Thêm bài mới (chưa có trong playlist)
    for (final path in _selectedPaths) {
      if (!existingPaths.contains(path)) {
        await notifier.addSongToPlaylist(widget.playlistId, path);
      }
    }

    // Xóa bài đã bỏ chọn (có trong playlist nhưng không còn selected)
    for (final path in existingPaths) {
      if (!_selectedPaths.contains(path)) {
        await notifier.removeSongFromPlaylist(widget.playlistId, path);
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}

class _SongPickerItem extends StatelessWidget {
  final Song song;
  final bool isSelected;
  final VoidCallback onToggle;

  const _SongPickerItem({
    required this.song,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onToggle,
      leading: Icon(
        isSelected ? Icons.check_circle : Icons.circle_outlined,
        color: isSelected ? Colors.deepPurpleAccent : Colors.white38,
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      subtitle: song.artist != null
          ? Text(
              song.artist!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            )
          : null,
      trailing: Text(
        song.durationText,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
    );
  }
}
