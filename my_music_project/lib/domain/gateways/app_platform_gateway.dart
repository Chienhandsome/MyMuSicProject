import '../entities/playback_event.dart';
import '../entities/song.dart';

abstract class AppPlatformGateway {
  Future<bool> openAppSettings();

  Future<void> exitApp();

  Future<bool> openExternalUrl(Uri uri);

  Future<ShareSongResult> shareSong(
    Song song, {
    ShareOrigin? origin,
  });
}
