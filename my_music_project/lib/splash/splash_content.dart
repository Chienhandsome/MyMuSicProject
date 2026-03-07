import 'package:flutter/material.dart';
import '../generated/l10n/app_localizations.dart';

class SplashContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Widget logo;
  
  const SplashContent({
    super.key,
    required this.fadeAnimation,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo
          logo,
          const SizedBox(height: 32),
          
          // App name
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [
                Color(0xFF7C4DFF),
                Color(0xFFB388FF),
              ],
            ).createShader(bounds),
            child: Text(
              l10n.appName,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
                shadows: [
                  Shadow(
                    blurRadius: 15.0,
                    color: Colors.black38,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),

          // Subtitle
          Text(
            l10n.feelTheMusic,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Loading indicator
          SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
              backgroundColor: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Loading text
          Text(
            l10n.startingUp,
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 14,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}