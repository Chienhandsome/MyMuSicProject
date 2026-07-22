import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../di/app_providers.dart';
import '../../domain/entities/playback_event.dart';
import '../../domain/entities/song.dart';

Future<void> shareSongFile(
  BuildContext context,
  WidgetRef ref,
  Song song,
) async {
  final renderBox = context.findRenderObject() as RenderBox?;
  final topLeft = renderBox?.localToGlobal(Offset.zero);
  final origin = renderBox == null || topLeft == null
      ? null
      : ShareOrigin(
          left: topLeft.dx,
          top: topLeft.dy,
          width: renderBox.size.width,
          height: renderBox.size.height,
        );
  final result = await ref
      .read(appPlatformUseCaseProvider)
      .shareSong(song, origin: origin);

  if (!context.mounted || result == ShareSongResult.success) return;
  final message = result == ShareSongResult.fileNotFound
      ? 'Unable to find this audio file.'
      : 'Unable to share this audio file.';
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
