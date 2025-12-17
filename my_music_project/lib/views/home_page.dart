import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'songs_page.dart';
import 'more_page.dart';
import '../widgets/mini_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          // optional: lift the mini player slightly from screen bottom
          const SizedBox(height: 8),

          // optional horizontal padding around mini player
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: MiniPlayer(),
          ),

          // space between mini player and bottom navigation bar
          const SizedBox(height: 8),

          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C2E),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 12,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
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
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.music_note),
                    label: 'Bài hát',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz),
                    label: 'Thêm',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
