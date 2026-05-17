import '../entities/storage_permission_status.dart';
import '../repositories/permission_repository.dart';

class RequestPermissionUseCase {
  final PermissionRepository _repository;

  RequestPermissionUseCase(this._repository);

  Future<StoragePermissionStatus> call() => _repository.requestStoragePermission();
}
