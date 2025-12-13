import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    if (await Permission.storage.isGranted ||
        await Permission.audio.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    if (storageStatus.isDenied) {
      final audioStatus = await Permission.audio.request();
      return audioStatus.isGranted;
    }

    return storageStatus.isGranted;
  }

  Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted ||
        await Permission.audio.isGranted;
  }
}