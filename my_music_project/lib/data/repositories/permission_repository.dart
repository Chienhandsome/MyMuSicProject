import '../services/permission_service.dart';

/// Repository interface for permission-related operations
abstract class PermissionRepository {
  /// Request storage permission
  Future<bool> requestStoragePermission();
  
  /// Check if storage permission is granted
  Future<bool> hasStoragePermission();
}

/// Implementation of PermissionRepository
class PermissionRepositoryImpl implements PermissionRepository {
  final PermissionService _permissionService;

  PermissionRepositoryImpl(this._permissionService);

  @override
  Future<bool> requestStoragePermission() async {
    return await _permissionService.requestStoragePermission();
  }

  @override
  Future<bool> hasStoragePermission() async {
    return await _permissionService.hasStoragePermission();
  }
}