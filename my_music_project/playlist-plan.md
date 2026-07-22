# Playlist Implementation Plan

## Goal

Implement playlist management for the offline music player while keeping the current MVVM/Clean Architecture style:

- CRUD user playlists.
- Always provide a built-in Favorites playlist.
- Allow songs to be added to and removed from playlists.
- Allow favorite/unfavorite songs.
- Keep playback logic inside `AudioNotifier` / `AudioRepository`.
- Keep playlist persistence and library logic outside the audio layer.

## Current Codebase Notes

- The app currently uses Riverpod for presentation state.
- `AudioRepository` owns playback state, current playlist for playback, play mode, continue-play behavior, and last-song persistence.
- `Song` already has `isFavorite`.
- `SongCacheService.updateFavorite(...)` already persists favorite state.
- `PlaylistPage` currently exists but is only a placeholder.
- Although some constants still mention Hive, current storage is implemented with Isar through `IsarStorageService`.

## Architecture

Playlist should be implemented as a separate feature:

```text
UI
PlaylistPage / PlaylistDetailPage / Song menu
        |
PlaylistNotifier
        |
PlaylistRepository interface
        |
PlaylistRepositoryImpl
        |
PlaylistStorageService / SongCacheService / Isar
```

Do not put playlist CRUD into `AudioRepository`. The audio layer should only receive a list of songs to play.

## Files To Add

```text
lib/domain/entities/playlist.dart
lib/domain/entities/playlist_type.dart
lib/domain/repositories/playlist_repository.dart

lib/data/models/playlist_record.dart
lib/data/repositories/playlist_repository.dart
lib/data/services/playlist_storage_service.dart

lib/presentation/providers/playlist_provider.dart
lib/presentation/pages/playlist/playlist_detail_page.dart
```

## Files To Update

```text
lib/data/services/isar_storage_service.dart
lib/presentation/pages/playlist/playlist_page.dart
lib/presentation/pages/player/player_page.dart
lib/presentation/widgets/song_item.dart
```

Optional later updates:

```text
lib/core/constants/playlists_box_keys.dart
lib/core/constants/hive_box_names.dart
AGENTS.md
```

The optional files still reference the older Hive-based naming. They can be cleaned up later if the app has fully moved to Isar.

## Domain Model

Create `PlaylistType`:

```dart
enum PlaylistType {
  favorites,
  user,
}
```

Create `Playlist`:

```dart
class Playlist {
  final String id;
  final String name;
  final PlaylistType type;
  final List<String> songPaths;
  final int createdAt;
  final int updatedAt;

  const Playlist({
    required this.id,
    required this.name,
    required this.type,
    required this.songPaths,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isSystem => type == PlaylistType.favorites;
}
```

Use `song.path` as the song identity inside playlists. It is more stable for this app than the device media id.

## Repository Contract

Create `PlaylistRepository` in the domain layer:

```dart
import '../entities/playlist.dart';
import '../entities/song.dart';

abstract class PlaylistRepository {
  Future<List<Playlist>> getPlaylists();
  Future<Playlist?> getPlaylist(String id);

  Future<Playlist> createPlaylist(String name);
  Future<void> renamePlaylist(String id, String name);
  Future<void> deletePlaylist(String id);

  Future<void> addSong(String playlistId, Song song);
  Future<void> removeSong(String playlistId, Song song);
  Future<void> reorderSongs(String playlistId, List<String> songPaths);

  Future<List<Song>> getPlaylistSongs(String playlistId);
  Future<List<Song>> getFavoriteSongs();
  Future<void> setFavorite(Song song, bool isFavorite);
  Future<void> toggleFavorite(Song song);
}
```

## Favorites Playlist

Favorites should be a system playlist.

Recommended approach:

- Do not store Favorites as a normal user playlist.
- Always inject it into the playlist list from `PlaylistRepositoryImpl` or `PlaylistNotifier`.
- Use `CachedSongRecord.isFavorite` as the source of truth.
- Query favorite songs from `SongCacheService` / Isar.
- Do not allow rename/delete for Favorites.

