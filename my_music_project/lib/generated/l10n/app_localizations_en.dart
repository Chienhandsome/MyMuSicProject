// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Music Player';

  @override
  String get songs => 'Songs';

  @override
  String get more => 'More';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Search songs, artists...';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get repeat => 'Repeat';

  @override
  String get settings => 'Settings';

  @override
  String get theme => 'Theme';

  @override
  String get language => 'Language';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get noSongs => 'No songs found';

  @override
  String get loading => 'Loading...';

  @override
  String get permissionRequired => 'Storage permission required';

  @override
  String get permissionMessage =>
      'App needs storage permission to scan and play music';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get permissionDenied =>
      'Permission denied. Please grant permission in settings.';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get languageOption => 'Language';

  @override
  String get startingUp => 'Starting up...';

  @override
  String get loadingMusic => 'Loading music...';

  @override
  String get feelTheMusic => 'Feel the music';
}
