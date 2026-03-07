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
  String get themeMode => 'Chế độ giao diện';

  @override
  String get languageOption => 'Ngôn ngữ';

  @override
  String get startingUp => 'Đang khởi động...';

  @override
  String get loadingMusic => 'Đang tải nhạc...';

  @override
  String get feelTheMusic => 'Cảm nhận giai điệu';
}
