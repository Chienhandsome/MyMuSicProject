import 'package:flutter/material.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhiều hơn'),
      ),
      body: const Center(
        child: Text('Tính năng đang phát triển'),
      ),
    );
  }
}
