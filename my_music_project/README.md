# Pocket Audio

Ung dung nghe nhac offline cho Android, xay dung bang Flutter voi kien truc Clean Architecture va Riverpod.

## Tinh nang

- Quet va phat nhac tu bo nho thiet bi (offline)
- Dieu khien phat nhac (play, pause, next, previous, seek)
- Che do phat: lap lai, ngau nhien, phat lien tuc
- Tim kiem bai hat
- Da ngon ngu (Tieng Viet, Tieng Anh)
- Phat nhac nen voi media notification
- Chia se bai hat
- Yeu thich bai hat

## Kien truc

Du an ap dung **Clean Architecture** ket hop **MVVM** pattern:

```
lib/
├── core/              # Hang so, tien ich dung chung
│   ├── constants/
│   └── utils/
├── data/              # Lop data - implementation cua repositories
│   ├── gateways/
│   ├── models/
│   ├── repositories/
│   └── services/
├── di/                # Dependency Injection (Riverpod providers)
├── domain/            # Lop domain - business logic thuan tuy
│   ├── entities/
│   ├── gateways/
│   ├── repositories/
│   └── usecases/
├── l10n/              # Localization (ARB files)
├── presentation/      # Lop presentation - UI va state
│   ├── pages/
│   ├── providers/
│   ├── services/
│   └── widgets/
└── main.dart
```

### Nguyen tac phu thuoc

| Layer | Phu thuoc vao | KHONG duoc phu thuoc |
|-------|--------------|---------------------|
| `domain` | Chi Dart thuan | Flutter, data, presentation, di, core |
| `data` | domain | presentation, di |
| `presentation` | domain, di | data (truc tiep), plugins |
| `core` | Chi Dart thuan | Flutter, data, presentation, di |

Cac quy tac nay duoc kiem tra tu dong trong `test/architecture_test.dart`.

## Cong nghe su dung

| Thanh phan | Thu vien |
|-----------|---------|
| State Management | flutter_riverpod |
| Audio Playback | just_audio, audio_service |
| Local Database | isar |
| Music Query | on_audio_query |
| Permission | permission_handler |
| Localization | flutter_localizations, intl |
| Sharing | share_plus |

## Yeu cau he thong

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android SDK (API 21+)
- Java 11+

## Cai dat

### 1. Clone repository

```bash
git clone <repository-url>
cd my_music_project
```

### 2. Cai dat dependencies

```bash
flutter pub get
```

### 3. Sinh code (Isar models)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Chay ung dung

```bash
flutter run
```

## Chay test

```bash
# Chay tat ca test
flutter test

# Chay test voi coverage
flutter test --coverage

# Chi chay architecture test
flutter test test/architecture_test.dart
```

## Build release

```bash
# Build APK
flutter build apk --release

# Build App Bundle (cho Google Play)
flutter build appbundle --release
```

## Cau truc thu muc test

```
test/
├── architecture_test.dart    # Kiem tra quy tac phu thuoc giua cac layer
├── domain/
│   └── load_songs_usecase_test.dart
└── widget_test.dart
```
