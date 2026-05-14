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
  String get permissionDeniedMessage =>
      'You have previously denied storage permission. Please grant permission in app settings to use this app.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get languageOption => 'Language';

  @override
  String get startingUp => 'Starting up...';

  @override
  String get loadingMusic => 'Loading music...';

  @override
  String get feelTheMusic => 'Feel the melody';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get noSongPlaying => 'No song playing';

  @override
  String get sleepTimer => 'Sleep Timer';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get minutes5 => '5 minutes';

  @override
  String get minutes10 => '10 minutes';

  @override
  String get minutes15 => '15 minutes';

  @override
  String get minutes30 => '30 minutes';

  @override
  String get hour1 => '1 hour';

  @override
  String get hour2 => '2 hour';

  @override
  String get searchSongs => 'Search songs...';

  @override
  String get voiceSearch => 'Voice search';

  @override
  String get searchFavoriteSong => 'Search for your favorite song';

  @override
  String get typeToSearch => 'Type song name to start searching';

  @override
  String get suggestionsForYou => '🎵 Suggestions for you';

  @override
  String get noResultsFound => 'No results found';

  @override
  String noMatchingSongs(String query) {
    return 'No songs found matching \"$query\"';
  }

  @override
  String get searchAgain => 'Search again';

  @override
  String foundResults(String count) {
    return 'Found $count result(s)';
  }

  @override
  String get voiceSearchComingSoon => 'Voice search (Coming soon)';

  @override
  String get playModeRepeat => 'Repeat one';

  @override
  String get playModeSequential => 'Sequential';

  @override
  String get playModeShuffle => 'Shuffle';

  @override
  String get continuePlayOn => 'Continue play: On';

  @override
  String get continuePlayOff => 'Continue play: Off';
}
