import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'presentations/songs/songs_page.dart';
import 'presentations/more/page/more_page.dart';
import 'presentations/widgets/mini_player.dart';
import 'l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (kDebugMode) {
      print("home page build - index: $_currentIndex");
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          SongsPage(),
          MorePage(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: MiniPlayer(),
          ),

          SafeArea(
            top: false,
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
              },
              selectedItemColor: Colors.deepPurpleAccent,
              unselectedItemColor: Colors.white54,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.music_note),
                  label: l10n.songs,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.more_horiz),
                  label: l10n.more,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