Recommended constant:

```dart
const favoritesPlaylistId = 'favorites';
```

When `playlistId == favoritesPlaylistId`, route operations to favorite logic instead of user playlist logic.

## Isar Model

Create a new Isar collection:

```dart
import 'package:isar/isar.dart';

part 'playlist_record.g.dart';

@collection
class PlaylistRecord {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String playlistId;

  late String name;
  late String type;
  late List<String> songPaths;
  late int createdAt;
  late int updatedAt;
}
```

Update `IsarStorageService.init()`:

```dart
_instance = await Isar.open(
  [
    CachedSongRecordSchema,
    SongCacheMetadataRecordSchema,
    AppSettingRecordSchema,
    PlaylistRecordSchema,
  ],
  directory: directory.path,
);
```

Then run:

```bash
flutter pub run build_runner build
```

## Playlist Storage Service

Create `PlaylistStorageService` to wrap Isar queries:

- `getPlaylists()`
- `getPlaylist(String id)`
- `createPlaylist(String name)`
- `renamePlaylist(String id, String name)`
- `deletePlaylist(String id)`
- `addSong(String playlistId, String songPath)`
- `removeSong(String playlistId, String songPath)`
- `reorderSongs(String playlistId, List<String> songPaths)`

Rules:

- Prevent duplicate song paths inside one playlist.
- Keep song order using `songPaths`.
- Update `updatedAt` on every playlist mutation.
- Do not handle Favorites here unless choosing to persist it as a special record.

## Song Cache Service Updates

Add these methods to `SongCacheService`:

```dart
Future<List<Song>> getSongsByPaths(List<String> paths);
Future<List<Song>> getFavoriteSongs();
```

Implementation detail:

- Fetch cached songs by path.
- Preserve playlist order from the `paths` list.
- Drop missing songs silently, because a song file may have been deleted or no longer scanned.

## Repository Implementation

`PlaylistRepositoryImpl` should depend on:

```dart
PlaylistStorageService
SongCacheService
```

Responsibilities:

- Return Favorites plus user playlists.
- Convert `PlaylistRecord` to domain `Playlist`.
- Resolve playlist song paths into `Song` objects.
- Delegate favorite state to `SongCacheService.updateFavorite(...)`.
- Prevent user CRUD operations on the Favorites playlist.

Expected behavior:

- `getPlaylists()` returns Favorites first, then user playlists.
- `getPlaylist(favoritesPlaylistId)` returns the synthetic Favorites playlist.
- `getPlaylistSongs(favoritesPlaylistId)` returns `getFavoriteSongs()`.
- `deletePlaylist(favoritesPlaylistId)` should be ignored or throw an `UnsupportedError`.
- `renamePlaylist(favoritesPlaylistId, ...)` should be ignored or throw an `UnsupportedError`.

## Playlist Provider

Create `PlaylistState`:

```dart
class PlaylistState {
  final List<Playlist> playlists;
  final Map<String, List<Song>> songsByPlaylistId;
  final bool isLoading;
  final String? errorMessage;
}
```

Create `PlaylistNotifier` methods:

- `loadPlaylists()`
- `loadPlaylistSongs(String playlistId)`
- `createPlaylist(String name)`
- `renamePlaylist(String id, String name)`
- `deletePlaylist(String id)`
- `addSongToPlaylist(String playlistId, Song song)`
- `removeSongFromPlaylist(String playlistId, Song song)`
- `reorderSongs(String playlistId, List<Song> songs)`
- `toggleFavorite(Song song)`
- `playPlaylist(String playlistId)`

`playPlaylist(...)` should use `AudioNotifier`:

```dart
final songs = await _playlistRepository.getPlaylistSongs(playlistId);
if (songs.isEmpty) return;
await _audioNotifier.setPlaylist(songs);
await _audioNotifier.playSongAt(0);
```

## Provider Wiring

Add providers in `playlist_provider.dart`:

