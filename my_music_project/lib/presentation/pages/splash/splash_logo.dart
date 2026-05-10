import 'package:flutter/material.dart';

class SplashLogo extends StatelessWidget {
  final Animation<double> scaleAnimation;
  
  const SplashLogo({
    super.key,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Hero(
        tag: 'app-logo',
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF7C4DFF),
                Color(0xFF651FFF),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurpleAccent.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 8),
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.music_note,
            size: 64,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}