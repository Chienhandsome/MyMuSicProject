import '../entities/song.dart';
import '../repositories/music_repository.dart';

class LoadSongsUseCase {
  final MusicRepository _repository;

  LoadSongsUseCase(this._repository);

  Future<List<Song>> call() => _repository.loadSongs();
}
