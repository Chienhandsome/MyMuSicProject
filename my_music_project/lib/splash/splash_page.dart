import 'package:flutter/material.dart';
import 'package:my_music_project/splash/splash_background.dart';
import 'package:my_music_project/splash/splash_content.dart';
import 'package:my_music_project/splash/splash_logo.dart';
import 'package:provider/provider.dart';
import '../viewmodels/music_player_viewmodel.dart';
import '../home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
  with TickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showPermissionRequest = false;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _controller.forward();
  }

  Future<void> _initializeApp() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final viewModel = context.read<MusicPlayerViewModel>();
    await viewModel.requestPermission();

    if (!mounted) return;

    if (viewModel.hasPermission) {
      _navigateToHome();
    } else {
      setState(() {
        _isCheckingPermission = false;
        _showPermissionRequest = true;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  Future<void> _requestPermission() async {
    final viewModel = context.read<MusicPlayerViewModel>();
    await viewModel.requestPermission();

    if (!mounted) return;

    if (viewModel.hasPermission) {
      _navigateToHome();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quyền truy cập bị từ chối. Vui lòng cấp quyền trong cài đặt.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBackground(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              children: [
                SplashContent(
                  fadeAnimation: _fadeAnimation,
                  logo: SplashLogo(scaleAnimation: _scaleAnimation),
                ),
                if (_showPermissionRequest)
                  _buildPermissionRequest(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const Icon(Icons.lock, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            const Text(
              'Cần quyền truy cập bộ nhớ',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Ứng dụng cần quyền truy cập bộ nhớ để quét và phát nhạc',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _requestPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Cấp quyền',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}