import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_music_project/presentations/splash/splash_page.dart';
import 'package:provider/provider.dart';
import 'viewmodels/music_player_viewmodel.dart';
import 'presentations/more/provider/locale_provider.dart';
import 'data/models/shared_preferences_helper.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MusicPlayerViewModel()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en'),
              Locale('vi'),
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


