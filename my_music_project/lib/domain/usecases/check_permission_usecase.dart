import '../entities/storage_permission_status.dart';
import '../repositories/permission_repository.dart';

class CheckPermissionUseCase {
  final PermissionRepository _repository;

  CheckPermissionUseCase(this._repository);

  Future<StoragePermissionStatus> call() => _repository.checkStoragePermission();
}
