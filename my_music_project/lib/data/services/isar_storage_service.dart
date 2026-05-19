import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/cached_song_record.dart';

class IsarStorageService {
  static Isar? _instance;

  static bool get isReady => _instance?.isOpen ?? false;

  static Future<void> init() async {
    if (_instance != null && _instance!.isOpen) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    _instance = await Isar.open(
      [
        CachedSongRecordSchema,
        SongCacheMetadataRecordSchema,
        AppSettingRecordSchema,
      ],
      directory: directory.path,
    );
  }

  static Isar get instance {
    final isar = _instance;
    if (isar == null || !isar.isOpen) {
      throw StateError('Isar is not open. Call init() first.');
    }
    return isar;
  }
}
