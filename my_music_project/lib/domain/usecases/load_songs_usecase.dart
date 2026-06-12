import '../entities/song.dart';
import '../repositories/music_repository.dart';

class LoadSongsUseCase {
  final MusicRepository _repository;

  LoadSongsUseCase(this._repository);

  //Future<List<Song>> call() => _repository.loadSongs();

  Future<List<Song>> loadCachedSongs() => _repository.loadCachedSongs();

  Future<List<Song>> scanDeviceSongs() => _repository.scanDeviceSongs();

  Future<void> saveSongCache(List<Song> songs) {
    return _repository.saveSongCache(songs);
  }

  Future<void> deleteSongFromDevice(Song song) {
    return _repository.deleteSongFromDevice(song);
  }

  Future<int?> getLastScanAt() => _repository.getLastScanAt();
}
