import 'dart:io';

import '../../domain/entities/song.dart';

class MusicFileService {
  Future<void> deleteSongFile(Song song) async {
    final file = File(song.path);
    final exists = await file.exists();
    if (!exists) {
      // File đã không còn trên thiết bị — coi như xóa thành công
      return;
    }

    await file.delete();
  }
}
