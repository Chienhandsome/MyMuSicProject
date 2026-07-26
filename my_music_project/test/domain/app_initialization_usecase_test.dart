import 'package:flutter_test/flutter_test.dart';
import 'package:my_music_project/domain/entities/storage_permission_status.dart';
import 'package:my_music_project/domain/gateways/app_initialization_gateway.dart';
import 'package:my_music_project/domain/repositories/permission_repository.dart';
import 'package:my_music_project/domain/repositories/preferences_repository.dart';
import 'package:my_music_project/domain/usecases/app_initialization_usecase.dart';
import 'package:my_music_project/domain/usecases/locale_usecases.dart';
import 'package:my_music_project/domain/usecases/permission_usecases.dart';

void main() {
  group('AppInitializationUseCase', () {
    test('calls gateway.initialize before loading app state', () async {
      final gateway = _FakeInitGateway();
      final prefRepo = _FakePreferencesRepository(languageCode: 'vi');
      final permRepo = _FakePermissionRepository(
        checkResult: StoragePermissionStatus.granted,
      );
      final localeUseCases = LocaleUseCases(prefRepo);
      final permUseCases = PermissionUseCases(permRepo, prefRepo);
      final useCase = AppInitializationUseCase(
        gateway,
        localeUseCases,
        permUseCases,
      );

      final result = await useCase.call();

      expect(gateway.initialized, isTrue);
      expect(result.languageCode, 'vi');
      expect(result.permission.status, StoragePermissionStatus.granted);
      expect(result.permission.hasDeniedBefore, isFalse);
    });

    test('returns null languageCode when none is saved', () async {
      final gateway = _FakeInitGateway();
      final prefRepo = _FakePreferencesRepository();
      final permRepo = _FakePermissionRepository(
        checkResult: StoragePermissionStatus.denied,
      );
      final localeUseCases = LocaleUseCases(prefRepo);
      final permUseCases = PermissionUseCases(permRepo, prefRepo);
      final useCase = AppInitializationUseCase(
        gateway,
        localeUseCases,
        permUseCases,
      );

      final result = await useCase.call();

      expect(result.languageCode, isNull);
      expect(result.permission.status, StoragePermissionStatus.denied);
    });

    test('reports hasDeniedBefore from preferences', () async {
      final gateway = _FakeInitGateway();
      final prefRepo = _FakePreferencesRepository(permissionDenied: true);
      final permRepo = _FakePermissionRepository(
        checkResult: StoragePermissionStatus.permanentlyDenied,
      );
      final localeUseCases = LocaleUseCases(prefRepo);
      final permUseCases = PermissionUseCases(permRepo, prefRepo);
      final useCase = AppInitializationUseCase(
        gateway,
        localeUseCases,
        permUseCases,
      );

      final result = await useCase.call();

      expect(result.permission.hasDeniedBefore, isTrue);
      expect(
        result.permission.status,
        StoragePermissionStatus.permanentlyDenied,
      );
    });

    test('propagates gateway initialization errors', () async {
      final gateway = _FakeInitGateway(error: StateError('init failed'));
      final prefRepo = _FakePreferencesRepository();
      final permRepo = _FakePermissionRepository();
      final localeUseCases = LocaleUseCases(prefRepo);
      final permUseCases = PermissionUseCases(permRepo, prefRepo);
      final useCase = AppInitializationUseCase(
        gateway,
        localeUseCases,
        permUseCases,
      );

      await expectLater(useCase.call(), throwsA(isA<StateError>()));
    });
  });
}

class _FakeInitGateway implements AppInitializationGateway {
  bool initialized = false;
  final Object? error;

  _FakeInitGateway({this.error});

  @override
  Future<void> initialize() async {
    final err = error;
    if (err != null) throw err;
    initialized = true;
  }
}

class _FakePermissionRepository implements PermissionRepository {
  final StoragePermissionStatus checkResult;

  _FakePermissionRepository({
    this.checkResult = StoragePermissionStatus.granted,
  });

  @override
  Future<StoragePermissionStatus> checkStoragePermission() async => checkResult;

  @override
  Future<StoragePermissionStatus> requestStoragePermission() async =>
      checkResult;
}

class _FakePreferencesRepository implements PreferencesRepository {
  bool permissionDenied;
  String? languageCode;
  String? lastSongPath;

  _FakePreferencesRepository({
    this.permissionDenied = false,
    this.languageCode,
    this.lastSongPath,
  });

  @override
  bool getPermissionDenied() => permissionDenied;

  @override
  Future<void> setPermissionDenied(bool value) async {
    permissionDenied = value;
  }

  @override
  String? getLanguageCode() => languageCode;

  @override
  Future<void> setLanguageCode(String code) async {
    languageCode = code;
  }

  @override
  String? getLastSongPath() => lastSongPath;

  @override
  Future<void> setLastSongPath(String path) async {
    lastSongPath = path;
  }
}
