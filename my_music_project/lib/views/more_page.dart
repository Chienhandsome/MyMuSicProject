import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("more page build");
    }
    return const AppScaffold(
      title: 'Tùy chọn',
      scrollableAppBar: true,
      body: Center(
        child: Text('Tính năng đang phát triển'),
      ),
    );
  }
}
