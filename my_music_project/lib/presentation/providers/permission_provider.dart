import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/permission_repository.dart';
import '../../data/services/permission_service.dart';
import '../../domain/entities/storage_permission_status.dart';
import '../../domain/repositories/permission_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import 'preferences_provider.dart';

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
  final PermissionRepository _permissionRepository;
  final PreferencesRepository _preferencesRepository;

  PermissionNotifier(
    this._permissionRepository,
    this._preferencesRepository,
  )
      : super(const PermissionState());

  Future<void> loadDeniedStatus() async {
    final denied = _preferencesRepository.getPermissionDenied();
    state = state.copyWith(hasDeniedBefore: denied);
  }

  Future<void> checkPermission() async {
    state = state.copyWith(isLoading: true);
    final status = await _permissionRepository.checkStoragePermission();
    state = state.copyWith(
      hasPermission: status == StoragePermissionStatus.granted,
      isPermanentlyDenied: status == StoragePermissionStatus.permanentlyDenied,
      isLoading: false,
    );
  }

  Future<void> requestPermission() async {
    state = state.copyWith(isLoading: true);
    final status = await _permissionRepository.requestStoragePermission();
    if (status == StoragePermissionStatus.granted) {
      await _preferencesRepository.setPermissionDenied(false);
      state = state.copyWith(
          hasPermission: true,
          hasDeniedBefore: false,
          isPermanentlyDenied: false,
          isLoading: false);
    } else {
      await _preferencesRepository.setPermissionDenied(true);
      state = state.copyWith(
          hasPermission: false,
          hasDeniedBefore: true,
          isPermanentlyDenied:
              status == StoragePermissionStatus.permanentlyDenied,
          isLoading: false);
    }
  }

  Future<void> resetDeniedStatus() async {
    await _preferencesRepository.setPermissionDenied(false);
    state = state.copyWith(hasDeniedBefore: false, isPermanentlyDenied: false);
  }
}

final permissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  return PermissionRepositoryImpl(PermissionService());
});

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
  return PermissionNotifier(
    ref.watch(permissionRepositoryProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});
