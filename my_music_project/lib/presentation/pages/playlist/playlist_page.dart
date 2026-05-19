import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlaylistPage extends StatelessWidget{
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      body: Center(
        child: Text('Playlist Page'),
      ),
    );
  }

}