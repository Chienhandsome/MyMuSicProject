# Huong dan dong gop

Cam on ban da quan tam den viec dong gop cho du an Pocket Audio!

## Quy trinh dong gop

### 1. Fork va Clone

```bash
git clone <your-fork-url>
cd my_music_project
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 2. Tao branch moi

```bash
git checkout -b feature/ten-tinh-nang
# hoac
git checkout -b fix/mo-ta-loi
```

### Quy uoc dat ten branch

| Loai | Tien to | Vi du |
|------|---------|-------|
| Tinh nang moi | `feature/` | `feature/playlist-crud` |
| Sua loi | `fix/` | `fix/audio-pause-bug` |
| Refactor | `refactor/` | `refactor/repository-layer` |
| Tai lieu | `docs/` | `docs/update-readme` |
| CI/CD | `ci/` | `ci/add-lint-step` |

### 3. Viet code

- Tuan thu kien truc Clean Architecture (xem README.md)
- Chay `flutter analyze` truoc khi commit
- Viet test cho logic moi

### 4. Commit

```bash
git add <files>
git commit -m "feat: mo ta ngan gon"
```

### Quy uoc commit message

Su dung [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[body]

[footer]
```

| Type | Mo ta |
|------|-------|
| `feat` | Tinh nang moi |
| `fix` | Sua loi |
| `refactor` | Tai cau truc code |
| `docs` | Cap nhat tai lieu |
| `test` | Them hoac sua test |
| `ci` | Thay doi CI/CD |
| `chore` | Cong viec khac (dependencies, config) |

### 5. Push va tao Pull Request

```bash
git push origin feature/ten-tinh-nang
```

Tao Pull Request tren GitHub voi mo ta ro rang ve thay doi.

## Quy tac code

### Kien truc

- **domain/** chi chua Dart thuan tuy, KHONG import Flutter hay bat ky plugin nao
- **data/** implement cac interface tu domain, KHONG import presentation
- **presentation/** chi truy cap domain thong qua providers trong **di/**
- **core/** doc lap, khong phu thuoc layer khac

### Style guide

- Su dung `flutter_lints` (da cau hinh trong `analysis_options.yaml`)
- Dat ten file theo snake_case
- Dat ten class theo PascalCase
- Dat ten bien/ham theo camelCase
- Moi file chi chua mot class public chinh
- Viet comment cho cac ham phuc tap

### Testing

- Moi usecase moi can co unit test tuong ung
- Test phai doc lap, khong phu thuoc trang thai ben ngoai
- Su dung Fake/Mock cho dependencies
- Chay `flutter test` truoc khi push

```bash
# Kiem tra truoc khi push
flutter analyze
flutter test
```

## Bao cao loi

Khi bao cao loi, vui long cung cap:

1. Mo ta loi ro rang
2. Cac buoc tai tao loi
3. Ket qua mong doi vs ket qua thuc te
4. Phien ban Flutter (`flutter --version`)
5. Thiet bi/emulator dang dung

## De xuat tinh nang

Khi de xuat tinh nang moi:

1. Mo ta tinh nang va ly do can thiet
2. Mockup/wireframe (neu co)
3. Pham vi anh huong den kien truc hien tai

## Hoi dap

Neu co thac mac, hay tao Issue voi nhan `question` tren GitHub.
