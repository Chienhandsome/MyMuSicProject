import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/settings_box_keys.dart';
import '../../domain/entities/play_mode.dart';
import '../../domain/repositories/play_config_repository.dart';
import '../services/hive_storage_service.dart';

class PlayConfigRepositoryImpl implements PlayConfigRepository {
  Box<dynamic> get _settingsBox => HiveStorageService.settingsBox;

  @override
  PlayMode getPlayMode() {
    final value = _settingsBox.get(
      SettingsBoxKeys.playMode,
      defaultValue: PlayMode.sequential.name,
    ) as String;

    return PlayMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => PlayMode.sequential,
    );
  }

  @override
  Future<void> setPlayMode(PlayMode playMode) async {
    await _settingsBox.put(SettingsBoxKeys.playMode, playMode.name);
  }

  @override
  bool getContinuePlay() {
    return _settingsBox.get(
      SettingsBoxKeys.isContinuePlay,
      defaultValue: false,
    ) as bool;
  }

  @override
  Future<void> setContinuePlay(bool value) async {
    await _settingsBox.put(SettingsBoxKeys.isContinuePlay, value);
  }
}
