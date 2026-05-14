import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/audio_provider.dart';
import '../../widgets/progress_slider.dart';
import '../../widgets/player_controls.dart';
import '../../../../l10n/app_localizations.dart';
import '../../widgets/scrolling_title.dart';

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
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 4),
          TextButton(
            onPressed: () => ref.read(audioProvider.notifier).cancelSleepTimer(),
            child: const Text(
              'Huỷ hẹn giờ',
              style: TextStyle(color: Colors.white38, fontSize: 12),
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

  void _onMoreEvent(BuildContext context, WidgetRef ref, String value) {
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
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(l10n.sleepTimer, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          _item(context, l10n.minutes5, const Duration(minutes: 5)),
          _item(context, l10n.minutes10, const Duration(minutes: 10)),
          _item(context, l10n.minutes15, const Duration(minutes: 15)),
          _item(context, l10n.minutes30, const Duration(minutes: 30)),
          _item(context, l10n.hour1, const Duration(hours: 1)),
          _item(context, l10n.hour2, const Duration(hours: 2)),
          ListTile(
            title: Text(l10n.cancel, style: const TextStyle(color: Colors.red)),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String text, Duration d) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        ref.read(audioProvider.notifier).startSleepTimer(context, d);
      },
    );
  }
}




