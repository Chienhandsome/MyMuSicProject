import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/music_player_viewmodel.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vm = MusicPlayerViewModel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.init();
        });
        return vm;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Music Player',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomePage(),
        // home: const Text("haha"),
      ),
    );
  }
}


