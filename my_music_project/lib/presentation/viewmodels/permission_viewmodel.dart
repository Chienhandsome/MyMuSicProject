import 'package:flutter/material.dart';
import '../../data/repositories/permission_repository.dart';
import '../../data/services/permission_service.dart';
import '../../data/services/shared_preferences_service.dart';
import '../../core/constants/permission_keys.dart';

class PermissionViewModel extends ChangeNotifier {
  final PermissionRepository _permissionRepository;

  bool _isLoading = false;
  bool _hasPermission = false;
  bool _hasPermanentlyDenied = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  bool get hasPermanentlyDenied => _hasPermanentlyDenied;
  String? get errorMessage => _errorMessage;

  PermissionViewModel({required PermissionRepository permissionRepository})
      : _permissionRepository = permissionRepository;

  factory PermissionViewModel.create() {
    return PermissionViewModel(
      permissionRepository: PermissionRepositoryImpl(PermissionService()),
    );
  }

  Future<void> loadPermissionDeniedStatus() async {
    try {
      _hasPermanentlyDenied = SharedPreferencesService.getBool(PermissionKeys.permissionDenied) ?? false;
      notifyListeners();
    } catch (e) {
      // Nếu có lỗi (SharedPreferences chưa ready), mặc định là false
      _hasPermanentlyDenied = false;
      notifyListeners();
    }
  }

  Future<void> checkPermission() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _permissionRepository.hasStoragePermission();
      _hasPermission = result;
    } catch (e) {
      // Nếu có lỗi khi check permission, mặc định là không có quyền
      _hasPermission = false;
      _errorMessage = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> requestPermission() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _permissionRepository.requestStoragePermission();
      _hasPermission = result;
      _isLoading = false;

      if (!result) {
        _errorMessage = 'Permission denied';
        // Lưu trạng thái user đã từ chối quyền
        try {
          await SharedPreferencesService.setBool(PermissionKeys.permissionDenied, true);
        } catch (e) {
          // Ignore error khi save state
        }
        _hasPermanentlyDenied = true;
      } else {
        // Reset trạng thái khi user cấp quyền
        try {
          await SharedPreferencesService.setBool(PermissionKeys.permissionDenied, false);
        } catch (e) {
          // Ignore error khi save state
        }
        _hasPermanentlyDenied = false;
      }
    } catch (e) {
      _hasPermission = false;
      _errorMessage = e.toString();
      _isLoading = false;
    }

    notifyListeners();
  }

  Future<void> resetPermissionDeniedStatus() async {
    try {
      await SharedPreferencesService.setBool(PermissionKeys.permissionDenied, false);
    } catch (e) {
      // Ignore error khi reset state
    }
    _hasPermanentlyDenied = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
