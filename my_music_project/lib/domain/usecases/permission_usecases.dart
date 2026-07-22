import '../entities/storage_permission_status.dart';
import '../repositories/permission_repository.dart';
import '../repositories/preferences_repository.dart';

class PermissionSnapshot {
  final StoragePermissionStatus status;
  final bool hasDeniedBefore;

  const PermissionSnapshot({
    required this.status,
    required this.hasDeniedBefore,
  });
}

class PermissionUseCases {
  final PermissionRepository _permissionRepository;
  final PreferencesRepository _preferencesRepository;

  PermissionUseCases(
    this._permissionRepository,
    this._preferencesRepository,
  );

  Future<PermissionSnapshot> loadCurrent() async {
    return PermissionSnapshot(
      status: await _permissionRepository.checkStoragePermission(),
      hasDeniedBefore: _preferencesRepository.getPermissionDenied(),
    );
  }

  Future<PermissionSnapshot> request() async {
    final status = await _permissionRepository.requestStoragePermission();
    final denied = status != StoragePermissionStatus.granted;
    await _preferencesRepository.setPermissionDenied(denied);
    return PermissionSnapshot(status: status, hasDeniedBefore: denied);
  }

  Future<void> resetDeniedStatus() {
    return _preferencesRepository.setPermissionDenied(false);
  }
}
