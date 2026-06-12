# State Problems And Solutions

## Muc tieu

Ghi lai cac van de trong cach dung state hien tai va huong xu ly khi refactor. Project dang dung Riverpod `StateNotifierProvider`, nhung state hien tai bi chia giua provider, widget-local state va stream truc tiep tu audio player.

## 1. Audio state co nhieu nguon su that

### Van de

`AudioNotifier` da listen `playerStateStream` va ghi `isPlaying` vao `AudioState` trong:

```text
lib/presentation/providers/audio_provider.dart
```

Nhung UI van nghe stream truc tiep o:

```text
lib/presentation/widgets/player_controls.dart
lib/presentation/widgets/progress_slider.dart
```

Dieu nay tao ra 2 nguon su that:

- `audioProvider` quan ly `AudioState`.
- Widget tu doc stream cua `AudioPlayer`.

Khi stream va provider cap nhat khac thoi diem, UI co the hien thi lech trang thai, vi du nut play/pause lay tu stream con cac widget khac lay tu `AudioState`.

### Huong giai quyet

- Chon mot nguon su that chinh cho playback UI.
- Nen de Riverpod expose cac stream can thiet bang provider rieng:

```dart
final playerStateProvider = StreamProvider<PlayerState>((ref) {
  return ref.watch(audioProvider.notifier).audioPlayer.playerStateStream;
});

final positionProvider = StreamProvider<Duration>((ref) {
  return ref.watch(audioProvider.notifier).audioPlayer.positionStream;
});
```

- UI dung `ref.watch(...)` thay vi tu tao `StreamBuilder` rai rac.
- Neu `AudioState.isPlaying` da du dung, nut play/pause nen doc tu `audioProvider.select((s) => s.isPlaying)`.

## 2. Notifier dang chua logic UI

### Van de

`AudioNotifier.startSleepTimer` nhan `BuildContext` va goi `ScaffoldMessenger` truc tiep:

```text
lib/presentation/providers/audio_provider.dart
```

Provider/notifier dang lam ca 2 viec:

- Quan ly business state cua hen gio tat nhac.
- Hien snackbar cho UI.

Dieu nay lam notifier kho test, phu thuoc vao widget tree, va de loi neu `context` da bi unmount.

### Huong giai quyet

- Notifier chi nen cap nhat state va thuc hien action audio.
- UI layer lang nghe state/action result de hien snackbar.
- Chuyen method thanh:

```dart
void startSleepTimer(Duration duration)
```

- Neu can message, co the tra ve result hoac dung `ref.listen` trong UI:

```dart
ref.listen(audioProvider.select((s) => s.sleepTimerEnd), (previous, next) {
  if (next != null) {
    // show snackbar in UI
  }
});
```

## 3. MusicNotifier phu thuoc truc tiep vao AudioNotifier

### Van de

`MusicNotifier` giu `_audioNotifier` va goi:

```text
_audioNotifier.setPlaylist(...)
_audioNotifier.stop()
```

trong:

```text
lib/presentation/providers/music_provider.dart
```

Dieu nay lam library state va playback state bi coupling manh. Load/xoa bai hat tu thu vien se tu dong day playlist sang audio layer.

### Huong giai quyet

- Tach ro library state va playback queue.
- `MusicNotifier` chi nen quan ly danh sach bai hat, scan, delete, cache.
- UI hoac mot coordinator/use case rieng quyet dinh khi nao can sync playlist sang audio.
- Neu van muon tu dong sync sau khi scan, tao method ro nghia hon nhu:

```dart
Future<void> syncLibraryToPlaybackQueue()
```

hoac de `AudioNotifier` watch song list qua provider dependency co kiem soat.

## 4. Rebuild qua rong vi watch ca AudioState

### Van de

`_SongsList` dang watch toan bo `audioProvider`:

```text
lib/presentation/pages/songs/songs_page.dart
```

Trong khi list chi can `currentIndex` de highlight bai dang phat. Khi `isPlaying`, `playMode`, `sleepTimerEnd` thay doi, list van co the rebuild.

### Huong giai quyet

Dung `select` de chi watch field can thiet:

```dart
final currentIndex = ref.watch(
  audioProvider.select((state) => state.currentIndex),
);
```

Tuong tu voi cac widget khac:

- Mini player chi watch `currentSong` va `isPlaying`.
- Sleep timer UI chi watch `sleepTimerEnd`.
- Play mode button chi watch `playMode`.

## 5. Search state de bi cu

### Van de

`SearchPage` luu `_searchResults`, `_searchQuery`, `_isSearching` bang local `setState`:

```text
lib/presentation/pages/search/search_page.dart
```

Nhung danh sach bai hat lai lay bang:

```dart
ref.read(musicProvider).songs
```

Vi dung `read`, search page khong tu update khi `musicProvider.songs` thay doi. Neu scan lai hoac xoa bai trong luc dang o search, ket qua search co the cu.