```dart
final playlistStorageServiceProvider = Provider<PlaylistStorageService>((ref) {
  return PlaylistStorageService();
});

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepositoryImpl(
    ref.watch(playlistStorageServiceProvider),
    SongCacheService(),
  );
});

final playlistProvider =
    StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  return PlaylistNotifier(
    ref.watch(playlistRepositoryProvider),
    ref.read(audioProvider.notifier),
  );
});
```

## UI Plan

### PlaylistPage

Show:

- Favorites playlist at the top.
- User-created playlists below.
- Create playlist action in the app bar or floating action button.
- Empty state when there are no user playlists.

Actions:

- Tap playlist: open `PlaylistDetailPage`.
- Long press or menu on user playlist: rename/delete.
- Favorites should not show rename/delete actions.

### PlaylistDetailPage

Show:

- Playlist name.
- Song count.
- Play button.
- List of songs.
- Remove song action for user playlists.
- Favorite toggle for Favorites or all song rows if desired.

Actions:

- Tap song: set playlist as current audio playlist and play selected index.
- Play all: set playlist and play index `0`.
- Remove: remove song from playlist.
- Reorder: optional second pass.

### Song Menus

Add menu actions from `SongItem` or `PlayerPage`:

- Toggle favorite.
- Add to playlist.

For "Add to playlist":

- Show a bottom sheet/dialog with user playlists.
- Include a create-new-playlist option.
- Exclude Favorites because favorite should be controlled by the heart action.

## Refactor Favorite Flow

Current flow:

```text
PlayerPage -> AudioNotifier.toggleCurrentSongFavorite()
```

Recommended final flow:

```text
PlayerPage / SongItem -> PlaylistNotifier.toggleFavorite(song)
```

Then refresh:

- Playlist state.
- Current song state if the toggled song is currently playing.
- Music song list if needed.

To keep the first implementation smaller, it is acceptable to leave `AudioNotifier.toggleCurrentSongFavorite()` temporarily and move it later. Long term, favorite belongs better in playlist/library logic than audio playback logic.

## Implementation Checklist

- [ ] Add `PlaylistType`.
- [ ] Add `Playlist` entity.
- [ ] Add `PlaylistRepository` interface.
- [ ] Add `PlaylistRecord` Isar model.
- [ ] Register `PlaylistRecordSchema` in `IsarStorageService`.
- [ ] Run Isar generator.
- [ ] Add `PlaylistStorageService`.
- [ ] Add `SongCacheService.getSongsByPaths(...)`.
- [ ] Add `SongCacheService.getFavoriteSongs()`.
- [ ] Add `PlaylistRepositoryImpl`.
- [ ] Add `PlaylistState`.
- [ ] Add `PlaylistNotifier`.
- [ ] Add playlist Riverpod providers.
- [ ] Replace placeholder `PlaylistPage`.
- [ ] Add `PlaylistDetailPage`.
- [ ] Add create playlist dialog.
- [ ] Add rename/delete playlist actions.
- [ ] Add add-to-playlist action from song rows/player menu.
- [ ] Move favorite toggle toward `PlaylistNotifier`.
- [ ] Run `flutter analyze`.
- [ ] Manually test create, rename, delete, add song, remove song, favorite, and play playlist flows.

## Risks And Decisions

### Deleted Or Missing Songs

If a playlist contains a song path that no longer exists in the song cache, skip that song when resolving playlist songs. Keep the stored path for now unless adding a cleanup flow.

### Duplicate Songs

Prevent duplicate paths inside the same playlist. If the user adds an existing song, either no-op or show a snackbar.

### Favorites Source Of Truth

Use `CachedSongRecord.isFavorite`, not a separate `favorites.songPaths` list. This avoids two sources of truth.

### Playing From Playlist

When playing from a playlist, pass that playlist's resolved songs into `AudioNotifier.setPlaylist(...)`. This lets next/previous operate inside the selected playlist without changing `AudioRepository` responsibilities.

### Music Reload

When `MusicNotifier.loadSongs()` rescans songs, it should preserve `isFavorite` through the existing cached-song merge. User playlists should keep using paths, so they remain valid as long as matching paths are still present.

