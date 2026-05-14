import '../../data/models/song_model.dart';
import '../../data/repositories/music_repository.dart';

class LoadSongsUseCase {
  final MusicRepository _repository;

  LoadSongsUseCase(this._repository);

  Future<List<SongModel>> call() => _repository.loadSongs();
}
