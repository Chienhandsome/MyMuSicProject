import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/storage_permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../services/permission_service.dart';

/// Implementation of PermissionRepository
class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionService _permissionService;

  PermissionRepositoryImpl(this._permissionService);

  @override
  Future<StoragePermissionStatus> requestStoragePermission() async {
    final status = await _permissionService.requestStoragePermission();
    return _mapStatus(status);
  }

  @override
  Future<StoragePermissionStatus> checkStoragePermission() async {
    final status = await _permissionService.checkStoragePermission();
    return _mapStatus(status);
  }

  StoragePermissionStatus _mapStatus(PermissionStatus status) {
    if (status.isGranted || status.isLimited) {
      return StoragePermissionStatus.granted;
    }
    if (status.isPermanentlyDenied) {
      return StoragePermissionStatus.permanentlyDenied;
    }
    return StoragePermissionStatus.denied;
  }
}
