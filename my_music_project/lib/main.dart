import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_music_project/core/constants/language_keys.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/splash/splash_page.dart';
import 'presentation/viewmodels/music_player_viewmodel.dart';
import 'presentation/viewmodels/permission_viewmodel.dart';
import 'presentation/viewmodels/locale_provider.dart';
import 'data/services/shared_preferences_service.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerViewModel.create()),
        ChangeNotifierProvider(create: (_) => PermissionViewModel.create()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale(LanguageKeys.englishCode),
              Locale(LanguageKeys.vietnameseCode),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'Music Player',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
            ),
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
