import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final Widget child;
  
  const SplashBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
               [
                  Color(0xFF0A0A0F),
                  Color(0xFF121212),
                  Color(0xFF1E1E2E),
                  Color(0xFF2D1B69),
                ]

        ),
      ),
      child: child,
    );
  }
}