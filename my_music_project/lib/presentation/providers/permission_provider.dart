import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/permission_keys.dart';
import '../../data/repositories/permission_repository.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/shared_preferences_service.dart';
import '../../domain/usecases/check_permission_usecase.dart';
import '../../domain/usecases/request_permission_usecase.dart';

class PermissionState {
  final bool hasPermission;
  final bool hasPermanentlyDenied;
  final bool isLoading;

  const PermissionState({
    this.hasPermission = false,
    this.hasPermanentlyDenied = false,
    this.isLoading = false,
  });

  PermissionState copyWith({
    bool? hasPermission,
    bool? hasPermanentlyDenied,
    bool? isLoading,
  }) {
    return PermissionState(
      hasPermission: hasPermission ?? this.hasPermission,
      hasPermanentlyDenied: hasPermanentlyDenied ?? this.hasPermanentlyDenied,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PermissionNotifier extends StateNotifier<PermissionState> {
  final CheckPermissionUseCase _checkPermission;
  final RequestPermissionUseCase _requestPermission;

  PermissionNotifier(this._checkPermission, this._requestPermission)
      : super(const PermissionState());

  Future<void> loadDeniedStatus() async {
    final denied =
        SharedPreferencesService.getBool(PermissionKeys.permissionDenied) ??
            false;
    state = state.copyWith(hasPermanentlyDenied: denied);
  }

  Future<void> checkPermission() async {
    state = state.copyWith(isLoading: true);
    final granted = await _checkPermission();
    state = state.copyWith(hasPermission: granted, isLoading: false);
  }

  Future<void> requestPermission() async {
    state = state.copyWith(isLoading: true);
    final granted = await _requestPermission();
    if (granted) {
      await SharedPreferencesService.setBool(
          PermissionKeys.permissionDenied, false);
      state = state.copyWith(
          hasPermission: true,
          hasPermanentlyDenied: false,
          isLoading: false);
    } else {
      await SharedPreferencesService.setBool(
          PermissionKeys.permissionDenied, true);
      state = state.copyWith(
          hasPermission: false,
          hasPermanentlyDenied: true,
          isLoading: false);
    }
  }

  Future<void> resetDeniedStatus() async {
    await SharedPreferencesService.setBool(
        PermissionKeys.permissionDenied, false);
    state = state.copyWith(hasPermanentlyDenied: false);
  }
}

final permissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  return PermissionRepositoryImpl(PermissionService());
});

final checkPermissionUseCaseProvider = Provider<CheckPermissionUseCase>((ref) {
  return CheckPermissionUseCase(ref.watch(permissionRepositoryProvider));
});

final requestPermissionUseCaseProvider =
    Provider<RequestPermissionUseCase>((ref) {
  return RequestPermissionUseCase(ref.watch(permissionRepositoryProvider));
});

final permissionProvider =
    StateNotifierProvider<PermissionNotifier, PermissionState>((ref) {
  return PermissionNotifier(
    ref.watch(checkPermissionUseCaseProvider),
    ref.watch(requestPermissionUseCaseProvider),
  );
});
