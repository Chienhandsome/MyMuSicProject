import 'dart:io';

import '../../domain/entities/song.dart';

class MusicFileService {
  Future<void> deleteSongFile(Song song) async {
    final file = File(song.path);
    final exists = await file.exists();
    if (!exists) {
      throw FileSystemException('File does not exist', song.path);
    }

    await file.delete();
  }
}
