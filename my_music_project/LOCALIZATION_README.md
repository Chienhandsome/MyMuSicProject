# Hướng dẫn Đổi Ngôn Ngữ (Localization)

## ✅ Đã Hoàn Thành

### 1. **Setup Localization**
- ✅ Đã tạo file `.arb` cho 2 ngôn ngữ:
  - `lib/l10n/app_en.arb` (English)
  - `lib/l10n/app_vi.arb` (Tiếng Việt)
- ✅ Đã tạo `l10n.yaml` config
- ✅ Đã generate localization code vào `lib/generated/l10n/`

### 2. **LocaleProvider**
- ✅ Đã tạo `providers/locale_provider.dart` để quản lý locale
- ✅ Lưu locale vào SharedPreferences
- ✅ Tự động load locale khi khởi động app

### 3. **Integration**
- ✅ Đã thêm `LocaleProvider` vào `MultiProvider` trong `main.dart`
- ✅ Đã kết nối `MaterialApp` với `LocaleProvider`
- ✅ Đã thêm `localizationsDelegates` đầy đủ

### 4. **UI Update**
- ✅ **MorePage**: Dropdown để chọn ngôn ngữ (English/Tiếng Việt)
- ✅ **HomePage**: Bottom navigation labels
- ✅ **SplashPage**: Permission dialog, loading text
- ✅ **SplashContent**: App name, subtitle, loading text

## 🎯 Cách Sử Dụng

### Đổi Ngôn Ngữ trong App:
1. Mở app
2. Vào tab "Thêm" (More)
3. Chọn "Ngôn ngữ"
4. Chọn "English" hoặc "Tiếng Việt" từ dropdown
5. App sẽ tự động cập nhật ngôn ngữ ngay lập tức

### Thêm Text Mới vào Localization:

1. **Thêm vào file `.arb`:**

```json
// lib/l10n/app_en.arb
{
  "myNewText": "My New Text"
}

// lib/l10n/app_vi.arb
{
  "myNewText": "Văn bản mới của tôi"
}
```

2. **Chạy generate:**
```bash
flutter gen-l10n
```

3. **Sử dụng trong code:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.myNewText)
```

## 📝 Text Đã Có

### Chung:
- `appName` - Tên app
- `songs` - Bài hát
- `more` - Thêm
- `search` - Tìm kiếm
- `searchHint` - Placeholder tìm kiếm
- `loading` - Đang tải...
- `noSongs` - Không tìm thấy bài hát

### Player Controls:
- `play` - Phát
- `pause` - Tạm dừng
- `next` - Tiếp theo
- `previous` - Trước đó
- `shuffle` - Ngẫu nhiên
- `repeat` - Lặp lại

### Settings:
- `settings` - Tùy chọn
- `theme` - Giao diện
- `language` - Ngôn ngữ
- `light` - Sáng
- `dark` - Tối
- `english` - English
- `vietnamese` - Tiếng Việt
- `themeMode` - Chế độ giao diện
- `languageOption` - Ngôn ngữ

### Permission:
- `permissionRequired` - Cần quyền truy cập
- `permissionMessage` - Message yêu cầu quyền
- `grantPermission` - Cấp quyền
- `permissionDenied` - Quyền bị từ chối

### Splash:
- `startingUp` - Đang khởi động...
- `loadingMusic` - Đang tải nhạc...
- `feelTheMusic` - Cảm nhận giai điệu

## 🔧 Technical Details

### Files Structure:
```
lib/
├── l10n/
│   ├── app_en.arb          # English translations
│   └── app_vi.arb          # Vietnamese translations
├── generated/
│   └── l10n/
│       ├── app_localizations.dart       # Generated base class
│       ├── app_localizations_en.dart    # Generated English
│       └── app_localizations_vi.dart    # Generated Vietnamese
├── providers/
│   └── locale_provider.dart             # Locale management
└── main.dart                            # Setup localization

l10n.yaml                                # Localization config
```

### Dependencies:
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.20.2
  
flutter:
  generate: true
```

## ✨ Features

1. **Tự động save locale**: Locale được lưu vào SharedPreferences
2. **Instant update**: Khi đổi ngôn ngữ, UI update ngay lập tức
3. **Default locale**: Mặc định là Tiếng Việt (`vi`)
4. **Material widgets support**: Các widget Material của Flutter cũng được dịch (dialog, date picker, etc.)

## 🚀 Next Steps

Để thêm ngôn ngữ mới (ví dụ: Tiếng Trung):

1. Tạo file `lib/l10n/app_zh.arb`
2. Copy nội dung từ `app_en.arb` và dịch sang Tiếng Trung
3. Thêm vào `supportedLocales` trong `main.dart`:
```dart
supportedLocales: const [
  Locale('en'),
  Locale('vi'),
  Locale('zh'), // Chinese
],
```
4. Thêm option vào dropdown trong `more_page.dart`
5. Chạy `flutter gen-l10n`

Done! 🎉

