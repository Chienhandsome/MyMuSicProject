import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/progress_slider.dart';
import '../../widgets/player_controls.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/scrolling_title.dart';
import '../../../core/utils/song_share.dart';

class PlayerPage extends ConsumerWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kDebugMode) {
      print("player page build");
    }
    final currentSong = ref.watch(audioProvider).currentSong;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        actions: const [_PlayerMoreMenu()],
      ),
      body: currentSong == null
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noSongPlaying,
                style: const TextStyle(color: Colors.white),
              ),
            )
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1E1E2C), Color(0xFF121212)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const _SleepTimerCountdown(),
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6A5AE0), Color(0xFF8F7CFF)],
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
                      ScrollingTitle(
                        text: currentSong.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 32),
                      const ProgressSlider(),
                      const SizedBox(height: 32),
                      const PlayerControls(),
                      const Spacer(),

                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _SleepTimerCountdown extends ConsumerStatefulWidget {
  const _SleepTimerCountdown();

  @override
  ConsumerState<_SleepTimerCountdown> createState() => _SleepTimerCountdownState();
}

class _SleepTimerCountdownState extends ConsumerState<_SleepTimerCountdown> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sleepTimerEnd = ref.watch(audioProvider).sleepTimerEnd;

    if (sleepTimerEnd == null) return const Spacer();

    final remaining = sleepTimerEnd.difference(DateTime.now());
    if (remaining.isNegative) return const Spacer();

    final minutes = remaining.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = remaining.inSeconds.remainder(60).toString().padLeft(2, '0');

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$minutes:$seconds',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => ref.read(audioProvider.notifier).cancelSleepTimer(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF6A5AE0),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
              ),
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.25),
            ),
            child: const Text(
              'Huỷ hẹn giờ',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerMoreMenu extends ConsumerWidget {
  const _PlayerMoreMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _onMoreEvent(context, ref, value),
      itemBuilder: (ctx) => [
        PopupMenuItem(
          value: 'timer',
          child: Row(
            children: [
              const Icon(Icons.timer, color: Colors.black),
              const SizedBox(width: 12),
              Text(l10n.sleepTimer),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'favourite',
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.black),
              const SizedBox(width: 12),
              Text(l10n.addToFavorites),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'speed',
          child: Row(
            children: [
              const Icon(Icons.speed, color: Colors.black),
              const SizedBox(width: 12),
              Text(l10n.speed),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'share',
          child: Row(
            children: [
              const Icon(Icons.share, color: Colors.black),
              const SizedBox(width: 12),
              Text(l10n.share),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'details',
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.black),
              const SizedBox(width: 12),
              Text(l10n.details),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.redAccent),
              const SizedBox(width: 12),
              Text(
                l10n.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onMoreEvent(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    if (value == 'timer') {
      showDialog(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          content: _SleepTimerSheet(ref: ref),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
        ),
      );
    }

    if (value == 'share') {
      final currentSong = ref.read(audioProvider).currentSong;
      if (currentSong == null) return;

      await shareSongFile(context, currentSong);
    }

    if (value == 'details') {
      _showDetails(context, ref);
    }

    if (value == 'favourite') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('not implemented')),
      );
    }

    if (value == 'delete') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('not implemented')),
      );
    }

    if (value == 'speed') {
      _showSpeedDialog(context, ref);
    }
  }

  void _showSpeedDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentSpeed = ref.read(audioProvider.notifier).audioPlayer.speed;
    double speed = currentSpeed.clamp(0.5, 2.0);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1C1C2E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(l10n.playbackSpeed, style: const TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${speed.toStringAsFixed(1)}x',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF8F7CFF),
                      inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
                      thumbColor: const Color(0xFF6A5AE0),
                      overlayColor: const Color(0xFF6A5AE0).withValues(alpha: 0.2),
                      valueIndicatorColor: const Color(0xFF6A5AE0),
                      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                    ),
                    child: Slider(
                      value: speed,
                      min: 0.5,
                      max: 2.0,
                      divisions: 10,
                      label: '${speed.toStringAsFixed(2)}x',
                      onChanged: (value) => setState(() => speed = value),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                  ),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF6A5AE0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await ref.read(audioProvider.notifier).setSpeed(speed);
                    if (context.mounted) {
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(l10n.ok),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDetails(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentSong = ref.read(audioProvider).currentSong;

    if (currentSong == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1C2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(currentSong.title, style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.pathLabel}: ${currentSong.path}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${l10n.durationLabel}: ${currentSong.durationText}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('Size: ${(currentSong.size!/1024/1024).toStringAsFixed(1)}MB', style: const TextStyle(color: Colors.white70)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              child: Text(l10n.close),
            ),
          ],
        );
      },
    );
  }
}

class _SleepTimerSheet extends StatelessWidget {
  final WidgetRef ref;

  const _SleepTimerSheet({required this.ref});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.sleepTimer,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Divider(color: Colors.white.withValues(alpha: 0.12)),
          _item(context, '10s', const Duration(seconds: 10)),
          _item(context, l10n.minutes5, const Duration(minutes: 5)),
          _item(context, l10n.minutes10, const Duration(minutes: 10)),
          _item(context, l10n.minutes15, const Duration(minutes: 15)),
          _item(context, l10n.minutes30, const Duration(minutes: 30)),
          _item(context, l10n.hour1, const Duration(hours: 1)),
          _item(context, l10n.hour2, const Duration(hours: 2)),
          ListTile(
            title: Text(l10n.cancel, style: const TextStyle(color: Colors.redAccent)),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String text, Duration d) {
    return ListTile(
      title: Text(text, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white70),
      onTap: () {
        Navigator.pop(context);
        ref.read(audioProvider.notifier).startSleepTimer(context, d);
      },
    );
  }
}