### Huong giai quyet

- Chi luu query trong local state hoac provider.
- Ket qua search nen la derived state tu `musicProvider.songs + query`.
- Co the dung `StateProvider<String>` cho query va `Provider<List<Song>>` cho result:

```dart
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = Provider<List<Song>>((ref) {
  final query = ref.watch(searchQueryProvider).trim();
  final songs = ref.watch(musicProvider.select((s) => s.songs));

  if (query.isEmpty) return const [];
  // filter songs
});
```

## 6. Tap lock cua SongItem la global

### Van de

`_songItemTapLockProvider` la `StateProvider<bool>` dung chung cho moi `SongItem`:

```text
lib/presentation/widgets/song_item.dart
```

Khi mot item dang play/push player page, tat ca item khac bi lock theo. Dieu nay co the chap nhan de chan double tap, nhung no la global state an trong widget file.

### Huong giai quyet

Tuy theo mong muon UX:

- Neu chi can chan double tap tren tung item, dung local state trong `SongItem` hoac lock theo song path.
- Neu can chan moi thao tac playback song song, chuyen thanh state ro rang trong `AudioState`, vi du `isChangingTrack`.
- Neu giu global lock, doi ten provider va dat gan playback/provider layer de y nghia ro hon.

## 7. MusicState chua bieu dien ro trang thai async

### Van de

`MusicState` hien co:

```text
songs
isLoading
isScanning
lastScanAt
errorMessage
```

Flow load hien tai:

1. Load cached songs.
2. Hien cached songs va set `isScanning = true`.
3. Scan device songs.
4. Replace songs bang ket qua scan.

Neu scan loi sau khi da co cached songs, UI co the chuyen sang error state thay vi giu data cu va hien loi refresh nen.

### Huong giai quyet

Tach cac trang thai:

```dart
class MusicState {
  final List<Song> songs;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isScanning;
  final String? loadError;
  final String? refreshError;
}
```

Quy tac UI:

- `isInitialLoading`: hien full-screen loading khi chua co data.
- `isRefreshing` hoac `isScanning`: hien progress nho khi da co data.
- `refreshError`: hien snackbar/banner, khong xoa list dang co.
- `loadError`: chi hien error full-screen khi khong co data.

## 8. State model chua co equality

### Van de

`AudioState`, `MusicState`, `PermissionState`, `SortOption` la class thuong, chua co `==` va `hashCode`. Moi lan `copyWith` tao object moi, Riverpod se notify listener ngay ca khi gia tri thuc te khong doi.

### Huong giai quyet

- Dung `freezed` neu project chap nhan code generation.
- Hoac them equality thu cong cho cac state quan trong.
- Toi thieu, ket hop voi `select` de giam rebuild khong can thiet.

## 9. Side effect va navigation nam trong widget item

### Van de

`SongItem` vua hien UI, vua:

- Goi play song.
- Check audio state.
- Navigate sang `PlayerPage`.
- Show snackbar.
- Xoa file.
- Share file.

File:

```text
lib/presentation/widgets/song_item.dart
```

Khi widget item nam trong nhieu man hinh khac nhau, logic nay de bi lap hoac kho tuy bien.

### Huong giai quyet

- Giu `SongItem` la presentational widget nhieu hon.
- Truyen callback tu parent:

```dart
SongItem(
  song: song,
  isCurrent: isCurrent,
  onTap: () => ...,
  onDelete: () => ...,
  onShare: () => ...,
)
```

- Parent screen quyet dinh navigation/snackbar.
- Cac action lien quan domain/playback nam trong notifier/use case.

## Thu tu refactor de xuat

1. Dung `select` cho cac widget dang watch provider qua rong.
2. Bo `BuildContext` khoi `AudioNotifier.startSleepTimer`.
3. Chuan hoa audio stream: expose bang Riverpod provider hoac gom vao `AudioState`.
4. Doi search result thanh derived state.
5. Tach callback/action ra khoi `SongItem`.
6. Giam coupling giua `MusicNotifier` va `AudioNotifier`.
7. Cai tien `MusicState` de phan biet initial loading, background scanning va error.
8. Them equality/freezed cho state model khi bat dau refactor lon.

## Checklist

- [ ] Dung `select` cho `_SongsList`.
- [ ] Dung `select` cho mini player/player controls/sleep timer UI.
- [ ] Xoa `BuildContext` khoi `AudioNotifier`.
- [ ] Chuyen snackbar sleep timer ve UI bang `ref.listen`.
- [ ] Chuyen audio streams thanh Riverpod stream providers hoac gom vao `AudioState`.
- [ ] Refactor search thanh derived state.
- [ ] Doi tap lock thanh local/per-song/playback action state.
- [ ] Tach `SongItem` thanh presentational widget.
- [ ] Giam coupling `MusicNotifier -> AudioNotifier`.
- [ ] Cai tien async state cua `MusicState`.
- [ ] Them equality/freezed cho state classes.
