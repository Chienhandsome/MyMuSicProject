import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../domain/entities/playback_event.dart';
import '../../domain/entities/song.dart';
import '../../domain/gateways/app_platform_gateway.dart';

class AppPlatformGatewayImpl implements AppPlatformGateway {
  @override
  Future<bool> openAppSettings() => permissions.openAppSettings();

  @override
  Future<void> exitApp() => SystemNavigator.pop();

  @override
  Future<bool> openExternalUrl(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ShareSongResult> shareSong(
    Song song, {
    ShareOrigin? origin,
  }) async {
    if (!await File(song.path).exists()) {
      return ShareSongResult.fileNotFound;
    }

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(song.path, mimeType: 'audio/mpeg')],
          fileNameOverrides: [_fileNameFor(song)],
          title: song.title,
          subject: song.title,
          sharePositionOrigin: origin == null
              ? null
              : Rect.fromLTWH(
                  origin.left,
                  origin.top,
                  origin.width,
                  origin.height,
                ),
        ),
      );
      return ShareSongResult.success;
    } catch (_) {
      return ShareSongResult.failed;
    }
  }

  String _fileNameFor(Song song) {
    final extension = song.extension?.trim();
    final safeTitle =
        song.title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
    final fallbackName = song.path.split(RegExp(r'[\\/]')).last;

    if (safeTitle.isEmpty || extension == null || extension.isEmpty) {
      return fallbackName;
    }
    return '$safeTitle.$extension';
  }
}
