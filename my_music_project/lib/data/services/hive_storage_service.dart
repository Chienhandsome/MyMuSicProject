import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/hive_box_names.dart';

class HiveStorageService {
  static const List<String> _boxNames = [
    HiveBoxNames.settings,
    HiveBoxNames.playlists,
    HiveBoxNames.songs,
  ];

  static Future<void> init() async {
    await Hive.initFlutter();
    for (final boxName in _boxNames) {
      await openBox(boxName);
    }
  }

  static Future<Box<dynamic>> openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<dynamic>(boxName);
    }
    return Hive.openBox<dynamic>(boxName);
  }

  static Box<dynamic> getBox(String boxName) {
    if (!Hive.isBoxOpen(boxName)) {
      throw StateError('Hive box "$boxName" is not open. Call init() first.');
    }
    return Hive.box<dynamic>(boxName);
  }

  static Box<dynamic> get settingsBox => getBox(HiveBoxNames.settings);

  static Box<dynamic> get playlistsBox => getBox(HiveBoxNames.playlists);

  static Box<dynamic> get songsBox => getBox(HiveBoxNames.songs);
}
