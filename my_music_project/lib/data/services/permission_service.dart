import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<PermissionStatus> requestStoragePermission() async {
    if (await Permission.storage.isGranted ||
        await Permission.audio.isGranted) {
      return PermissionStatus.granted;
    }

    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted || storageStatus.isPermanentlyDenied) {
      return storageStatus;
    }

    return Permission.audio.request();
  }

  Future<PermissionStatus> checkStoragePermission() async {
    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted || storageStatus.isPermanentlyDenied) {
      return storageStatus;
    }

    final audioStatus = await Permission.audio.status;
    if (audioStatus.isGranted || audioStatus.isPermanentlyDenied) {
      return audioStatus;
    }

    return storageStatus;
  }
}
