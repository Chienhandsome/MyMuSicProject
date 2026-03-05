import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/music_player_viewmodel.dart';
import 'splash/splash_page.dart';
import 'models/shared_preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MusicPlayerViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const SplashPage(),
      ),
    );
  }
}


