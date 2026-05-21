# My Music Project - Architecture Guide

## Project Overview

Offline music player app built with Flutter. The current architecture follows a pragmatic MVVM/Clean Architecture style with Riverpod for state management.

## Architecture

```text
lib/
├── core/                    # Core utilities and constants
│   ├── constants/           # App constants
│   └── utils/               # Utility classes
├── domain/                  # Business contracts and use cases
│   ├── entities/            # Domain entities and enums
│   ├── repositories/        # Repository interfaces
│   └── usecases/            # Application use cases
├── data/                    # Data layer implementations
│   ├── models/              # Data models, extending domain entities when needed
│   ├── repositories/        # Repository implementations
│   └── services/            # External services and package wrappers
├── presentation/            # Presentation layer
│   ├── pages/               # Screen pages
│   ├── providers/           # Riverpod notifiers/providers
│   └── widgets/             # Reusable widgets
├── l10n/                    # Localization files
└── main.dart                # App entry point
```

## Layer Responsibilities

### Presentation

- Contains pages, widgets, and Riverpod providers/notifiers.
- UI reads state with `ref.watch(...)`.
- UI triggers actions through notifier methods.
- UI should not call services directly.

### Domain

- Contains entities such as `Song`, `PlayMode`, and `StoragePermissionStatus`.
- Contains repository interfaces such as `MusicRepository`, `AudioRepository`, `PlayConfigRepository`, `PermissionRepository`, and `PreferencesRepository`.
- Contains use cases when they hold real application logic. Currently `LoadSongsUseCase` remains; simple permission checks go directly through `PermissionRepository`.
- Domain should not depend on data-layer implementations.

### Data

- Contains concrete repository implementations.
- Contains services that wrap external packages:
  - `AudioPlayerService` wraps `just_audio`.
  - `MusicQueryService` wraps device music querying.
  - `PermissionService` wraps `permission_handler`.
  - `HiveStorageService` initializes Hive and opens/returns boxes only.
- Persistence details should go through repository implementations, not directly from UI.
- Hive box names and keys are defined in constants files:
  - `HiveBoxNames`: `settings`, `playlists`, `songs`.
  - `SettingsBoxKeys`: language, last song path, permission flags.
  - `PlaylistsBoxKeys`: playlist-related storage keys.
  - `SongsBoxKeys`: song cache-related storage keys.

## Key Flows

### Startup

1. `main()` initializes `HiveStorageService`.
2. `ProviderScope` enables Riverpod.
3. `MyApp` watches `localeProvider`.
4. `SplashPage` checks permissions and loads songs.
5. `HomePage` shows `SongsPage`, `MorePage`, and `MiniPlayer`.

### Music Loading

`SongsPage/SplashPage -> MusicNotifier -> LoadSongsUseCase -> MusicRepository -> MusicQueryService`

After songs are loaded, `MusicNotifier` passes the playlist to `AudioNotifier`.

### Playback

`SongItem/PlayerControls/MiniPlayer -> AudioNotifier -> AudioRepository -> AudioPlayerService`

`AudioRepositoryImpl` owns playlist state, current index, play mode, continue-play behavior, and last-song persistence. `AudioPlayerService` stays focused on low-level `just_audio` operations.

### Permissions

`SplashPage -> PermissionNotifier -> Permission UseCases -> PermissionRepository -> PermissionService`

Permission state distinguishes normal denial from permanent denial using `StoragePermissionStatus`.

## Build & Test Commands

### Analyze code

```bash
flutter analyze
```

### Run app

```bash
flutter run
```

### Build for release

```bash
flutter build apk
```

## Key Dependencies

- `flutter_riverpod` - State management
- `just_audio` - Audio playback
- `on_audio_query` - Music file querying
- `permission_handler` - Permissions
- `hive_flutter` - Persistent storage
- `intl` - Internationalization

## Important Notes

### Localization

- App supports English and Vietnamese.
- Localization files live in `lib/l10n/`.
- Use `AppLocalizations.of(context)!` to access translations.

### State Management

- Providers use Riverpod.
- Use `ref.watch(...)` for reactive reads.
- Use `ref.read(...)` for one-time reads and actions.

### Audio Features

- Play modes: sequential, repeat, shuffle.
- Sleep timer functionality.
- Continue play toggle.
- Playlist management.
- Last played song restoration.

## Future Improvements

- Add unit tests for notifiers, use cases, and repository implementations.
- Add playlist, queue, favorite, share, and delete flows.
- Improve generated localization coverage for hardcoded strings.
- Add caching for music queries.
