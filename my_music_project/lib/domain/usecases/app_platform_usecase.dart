import '../entities/playback_event.dart';
import '../entities/song.dart';
import '../gateways/app_platform_gateway.dart';

class AppPlatformUseCase {
  final AppPlatformGateway _gateway;

  AppPlatformUseCase(this._gateway);

  Future<bool> openAppSettings() => _gateway.openAppSettings();

  Future<void> exitApp() => _gateway.exitApp();

  Future<bool> openExternalUrl(Uri uri) => _gateway.openExternalUrl(uri);

  Future<ShareSongResult> shareSong(
    Song song, {
    ShareOrigin? origin,
  }) {
    return _gateway.shareSong(song, origin: origin);
  }
}
