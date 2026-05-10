# My Music Project - Architecture Guide

## Project Overview
Offline music player app built with Flutter using MVVM architecture pattern.

## Architecture

### MVVM Structure
```
lib/
├── core/                    # Core utilities and constants
│   ├── constants/          # App constants
│   └── utils/              # Utility classes (Result, formatters, etc.)
├── data/                   # Data layer
│   ├── models/             # Data models
│   ├── services/           # External services (audio, permissions, etc.)
│   └── repositories/       # Repository pattern implementations
├── presentation/           # Presentation layer
│   ├── pages/              # Screen pages
│   │   ├── more/
│   │   ├── player/
│   │   ├── search/
│   │   ├── songs/
│   │   └── splash/
│   ├── widgets/            # Reusable widgets
│   └── viewmodels/         # ViewModels (state management)
├── generated/              # Generated files (localizations)
├── l10n/                   # Localization files
└── main.dart               # App entry point
```

## Key Components

### Repository Layer
- **MusicRepository**: Handles music data operations
- **AudioRepository**: Manages audio player operations
- **PermissionRepository**: Handles permission requests
- Repository pattern abstracts service layer from viewmodels

### ViewModels
- **MusicPlayerViewModel**: Main music player state management
- **LocaleProvider**: Locale/language state management
- Uses Provider package for state management
- Implements dependency injection via factory constructors

### Services
- **AudioPlayerService**: Wraps just_audio for playback
- **MusicQueryService**: Queries device for music files
- **PermissionService**: Handles storage permissions

### Error Handling
- Custom `Result<T>` class for operation results
- Centralized error handling in ViewModels
- Error state exposed to UI for user feedback

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
- `provider: ^6.1.1` - State management
- `just_audio: ^0.9.36` - Audio playback
- `on_audio_query: ^2.9.0` - Music file querying
- `permission_handler: ^11.0.1` - Permissions
- `shared_preferences: ^2.2.2` - Persistent storage
- `intl: ^0.20.2` - Internationalization

## Important Notes

### Localization
- App supports English and Vietnamese
- Localization files in `l10n/` directory
- Generated files in `generated/l10n/`
- Use `AppLocalizations.of(context)!` to access translations

### State Management
- All ViewModels extend `ChangeNotifier`
- Use `Consumer<T>` or `context.watch<T>()` for reactive UI
- Use `context.read<T>()` for one-time access without rebuild

### File Paths
- Music files filtered to specific folders:
  - `/storage/emulated/0/Music`
  - `/storage/emulated/0/Download`

### Audio Features
- Play modes: sequential, repeat, shuffle
- Sleep timer functionality
- Continue play toggle
- Playlist management
- Last played song restoration

## Future Improvements
- Add unit tests for ViewModels and Repositories
- Implement dependency injection container (get_it)
- Add more comprehensive error handling
- Implement caching for music queries
- Add playlist management features