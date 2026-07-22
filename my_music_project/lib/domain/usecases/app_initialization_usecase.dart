import '../gateways/app_initialization_gateway.dart';
import 'locale_usecases.dart';
import 'permission_usecases.dart';

class AppInitializationResult {
  final String? languageCode;
  final PermissionSnapshot permission;

  const AppInitializationResult({
    required this.languageCode,
    required this.permission,
  });
}

class AppInitializationUseCase {
  final AppInitializationGateway _gateway;
  final LocaleUseCases _localeUseCases;
  final PermissionUseCases _permissionUseCases;

  AppInitializationUseCase(
    this._gateway,
    this._localeUseCases,
    this._permissionUseCases,
  );

  Future<AppInitializationResult> call() async {
    await _gateway.initialize();
    return AppInitializationResult(
      languageCode: _localeUseCases.loadLanguageCode(),
      permission: await _permissionUseCases.loadCurrent(),
    );
  }
}
