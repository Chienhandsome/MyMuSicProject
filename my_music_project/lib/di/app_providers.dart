import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/gateways/app_initialization_gateway.dart';
import '../data/gateways/app_platform_gateway.dart';
import '../data/repositories/audio_repository.dart';
import '../data/repositories/music_repository.dart';
import '../data/repositories/permission_repository.dart';
import '../data/repositories/play_config_repository.dart';
import '../data/repositories/preferences_repository.dart';
import '../data/services/app_settings_service.dart';
import '../data/services/audio_player_service.dart';
import '../data/services/music_file_service.dart';
import '../data/services/music_query_service.dart';
import '../data/services/permission_service.dart';
import '../data/services/song_cache_service.dart';
import '../domain/repositories/audio_repository.dart';
import '../domain/repositories/music_repository.dart';
import '../domain/repositories/permission_repository.dart';
import '../domain/repositories/play_config_repository.dart';
import '../domain/repositories/preferences_repository.dart';
import '../domain/usecases/app_initialization_usecase.dart';
import '../domain/usecases/app_platform_usecase.dart';
import '../domain/usecases/load_songs_usecase.dart';
import '../domain/usecases/locale_usecases.dart';
import '../domain/usecases/permission_usecases.dart';
import '../domain/usecases/playback_usecases.dart';

final appSettingsServiceProvider = Provider<AppSettingsService>((ref) {
  return AppSettingsService();
});

final songCacheServiceProvider = Provider<SongCacheService>((ref) {
  return SongCacheService();
});

final audioServiceProvider = Provider<AudioPlayerService>((ref) {
  return audioPlayerHandler;
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  return PreferencesRepositoryImpl(ref.watch(appSettingsServiceProvider));
});

final playConfigRepositoryProvider = Provider<PlayConfigRepository>((ref) {
  return PlayConfigRepositoryImpl(ref.watch(appSettingsServiceProvider));
});

final permissionRepositoryProvider = Provider<PermissionRepository>((ref) {
  return PermissionRepositoryImpl(PermissionService());
});

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl(
    MusicQueryService(),
    ref.watch(songCacheServiceProvider),
    MusicFileService(),
  );
});

final audioRepositoryProvider = Provider<AudioRepository>((ref) {
  final repository = AudioRepositoryImpl(ref.watch(audioServiceProvider));
  ref.onDispose(repository.dispose);
  return repository;
});

final playbackUseCasesProvider = Provider<PlaybackUseCases>((ref) {
  final useCases = PlaybackUseCases(
    ref.watch(audioRepositoryProvider),
    ref.watch(preferencesRepositoryProvider),
    ref.watch(playConfigRepositoryProvider),
    ref.watch(musicRepositoryProvider),
  );
  ref.onDispose(useCases.dispose);
  return useCases;
});

final loadSongsUseCaseProvider = Provider<LoadSongsUseCase>((ref) {
  return LoadSongsUseCase(
    ref.watch(musicRepositoryProvider),
    ref.watch(playbackUseCasesProvider),
  );
});

final permissionUseCasesProvider = Provider<PermissionUseCases>((ref) {
  return PermissionUseCases(
    ref.watch(permissionRepositoryProvider),
    ref.watch(preferencesRepositoryProvider),
  );
});

final localeUseCasesProvider = Provider<LocaleUseCases>((ref) {
  return LocaleUseCases(ref.watch(preferencesRepositoryProvider));
});

final appInitializationUseCaseProvider =
    Provider<AppInitializationUseCase>((ref) {
  return AppInitializationUseCase(
    AppInitializationGatewayImpl(),
    ref.watch(localeUseCasesProvider),
    ref.watch(permissionUseCasesProvider),
  );
});

final appPlatformUseCaseProvider = Provider<AppPlatformUseCase>((ref) {
  return AppPlatformUseCase(AppPlatformGatewayImpl());
});
