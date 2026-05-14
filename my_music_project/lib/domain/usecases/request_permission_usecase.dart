import '../../data/repositories/permission_repository.dart';

class RequestPermissionUseCase {
  final PermissionRepository _repository;

  RequestPermissionUseCase(this._repository);

  Future<bool> call() => _repository.requestStoragePermission();
}
