import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/app_localizations.dart';
import '../providers/audio_provider.dart';
import '../pages/player/player_page.dart';

class SongItem extends ConsumerWidget {
  final int index;
  final dynamic song;
  final int currentIndex;

  const SongItem({
    required this.index,
    required this.song,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = currentIndex == index;

    return Card(
      elevation: isPlaying ? 6 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      color: isPlaying ? const Color(0xFF2A2A3D) : const Color(0xFF1C1C2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isPlaying ? Icons.equalizer : Icons.music_note,
          color: isPlaying ? Colors.deepPurpleAccent : Colors.white70,
        ),
        title: Text(
          song.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          song.durationText,
          style: const TextStyle(color: Colors.white54),
        ),
        trailing: IconButton(
            onPressed: () => _onMoreEvent(context, ref),
            icon: const Icon(Icons.more_vert)
        ),
        onTap: () => _playSong(context, ref),
      ),
    );
  }

  Future<void> _playSong(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PlayerPage()),
      );
    }

    await ref.read(audioProvider.notifier).playSongAt(index);
  }

  void _onMoreEvent(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.play_arrow, color: Colors.white),
                title: Text(l10n.play, style: const TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(ctx);
                  FocusScope.of(context).unfocus();
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PlayerPage()),
                    );
                  }
                  await ref.read(audioProvider.notifier).playSongAt(index);
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.white),
                title: const Text('Add to favorite', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('not implemented')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: Text(l10n.details, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showDetails(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: Text(l10n.share, style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.shareNotImplemented)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.white70),
                title: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C2E),
          title: Text(song.title, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.pathLabel}: ${song.path}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${l10n.durationLabel}: ${song.durationText}', style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.close, style: const TextStyle(color: Colors.white70)),
            ),
          ],
        );
      },
    );
  }
}
