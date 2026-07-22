import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/app_providers.dart';
import '../../domain/entities/storage_permission_status.dart';
import '../../domain/usecases/permission_usecases.dart';

class PermissionState {
  final bool hasPermission;
  final bool hasDeniedBefore;
  final bool isPermanentlyDenied;
  final bool isLoading;

  const PermissionState({
    this.hasPermission = false,
    this.hasDeniedBefore = false,
    this.isPermanentlyDenied = false,
    this.isLoading = false,
  });

  PermissionState copyWith({
    bool? hasPermission,
    bool? hasDeniedBefore,
    bool? isPermanentlyDenied,
    bool? isLoading,
  }) {
    return PermissionState(
      hasPermission: hasPermission ?? this.hasPermission,
      hasDeniedBefore: hasDeniedBefore ?? this.hasDeniedBefore,
      isPermanentlyDenied: isPermanentlyDenied ?? this.isPermanentlyDenied,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PermissionNotifier extends StateNotifier<PermissionState> {
  final PermissionUseCases _permissionUseCases;

  PermissionNotifier(this._permissionUseCases) : super(const PermissionState());

  void restore(PermissionSnapshot snapshot) {
    state = _stateFromSnapshot(snapshot);
  }

  Future<void> checkPermission() async {
    state = state.copyWith(isLoading: true);
    state = _stateFromSnapshot(await _permissionUseCases.loadCurrent());
  }

  Future<void> requestPermission() async {
    state = state.copyWith(isLoading: true);
    state = _stateFromSnapshot(await _permissionUseCases.request());
  }

  Future<void> resetDeniedStatus() async {
    await _permissionUseCases.resetDeniedStatus();
    state = state.copyWith(hasDeniedBefore: false, isPermanentlyDenied: false);
  }

  PermissionState _stateFromSnapshot(PermissionSnapshot snapshot) {
    return PermissionState(
      hasPermission: snapshot.status == StoragePermissionStatus.granted,
      hasDeniedBefore: snapshot.hasDeniedBefore,
      isPermanentlyDenied:
          snapshot.status == StoragePermissionStatus.permanentlyDenied,
    );
  }
}

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
  return PermissionNotifier(
    ref.watch(permissionUseCasesProvider),
  );
});
