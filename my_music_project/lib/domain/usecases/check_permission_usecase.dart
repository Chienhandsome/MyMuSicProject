import '../../data/repositories/permission_repository.dart';

class CheckPermissionUseCase {
  final PermissionRepository _repository;

  CheckPermissionUseCase(this._repository);

  Future<bool> call() => _repository.hasStoragePermission();
}
