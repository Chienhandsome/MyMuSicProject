import 'dart:io';

import '../../domain/entities/song.dart';

class MusicFileService {
  Future<void> deleteSongFile(Song song) async {
    try {
      final file = File(song.path);
      final exists = await file.exists();
      if (!exists) {
        // File đã không còn trên thiết bị — coi như xóa thành công
        return;
      }
      await file.delete();
    } on PathNotFoundException {
      // Path không hợp lệ hoặc file đã bị xóa — bỏ qua
      return;
    } on FileSystemException {
      // Không có quyền xóa hoặc lỗi filesystem khác
      rethrow;
    }
  }
}
