import 'package:flutter_test/flutter_test.dart';
import 'package:my_music_project/domain/entities/storage_permission_status.dart';
import 'package:my_music_project/domain/repositories/permission_repository.dart';
import 'package:my_music_project/domain/repositories/preferences_repository.dart';
import 'package:my_music_project/domain/usecases/permission_usecases.dart';

void main() {
  group('PermissionUseCases', () {
    group('loadCurrent', () {
      test('returns granted status with no prior denial', () async {
        final permRepo = _FakePermissionRepository(
          checkResult: StoragePermissionStatus.granted,
        );
        final prefRepo = _FakePreferencesRepository(permissionDenied: false);
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.loadCurrent();

        expect(snapshot.status, StoragePermissionStatus.granted);
        expect(snapshot.hasDeniedBefore, isFalse);
      });

      test('returns denied status with prior denial flag', () async {
        final permRepo = _FakePermissionRepository(
          checkResult: StoragePermissionStatus.denied,
        );
        final prefRepo = _FakePreferencesRepository(permissionDenied: true);
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.loadCurrent();

        expect(snapshot.status, StoragePermissionStatus.denied);
        expect(snapshot.hasDeniedBefore, isTrue);
      });

      test('returns permanentlyDenied status', () async {
        final permRepo = _FakePermissionRepository(
          checkResult: StoragePermissionStatus.permanentlyDenied,
        );
        final prefRepo = _FakePreferencesRepository(permissionDenied: true);
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.loadCurrent();

        expect(snapshot.status, StoragePermissionStatus.permanentlyDenied);
        expect(snapshot.hasDeniedBefore, isTrue);
      });
    });

    group('request', () {
      test('sets permissionDenied to false when granted', () async {
        final permRepo = _FakePermissionRepository(
          requestResult: StoragePermissionStatus.granted,
        );
        final prefRepo = _FakePreferencesRepository();
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.request();

        expect(snapshot.status, StoragePermissionStatus.granted);
        expect(snapshot.hasDeniedBefore, isFalse);
        expect(prefRepo.permissionDenied, isFalse);
      });

      test('sets permissionDenied to true when denied', () async {
        final permRepo = _FakePermissionRepository(
          requestResult: StoragePermissionStatus.denied,
        );
        final prefRepo = _FakePreferencesRepository();
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.request();

        expect(snapshot.status, StoragePermissionStatus.denied);
        expect(snapshot.hasDeniedBefore, isTrue);
        expect(prefRepo.permissionDenied, isTrue);
      });

      test('sets permissionDenied to true when permanently denied', () async {
        final permRepo = _FakePermissionRepository(
          requestResult: StoragePermissionStatus.permanentlyDenied,
        );
        final prefRepo = _FakePreferencesRepository();
        final useCases = PermissionUseCases(permRepo, prefRepo);

        final snapshot = await useCases.request();

        expect(snapshot.status, StoragePermissionStatus.permanentlyDenied);
        expect(snapshot.hasDeniedBefore, isTrue);
      });
    });

    group('resetDeniedStatus', () {
      test('sets permissionDenied to false', () async {
        final permRepo = _FakePermissionRepository();
        final prefRepo = _FakePreferencesRepository(permissionDenied: true);
        final useCases = PermissionUseCases(permRepo, prefRepo);

        await useCases.resetDeniedStatus();

        expect(prefRepo.permissionDenied, isFalse);
      });
    });
  });
}

class _FakePermissionRepository implements PermissionRepository {
  final StoragePermissionStatus checkResult;
  final StoragePermissionStatus requestResult;

  _FakePermissionRepository({
    this.checkResult = StoragePermissionStatus.granted,
    this.requestResult = StoragePermissionStatus.granted,
  });

  @override
  Future<StoragePermissionStatus> checkStoragePermission() async => checkResult;

  @override
  Future<StoragePermissionStatus> requestStoragePermission() async =>
      requestResult;
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
