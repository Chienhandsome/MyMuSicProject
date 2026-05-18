import '../../core/constants/settings_box_keys.dart';
import '../../domain/entities/play_mode.dart';
import '../../domain/repositories/play_config_repository.dart';
import '../services/app_settings_service.dart';

class PlayConfigRepositoryImpl implements PlayConfigRepository {
  final AppSettingsService _settingsService;

  PlayConfigRepositoryImpl(this._settingsService);

  @override
  PlayMode getPlayMode() {
    final value =
        _settingsService.getString(SettingsBoxKeys.playMode) ??
            PlayMode.sequential.name;

    return PlayMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => PlayMode.sequential,
    );
  }

  @override
  Future<void> setPlayMode(PlayMode playMode) async {
    await _settingsService.setString(SettingsBoxKeys.playMode, playMode.name);
  }

  @override
  bool getContinuePlay() {
    return _settingsService.getBool(SettingsBoxKeys.isContinuePlay);
  }

  @override
  Future<void> setContinuePlay(bool value) async {
    await _settingsService.setBool(SettingsBoxKeys.isContinuePlay, value);
  }
}
