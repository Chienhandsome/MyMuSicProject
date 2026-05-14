// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Trình phát nhạc';

  @override
  String get songs => 'Bài hát';

  @override
  String get more => 'Thêm';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchHint => 'Tìm bài hát, nghệ sĩ...';

  @override
  String get play => 'Phát';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get next => 'Tiếp theo';

  @override
  String get previous => 'Trước đó';

  @override
  String get shuffle => 'Ngẫu nhiên';

  @override
  String get repeat => 'Lặp lại';

  @override
  String get settings => 'Tùy chọn';

  @override
  String get theme => 'Giao diện';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get light => 'Sáng';

  @override
  String get dark => 'Tối';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get noSongs => 'Không tìm thấy bài hát';

  @override
  String get loading => 'Đang tải...';

  @override
  String get permissionRequired => 'Cần quyền truy cập bộ nhớ';

  @override
  String get permissionMessage =>
      'Ứng dụng cần quyền truy cập bộ nhớ để quét và phát nhạc';

  @override
  String get grantPermission => 'Cấp quyền';

  @override
  String get permissionDenied =>
      'Quyền truy cập bị từ chối. Vui lòng cấp quyền trong cài đặt.';

  @override
  String get permissionDeniedMessage =>
      'Bạn đã từ chối quyền truy cập bộ nhớ trước đó. Vui lòng cấp quyền trong cài đặt ứng dụng để sử dụng ứng dụng này.';

  @override
  String get openSettings => 'Mở Cài Đặt';

  @override
  String get themeMode => 'Chế độ giao diện';

  @override
  String get languageOption => 'Ngôn ngữ';

  @override
  String get startingUp => 'Đang khởi động...';

  @override
  String get loadingMusic => 'Đang tải nhạc...';

  @override
  String get feelTheMusic => 'Cảm nhận giai điệu';

  @override
  String get nowPlaying => 'Đang phát';

  @override
  String get noSongPlaying => 'Không có bài hát nào';

  @override
  String get sleepTimer => 'Hẹn giờ tắt';

  @override
  String get addToFavorites => 'Thêm vào yêu thích';

  @override
  String get delete => 'Xóa';

  @override
  String get cancel => 'Hủy';

  @override
  String get minutes5 => '5 phút';

  @override
  String get minutes10 => '10 phút';

  @override
  String get minutes15 => '15 phút';

  @override
  String get minutes30 => '30 phút';

  @override
  String get hour1 => '1 giờ';

  @override
  String get searchSongs => 'Tìm kiếm bài hát...';

  @override
  String get voiceSearch => 'Tìm kiếm bằng giọng nói';

  @override
  String get searchFavoriteSong => 'Tìm kiếm bài hát yêu thích';

  @override
  String get typeToSearch => 'Nhập tên bài hát để bắt đầu tìm kiếm';

  @override
  String get suggestionsForYou => '🎵 Gợi ý cho bạn';

  @override
  String get noResultsFound => 'Không tìm thấy kết quả';

  @override
  String noMatchingSongs(String query) {
    return 'Không tìm thấy bài hát phù hợp với \"$query\"';
  }

  @override
  String get searchAgain => 'Tìm kiếm khác';

  @override
  String foundResults(String count) {
    return 'Tìm thấy $count kết quả';
  }

  @override
  String get voiceSearchComingSoon => 'Tìm kiếm bằng giọng nói (Sắp ra mắt)';

  @override
  String get playModeRepeat => 'Lặp lại một bài';

  @override
  String get playModeSequential => 'Phát tuần tự';

  @override
  String get playModeShuffle => 'Phát ngẫu nhiên';

  @override
  String get continuePlayOn => 'Phát tiếp: Bật';

  @override
  String get continuePlayOff => 'Phát tiếp: Tắt';
}
