import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/song.dart';

Future<void> shareSongFile(BuildContext context, Song song) async {
  final file = File(song.path);
  if (!file.existsSync()) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to find this audio file.')),
    );
    return;
  }

  final renderBox = context.findRenderObject() as RenderBox?;
  final sharePositionOrigin = renderBox == null
      ? null
      : renderBox.localToGlobal(Offset.zero) & renderBox.size;

  try {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(song.path, mimeType: 'audio/mpeg')],
        fileNameOverrides: [_fileNameFor(song)],
        title: song.title,
        subject: song.title,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  } catch (_) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unable to share this audio file.')),
    );
  }
}

String _fileNameFor(Song song) {
  final extension = song.extension?.trim();
  final safeTitle = song.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  final fallbackName = fileNameFromPath(song.path);

  if (safeTitle.isEmpty) return fallbackName;
  if (extension == null || extension.isEmpty) return fallbackName;

  return '$safeTitle.$extension';
}

String fileNameFromPath(String path) {
  return path.split(RegExp(r'[\\/]')).last;
}
