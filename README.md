# Pocket Audio

Pocket Audio là ứng dụng nghe nhạc trên thiết bị di động, được xây dựng bằng Flutter. Ứng dụng tập trung vào trải nghiệm nghe nhạc offline gọn nhẹ: tự động quét các tệp âm thanh trong thiết bị, quản lý thư viện cá nhân và phát nhạc ngay cả khi ứng dụng chạy nền.

## Tính năng chính

- Quét và phát các bài hát có sẵn trong bộ nhớ thiết bị.
- Điều khiển phát nhạc: phát, tạm dừng, chuyển bài và tua bài.
- Hỗ trợ phát lặp, phát ngẫu nhiên và phát liên tục.
- Tìm kiếm bài hát và nghệ sĩ.
- Đánh dấu bài hát yêu thích và quản lý playlist cá nhân.
- Phát nhạc nền kèm thông báo điều khiển trên Android.
- Chia sẻ bài hát.
- Hỗ trợ tiếng Việt và tiếng Anh.

## Cấu trúc repository

```text
MyMuSicProject/
|-- my_music_project/   # Ứng dụng Flutter
|-- download_server/    # Backend phục vụ các tính năng liên quan đến tải nhạc
|-- index.html          # Trang giới thiệu dự án
`-- README.md
```

### Ứng dụng Flutter

Mã nguồn ứng dụng nằm trong thư mục [`my_music_project`](./my_music_project). Dự án sử dụng Clean Architecture kết hợp Riverpod để quản lý trạng thái, `just_audio` và `audio_service` để phát nhạc, cùng Isar để lưu dữ liệu cục bộ.

Xem hướng dẫn cài đặt, chạy ứng dụng và kiểm thử tại [`my_music_project/README.md`](./my_music_project/README.md).

### Backend

Backend nằm trong thư mục [`download_server`](./download_server) và đang trong quá trình phát triển. Trong các phiên bản tiếp theo, backend sẽ được hoàn thiện để cung cấp API tải nhạc, sau đó tích hợp vào ứng dụng Pocket Audio để người dùng có thể tải bài hát về thiết bị và nghe offline.

> Tính năng tải nhạc chưa được xem là tính năng hoàn chỉnh của ứng dụng ở thời điểm hiện tại.

## Chạy ứng dụng

```bash
cd my_music_project
flutter pub get
flutter run
```

Yêu cầu Flutter SDK và một thiết bị hoặc trình giả lập đã được cấu hình phù hợp.

## Định hướng phát triển

- Hoàn thiện backend tải nhạc và kết nối với ứng dụng Flutter.
- Quản lý tiến trình, trạng thái và lịch sử tải xuống.
- Tự động đưa bài hát đã tải vào thư viện nhạc offline.
- Tiếp tục cải thiện hiệu năng và trải nghiệm quản lý playlist.

