import '../entities/storage_permission_status.dart';

abstract class PermissionRepository {
  Future<StoragePermissionStatus> requestStoragePermission();

  Future<StoragePermissionStatus> checkStoragePermission();
}
